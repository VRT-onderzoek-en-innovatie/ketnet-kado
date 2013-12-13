//
//  TransportManager.h
//  ketnetkado
//
//  Created by Martijn Vandenberghe on 12/12/13.
//  Copyright (c) 2013 VRT Onderzoek en Innovatie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "NetworkManager.h"

@class TransportManager;

@protocol TransportManagerDelegate <NSObject>

@required
- (void)transportBeeindigdMetStatus:(NSString*)status;

@end

@interface TransportManager : NSObject <NSStreamDelegate> {
	id<TransportManagerDelegate>delegate;
	
	NSString *serverURL;
	NSString *username;
	NSString *password;
}

@property (nonatomic, retain) id<TransportManagerDelegate>delegate;

@property (nonatomic, assign, readonly ) BOOL              isSending;
@property (nonatomic, strong, readwrite) NSOutputStream *  networkStream;
@property (nonatomic, strong, readwrite) NSInputStream *   fileStream;
@property (nonatomic, assign, readonly ) uint8_t *         buffer;
@property (nonatomic, assign, readwrite) size_t            bufferOffset;
@property (nonatomic, assign, readwrite) size_t            bufferLimit;

- (void)writeAsset:(ALAsset*)asset withFilename:(NSString*)repoNaam;

@end
