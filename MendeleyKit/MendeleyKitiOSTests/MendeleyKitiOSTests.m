//
//  MendeleyKitiOSTests.m
//  MendeleyKitiOSTests
//
//  Created by Peter Schmidt on 22/06/2015.
//  Copyright © 2015 Mendeley. All rights reserved.
//

@import MendeleyKitiOS;
#import <XCTest/XCTest.h>


@interface MendeleyKitiOSTests : XCTestCase

@end

@implementation MendeleyKitiOSTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    MendeleyAcademicStatus *status = [MendeleyAcademicStatus new];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
