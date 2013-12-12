//
//  LoginManager.h
//  ketnetkado
//
//  Created by Martijn Vandenberghe on 12/12/13.
//  Copyright (c) 2013 VRT Onderzoek en Innovatie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginViewController.h"

@class LoginManager;

@protocol LoginManagerDelegate <NSObject>

@optional

@end

@interface LoginManager : NSObject <LoginViewControllerDelegate> {
    
}

+ (BOOL)isIngelogd;

- (void)logGebruikerIn;

@end
