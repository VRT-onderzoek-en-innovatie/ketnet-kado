//
//  FilmCameraViewController.m
//  ketnetkado
//
//  Created by Martijn on 9/12/13.
//  Copyright (c) 2013 VRT Onderzoek en Innovatie. All rights reserved.
//

#import "FilmCameraViewController.h"
#import "VideoAlbumManager.h"
#import "PreviewViewController.h"

#define kMaxAantalSeconden 60
#define kFramesPerSeconde 50

#define kOpnameKnopGrootte 104

//Niet enige datumbepaling >> check ook HoofdschermViewController
#define dag01 @"12/18/2013"
#define dag02 @"12/21/2013"
#define dag03 @"12/25/2013"
#define dag04 @"12/28/2013"
#define dag05 @"01/01/2014"

@interface FilmCameraViewController ()

@end

@implementation FilmCameraViewController

@synthesize opdrachtID;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self setupAVSession];
    [self addRecordButton];
	NSLog(@"<FilmCameraViewController> OpdrachtID: %@", opdrachtID);
    
//    if ([opdrachtID isEqualToString:@"0"]) {
//        //Toon opdracht
        [self toonOpdracht];
//    }
//    else {
//        //Gewoon filmen
//    }
}

- (void)viewWillAppear:(BOOL)animated {
    
}
    
- (void)viewDidLayoutSubviews {
    [self setupOutputProperties];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    
#pragma mark - Elementen
    
- (void)addRecordButton {
    btnRecord = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetHeight(self.view.bounds) - kOpnameKnopGrootte,
														   CGRectGetMidX(self.view.bounds) - kOpnameKnopGrootte/2,
														   kOpnameKnopGrootte,
														   kOpnameKnopGrootte)];
    [btnRecord addTarget:self action:@selector(StartStopButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btnRecord setBackgroundImage:[UIImage imageNamed:@"record_pushme"] forState:UIControlStateNormal];
    [self.view addSubview:btnRecord];
}
    
#pragma mark - Acties

- (IBAction)StartStopButtonPressed:(id)sender
    {
        if (!isInOpname)
        {
            NSLog(@"Start opname");
            isInOpname = YES;
			[btnRecord setBackgroundImage:[UIImage imageNamed:@"record_busy"] forState:UIControlStateNormal];
            
            //Tijdelijke url aanmaken om naar op te slaan
            NSString *outputPath = [[NSString alloc] initWithFormat:@"%@%@", NSTemporaryDirectory(), @"output.mov"];
            NSURL *outputURL = [[NSURL alloc] initFileURLWithPath:outputPath];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if ([fileManager fileExistsAtPath:outputPath])
            {
                NSError *error;
                if ([fileManager removeItemAtPath:outputPath error:&error] == NO)
                {
                    //Error
                }
            }
            
            [filmOutput startRecordingToOutputFileURL:outputURL recordingDelegate:self];
        }
        else
        {
            NSLog(@"Stop opname");
            isInOpname = NO;
			[btnRecord setBackgroundImage:[UIImage imageNamed:@"record_pushme"] forState:UIControlStateNormal];
            
            [filmOutput stopRecording];
        }
    }

- (void)prepareForTransportOfAssetURL:(NSURL*)assetURL {
    NSLog(@"<FilmCameraViewController> Klaarmaken voor transport");
    
    PreviewViewController *previewVC = [[PreviewViewController alloc] initWithAssetURL:assetURL andOpdrachtID:opdrachtID];
    [self.navigationController pushViewController:previewVC
                                         animated:YES];
}

#pragma mark - Opdracht

- (void)toonOpdracht {
	if ([opdrachtID isEqualToString:@"0"]) {
		return;
	}
    NSLog(@"<FilmCameraViewController> Toon de opdracht van de dag");
    moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:[self movieURLForToday]];

    [moviePlayer.view setFrame:CGRectMake(0,
                                          0,
                                          CGRectGetHeight(self.view.bounds),
                                          CGRectGetWidth(self.view.bounds))];
    [self.view addSubview:moviePlayer.view];
    [self.view bringSubviewToFront:moviePlayer.view];
    
    // Remove the movie player view controller from the "playback did finish" notification observers
    [[NSNotificationCenter defaultCenter] removeObserver:moviePlayer
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:moviePlayer];
    
    // Register this class as an observer instead
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(movieFinishedCallback:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:moviePlayer];
    
    [moviePlayer setScalingMode:MPMovieScalingModeAspectFit];
    [moviePlayer setControlStyle:MPMovieControlStyleNone];
    
    [moviePlayer play];
}

