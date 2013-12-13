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

//Niet enige datumbepaling >> check ook FilmCameraViewController
#define dag01 @"10/14/2013"
#define dag02 @"10/19/2013"
#define dag03 @"10/23/2013"
#define dag04 @"10/26/2013"
#define dag05 @"10/30/2013"

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
	
	[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"achtergrond"]]];
    [self maakKnoppen];
}

- (void)viewDidAppear:(BOOL)animated {

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    
#pragma mark - Knop acties

- (void)startFilmenZonderOpdracht {
    [self startFilmenMetOpdrachtID:@"0"];
}

- (void)startFilmenMetOpdracht {
    [self startFilmenMetOpdrachtID:[self opdrachtIDForToday]];
}
    
- (void)startFilmenMetOpdrachtID:(NSString*)opdrachtID {
    NSLog(@"<HoofdschermViewController> Filmen met opdrachtID %@", opdrachtID);
	
	FilmCameraViewController *filmCameraVC = [[FilmCameraViewController alloc] init];
	[filmCameraVC setOpdrachtID:opdrachtID];
    [self.navigationController pushViewController:filmCameraVC
                                         animated:YES];
}

#pragma mark - Opdracht

- (NSString*)opdrachtIDForToday {
	NSString* opdrachtID = @"0";
	
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
        opdrachtID = @"1";
    }
	else if([day2 compare:today] == NSOrderedAscending) {
        opdrachtID = @"2";
    }
	else if([day3 compare:today] == NSOrderedAscending) {
        opdrachtID = @"3";
    }
	else if([day4 compare:today] == NSOrderedAscending) {
        opdrachtID = @"4";
    }
	else if([day5 compare:today] == NSOrderedAscending) {
        opdrachtID = @"5";
    }
	
	return opdrachtID;
}
    
#pragma mark - View setup
    
- (void)maakKnoppen {
    btnFilmen = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMidY(self.view.bounds) - kMargeTussenKnoppen/2 - kKnopBreedte,
                                                           CGRectGetMidX(self.view.bounds)/2 + kKnopHoogte/2,
                                                           kKnopBreedte,
                                                           kKnopHoogte)];
    [btnFilmen addTarget:self
                  action:@selector(startFilmenZonderOpdracht)
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
