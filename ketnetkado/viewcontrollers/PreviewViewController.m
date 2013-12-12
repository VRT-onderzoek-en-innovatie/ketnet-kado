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

- (void)setupThumbnailWithAssetURL:(NSURL*)assetURL {
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library assetForURL:assetURL
             resultBlock:^(ALAsset *asset) {
                 thumbnailView = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                               0,
                                                                               CGRectGetWidth(self.view.frame),
                                                                               CGRectGetHeight(self.view.frame))];
                 [thumbnailView setImage:[UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]]];
                 [self.view addSubview:thumbnailView];
             }
            failureBlock:^(NSError *error) {
                 
             }];
}

@end
