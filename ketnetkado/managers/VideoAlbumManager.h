//
//  VideoAlbumManager.h
//  ketnetkado
//
//  Created by Martijn on 10/12/13.
//  Copyright (c) 2013 VRT Onderzoek en Innovatie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoAlbumManager : NSObject {
	NSConditionLock* albumReadLock;    
}
    
+ (void)addVideoWithAssetURL:(NSURL*)assetURL toAlbumWithName:(NSString*)albumName;

@end
