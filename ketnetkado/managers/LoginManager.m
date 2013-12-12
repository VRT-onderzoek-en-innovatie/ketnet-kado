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

@synthesize delegate;

- (id)init {
    self = [super init];
    if (self) {
        //We bestaan! Hoera!
        //Check of er al credentials zijn opgeslagen en log al in indien ja.
        if (![self heeftCredentials]) {
            NSLog(@"<LoginManager> Er zijn nog geen credentials te vinden, gebruiker zal moeten inloggen straks");
        }
        else {
            NSLog(@"<LoginManager> Credentials gevonden, inloggen...");
        }
    }
    
    return self;
}

- (BOOL)heeftCredentials {
    return NO;
}

- (BOOL)isIngelogd {
    NSLog(@"<LoginManager> Aanvraag of de gebruiker is ingelogd.");
    return [self heeftCredentials];
}

- (void)logGebruikerInMetGebruikersnaam:(NSString*)username enPaswoord:(NSString*)password {
    
}

#pragma mark - LoginViewController

@end
