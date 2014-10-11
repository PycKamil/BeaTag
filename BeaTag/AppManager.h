//
//  UserManager.h
//  BeaTag
//
//  Created by Anna Kwiecińska on 11/10/14.
//  Copyright (c) 2014 Kamil Pyć. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Event.h"

@class Beacon;
@class BeaconManager;

@interface AppManager : NSObject

@property (strong) Beacon* usersBeacon;
@property (strong) Event* selectedEvent;
@property (nonatomic, strong) BeaconManager *beaconManager;
@property (nonatomic, assign) PFCachePolicy currentAppCachePolicy;

+ (AppManager *)sharedInstance;

- (void)uploadEvent:(Event *)event;
- (NSArray *)getUsersImagesInSelectedEvent;
- (void)uploadImage:(UIImage *)image;

@end
