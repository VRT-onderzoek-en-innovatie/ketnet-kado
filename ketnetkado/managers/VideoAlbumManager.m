//
//  VideoAlbumManager.m
//  ketnetkado
//
//  Created by Martijn on 10/12/13.
//  Copyright (c) 2013 VRT Onderzoek en Innovatie. All rights reserved.
//

#import "VideoAlbumManager.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation VideoAlbumManager
    
+ (void)addVideoWithAssetURL:(NSURL*)assetURL toAlbumWithName:(NSString*)albumName {
	ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
	[library addAssetsGroupAlbumWithName:albumName
							 resultBlock:^(ALAssetsGroup *group) {
								 NSLog(@"<VideoAlbumManager> Album '%@' aangemaakt", albumName);
							 }
							failureBlock:^(NSError *error) {
								NSLog(@"<VideoAlbumManager> Fout bij het aanmaken van het album!");
							}];
	
	__block ALAssetsGroup* groupToAddTo;
    [library enumerateGroupsWithTypes:ALAssetsGroupAlbum
						   usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
							   if ([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:albumName]) {
								   NSLog(@"<VideoAlbumManager> Album '%@' gevonden", albumName);
								   groupToAddTo = group;
							   }
						   }
						 failureBlock:^(NSError* error) {
							 NSLog(@"<VideoAlbumManager> Fout bij het opsommen van de albums:\nFoutmelding: %@", [error localizedDescription]);
						 }];
	
	[library assetForURL:assetURL
			 resultBlock:^(ALAsset *asset) {
				 //Voeg de video toe aan de groep
				 [groupToAddTo addAsset:asset];
				 NSLog(@"<VideoAlbumManager> Video '%@' toegevoegd aan het album '%@'", [[asset defaultRepresentation] filename], albumName);
			 }
			failureBlock:^(NSError* error) {
				NSLog(@"<VideoAlbumManager> Fout bij het toevoegen van de video aan een album:\nFoutmelding: %@ ", [error localizedDescription]);
			}];
}

@end
