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
	
	[self maakAchtergrond];
    
    [self maakKnoppen];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    
#pragma mark - Knop acties
    
- (void)toonOpdracht {
    NSLog(@"<HoofdschermViewController> Toon de opdracht van de dag");
    
	MPMoviePlayerViewController *opdrachtVC = [[MPMoviePlayerViewController alloc] initWithContentURL:[self movieURLForToday]];
	
	// Remove the movie player view controller from the "playback did finish" notification observers
    [[NSNotificationCenter defaultCenter] removeObserver:opdrachtVC
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:opdrachtVC.moviePlayer];
	
    // Register this class as an observer instead
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(movieFinishedCallback:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:opdrachtVC.moviePlayer];

    [self.navigationController presentViewController:opdrachtVC
                                            animated:YES
                                          completion:^{
                                              
                                          }];
}
    
- (void)startFilmenMetOpdrachtNummer:(int)opdrachtNummer {
    NSLog(@"<HoofdschermViewController> Filmen met opdrachtnummer %i", opdrachtNummer);
	
	FilmCameraViewController *filmCameraVC = [[FilmCameraViewController alloc] init];
	[filmCameraVC setOpdrachtNummer:opdrachtNummer];
    [self.navigationController presentViewController:filmCameraVC
                                            animated:YES
                                          completion:^{
                                              
                                          }];
}

#pragma mark - Einde opdracht

- (void)movieFinishedCallback:(NSNotification*)aNotification
{
    //Probeer te weten hoe de movieplayer gestopt werd
    NSNumber *finishReason = [[aNotification userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
	
    // Dismiss the view controller ONLY when the reason is not "playback ended"
    if ([finishReason intValue] == MPMovieFinishReasonPlaybackEnded)
    {
		NSLog(@"<OpdrachtViewController> Gebruiker heeft het filmpje uitgekeken. Opdracht aanvaard.");
		
        //Verwijder de notificatie van de movieplayer
		MPMoviePlayerController *moviePlayer = [aNotification object];
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:MPMoviePlayerPlaybackDidFinishNotification
                                                      object:moviePlayer];
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(opdrachtIsVerdwenen)
													 name:@"OpdrachtIsVerdwenenMelding"
												   object:nil];
        //Verwijder de viewcontroller
        [self.navigationController dismissViewControllerAnimated:YES
													  completion:^{
														  [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"OpdrachtIsVerdwenenMelding" object:nil]];
													  }];
    }
	else if ([finishReason intValue] == MPMovieFinishReasonUserExited) {
		NSLog(@"<OpdrachtViewController> Gebruiker heeft het filmpje gestopt. Geen opdracht aanvaard.");
		
		//Verwijder de viewcontroller
        [self.navigationController dismissMoviePlayerViewControllerAnimated];
	}
}
		 
- (void)opdrachtIsVerdwenen {
	[self startFilmenMetOpdrachtNummer:[self opdrachtNummerForToday]];
}
			 

#pragma mark - Opdracht

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

- (int)opdrachtNummerForToday {
	int opdrachtNummer = 0;
	
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
        opdrachtNummer = 1;
    }
	else if([day2 compare:today] == NSOrderedAscending) {
        opdrachtNummer = 2;
    }
	else if([day3 compare:today] == NSOrderedAscending) {
        opdrachtNummer = 3;
    }
	else if([day4 compare:today] == NSOrderedAscending) {
        opdrachtNummer = 4;
    }
	else if([day5 compare:today] == NSOrderedAscending) {
        opdrachtNummer = 5;
    }
	
	return opdrachtNummer;
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
                  action:@selector(startFilmenMetOpdrachtNummer:)
        forControlEvents:UIControlEventTouchUpInside];
	[btnFilmen setBackgroundImage:[UIImage imageNamed:@"filmen"] forState:UIControlStateNormal];
	[btnFilmen setBackgroundImage:[UIImage imageNamed:@"filmen_pressed"] forState:UIControlStateHighlighted];
    [self.view addSubview:btnFilmen];
    
    btnOpdracht = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMidY(self.view.bounds) + kMargeTussenKnoppen/2,
                                                             CGRectGetMidX(self.view.bounds)/2 + kKnopHoogte/2,
                                                             kKnopBreedte,
                                                             kKnopHoogte)];
    [btnOpdracht addTarget:self
                    action:@selector(toonOpdracht)
          forControlEvents:UIControlEventTouchUpInside];
	[btnOpdracht setBackgroundImage:[UIImage imageNamed:@"opdrachtbekijken"] forState:UIControlStateNormal];
	[btnOpdracht setBackgroundImage:[UIImage imageNamed:@"opdrachtbekijken_pressed"] forState:UIControlStateHighlighted];
    [self.view addSubview:btnOpdracht];
}

@end
