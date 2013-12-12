//
//  LoginManager.m
//  ketnetkado
//
//  Created by Martijn Vandenberghe on 12/12/13.
//  Copyright (c) 2013 VRT Onderzoek en Innovatie. All rights reserved.
//

#import "LoginManager.h"
#import "AppDelegate.h"

@implementation LoginManager

+ (BOOL)isIngelogd {
    return NO;
}

- (void)logGebruikerIn {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    
    [appDelegate.window.rootViewController.navigationController presentViewController:loginVC
                                                                             animated:YES
                                                                           completion:nil];
    
    [loginVC setDelegate:self];
}

#pragma mark - LoginViewController

@end
