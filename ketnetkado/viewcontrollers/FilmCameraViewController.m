//
//  FilmCameraViewController.m
//  ketnetkado
//
//  Created by Martijn on 9/12/13.
//  Copyright (c) 2013 VRT Onderzoek en Innovatie. All rights reserved.
//

#import "FilmCameraViewController.h"
#import "VideoAlbumManager.h"

#define kMaxAantalSeconden 60
#define kFramesPerSeconde 50

#define kOpnameKnopGrootte 100

@interface FilmCameraViewController ()

@end

@implementation FilmCameraViewController

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
    UIButton *btnRecord = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetHeight(self.view.bounds) - kOpnameKnopGrootte - 25,
                                                                     CGRectGetMidX(self.view.bounds) - kOpnameKnopGrootte/2,
                                                                     kOpnameKnopGrootte,
                                                                     kOpnameKnopGrootte)];
    [btnRecord addTarget:self action:@selector(StartStopButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btnRecord setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:btnRecord];
}
    
#pragma mark - Acties

- (IBAction)StartStopButtonPressed:(id)sender
    {
        
        if (!isInOpname)
        {
            NSLog(@"Start opname");
            isInOpname = YES;
            
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
            
            [filmOutput stopRecording];
        }
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
		[VideoAlbumManager addVideoWithAssetURL:outputFileURL toAlbumWithName:@"Ketnet Kado"];
		
//        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
//        if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:outputFileURL])
//        {
//            [library writeVideoAtPathToSavedPhotosAlbum:outputFileURL
//                                        completionBlock:^(NSURL *assetURL, NSError *error) {
//                                            //error handling
//                                            if (error!=nil) {
//                                                return;
//                                            }
//                                            
//                                            
//                                        }];
//        }
    }
}

@end
