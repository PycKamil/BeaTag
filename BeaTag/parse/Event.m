//
//  Event.m
//  BeaTag
//
//  Created by Anna Kwiecińska on 11/10/14.
//  Copyright (c) 2014 Kamil Pyć. All rights reserved.
//

#import "Event.h"

@implementation Event

- (instancetype)initWithParseObject:(PFObject *)parseObject
{
    
    self = [super init];
    if (self) {
        self.objectId = parseObject[@"objectId"];
        self.name = parseObject[@"name"];

    }
    return self;
    
}


@end
