//
//  UserManager.m
//  BeaTag
//
//  Created by Anna Kwiecińska on 11/10/14.
//  Copyright (c) 2014 Kamil Pyć. All rights reserved.
//

#import "AppManager.h"

@implementation AppManager

static AppManager *instance;


+ (AppManager *)sharedInstance
{
    static AppManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[AppManager alloc] init];
        // init
    });
    return sharedInstance;
}



@end
