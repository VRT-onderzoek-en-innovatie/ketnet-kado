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
    NSLog(@"<LoginManager> Logingegevens ontvangen, aanvraag doen...");
    NSString *post = [NSString stringWithFormat:@"name=%@&pass=%@",username, password];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.ketnet.be/ketnet_com/login"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
    [request setHTTPBody:postData];

    NSHTTPURLResponse* urlResponse = nil;
    NSError *error = [[NSError alloc] init];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
//     NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    NSLog(@"<LoginManager> Antwoord van de server: %d", [urlResponse statusCode]);
    if ([urlResponse statusCode] == 200) {
        NSDictionary *resultDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
        if ([[resultDictionary objectForKey:@"success"] isEqualToString:@"true"]) {
            NSLog(@"<LoginManager> Login succesvol!");
            if ([self.delegate respondsToSelector:@selector(isIngelogdMetSessieID:)]) {
                NSLog(@"<LoginManager> SessieID doorgeven");
                [self.delegate isIngelogdMetSessieID:[resultDictionary objectForKey:@"session_id"]];
            }
        }
        else {
            NSLog(@"<LoginManager> Login gefaald, geen correcte gegevens!");
            if ([self.delegate respondsToSelector:@selector(isNietIngelogdMetFout:)]) {
                NSLog(@"<LoginManager> Boodschap doorgeven");
                [self.delegate isNietIngelogdMetFout:nil];
            }
        }
    }
    else {
        NSLog(@"<LoginManager> Antwoord van server is niet goed, login heeft gefaald.");
    }
}

@end
