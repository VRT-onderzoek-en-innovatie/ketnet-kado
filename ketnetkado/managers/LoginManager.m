//
//  LoginManager.m
//  ketnetkado
//
//  Created by Martijn Vandenberghe on 12/12/13.
//  Copyright (c) 2013 VRT Onderzoek en Innovatie. All rights reserved.
//

#import "LoginManager.h"

@implementation LoginManager

+ (BOOL)isIngelogd {
    return NO;
}

+ (void)logGebruikerIn {
    UIViewController *vragendeVC = [window rootViewController];
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    [loginVC setDelegate:self];
    
    [vragendeVC presentViewController:loginVC
                             animated:YES
                           completion:^{
                               
                           }];
}

@end
