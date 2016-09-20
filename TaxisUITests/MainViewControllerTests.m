//
//  MainViewControllerTests.m
//  Taxis
//
//  Created by Ricardo Hurla on 8/22/16.
//  Copyright © 2016 rihurla. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface MainViewControllerTests : XCTestCase

@end

@implementation MainViewControllerTests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];

    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testTaxiRegistrationNavigation {

    //User must not be already registered on the app
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app.textFields[@"ADDRESS"] tap];
    [app typeText:@"87 Victoria Street Belfast\r"];
    [app.buttons[@"taxi button"] tap];
    XCTAssert(app.buttons[@"Register"].exists);
    
    
}


@end
