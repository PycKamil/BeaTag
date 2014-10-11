//
//  Image.m
//  BeaTag
//
//  Created by Anna Kwiecińska on 11/10/14.
//  Copyright (c) 2014 Kamil Pyć. All rights reserved.
//

#import "Image.h"

@implementation Image

NSString *const parseImageClassName = @"Image";

- (instancetype)initWithParseObject:(PFObject *)parseObject
{
    
    self = [super init];
    if (self) {
        self.parseObject = parseObject;

        self.objectId = parseObject[@"objectId"];
    }
    return self;
    
}

- (void)findImagesForBeaconId:(NSString *)beaconId WithBlock:(PFArrayResultBlock)callback
{
    PFObject* beacon = [PFObject objectWithoutDataWithClassName:parseImageClassName objectId:beaconId];
    [self findImagesForBeacon:beaconId WithBlock:callback];
}


- (void)findImagesForBeacon:(PFObject *)beacon WithBlock:(PFArrayResultBlock)callback
{
    PFQuery* query = [PFQuery queryWithClassName:parseBeaconClassName];
    [query whereKey:@"beacon" equalTo:beacon];
    
    [query findObjectsInBackgroundWithBlock:callback];
}

- (void)findImagesInEvent:(PFObject *)event ForBeacon:(PFObject *)beacon WithBlock:(PFArrayResultBlock)callback
{
    PFQuery* query = [PFQuery queryWithClassName:parseBeaconClassName];
    [quert whereKey:@"event" equalTo:event];
    [query whereKey:@"beacon" equalTo:beacon];
    
    
    [query findObjectsInBackgroundWithBlock:callback];
}

@end
