//
//  HoofdschermViewController.m
//  ketnetkado
//
//  Created by Martijn on 9/12/13.
//  Copyright (c) 2013 VRT Onderzoek en Innovatie. All rights reserved.
//

#import "HoofdschermViewController.h"
#import "opdrachtdatums.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define kKnopBreedte 136
#define kKnopHoogte 125

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
	
	[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"01achtergrond"]]];
    [self maakKnoppen];
	[self maakLabels];
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

- (void)toonInfo {
	UIAlertView *altVoorwaarden = [[UIAlertView alloc] initWithTitle:@"Info"
															 message:@"Dit is een testversie van de \nKetnet Reporter-applicatie.\nDit is geen finaal product.\nProblemen met de app? Mail naar panel@deproeftuin.vrt.be.\n Gebruikersvoorwaarden op\nhttp://deproeftuin.vrt.be/node/123"
															delegate:self
												   cancelButtonTitle:@"OK"
												   otherButtonTitles:nil];
	[altVoorwaarden show];
}

#pragma mark - Opdracht

- (NSString*)opdrachtIDForToday {
	NSString* opdrachtID = @"1";
	
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
	if([day2 compare:today] == NSOrderedAscending) {
        opdrachtID = @"2";
    }
	if([day3 compare:today] == NSOrderedAscending) {
        opdrachtID = @"3";
    }
	if([day4 compare:today] == NSOrderedAscending) {
        opdrachtID = @"4";
    }
	if([day5 compare:today] == NSOrderedAscending) {
        opdrachtID = @"5";
    }
	
	return opdrachtID;
}

- (NSArray*)iconForToday {
	UIImage *icoon = [UIImage imageNamed:@"01filmen"];
	UIImage *icoon_ingedrukt = [UIImage imageNamed:@"01filmen_pressed"];
	
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
		icoon = [UIImage imageNamed:@"01opdracht"];
		icoon_ingedrukt = [UIImage imageNamed:@"01opdracht_pressed"];
    }
	if([day2 compare:today] == NSOrderedAscending) {
        icoon = [UIImage imageNamed:@"01huisdier"];
		icoon_ingedrukt = [UIImage imageNamed:@"01huisdier_pressed"];
    }
	if([day3 compare:today] == NSOrderedAscending) {
        icoon = [UIImage imageNamed:@"01sidool"];
		icoon_ingedrukt = [UIImage imageNamed:@"01idool_pressed"];
    }
	if([day4 compare:today] == NSOrderedAscending) {
        icoon = [UIImage imageNamed:@"01schrikken"];
		icoon_ingedrukt = [UIImage imageNamed:@"01schrikken_pressed"];
    }
	if([day5 compare:today] == NSOrderedAscending) {
        icoon = [UIImage imageNamed:@"01interviewstraat"];
		icoon_ingedrukt = [UIImage imageNamed:@"01interviewstraat_pressed"];
    }
	
	NSArray *icoonArray = [[NSArray alloc] initWithObjects:icoon, icoon_ingedrukt, nil];
	
	return icoonArray;
}

- (NSString*)opdrachtTekstForToday {
	NSString *opdrachtTekst = @"Welkom";
	
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
		opdrachtTekst = @"Welkom";
    }
	if([day2 compare:today] == NSOrderedAscending) {
		opdrachtTekst = @"Huisdier";
    }
	if([day3 compare:today] == NSOrderedAscending) {
		opdrachtTekst = @"Idool";
    }
	if([day4 compare:today] == NSOrderedAscending) {
		opdrachtTekst = @"Schrikken";
    }
	if([day5 compare:today] == NSOrderedAscending) {
		opdrachtTekst = @"Interview";
    }
	
	return opdrachtTekst;
}
    
#pragma mark - View setup
    
- (void)maakKnoppen {
    btnFilmen = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMidY(self.view.bounds) - kMargeTussenKnoppen/2 - kKnopBreedte,
                                                           CGRectGetMidX(self.view.bounds)/2,
                                                           kKnopBreedte,
                                                           kKnopHoogte)];
    [btnFilmen addTarget:self
                  action:@selector(startFilmenZonderOpdracht)
        forControlEvents:UIControlEventTouchUpInside];
	[btnFilmen setBackgroundImage:[UIImage imageNamed:@"01filmen"] forState:UIControlStateNormal];
	[btnFilmen setBackgroundImage:[UIImage imageNamed:@"01filmen_pressed"] forState:UIControlStateHighlighted];
    [self.view addSubview:btnFilmen];
    
    btnOpdracht = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMidY(self.view.bounds) + kMargeTussenKnoppen/2,
                                                             CGRectGetMidX(self.view.bounds)/2,
                                                             kKnopBreedte,
                                                             kKnopHoogte)];
    [btnOpdracht addTarget:self
                    action:@selector(startFilmenMetOpdracht)
          forControlEvents:UIControlEventTouchUpInside];
	[btnOpdracht setBackgroundImage:[[self iconForToday] objectAtIndex:0] forState:UIControlStateNormal];
	[btnOpdracht setBackgroundImage:[[self iconForToday] objectAtIndex:1] forState:UIControlStateHighlighted];
    [self.view addSubview:btnOpdracht];
	
	btnVoorwaarden = [[UIButton alloc] initWithFrame:CGRectMake(420,
																230,
																214,
																104)];
    [btnVoorwaarden addTarget:self
                    action:@selector(toonInfo)
          forControlEvents:UIControlEventTouchUpInside];
	[btnVoorwaarden setBackgroundImage:[UIImage imageNamed:@"01vraagteken"] forState:UIControlStateNormal];
	[btnVoorwaarden setBackgroundImage:[UIImage imageNamed:@"01vraagteken_pressed"] forState:UIControlStateHighlighted];
    [self.view addSubview:btnVoorwaarden];
}

- (void)maakLabels {
	lblFilmen = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidY(self.view.bounds) - kMargeTussenKnoppen/2 - kKnopBreedte,
														  CGRectGetMidX(self.view.bounds)/2 + 75,
														  kKnopBreedte,
														  kKnopHoogte)];
	[lblFilmen setText:@"Filmen"];
	[lblFilmen setFont:[UIFont fontWithName:@"Ovink-Black" size:25.0]];
	[lblFilmen setTextAlignment:NSTextAlignmentCenter];
	[lblFilmen setTextColor:UIColorFromRGB(0xed145b)];
	[self.view addSubview:lblFilmen];
	
	lblOpdracht = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidY(self.view.bounds) + kMargeTussenKnoppen/2,
															CGRectGetMidX(self.view.bounds)/2 + 75,
															kKnopBreedte,
															kKnopHoogte)];
	[lblOpdracht setText:[self opdrachtTekstForToday]];
	[lblOpdracht setFont:[UIFont fontWithName:@"Ovink-Black" size:25.0]];
	[lblOpdracht setTextAlignment:NSTextAlignmentCenter];
	[lblOpdracht setTextColor:UIColorFromRGB(0xed145b)];
	[self.view addSubview:lblOpdracht];
}

@end
