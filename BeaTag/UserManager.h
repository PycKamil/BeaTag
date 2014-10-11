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

@interface UserManager : NSObject

@property (strong) Beacon* usersBeacon;
@property (strong) Event* selectedEvent;


+ (UserManager *)sharedInstance;

- (NSArray *)getListOfEvents;
- (NSArray *)getUsersImagesInSelectedEvent;
- (void)uploadImage:(UIImage *)image withBeacons:(NSArray *)beacons;

@end
