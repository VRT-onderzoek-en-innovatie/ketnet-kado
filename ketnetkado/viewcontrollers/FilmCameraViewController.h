//
//  FilmCameraViewController.h
//  ketnetkado
//
//  Created by Martijn on 9/12/13.
//  Copyright (c) 2013 VRT Onderzoek en Innovatie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MediaPlayer/MediaPlayer.h>

@interface FilmCameraViewController : UIViewController <AVCaptureFileOutputRecordingDelegate> {
    AVCaptureSession *session;
    AVCaptureMovieFileOutput *filmOutput;
    
    MPMoviePlayerController *moviePlayer;
	
	UIButton *btnRecord;
    
    BOOL isInOpname;
	
	NSString *opdrachtID;
}

@property (nonatomic, retain) NSString* opdrachtID;
    
- (IBAction)StartStopButtonPressed:(id)sender;

@end
