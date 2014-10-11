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
    [self findImagesForBeacon:beacon WithBlock:callback];
}


- (void)findImagesForBeacon:(PFObject *)beacon WithBlock:(PFArrayResultBlock)callback
{
    PFQuery* query = [PFQuery queryWithClassName:parseImageClassName];
    [query whereKey:@"beacon" equalTo:beacon];
    
    [query findObjectsInBackgroundWithBlock:callback];
}

- (void)findImagesInEvent:(PFObject *)event ForBeacon:(PFObject *)beacon WithBlock:(PFArrayResultBlock)callback
{
    PFQuery* query = [PFQuery queryWithClassName:parseImageClassName];
    [query whereKey:@"event" equalTo:event];
    [query whereKey:@"beacon" equalTo:beacon];
    
    
    [query findObjectsInBackgroundWithBlock:callback];
}

- (void)saveImage:(UIImage *)image
{
    NSData *imageData = UIImageJPEGRepresentation(image, 0.05f);
    
    PFFile *file = [PFFile fileWithData:imageData];
    
    [self uploadImage:file];
}

- (void)uploadImage:(PFFile *)imageFile
{
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {

            PFObject *userPhoto = [PFObject objectWithClassName:parseImageClassName];
            [userPhoto setObject:imageFile forKey:@"imageFile"];
            
            [userPhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                }
                else{
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
        }
        else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    } progressBlock:^(int percentDone) {
    }];
}

- (void)saveToCache:(NSDictionary *)imagesInEvent
{
}

- (void)readFromCache
{
}

@end
