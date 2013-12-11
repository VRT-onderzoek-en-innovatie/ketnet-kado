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

@interface FilmCameraViewController : UIViewController <AVCaptureFileOutputRecordingDelegate> {
    AVCaptureSession *session;
    AVCaptureMovieFileOutput *filmOutput;
	
	UIButton *btnRecord;
    
    BOOL isInOpname;
	
	int opdrachtNummer;
}

@property (nonatomic) int opdrachtNummer;
    
- (IBAction)StartStopButtonPressed:(id)sender;

@end
