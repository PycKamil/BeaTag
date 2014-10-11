//
//  Beacon.m
//  BeaTag
//
//  Created by Anna Kwiecińska on 11/10/14.
//  Copyright (c) 2014 Kamil Pyć. All rights reserved.
//

#import "Beacon.h"
#import <ESTBeaconManager.h>

@implementation Beacon

NSString *const parseBeaconClassName = @"Beacon";

- (instancetype)initWithParseObject:(PFObject *)parseObject
{
    
    self = [super init];
    if (self) {
        self.parseObject = parseObject;
        
        self.objectId = parseObject[@"objectId"];
        self.beaconId = parseObject[@"beaconId"];
        self.minor = parseObject[@"minor"];
        self.major = parseObject[@"major"];
        self.uuid = parseObject[@"uuid"];
    }
    return self;
    
}

+ (void)findByMinor:(NSNumber *)minor AndMajor:(NSNumber *)major WithBlock:(PFArrayResultBlock)callback
{
    PFQuery * query = [PFQuery queryWithClassName:parseBeaconClassName];
    [query whereKey:@"uuid" equalTo:ESTIMOTE_PROXIMITY_UUID];
    [query whereKey:@"minor" greaterThan:minor];
    [query whereKey:@"major" greaterThan:major];
    
    [query findObjectsInBackgroundWithBlock:callback];
}


+ (void)findByBeaconId:(NSNumber *)beaconId WithBlock:(PFArrayResultBlock)callback
{
    PFQuery * query = [PFQuery queryWithClassName:parseBeaconClassName];
    [query whereKey:@"beaconId" equalTo:beaconId];

    [query findObjectsInBackgroundWithBlock:callback];
}



@end
