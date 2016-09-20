//
//  ServiceManagerTests.m
//  Taxis
//
//  Created by Ricardo Hurla on 8/19/16.
//  Copyright © 2016 rihurla. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ServiceManager.h"
#import "GeoFrame.h"
#import "Taxi.h"
#import "User.h"

@interface ServiceManagerTests : XCTestCase {
    GeoFrame *frame;
}

@end

@implementation ServiceManagerTests

- (void)setUp {
    [super setUp];

    frame = [[GeoFrame alloc]init];
    frame.SWlatitude = @-50.38915698659123;
    frame.SWlongitude = @-129.9886939511671;
    frame.NElatitude = @76.30959403280282;
    frame.NElongitude = @49.98869395116711;
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testLastLocationsRequest {
    
    __block BOOL done = NO;
    [[ServiceManager sharedManager] getLastLocationsForDriversInArea:frame completionHandler:^(NSArray* result, NSError *error) {
        
        XCTAssertNil(error, @"Api request error");
        XCTAssertNotNil(result, @"Result is nil");
        XCTAssertGreaterThan(result.count, 0, @"The count of products is not greater than 0");
        XCTAssertEqual([result[0] class], [Taxi class], @"The object inside the result is not a Taxi object");
        done = YES;
        
    }];
    
    XCTAssertTrue([self waitForBlockToFinish:&done timeout:20], @"No response from the server, check the internet or the timeout");
    
}

#pragma mark - Block Timeout
- (BOOL)waitForBlockToFinish:(BOOL*)finished timeout:(NSTimeInterval)timeoutSecs {
    
    NSDate *timeoutDate = [NSDate dateWithTimeIntervalSinceNow:timeoutSecs];
    
    do {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:timeoutDate];
        if ([timeoutDate timeIntervalSinceNow] < 0.0) {
            break;
        }
    }while (!*finished);
    
    return *finished;
}

@end
