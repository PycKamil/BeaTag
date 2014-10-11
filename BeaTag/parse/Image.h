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

@property (nonatomic, strong) NSString* objectId;
@property (nonatomic, strong) PFObject *parseObject;
@property (nonatomic, strong) UIImage *image;


- (instancetype)initWithParseObject:(PFObject *)parseObject;

+ (void)findImagesForBeaconId:(NSString *)beaconId WithBlock:(PFArrayResultBlock)callback;

+ (void)findImagesForBeacon:(PFObject *)beacon WithBlock:(PFArrayResultBlock)callback;

+ (void)findImagesInEvent:(PFObject *)event ForBeacon:(PFObject *)beacon WithBlock:(PFArrayResultBlock)callback;

+ (void)findImagesInEvent:(PFObject *)event WithBlock:(PFArrayResultBlock)callback;

+ (void)uploadImage:(UIImage *)image withBeacons:(NSArray *)enitityBeacons event:(PFObject *)event;

@end
