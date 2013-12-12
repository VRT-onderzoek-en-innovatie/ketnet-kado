//
//  LoginViewController.h
//  ketnetkado
//
//  Created by Martijn Vandenberghe on 12/12/13.
//  Copyright (c) 2013 VRT Onderzoek en Innovatie. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LoginViewController;

@protocol LoginViewControllerDelegate <NSObject>

@required
- (void)isIngelogdMetSessieID:(NSString*)sessieID;
- (void)isNietIngelogdMetFout:(NSError*)fout;

@end

@interface LoginViewController : UIViewController {
    id<LoginViewControllerDelegate>delegate;
    
    UITextField *txtUsername;
    UITextField *txtPassword;
    UIButton *btnLogin;
}

@property (nonatomic, retain) id<LoginViewControllerDelegate>delegate;

@end
