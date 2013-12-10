//
//  HoofdschermViewController.m
//  ketnetkado
//
//  Created by Martijn on 9/12/13.
//  Copyright (c) 2013 VRT Onderzoek en Innovatie. All rights reserved.
//

#import "HoofdschermViewController.h"

#define kKnopBreedte 150
#define kKnopHoogte 150

#define kMargeTussenKnoppen 50

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
    
- (void)maakKnoppen {
    btnFilmen = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMidY(self.view.bounds) - kMargeTussenKnoppen/2 - kKnopBreedte,
                                                           CGRectGetMidX(self.view.bounds) - kKnopHoogte/2,
                                                           kKnopBreedte,
                                                           kKnopHoogte)];
    [btnFilmen setTitle:@"Filmen" forState:UIControlStateNormal];
    [btnFilmen setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btnFilmen addTarget:self
                  action:@selector(startFilmen)
        forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnFilmen];
    
    btnOpdracht = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMidY(self.view.bounds) + kMargeTussenKnoppen/2,
                                                             CGRectGetMidX(self.view.bounds) - kKnopHoogte/2,
                                                             kKnopBreedte,
                                                             kKnopHoogte)];
    [btnOpdracht setTitle:@"Opdracht bekijken" forState:UIControlStateNormal];
    [btnOpdracht setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btnOpdracht addTarget:self
                    action:@selector(startFilmenMetOpdracht)
          forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnOpdracht];
}

@end
