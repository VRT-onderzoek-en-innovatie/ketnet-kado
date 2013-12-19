//
//  TransportManager.m
//  ketnetkado
//
//  Created by Martijn Vandenberghe on 12/12/13.
//  Copyright (c) 2013 VRT Onderzoek en Innovatie. All rights reserved.
//

#import "TransportManager.h"

#include <CFNetwork/CFNetwork.h>

enum {
    kSendBufferSize = 32768
};

@implementation TransportManager

{
    uint8_t                     _buffer[kSendBufferSize];
}

@synthesize delegate;

@synthesize networkStream = _networkStream;
@synthesize fileStream    = _fileStream;
@synthesize bufferOffset  = _bufferOffset;
@synthesize bufferLimit   = _bufferLimit;

- (id)init {
	self = [super init];
	if (self) {
		NSString *pathToServerSettings = [[NSBundle mainBundle] pathForResource:@"serverdata" ofType:@"plist"];
		NSURL *serverSettingsURL = [[NSURL alloc] initFileURLWithPath:pathToServerSettings];
		NSDictionary *dictServerSettings = [[NSDictionary alloc] initWithContentsOfURL:serverSettingsURL];
		
		serverURL = [dictServerSettings objectForKey:@"serverURL"];
		username = [dictServerSettings objectForKey:@"username"];
		password = [dictServerSettings objectForKey:@"password"];
	}
	return self;
}

- (void)writeAsset:(ALAsset*)asset withFilename:(NSString *)repoNaam
{
	//Laat eerst de invokerende vc weten dat we gestart zijn
	if ([self.delegate respondsToSelector:@selector(transportBegonnenMetStatus:)]) {
		[self.delegate transportBegonnenMetStatus:@""];
	}
	
	//Sla op en vervolg met zending
    ALAssetRepresentation *representation = asset.defaultRepresentation;
	long long size = representation.size;
    NSMutableData *rawData = [[NSMutableData alloc] initWithCapacity:size];
    void *buffer = [rawData mutableBytes];
    [representation getBytes:buffer fromOffset:0 length:size error:nil];
    NSData *assetData = [[NSData alloc] initWithBytes:buffer length:size];
    [assetData writeToFile:[NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), repoNaam] atomically:YES];
	
	//Start de zending
	[self startSend:[NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), repoNaam]];
}

- (void)leegTemporaryFiles
{
    NSArray *tmpDirectory = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:NSTemporaryDirectory() error:NULL];
    for (NSString *file in tmpDirectory) {
        [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), file] error:NULL];
    }
}

#pragma mark * Status management

// These methods are used by the core transfer code to update the UI.

- (void)sendDidStart
{
    [[NetworkManager sharedInstance] didStartNetworkOperation];
}

- (void)updateStatus:(NSString *)statusString
{

}

- (void)sendDidStopWithStatus:(NSString *)statusString
{
    if (statusString == nil) {
        statusString = @"ok";
		
		if ([self.delegate respondsToSelector:@selector(transportBeeindigdMetStatus:)]) {
			[self.delegate transportBeeindigdMetStatus:statusString];
		}
    }

    [[NetworkManager sharedInstance] didStopNetworkOperation];
}

#pragma mark * Core transfer code

// This is the code that actually does the networking.

// Because buffer is declared as an array, you have to use a custom getter.
// A synthesised getter doesn't compile.

- (uint8_t *)buffer
{
    return self->_buffer;
}

- (BOOL)isSending
{
    return (self.networkStream != nil);
}

