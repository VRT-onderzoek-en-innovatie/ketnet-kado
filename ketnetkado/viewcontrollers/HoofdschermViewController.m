//
//  HoofdschermViewController.m
//  ketnetkado
//
//  Created by Martijn on 9/12/13.
//  Copyright (c) 2013 VRT Onderzoek en Innovatie. All rights reserved.
//

#import "HoofdschermViewController.h"

#define kKnopBreedte 214
#define kKnopHoogte 104

#define kMargeTussenKnoppen 0

@interface HoofdschermViewController ()

@end

@implementation HoofdschermViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES];
	
	[self maakAchtergrond];
    
    [self maakKnoppen];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    
#pragma mark - Knop acties
    
- (void)startFilmen {
    NSLog(@"Filmen zonder opdracht");
    
    FilmCameraViewController *filmCameraVC = [[FilmCameraViewController alloc] init];
    [self.navigationController presentViewController:filmCameraVC
                                            animated:YES
                                          completion:^{
                                              
                                          }];
}
    
- (void)startFilmenMetOpdracht {
    NSLog(@"Filmen met opdracht");
}
    
#pragma mark - View setup

- (void)maakAchtergrond {
	UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"achtergrond"]];
	[self.view addSubview:backgroundView];
	[self.view sendSubviewToBack:backgroundView];
}
    
- (void)maakKnoppen {
    btnFilmen = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMidY(self.view.bounds) - kMargeTussenKnoppen/2 - kKnopBreedte,
                                                           CGRectGetMidX(self.view.bounds)/2 + kKnopHoogte/2,
                                                           kKnopBreedte,
                                                           kKnopHoogte)];
    [btnFilmen addTarget:self
                  action:@selector(startFilmen)
        forControlEvents:UIControlEventTouchUpInside];
	[btnFilmen setBackgroundImage:[UIImage imageNamed:@"filmen"] forState:UIControlStateNormal];
	[btnFilmen setBackgroundImage:[UIImage imageNamed:@"filmen_pressed"] forState:UIControlStateHighlighted];
    [self.view addSubview:btnFilmen];
    
    btnOpdracht = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMidY(self.view.bounds) + kMargeTussenKnoppen/2,
                                                             CGRectGetMidX(self.view.bounds)/2 + kKnopHoogte/2,
                                                             kKnopBreedte,
                                                             kKnopHoogte)];
    [btnOpdracht addTarget:self
                    action:@selector(startFilmenMetOpdracht)
          forControlEvents:UIControlEventTouchUpInside];
	[btnOpdracht setBackgroundImage:[UIImage imageNamed:@"opdrachtbekijken"] forState:UIControlStateNormal];
	[btnOpdracht setBackgroundImage:[UIImage imageNamed:@"opdrachtbekijken_pressed"] forState:UIControlStateHighlighted];
    [self.view addSubview:btnOpdracht];
}

@end
