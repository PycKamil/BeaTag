//
//  Beacon.h
//  BeaTag
//
//  Created by Anna Kwiecińska on 11/10/14.
//  Copyright (c) 2014 Kamil Pyć. All rights reserved.
//

#import <Parse/Parse.h>

@class Event;

@interface Beacon : NSObject

@property (strong) NSString *objectId;
@property (strong) NSNumber *beaconId;

@property (strong) NSNumber *minor;
@property (strong) NSNumber *major;
@property (strong) NSString *uuid;

@property (strong) PFObject *parseObject;

- (instancetype)initWithParseObject:(PFObject *)parseObject;


+ (void)findBeaconByObjectId:(NSString *)objectId;
+ (void)findByMinor:(NSNumber *)minor AndMajor:(NSNumber *)major WithBlock:(PFArrayResultBlock)callback;
+ (void)findByBeaconId:(NSNumber *)beaconId WithBlock:(PFArrayResultBlock)callback;

+ (NSArray *)getBeconsEnitiesWithEstimotes:(NSArray*)estimotesBeacons;
+ (void)assignBeacon:(Beacon *)beacon ToUser:(PFUser *)user AndEvent:(Event *)event WithBlock:(PFBooleanResultBlock)callback;
+ (void)getBeaconsAndEventsAssignedToUser:(PFUser *)user WithBlock:(PFArrayResultBlock)callback;
+ (void)getBeaconForEvent:(Event *)event AssignedToUser:(PFUser *)user WithBlock:(PFArrayResultBlock)callback;

+ (void)findBeaconByObjectId:(NSString *)objectId WithBlock:(PFObjectResultBlock)callback;


@end
