//
//  Beacon.m
//  BeaTag
//
//  Created by Anna Kwiecińska on 11/10/14.
//  Copyright (c) 2014 Kamil Pyć. All rights reserved.
//

#import "Beacon.h"
#import "Constants.h"


@implementation Beacon

- (instancetype)initWithParseObject:(PFObject *)parseObject
{
    
    self = [super init];
    if (self) {
        self.objectId = parseObject[@"objectId"];
        self.minor = parseObject[@"minor"];
        self.major = parseObject[@"major"];
        self.uuid = parseObject[@"uuid"];
    }
    return self;
    
}

+ (Beacon *)findByUuidSync:(NSString *)uuid
{
    PFQuery * query = [PFQuery queryWithClassName:@"Beacon"];
    [query whereKey:@"uuid" equalTo:uuid];
    
    NSArray *obj = [query findObjects];

    return [[Beacon alloc] initWithParseObject:[obj objectAtIndex:0]];
}

+ (void)findByMinor:(NSNumber *)minor AndMajor:(NSNumber *)major WithBlock:(PFArrayResultBlock)callback
{
    PFQuery * query = [PFQuery queryWithClassName:@"Beacon"];
    [query whereKey:@"uuid" equalTo:UUID];
    [query whereKey:@"minor" greaterThan:minor];
    [query whereKey:@"major" greaterThan:major];
    
    [query findObjectsInBackgroundWithBlock:callback];
}

@end
