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

@required
- (void)isIngelogdMetSessieID:(NSString*)sessieID;
- (void)isNietIngelogdMetFout:(NSError*)fout;

@end

@interface LoginManager : NSObject {
    id<LoginManagerDelegate>delegate;
}

@property (nonatomic, retain) id<LoginManagerDelegate>delegate;

+ (BOOL)isIngelogd;

- (void)logGebruikerIn;

@end
