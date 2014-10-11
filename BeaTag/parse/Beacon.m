//
//  Beacon.m
//  BeaTag
//
//  Created by Anna Kwiecińska on 11/10/14.
//  Copyright (c) 2014 Kamil Pyć. All rights reserved.
//

#import "Beacon.h"

@implementation Beacon

@synthesize minor;
@synthesize major;
@synthesize uuid;

NSString* const className = @"Beacon";


- (instancetype)initWithParseObject:(PFObject *)parseObject
{
    
    self = [super init];
    if (self) {
        self.minor = parseObject[@"minor"];
        self.major = parseObject[@"major"];
        self.uuid = parseObject[@"uuid"];
    }
    return self;
    
}


+ (Beacon *)findByUuid:(NSString *)uuid
{
    
    PFQuery * query = [PFQuery queryWithClassName:className];
    [query whereKey:@"uuid" equalTo:uuid];
    
    NSArray *obj = [query findObjects];
    
    
    return [[Beacon alloc] initWithParseObject:[obj objectAtIndex:0]];
}

@end
