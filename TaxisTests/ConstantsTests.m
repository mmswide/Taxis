//
//  ConstantsTests.m
//  Taxis
//
//  Created by Ricardo Hurla on 8/19/16.
//  Copyright © 2016 rihurla. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Constants.h"

@interface ConstantsTests : XCTestCase

@end

@implementation ConstantsTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testConstants {

    //Verify if any of the constants has been modified
    XCTAssertTrue([kServiceLocations isEqualToString:@"https://api.99taxis.com/lastLocations"]);
    XCTAssertTrue([kServiceURL isEqualToString:@"http://ec2-54-88-12-34.compute-1.amazonaws.com"]);
    XCTAssertTrue([kServiceUser isEqualToString:@"/v1/users"]);
    XCTAssertTrue([kServiceRide isEqualToString:@"/v1/ride"]);
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
