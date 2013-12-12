//
//  PreviewViewController.h
//  ketnetkado
//
//  Created by Martijn Vandenberghe on 12/12/13.
//  Copyright (c) 2013 VRT Onderzoek en Innovatie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface PreviewViewController : UIViewController {
    MPMoviePlayerController *moviePlayer;
    NSURL *videoLocatie;
    NSString *opdrachtID;
    
    UIImageView *thumbnailView;
}

@property (nonatomic, retain) MPMoviePlayerController *moviePlayer;
@property (nonatomic, retain) NSURL *videoLocatie;
@property (nonatomic, retain) NSString *opdrachtID;

- (id)initWithAssetURL:(NSURL*)assetURL andOpdrachtID:(NSString*)opdracht;

@end
