//
//  Image.m
//  BeaTag
//
//  Created by Anna Kwiecińska on 11/10/14.
//  Copyright (c) 2014 Kamil Pyć. All rights reserved.
//

#import "Image.h"
#import "Beacon.h"

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

+(void)findImagesInEvent:(PFObject *)event WithBlock:(PFArrayResultBlock)callback
{
    PFQuery* query = [PFQuery queryWithClassName:parseImageClassName];
    [query whereKey:@"event" equalTo:event];
    [query findObjectsInBackgroundWithBlock:callback];
}

+ (void)findImagesForBeaconId:(NSString *)beaconId WithBlock:(PFArrayResultBlock)callback
{
    PFObject* beacon = [PFObject objectWithoutDataWithClassName:parseImageClassName objectId:beaconId];
    [self findImagesForBeacon:beacon WithBlock:callback];
}


+ (void)findImagesForBeacon:(PFObject *)beacon WithBlock:(PFArrayResultBlock)callback
{
    PFQuery* query = [PFQuery queryWithClassName:parseImageClassName];
    [query whereKey:@"beacon" equalTo:beacon];
    
    [query findObjectsInBackgroundWithBlock:callback];
}

+ (void)findImagesInEvent:(PFObject *)event ForBeacon:(PFObject *)beacon WithBlock:(PFArrayResultBlock)callback
{
    PFQuery* query = [PFQuery queryWithClassName:parseImageClassName];
    [query whereKey:@"event" equalTo:event];
    [query whereKey:@"beacon" equalTo:beacon];
    
    
    [query findObjectsInBackgroundWithBlock:callback];
}

+ (void)saveImage:(UIImage *)image withBeacons:(NSArray *)enitityBeacons event:(PFObject *)event
{
    NSData *imageData = UIImageJPEGRepresentation(image, 0.05f);
    
    PFFile *file = [PFFile fileWithData:imageData];
    
    [self createRelationUploadImage:file withBeacons:enitityBeacons event:event];
}

+ (void)createRelationUploadImage:(PFFile *)imageFile withBeacons:(NSArray *)enitityBeacons event:(PFObject *)event
{
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {

            PFObject *userPhoto = [PFObject objectWithClassName:parseImageClassName];
            [userPhoto setObject:imageFile forKey:@"imageFile"];
            PFRelation *relation = [userPhoto relationForKey:@"beacons"];
            for (PFObject *beacon in enitityBeacons) {
                [relation addObject:beacon];
            }
            [userPhoto setValue:event forKey:@"event"];
            [userPhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                }
                else {
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

typedef void(^ImageResultBlock)(UIImage *image);


- (void)getImageDataWithBlock:(ImageResultBlock)block
{
    if (self.image) {
        block(self.image);
    } else {
        PFFile *photoFile = [PFFile new];
        [photoFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if(!error) {
                self.image = [UIImage imageWithData:data];
            }
            else {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
    }
}

- (void)saveToCache:(NSDictionary *)imagesInEvent
{
}

- (void)readFromCache
{
}

+(void)uploadImage:(UIImage *)image withBeacons:(NSArray *)enitityBeacons event:(PFObject *)event
{
    [Image saveImage:image withBeacons:enitityBeacons event:event];
}

@end
