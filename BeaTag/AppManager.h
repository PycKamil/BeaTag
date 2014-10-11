//
//  UserManager.h
//  BeaTag
//
//  Created by Anna Kwiecińska on 11/10/14.
//  Copyright (c) 2014 Kamil Pyć. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Beacon.h"
#import "Event.h"
#import "BeaconManager.h"

@interface AppManager : NSObject

@property (strong) Beacon* usersBeacon;
@property (strong) Event* selectedEvent;
@property (nonatomic, strong) BeaconManager *beaconManager;

+ (AppManager *)sharedInstance;

- (void)uploadEvent:(Event *)event;
- (NSArray *)getListOfEvents;
- (NSArray *)getUsersImagesInSelectedEvent;
- (void)uploadImage:(UIImage *)image withBeacons:(NSArray *)beacons;

@end
