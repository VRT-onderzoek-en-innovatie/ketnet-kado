//
//  VideoAlbumManager.h
//  ketnetkado
//
//  Created by Martijn on 10/12/13.
//  Copyright (c) 2013 VRT Onderzoek en Innovatie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoAlbumManager : NSObject {
}

+ (BOOL)albumWithAlbumName:(NSString*)albumName;
+ (void)addAlbumWithAlbumName:(NSString *)albumName;
+ (void)addVideoWithAssetURL:(NSURL*)assetURL toAlbumWithName:(NSString*)albumName;

@end
