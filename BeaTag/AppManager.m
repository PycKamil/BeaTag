//
//  UserManager.m
//  BeaTag
//
//  Created by Anna Kwiecińska on 11/10/14.
//  Copyright (c) 2014 Kamil Pyć. All rights reserved.
//

#import "AppManager.h"
#import "BeaconManager.h"

@implementation AppManager

static AppManager *instance;


+ (AppManager *)sharedInstance
{
    static AppManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[AppManager alloc] init];
        sharedInstance.beaconManager = [[BeaconManager alloc]init];
    });
    return sharedInstance;
}



- (void)uploadEvent:(Event *)event
{
    
}

- (NSArray *)getListOfEvents
{
    return nil;
}

- (NSArray *)getUsersImagesInSelectedEvent
{
    return nil;
    
}

- (void)uploadImage:(UIImage *)image withBeacons:(NSArray *)beacons
{
    
}


@end
