//
//  Image.m
//  BeaTag
//
//  Created by Anna Kwiecińska on 11/10/14.
//  Copyright (c) 2014 Kamil Pyć. All rights reserved.
//

#import "Image.h"

@implementation Image


NSString* const className = @"Image";

- (instancetype)initWithParseObject:(PFObject *)parseObject
{
    
    self = [super init];
    if (self) {
        self.objectId = parseObject[@"objectId"];
    }
    return self;
    
}

@end
