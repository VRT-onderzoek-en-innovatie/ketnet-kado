//
//  VerzendViewController.m
//  ketnetkado
//
//  Created by Martijn Vandenberghe on 12/12/13.
//  Copyright (c) 2013 VRT Onderzoek en Innovatie. All rights reserved.
//

#import "VerzendViewController.h"
#import "LoginManager.h"

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
}

- (void)stuurFilmpjeDoor {
    if (![LoginManager isIngelogd]) {
        NSLog(@"<VerzendViewController> De gebruiker is nog niet aangemeld. Toont loginscherm...");
    }
    else {
        NSLog(@"<VerzendViewController> De gebruiker is aangemeld, we kunnen verzenden...");
    }
}

- (void)terugNaarStart {
    [self.navigationController popToRootViewControllerAnimated:YES];
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
