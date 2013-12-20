//
//  UpdateManager.m
//  KetnetReporter
//
//  Created by Martijn on 20/12/13.
//  Copyright (c) 2013 VRT Onderzoek en Innovatie. All rights reserved.
//

#import "UpdateManager.h"

@implementation UpdateManager

@synthesize delegate;

- (void)checkForUpdate {
	NSURL *versionsURL = [[NSURL alloc] initWithString:@"http://ketnet-videoreporter.lab.vrt.be/upload/app/versions.json"];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:versionsURL];
	NSURLConnection *connection =[[NSURLConnection alloc] initWithRequest:request delegate:self];
	
    if (connection) {
		//Alles gaat goed
		NSLog(@"<UpdateManager> Checken op nieuwere versies...");
    }
	else {
		//Fout bij verbinden
		NSLog(@"<UpdateManager> Fout bij checken op nieuwere versies: verbinding faalt");
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	NSDictionary *versions = [NSJSONSerialization JSONObjectWithData:data
															 options:kNilOptions
															   error:nil];

	if ([[versions objectForKey:@"version"] doubleValue] > [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] doubleValue]) {
		NSLog(@"<UpdateManager> Update beschikbaar. Boodschap tonen.");
		if ([self.delegate respondsToSelector:@selector(heeftUpdateKlaar)]) {
			[self.delegate heeftUpdateKlaar];
		}
	}
}

@end
