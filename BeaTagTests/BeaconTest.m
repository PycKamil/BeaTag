//
//  BeaconTest.m
//  BeaTag
//
//  Created by Kamil Pyć on 10/11/14.
//  Copyright (c) 2014 Kamil Pyć. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "Beacon.h"
#import <OCMock/OCMock.h>
#import <Parse/Parse.h>

@interface BeaconTest : XCTestCase

@end

@implementation BeaconTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testBeaconInitializationWithEmptyPFObject {
    id parseBeaconMock = [OCMockObject niceMockForClass:[PFObject class]];
    Beacon *beacon = [[Beacon alloc]initWithParseObject:parseBeaconMock];
    XCTAssertNotNil(beacon, @"Pass");
    XCTAssertNil(beacon.beaconId);
    XCTAssertNil(beacon.minor);
    XCTAssertNil(beacon.major);

}

@end
