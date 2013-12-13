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
	//NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
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
    
	//NSLog(@"<LoginManager> Antwoord van de server: %d", [urlResponse statusCode]);
    NSLog(@"<LoginManager> Antwoord van de server: %ld", (long)[urlResponse statusCode]);
    if ([urlResponse statusCode] == 200) {
        NSDictionary *resultDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
        if ([[resultDictionary objectForKey:@"success"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
            NSLog(@"<LoginManager> Login succesvol!");
            //Sla de sessie op in een cookie
            [self maakCookieVoorSessie:[resultDictionary objectForKey:@"session_id"]];
            //Haal de gegevens op
            [self haalGebruikersgegevensOpVoorSessieID:[resultDictionary objectForKey:@"session_id"]];
        }
        else {
            NSLog(@"<LoginManager> Login gefaald, geen correcte gegevens!");
            if ([self.delegate respondsToSelector:@selector(isNietIngelogdMetFout:)]) {
                NSLog(@"<LoginManager> Boodschap doorgeven.");
                [self.delegate isNietIngelogdMetFout:error];
            }
        }
    }
    else {
        NSLog(@"<LoginManager> Antwoord van server is niet goed, login heeft gefaald.");
    }
}

- (void)maakCookieVoorSessie:(NSString*)sessieID {
    NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
    [cookieProperties setObject:@"session_id" forKey:NSHTTPCookieName];
    [cookieProperties setObject:sessieID forKey:NSHTTPCookieValue];
    [cookieProperties setObject:@"www.ketnet.be" forKey:NSHTTPCookieDomain];
    [cookieProperties setObject:@"www.ketnet.be" forKey:NSHTTPCookieOriginURL];
    [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
    [cookieProperties setObject:@"0" forKey:NSHTTPCookieVersion];
    
    //Vervaldatum (van een maand) zetten zodat onze sessie blijft doorlopen in de app en over het systeem heen.
    //Wegdoen = cookie vernietigen bij exist
    [cookieProperties setObject:[[NSDate date] dateByAddingTimeInterval:2629743] forKey:NSHTTPCookieExpires];
    
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
}

- (void)haalGebruikersgegevensOpVoorSessieID:(NSString*)sessieID {
    NSLog(@"<LoginManager> Met sessieID gebruikersgegevens ophalen...");
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    //Cookies in de headers plaatsen
    NSDictionary *headers = [NSHTTPCookie requestHeaderFieldsWithCookies:[cookieJar cookies]];
    [request setAllHTTPHeaderFields:headers];
    
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.ketnet.be/ws/user"]]];
    [request setHTTPMethod:@"GET"];
    
    NSHTTPURLResponse* urlResponse = nil;
    NSError *error = [[NSError alloc] init];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if ([urlResponse statusCode] == 200) {
        NSDictionary *resultDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
        if ([[resultDictionary objectForKey:@"success"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
            NSLog(@"<LoginManager> Gebruikersgegevens ophalen succesvol!");
            if ([self.delegate respondsToSelector:@selector(isIngelogdMetGebruikersGegevens:)]) {
                NSLog(@"<LoginManager> Gebruikersgegevens doorgeven.");
                [self.delegate isIngelogdMetGebruikersGegevens:[resultDictionary objectForKey:@"user"]];
            }
        }
        else {
            NSLog(@"<LoginManager> Gebruikersgegevens ophalen heeft gefaald!");
            if ([self.delegate respondsToSelector:@selector(isNietIngelogdMetFout:)]) {
                NSLog(@"<LoginManager> Boodschap doorgeven");
                [self.delegate isNietIngelogdMetFout:error];
            }
        }
    }
    else {
        NSLog(@"<LoginManager> Antwoord van server is niet goed, login heeft gefaald.");
    }
}

@end
