//
//  PreviewViewController.m
//  ketnetkado
//
//  Created by Martijn Vandenberghe on 12/12/13.
//  Copyright (c) 2013 VRT Onderzoek en Innovatie. All rights reserved.
//

#import "PreviewViewController.h"

@interface PreviewViewController ()

@end

@implementation PreviewViewController

@synthesize moviePlayer;
@synthesize videoLocatie, opdrachtID;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithAssetURL:(NSURL*)assetURL andOpdrachtID:(NSString *)opdracht {
    self = [super init];
    if (self) {
        NSLog(@"<PreviewViewController> Video voor opdracht %@ ontvangen. Thumbnail tonen...", opdrachtID);
        [self setVideoLocatie:assetURL];
        [self setOpdrachtID:opdrachtID];
        [self setupThumbnailWithAssetURL:assetURL];
        [self setupPlayButtons];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
}

- (void)viewDidAppear:(BOOL)animated {
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Werking



#pragma mark - View setup

- (void)setupBackground {
    achtergrond = [[UIImageView alloc] initWithFrame:self.view.frame];
    [achtergrond setImage:[UIImage imageNamed:@"achtergrond"]];
    [self.view addSubview:achtergrond];
    [self.view sendSubviewToBack:achtergrond];
}

- (void)setupPlayButtons {
    btnAfspelenUitleg = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMidY(self.view.bounds) - (214/2),
                                                                   CGRectGetMidX(self.view.bounds),
                                                                   214,
                                                                   104)];
    [btnAfspelenUitleg addTarget:self
                          action:nil
                forControlEvents:UIControlEventTouchUpInside];
	[btnAfspelenUitleg setBackgroundImage:[UIImage imageNamed:@"opdrachtbekijken"] forState:UIControlStateNormal];
	[btnAfspelenUitleg setBackgroundImage:[UIImage imageNamed:@"opdrachtbekijken_pressed"] forState:UIControlStateHighlighted];
    [self.view addSubview:btnAfspelenUitleg];
    [self.view bringSubviewToFront:btnAfspelenUitleg];
    
    btnPlay = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMidY(self.view.bounds) - (104/2),
                                                         CGRectGetMidX(self.view.bounds) - 104,
                                                         104,
                                                         104)];
    [btnPlay addTarget:self
                action:nil
      forControlEvents:UIControlEventTouchUpInside];
	[btnPlay setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    [self.view addSubview:btnPlay];
    [self.view bringSubviewToFront:btnPlay];
}

- (void)setupThumbnailWithAssetURL:(NSURL*)assetURL {
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library assetForURL:assetURL
             resultBlock:^(ALAsset *asset) {
                 thumbnailView = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                               0,
                                                                               CGRectGetWidth(self.view.frame),
                                                                               CGRectGetHeight(self.view.frame))];
                 [thumbnailView setImage:[UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]]];
                 [thumbnailView setAlpha:0];
                 [self.view addSubview:thumbnailView];
                 [self.view sendSubviewToBack:thumbnailView];
                 
                 [UIView animateWithDuration:0.25
                                  animations:^{
                                      [thumbnailView setAlpha:1.0];
                                      [achtergrond setAlpha:0.0];
                                  }
                                  completion:^(BOOL finished) {
                                      //verwijder de achtergrond
                                      [achtergrond removeFromSuperview];
                                      achtergrond = nil;
                                  }];
             }
            failureBlock:^(NSError *error) {
                 
             }];
}

@end
