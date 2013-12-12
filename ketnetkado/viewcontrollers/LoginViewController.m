//
//  LoginViewController.m
//  ketnetkado
//
//  Created by Martijn Vandenberghe on 12/12/13.
//  Copyright (c) 2013 VRT Onderzoek en Innovatie. All rights reserved.
//

#import "LoginViewController.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface LoginViewController ()

@end

@implementation LoginViewController

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
	
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"05achtergrond"]]];
    
    [self setupUitleg];
    [self setupTextFields];
    [self setupLoginButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View setup

- (void)setupUitleg {
    UILabel *uitleg = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                25,
                                                                self.view.frame.size.height,
                                                                30)];
    [uitleg setText:@"Log in met je Ketprofiel"];
    [uitleg setFont:[UIFont fontWithName:@"Ovink-Black" size:20.0]];
    [uitleg setTextAlignment:NSTextAlignmentCenter];
    [uitleg setTextColor:UIColorFromRGB(0xed145b)];
    [self.view addSubview:uitleg];
}

- (void)setupLoginButton  {
    btnLogin = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.bounds),
                                                          200,
                                                          214,
                                                          104)];
    
    [btnLogin addTarget:self
                     action:@selector(logGebruikerIn)
           forControlEvents:UIControlEventTouchUpInside];
	[btnLogin setBackgroundImage:[UIImage imageNamed:@"05loginbutton"] forState:UIControlStateNormal];
	[btnLogin setBackgroundImage:[UIImage imageNamed:@"05loginbutton_pressed"] forState:UIControlStateHighlighted];
    [self.view addSubview:btnLogin];
    [self.view bringSubviewToFront:btnLogin];
}

- (void)setupTextFields {
    txtUsername = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMidY(self.view.bounds) - 348/2,
                                                                50,
                                                                348,
                                                                114)];
    [txtUsername setFont:[UIFont fontWithName:@"Ovink-Black" size:20.0]];
    [txtUsername setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"05username"]]];
    
    UIView *spacerViewUser = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 45, 10)];
    [txtUsername setLeftViewMode:UITextFieldViewModeAlways];
    [txtUsername setLeftView:spacerViewUser];
    
    [self.view addSubview:txtUsername];
    [self.view bringSubviewToFront:txtUsername];
    
    txtPassword = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMidY(self.view.bounds) - 348/2,
                                                                125,
                                                                348,
                                                                114)];
    [txtPassword setFont:[UIFont fontWithName:@"Ovink-Black" size:20.0]];
    [txtPassword setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"05paswoord"]]];
    [txtPassword setSecureTextEntry:YES];
    
    UIView *spacerViewPass = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 45, 10)];
    [txtPassword setLeftViewMode:UITextFieldViewModeAlways];
    [txtPassword setLeftView:spacerViewPass];
    
    [self.view addSubview:txtPassword];
    [self.view bringSubviewToFront:txtPassword];
}

#pragma mark - Acties

- (void)logGebruikerIn {
    NSLog(@"<LoginViewController> Login starten...");
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    loginManager = appDelegate.loginManager;
    [loginManager setDelegate:self];
    
    [loginManager logGebruikerInMetGebruikersnaam:txtUsername.text enPaswoord:txtPassword.text];
}

- (void)touchesEnded: (NSSet *)touches withEvent: (UIEvent *)event {
	for (UIView* view in self.view.subviews) {
		if ([view isKindOfClass:[UITextField class]])
			[view resignFirstResponder];
	}
}

#pragma mark - LoginManager delegate

- (void)isIngelogdMetSessieID:(NSString *)sessieID {
    NSLog(@"<LoginViewController> SessieID (%@) ontvangen, doorgaan met upload", sessieID);
    
    [self.presentingViewController dismissViewControllerAnimated:YES
                                                      completion:^{
                                                          NSLog(@"<LoginViewController> Start the dance...");
                                                      }];
}

- (void)isNietIngelogdMetFout:(NSError *)fout {
    NSLog(@"<LoginViewController> Foutmelding tonen");
    UIAlertView *foutmelding = [[UIAlertView alloc] initWithTitle:@"Oeps!"
                                                          message:@"Je gebruikersnaam of je paswoord zijn niet helemaal juist. Vul je ze even opnieuw in?"
                                                         delegate:self
                                                cancelButtonTitle:@"Ja"
                                                otherButtonTitles:nil];
    [foutmelding show];
}

@end
