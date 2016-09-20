//
//  GeoFrameTests.m
//  Taxis
//
//  Created by Ricardo Hurla on 8/19/16.
//  Copyright © 2016 rihurla. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GeoFrame+Actions.h"

@interface GeoFrameTests : XCTestCase {
    MKMapRect mRect;
}

@end

@implementation GeoFrameTests

- (void)setUp {
    [super setUp];
    
    float lat1 = -50.38915698659123;
    float long1 = -129.9886939511671;
    float lat2 = 76.30959403280282;
    float long2 = 49.98869395116711;
    
    CLLocationCoordinate2D coordinate1 = CLLocationCoordinate2DMake(lat1,long1);
    CLLocationCoordinate2D coordinate2 = CLLocationCoordinate2DMake(lat2,long2);
    
    MKMapPoint p1 = MKMapPointForCoordinate (coordinate1);
    MKMapPoint p2 = MKMapPointForCoordinate (coordinate2);
    
    mRect = MKMapRectMake(fmin(p1.x,p2.x), fmin(p1.y,p2.y), fabs(p1.x-p2.x), fabs(p1.y-p2.y));
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testGeoFrame {
    
    //Creates a geoFrame and tests the method that populates all the properties of it
    GeoFrame* frame = [[GeoFrame shared] getGeoFrameFromMapRect:mRect];
    XCTAssertNotNil(frame, @"Geo Frame does not exists");
    XCTAssertNotNil(frame.SWlatitude, @"South West latitude does not exists");
    XCTAssertNotNil(frame.SWlongitude, @"South West longitude does not exists");
    XCTAssertNotNil(frame.NElatitude, @"North East latitude does not exists");
    XCTAssertNotNil(frame.NElongitude, @"North East longitude does not exists");
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
