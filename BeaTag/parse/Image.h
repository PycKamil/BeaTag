//
//  Image.h
//  BeaTag
//
//  Created by Anna Kwiecińska on 11/10/14.
//  Copyright (c) 2014 Kamil Pyć. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "Beacon.h"


@interface Image : NSObject

@property (strong) NSString* objectId;
@property (strong) PFObject *parseObject;


- (instancetype)initWithParseObject:(PFObject *)parseObject;

- (void)findImagesForBeaconId:(NSString *)beaconId WithBlock:(PFArrayResultBlock)callback;

- (void)findImagesForBeacon:(PFObject *)beacon WithBlock:(PFArrayResultBlock)callback;

- (void)findImagesInEvent:(PFObject *)event ForBeacon:(PFObject *)beacon WithBlock:(PFArrayResultBlock)callback;

- (void)saveImage:(UIImage *)image;

@end
