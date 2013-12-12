//
//  AppDelegate.h
//  ketnetkado
//
//  Created by Martijn on 9/12/13.
//  Copyright (c) 2013 VRT Onderzoek en Innovatie. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HoofdschermViewController.h"
#import "LoginManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    LoginManager *loginManager;
}

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, retain) LoginManager *loginManager;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
