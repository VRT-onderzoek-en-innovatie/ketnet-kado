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

@interface LoginViewController : UIViewController <LoginManagerDelegate> {
    UITextField *txtUsername;
    UITextField *txtPassword;
    UIButton *btnLogin;
    
    LoginManager *loginManager;
}

@end
