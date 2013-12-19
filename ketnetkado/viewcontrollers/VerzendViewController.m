//
//  VerzendViewController.m
//  ketnetkado
//
//  Created by Martijn Vandenberghe on 12/12/13.
//  Copyright (c) 2013 VRT Onderzoek en Innovatie. All rights reserved.
//

#import "VerzendViewController.h"
#import "AppDelegate.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface VerzendViewController ()

@end

@implementation VerzendViewController

@synthesize videoLocatie, opdrachtID;

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
    NSLog(@"<VerzendViewController> Opdracht tot verzenden ontvangen voor video (%@) met opdrachtID '%@'", videoLocatie, opdrachtID);
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"04achtergrond"]]];
    [self setupButtons];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Acties

- (void)maakNieuwFilmpje {
    NSLog(@"<VerzendViewController> De gebruiker wil een nieuw filmpje maken met dezelfde opdrachtID");
    //Terugschakelen naar de FilmCameraViewcontroller
    for (UIViewController *childView in [self.navigationController childViewControllers]) {
        if ([childView isKindOfClass:[FilmCameraViewController class]]) {
            [self.navigationController popToViewController:childView animated:YES];
            return;
        }
    }
}

- (void)stuurFilmpjeDoor {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if (![appDelegate.loginManager isIngelogd]) {
        NSLog(@"<VerzendViewController> De gebruiker is nog niet aangemeld. Toont loginscherm...");
        LoginViewController *loginVC = [[LoginViewController alloc] init];
		[loginVC setDelegate:self];
        [self.navigationController presentViewController:loginVC
                                                animated:YES
                                              completion:^{}];
    }
    else {
        NSLog(@"<VerzendViewController> De gebruiker is aangemeld, we kunnen verzenden...");
    }
}

- (void)terugNaarStart {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)toonBezig {
    UIView *bezigView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                 0,
                                                                 self.view.frame.size.width,
                                                                 self.view.frame.size.height)];
    [bezigView setBackgroundColor:UIColorFromRGB(0xed145b)];
    
    UILabel *bezigLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                    self.view.frame.size.height/2 - 50/2 - 50,
                                                                    self.view.frame.size.width,
                                                                    50)];
    [bezigLabel setText:@"We versturen nu je filmpje..."];
    [bezigLabel setFont:[UIFont fontWithName:@"Ovink-Black" size:25.0]];
    [bezigLabel setTextAlignment:NSTextAlignmentCenter];
    [bezigLabel setTextColor:[UIColor whiteColor]];
	[bezigView addSubview:bezigLabel];
	
	UIActivityIndicatorView *bezigSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	[bezigSpinner setFrame:CGRectMake(self.view.frame.size.width/2 - 100/2,
									  self.view.frame.size.height/2 - 100/2 + 20,
									  100,
									  100)];
	[bezigView addSubview:bezigSpinner];
	[bezigSpinner startAnimating];
    
    [bezigView setTag:99];
    [bezigView setAlpha:0];
    [self.view addSubview:bezigView];
    [self.view bringSubviewToFront:bezigView];
    [UIView animateWithDuration:0.25
                     animations:^{
                         [bezigView setAlpha:1];
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

- (void)verbergBezig {
    for (UIView *subView in [self.view subviews]) {
        if (subView.tag == 99) {
            [UIView animateWithDuration:0.25
                             animations:^{
                                 [subView setAlpha:0];
                             }
                             completion:^(BOOL finished) {
                                 [subView removeFromSuperview];
                             }];
        }
    }
}

#pragma mark - LoginViewControllerDelegate

- (void)inloggenBeeindigdMetGebruikersGegevens:(NSDictionary*)gebruikersGegevens {
	NSLog(@"<VerzendViewController> File hernoemen en verzenden");
	
	NSString *reportageNaam = [NSString stringWithFormat:@"%@_%@_%@_%f.mov", opdrachtID, [gebruikersGegevens objectForKey:@"uid"], [gebruikersGegevens objectForKey:@"name"], [NSDate timeIntervalSinceReferenceDate]];
	
	AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	__block TransportManager *transporter = appDelegate.transportManager;
	[transporter setDelegate:self];
	
	ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
	[library assetForURL:videoLocatie
			 resultBlock:^(ALAsset *asset) {
				 [transporter writeAsset:asset withFilename:reportageNaam];
			 }
			failureBlock:^(NSError *error) {
				//Fout bij het vinden van de video
			}];
}

#pragma mark - TransportManagerDelegate

- (void)transportBegonnenMetStatus:(NSString *)status {
	[self toonBezig];
}

- (void)transportBeeindigdMetStatus:(NSString *)status {
	if ([status isEqualToString:@"ok"]) {
		NSLog(@"<VerzendViewController> Transport geslaagd! Terug naar begin.");
		[self verbergBezig];
		[self.navigationController popToRootViewControllerAnimated:YES];
	}
	else {
		NSLog(@"<VerzendViewController> Er liep iets fout bij het versturen!");
	}
}

#pragma mark - View setup

- (void)setupButtons {
    btnStuurDoor = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMidY(self.view.bounds) - 214,
                                                              CGRectGetMidX(self.view.bounds) - 104/2,
                                                              214,
                                                              104)];
    [btnStuurDoor addTarget:self
                     action:@selector(stuurFilmpjeDoor)
           forControlEvents:UIControlEventTouchUpInside];
	[btnStuurDoor setBackgroundImage:[UIImage imageNamed:@"04stuurdoor"] forState:UIControlStateNormal];
	[btnStuurDoor setBackgroundImage:[UIImage imageNamed:@"04stuurdoor_pressed"] forState:UIControlStateHighlighted];
    [self.view addSubview:btnStuurDoor];
    [self.view bringSubviewToFront:btnStuurDoor];
    
    btnMaakNieuwe = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMidY(self.view.bounds),
                                                               CGRectGetMidX(self.view.bounds) - 104/2,
                                                               214,
                                                               104)];
    [btnMaakNieuwe addTarget:self
                      action:@selector(maakNieuwFilmpje)
            forControlEvents:UIControlEventTouchUpInside];
	[btnMaakNieuwe setBackgroundImage:[UIImage imageNamed:@"04maaknieuwe"] forState:UIControlStateNormal];
	[btnMaakNieuwe setBackgroundImage:[UIImage imageNamed:@"04maaknieuwe_pressed"] forState:UIControlStateHighlighted];
    [self.view addSubview:btnMaakNieuwe];
    [self.view bringSubviewToFront:btnMaakNieuwe];
    
    btnTerugNaarStart = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMidY(self.view.bounds) - (400/2),
                                                                   CGRectGetMidX(self.view.bounds) + 50,
                                                                   400,
                                                                   50)];
                                                                 
    [btnTerugNaarStart.titleLabel setFont:[UIFont fontWithName:@"Ovink-Black" size:20.0]];
    [btnTerugNaarStart setTitle:@"Terug naar start" forState:UIControlStateNormal];
    [btnTerugNaarStart setTitleColor:UIColorFromRGB(0x3cc0f0) forState:UIControlStateNormal];
    [btnTerugNaarStart setTitleColor:UIColorFromRGB(0xed145b) forState:UIControlStateHighlighted];
    [btnTerugNaarStart addTarget:self
                          action:@selector(terugNaarStart)
                forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnTerugNaarStart];
    [self.view bringSubviewToFront:btnTerugNaarStart];
}

@end
