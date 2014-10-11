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

- (instancetype)initWithParseObject:(PFObject *)parseObject;

- (void)findImagesForBeacon:(Beacon *)beacon WithBlock:(PFArrayResultBlock)callback;

@end
