//
//  VerzendViewController.m
//  ketnetkado
//
//  Created by Martijn Vandenberghe on 12/12/13.
//  Copyright (c) 2013 VRT Onderzoek en Innovatie. All rights reserved.
//

#import "VerzendViewController.h"

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

#pragma mark - View setup

- (void)setupButtons {
    btnStuurDoor = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMidY(self.view.bounds) - 214,
                                                              CGRectGetMidX(self.view.bounds) - 104/2,
                                                              214,
                                                              104)];
    [btnStuurDoor addTarget:self
                     action:nil
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
                      action:nil
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
    [btnTerugNaarStart setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btnTerugNaarStart setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [btnTerugNaarStart addTarget:self
                          action:nil
                forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnTerugNaarStart];
    [self.view bringSubviewToFront:btnTerugNaarStart];
}

@end
