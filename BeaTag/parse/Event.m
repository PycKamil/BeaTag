//
//  Event.m
//  BeaTag
//
//  Created by Anna Kwiecińska on 11/10/14.
//  Copyright (c) 2014 Kamil Pyć. All rights reserved.
//

#import "Event.h"

@implementation Event

NSString *const parseEventClassName = @"Event";


- (instancetype)initWithParseObject:(PFObject *)parseObject
{
    
    self = [super init];
    if (self) {
        self.parseObject = parseObject;

        self.objectId = parseObject[@"objectId"];
        self.name = parseObject[@"name"];

    }
    return self;
    
}

+ (BOOL)saveToCacheEvents:(NSArray *)events
{
    NSString *cacheDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *path = [cacheDirectoryPath stringByAppendingPathComponent:@"events.out"];
    
    return [events writeToFile:path atomically:YES];
}

+(void)getListOfEventsWithBlock:(PFArrayResultBlock)callback
{
    PFQuery * query = [PFQuery queryWithClassName:parseEventClassName];
    [query findObjectsInBackgroundWithBlock:callback];
}


@end