- (void)movieFinishedCallback:(NSNotification*)aNotification
{
    //Probeer te weten hoe de movieplayer gestopt werd
    NSNumber *finishReason = [[aNotification userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
	
    // Dismiss the view controller ONLY when the reason is not "playback ended"
    if ([finishReason intValue] == MPMovieFinishReasonPlaybackEnded)
    {
		NSLog(@"<FilmCameraViewController> Gebruiker heeft het filmpje uitgekeken. Start nu met filmen...");
		
        //Verwijder de notificatie van de movieplayer
		MPMoviePlayerController *speler = [aNotification object];
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:MPMoviePlayerPlaybackDidFinishNotification
                                                      object:speler];
        //Verwijder de view
        [UIView animateWithDuration:0.25
                         animations:^{
                             [moviePlayer.view setAlpha:0];
                         }
                         completion:^(BOOL finished) {
                             [moviePlayer.view removeFromSuperview];
                             moviePlayer = nil;
                         }];
    }
}

- (NSURL*)movieURLForToday {
	NSString *videoName = [[NSString alloc] init];
    
    NSDateFormatter *mmddccyy = [[NSDateFormatter alloc] init];
    [mmddccyy  setTimeStyle:NSDateFormatterNoStyle];
    [mmddccyy setDateFormat:@"MM/dd/yyyy"];
	
    NSDate *today = [[NSDate alloc]init];
    
    NSDate *day1 = [mmddccyy dateFromString:dag01];
    NSDate *day2 = [mmddccyy dateFromString:dag02];
    NSDate *day3 = [mmddccyy dateFromString:dag03];
    NSDate *day4 = [mmddccyy dateFromString:dag04];
    NSDate *day5 = [mmddccyy dateFromString:dag05];
    
    if([day1 compare:today] == NSOrderedAscending) {
        videoName=@"01";
    }
	if([day2 compare:today] == NSOrderedAscending) {
        videoName=@"02";
    }
	if([day3 compare:today] == NSOrderedAscending) {
        videoName=@"03";
    }
	if([day4 compare:today] == NSOrderedAscending) {
        videoName=@"04";
    }
	if([day5 compare:today] == NSOrderedAscending) {
        videoName=@"05";
    }
	
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:videoName ofType:@"mov" inDirectory:nil]];
	
	return url;
}

    
#pragma mark - Filmsessie setup
    
- (void)setupAVSession {
    //Sessie initialiseren
    session = [[AVCaptureSession alloc] init];
    
    //Kwaliteit instellen
    [session setSessionPreset:AVCaptureSessionPreset1280x720]; //p50
    
    //Inputs toevoegen aan sessie
    //0. Eventuele foutmelding
    NSError *foutBijInput = [[NSError alloc] init];
    
    //1. Video
    AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&foutBijInput];
    
    //2. Audio
    AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    AVCaptureDeviceInput * audioInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:&foutBijInput];
    
    if ([session canAddInput:videoInput] && [session canAddInput:audioInput]) {
        [session addInput:videoInput];
        [session addInput:audioInput];
        
        //Maak de preview klaar
        [self setupPreview];
        
        //Maak de outputs klaar
        [self setupOutputs];
        
        //Start de sessie
        [session startRunning];
    }
}

- (void)setupPreview {
    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspect];
    [[previewLayer connection] setVideoOrientation:AVCaptureVideoOrientationLandscapeRight];
    
    UIView *previewView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                   0,
                                                                   CGRectGetHeight(self.view.bounds),
                                                                   CGRectGetWidth(self.view.bounds))];
    CALayer *rootLayer = [previewView layer];
    [rootLayer setMasksToBounds:YES];
    [previewLayer setFrame:CGRectMake(0, 0, rootLayer.bounds.size.width, rootLayer.bounds.size.height)];
    [rootLayer insertSublayer:previewLayer atIndex:0];
    
    [self.view addSubview:previewView];
}
    
- (void)setupOutputs {
	filmOutput = [[AVCaptureMovieFileOutput alloc] init];

	CMTime maxDuration = CMTimeMakeWithSeconds(kMaxAantalSeconden, kFramesPerSeconde);
	filmOutput.maxRecordedDuration = maxDuration;
	filmOutput.minFreeDiskSpaceLimit = 1024 * 1024;
	
	if ([session canAddOutput:filmOutput]) {
        [session addOutput:filmOutput];
    }
}
    
- (void)setupOutputProperties {
    AVCaptureConnection *verbinding = [filmOutput connectionWithMediaType:AVMediaTypeVideo];
    
    //Set landscape
    if ([verbinding isVideoOrientationSupported])
    {
        [verbinding setVideoOrientation:AVCaptureVideoOrientationLandscapeRight];
    }
}

#pragma mark - AVDelegates
    
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error {
    
    BOOL opnameIsSuccesvol = YES;
    if ([error code] != noErr) {
        //Er was een probleem tijdens de opname. Probeer te vinden of de opname succesvol was.
        id value = [[error userInfo] objectForKey:AVErrorRecordingSuccessfullyFinishedKey];
        if (value)
        {
            opnameIsSuccesvol = [value boolValue];
        }
    }
    if (opnameIsSuccesvol) {
		ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:outputFileURL])
        {
            [library writeVideoAtPathToSavedPhotosAlbum:outputFileURL
                                        completionBlock:^(NSURL *assetURL, NSError *error) {
                                            //error handling
                                            if (error != nil) {
												//Errorhandling
                                            }
											else {
												NSLog(@"<FilmCameraViewController> Doorgeven van de assetURL: %@", assetURL);
                                                [VideoAlbumManager addVideoWithAssetURL:assetURL toAlbumWithName:@"Ketnet Kado"];
                                                [self prepareForTransportOfAssetURL:assetURL];
											}
                                        }];
        }
    }
}

@end
