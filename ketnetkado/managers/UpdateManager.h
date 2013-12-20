//
//  UpdateManager.h
//  KetnetReporter
//
//  Created by Martijn on 20/12/13.
//  Copyright (c) 2013 VRT Onderzoek en Innovatie. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UpdateManager;

@protocol UpdateManagerDelegate <NSObject>

@required
- (void)heeftUpdateKlaar;

@end

@interface UpdateManager : NSObject <NSURLConnectionDataDelegate> {
	id<UpdateManagerDelegate>delegate;
}

@property (nonatomic, retain) id<UpdateManagerDelegate>delegate;

- (void)checkForUpdate;

@end
