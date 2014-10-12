//
//  UserManager.m
//  BeaTag
//
//  Created by Anna Kwiecińska on 11/10/14.
//  Copyright (c) 2014 Kamil Pyć. All rights reserved.
//

#import "AppManager.h"
#import "BeaconManager.h"
#import "Beacon.h"
#import "Image.h"

@interface AppManager ()

@property (strong,nonatomic) dispatch_queue_t sessionQueue; // Communicate with the session and other session objects on this queue.


@end

@implementation AppManager

static AppManager *instance;


+ (AppManager *)sharedInstance
{
    static AppManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[AppManager alloc] init];
        sharedInstance.beaconManager = [[BeaconManager alloc]init];
        dispatch_queue_t imageUploadQueue = dispatch_queue_create("ImageUpload", DISPATCH_QUEUE_SERIAL);
        sharedInstance.sessionQueue = imageUploadQueue;
        sharedInstance.currentAppCachePolicy = kPFCachePolicyCacheElseNetwork;

    });
    return sharedInstance;
}

- (void)uploadImage:(UIImage *)image
{
    dispatch_async(self.sessionQueue, ^{
        NSArray *estimoteBeacons = [self.beaconManager beaconsArray];
        NSArray *enitityBeacons = [Beacon getBeconsEnitiesWithEstimotes:estimoteBeacons];
        [Image uploadImage:image withBeacons:enitityBeacons event:self.selectedEvent.parseObject];
    });
}


//
//- (void)triggerFetchingListOfBeaconsAndEventsForCurrentUser
//{
//    PFArrayResultBlock completion = ^(NSArray *objects, NSError *error) {
//        
//        
//        NSMutableDictionary *beaconsEvents = [NSMutableDictionary new];
//        
//        for (PFObject* object in objects) {
//            PFObject *e = object[@"event"];
//            PFObject *b = object[@"beacon"];
//            
//        }
//        
//        [AppManager sharedInstance].beaconsAndEvents = beaconsEvents;
//        
//    };
//    
//    
//    [Beacon getBeaconsAndEventsAssignedToUser:[PFUser currentUser] WithBlock:completion];
//    
//}

@end
