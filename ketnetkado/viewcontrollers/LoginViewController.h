//
//  LoginViewController.h
//  ketnetkado
//
//  Created by Martijn Vandenberghe on 12/12/13.
//  Copyright (c) 2013 VRT Onderzoek en Innovatie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "LoginManager.h"

@class LoginViewController;

@protocol LoginViewControllerDelegate <NSObject>

@required
- (void)inloggenBeeindigdMetGebruikersGegevens:(NSDictionary*)gebruikersGegevens;

@end

@interface LoginViewController : UIViewController <LoginManagerDelegate> {
	id<LoginViewControllerDelegate>delegate;
	
    UITextField *txtUsername;
    UITextField *txtPassword;
    UIButton *btnLogin;
    
    LoginManager *loginManager;
}

@property (nonatomic, retain) id<LoginViewControllerDelegate>delegate;

@end