- (void)startSend:(NSString *)filePath
{
    BOOL                    success;
    NSURL *                 url;
    
    assert(filePath != nil);
    assert([[NSFileManager defaultManager] fileExistsAtPath:filePath]);
    assert( [filePath.pathExtension isEqual:@"mov"] || [filePath.pathExtension isEqual:@"png"] );
    
    assert(self.networkStream == nil);      // don't tap send twice in a row!
    assert(self.fileStream == nil);         // ditto
	
    // First get and check the URL.
    
    url = [[NetworkManager sharedInstance] smartURLForString:serverURL];
    success = (url != nil);
    
    if (success) {
        // Add the last part of the file name to the end of the URL to form the final
        // URL that we're going to put to.
        
        url = CFBridgingRelease(
								CFURLCreateCopyAppendingPathComponent(NULL, (__bridge CFURLRef) url, (__bridge CFStringRef) [filePath lastPathComponent], false)
								);
        success = (url != nil);
    }
    
    // If the URL is bogus, let the user know.  Otherwise kick off the connection.
	
    if ( ! success) {
        //Foute URL
    } else {
		
        // Open a stream for the file we're going to send.  We do not open this stream;
        // NSURLConnection will do it for us.
        
        self.fileStream = [NSInputStream inputStreamWithFileAtPath:filePath];
        assert(self.fileStream != nil);
        
        [self.fileStream open];
        
        // Open a CFFTPStream for the URL.
		
        self.networkStream = CFBridgingRelease(
											   CFWriteStreamCreateWithFTPURL(NULL, (__bridge CFURLRef) url)
											   );
        assert(self.networkStream != nil);
		
        if ([username length] != 0) {
            success = [self.networkStream setProperty:username forKey:(id)kCFStreamPropertyFTPUserName];
            assert(success);
            success = [self.networkStream setProperty:password forKey:(id)kCFStreamPropertyFTPPassword];
            assert(success);
        }
		
        self.networkStream.delegate = self;
        [self.networkStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [self.networkStream open];
		
        // Tell the UI we're sending.
        
        [self sendDidStart];
    }
}

- (void)stopSendWithStatus:(NSString *)statusString
{
    if (self.networkStream != nil) {
        [self.networkStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        self.networkStream.delegate = nil;
        [self.networkStream close];
        self.networkStream = nil;
    }
    if (self.fileStream != nil) {
        [self.fileStream close];
        self.fileStream = nil;
    }
    [self sendDidStopWithStatus:statusString];
}

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
// An NSStream delegate callback that's called when events happen on our
// network stream.
{
#pragma unused(aStream)
    assert(aStream == self.networkStream);
	
    switch (eventCode) {
        case NSStreamEventOpenCompleted: {
            [self updateStatus:@"Opened connection"];
        } break;
        case NSStreamEventHasBytesAvailable: {
            assert(NO);     // should never happen for the output stream
        } break;
        case NSStreamEventHasSpaceAvailable: {
            [self updateStatus:@"Sending"];
            
            // If we don't have any data buffered, go read the next chunk of data.
            
            if (self.bufferOffset == self.bufferLimit) {
                NSInteger   bytesRead;
                
                bytesRead = [self.fileStream read:self.buffer maxLength:kSendBufferSize];
                
                if (bytesRead == -1) {
                    [self stopSendWithStatus:@"File read error"];
                } else if (bytesRead == 0) {
                    [self stopSendWithStatus:nil];
                } else {
                    self.bufferOffset = 0;
                    self.bufferLimit  = bytesRead;
                }
            }
            
            // If we're not out of data completely, send the next chunk.
            
            if (self.bufferOffset != self.bufferLimit) {
                NSInteger   bytesWritten;
                bytesWritten = [self.networkStream write:&self.buffer[self.bufferOffset] maxLength:self.bufferLimit - self.bufferOffset];
                assert(bytesWritten != 0);
                if (bytesWritten == -1) {
                    [self stopSendWithStatus:@"Network write error"];
                } else {
                    self.bufferOffset += bytesWritten;
                }
            }
        } break;
        case NSStreamEventErrorOccurred: {
            [self stopSendWithStatus:@"Stream open error"];
        } break;
        case NSStreamEventEndEncountered: {
            // ignore
        } break;
        default: {
            assert(NO);
        } break;
    }
}


@end