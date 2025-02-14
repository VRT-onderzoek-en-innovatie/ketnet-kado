//
//  VerzendViewController.h
//  ketnetkado
//
//  Created by Martijn Vandenberghe on 12/12/13.
//  Copyright (c) 2013 VRT Onderzoek en Innovatie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"

@interface VerzendViewController : UIViewController <LoginViewControllerDelegate, TransportManagerDelegate> {
    NSURL *videoLocatie;
    NSString *opdrachtID;
    
    UIButton *btnMaakNieuwe;
    UIButton *btnStuurDoor;
    UIButton *btnTerugNaarStart;
}

@property (nonatomic, retain) NSURL *videoLocatie;
@property (nonatomic, retain) NSString *opdrachtID;

@end
