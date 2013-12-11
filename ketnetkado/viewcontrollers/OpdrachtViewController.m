//
//  OpdrachtViewController.m
//  ketnetkado
//
//  Created by Martijn on 11/12/13.
//  Copyright (c) 2013 VRT Onderzoek en Innovatie. All rights reserved.
//

#import "OpdrachtViewController.h"

#define dag01 @"10/14/2013"
#define dag02 @"10/19/2013"
#define dag03 @"10/23/2013"
#define dag04 @"10/26/2013"
#define dag05 @"10/30/2013"

@interface OpdrachtViewController ()

@end

@implementation OpdrachtViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Opdrachtlogica

- (NSURL*)movieURLForToday {
	NSString *videoName = [[NSString alloc] init];
    
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
        videoName=@"01";
    }
	else if([day2 compare:today] == NSOrderedAscending) {
        videoName=@"02";
    }
	else if([day3 compare:today] == NSOrderedAscending) {
        videoName=@"03";
    }
	else if([day4 compare:today] == NSOrderedAscending) {
        videoName=@"04";
    }
	else if([day5 compare:today] == NSOrderedAscending) {
        videoName=@"05";
    }

    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:videoName ofType:@"mov" inDirectory:nil]];
	
	return url;
}

@end
