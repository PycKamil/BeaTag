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

+ (Beacon *)findByMinor:(NSNumber *)minor andMajor:(NSNumber *)major
{
    PFQuery * query = [PFQuery queryWithClassName:parseBeaconClassName];
    [query whereKey:@"uuid" equalTo:[[ESTIMOTE_PROXIMITY_UUID UUIDString] lowercaseString]];
    [query whereKey:@"minor" greaterThan:minor];
    [query whereKey:@"major" greaterThan:major];
    
    return [[query findObjects] firstObject];
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


+(NSArray *)getBeconsEnitiesWithEstimotes:(NSArray *)estimotesBeacons
{
    NSMutableArray *entityBeacons = [NSMutableArray arrayWithCapacity:estimotesBeacons.count];
    
    for (ESTBeacon *estimoteBeacon in estimotesBeacons) {
        Beacon *entityBeacon = [Beacon findByMinor:estimoteBeacon.minor andMajor:estimoteBeacon.major];
        if(entityBeacon) {
            [entityBeacons addObject:entityBeacon];
        } else {
            NSLog(@"Unknown beacon!");
        }
    }
    
    return entityBeacons.copy;
}


@end
