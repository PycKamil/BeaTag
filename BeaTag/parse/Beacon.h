//
//  Beacon.h
//  BeaTag
//
//  Created by Anna Kwiecińska on 11/10/14.
//  Copyright (c) 2014 Kamil Pyć. All rights reserved.
//

#import <Parse/Parse.h>

@interface Beacon : NSObject

@property (strong) NSString *objectId;
@property (strong) NSNumber *beaconId;

@property (strong) NSNumber *minor;
@property (strong) NSNumber *major;
@property (strong) NSString *uuid;

@property (strong) PFObject *parseObject;

- (instancetype)initWithParseObject:(PFObject *)parseObject;

+ (void)findByMinor:(NSNumber *)minor AndMajor:(NSNumber *)major WithBlock:(PFArrayResultBlock)callback;
+ (void)findByBeaconId:(NSNumber *)beaconId WithBlock:(PFArrayResultBlock)callback;

@end
