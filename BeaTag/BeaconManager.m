//
//  BeaconManager.m
//  BeaTag
//
//  Created by Kamil Pyć on 10/11/14.
//  Copyright (c) 2014 Kamil Pyć. All rights reserved.
//

#import "BeaconManager.h"
#import <EstimoteSDK/ESTBeaconManager.h>
#import "ErrorHelper.h"

@interface BeaconManager() <ESTBeaconManagerDelegate>

@property (nonatomic, strong) ESTBeaconManager *beaconManager;
@property (nonatomic, strong) ESTBeaconRegion *region;
@property (nonatomic, strong) NSArray *beaconsArray;


@end

@implementation BeaconManager


-(id)init
{
    self = [super init];
    if (self) {
        [self initEstimoteBeaconManagerAndRegion];
    }
    return self;
}

-(void)initEstimoteBeaconManagerAndRegion
{
    self.beaconManager = [[ESTBeaconManager alloc] init];
    self.beaconManager.delegate = self;
    self.region = [[ESTBeaconRegion alloc]initWithProximityUUID:ESTIMOTE_PROXIMITY_UUID identifier:@"BeaTagRegion"];
}

- (void)beaconManager:(ESTBeaconManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    [self startRangingBeacons];
}

-(void)startRangingBeacons
{
    if ([ESTBeaconManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [self.beaconManager requestAlwaysAuthorization];
    } else if([ESTBeaconManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways) {
        [self.beaconManager startRangingBeaconsInRegion:self.region];
    } else if([ESTBeaconManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        displayErrorOnMainQueue(nil, @"Beacons module error!");
    } else if([ESTBeaconManager authorizationStatus] == kCLAuthorizationStatusRestricted) {
        displayErrorOnMainQueue(nil, @"You have no access to location services.");
    }
}

- (void)beaconManager:(ESTBeaconManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(ESTBeaconRegion *)region
{
    self.beaconsArray = beacons;
}

-(void)beaconManager:(ESTBeaconManager *)manager rangingBeaconsDidFailForRegion:(ESTBeaconRegion *)region withError:(NSError *)error
{
    displayErrorOnMainQueue(error, @"Beacons module error!");
    
}

-(void)dealloc
{
    [self.beaconManager stopRangingBeaconsInRegion:self.region];
    [self.beaconManager stopEstimoteBeaconDiscovery];
}

@end
