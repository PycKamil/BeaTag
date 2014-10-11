//
//  Event.h
//  BeaTag
//
//  Created by Anna Kwiecińska on 11/10/14.
//  Copyright (c) 2014 Kamil Pyć. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>


@interface Event : NSObject

@property (strong) NSString* objectId;
@property (strong) NSString* name;
@property (strong) PFObject* parseObject;

@property (strong) NSString* photoAddress;
@property (strong) NSString* dateString;


- (instancetype)initWithParseObject:(PFObject *)parseObject;

+ (void)getListOfEventsWithBlock:(PFArrayResultBlock)callback;


@end
