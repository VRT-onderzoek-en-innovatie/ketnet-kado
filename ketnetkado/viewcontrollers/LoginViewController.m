//
//  LoginViewController.m
//  ketnetkado
//
//  Created by Martijn Vandenberghe on 12/12/13.
//  Copyright (c) 2013 VRT Onderzoek en Innovatie. All rights reserved.
//

#import "LoginViewController.h"

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
    [self setupTextFields];
    [self setupLoginButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View setup

- (void)setupLoginButton  {
    btnLogin = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMidY(self.view.bounds) - 214,
                                                          CGRectGetMidX(self.view.bounds) + 104/2,
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
                                                                70)];

    [txtUsername setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"05username"]]];
    [self.view addSubview:txtUsername];
    [self.view bringSubviewToFront:txtUsername];
    
    txtPassword = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMidY(self.view.bounds) - 348/2,
                                                                150,
                                                                348,
                                                                70)];
    [txtPassword setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"05paswoord"]]];
    [txtPassword setSecureTextEntry:YES];
    [self.view addSubview:txtPassword];
    [self.view bringSubviewToFront:txtPassword];
}

#pragma mark - Acties

- (void)logGebruikerIn {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    loginManager = appDelegate.loginManager;
    [loginManager setDelegate:self];
    
    [loginManager logGebruikerInMetGebruikersnaam:txtUsername.text enPaswoord:txtPassword.text];
}

#pragma mark - LoginManager delegate

- (void)isIngelogdMetSessieID:(NSString *)sessieID {
    
}

- (void)isNietIngelogdMetFout:(NSError *)fout {
    
}

@end
