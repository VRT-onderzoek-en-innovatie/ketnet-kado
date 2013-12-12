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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View setup

- (void)setupTextFields {
    txtUsername = [[UITextField alloc] initWithFrame:CGRectMake(0,
                                                                0,
                                                                348,
                                                                70)];
    [txtUsername setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"05username"]]];
    [self.view addSubview:txtUsername];
    
    txtPassword = [[UITextField alloc] initWithFrame:CGRectMake(0,
                                                                100,
                                                                348,
                                                                70)];
    [txtPassword setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"05password"]]];
    [txtPassword setSecureTextEntry:YES];
    [self.view addSubview:txtPassword];
}

@end
