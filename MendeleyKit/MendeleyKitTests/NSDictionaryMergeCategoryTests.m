/*
 ******************************************************************************
 * Copyright (C) 2014-2017 Elsevier/Mendeley.
 *
 * This file is part of the Mendeley iOS SDK.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *****************************************************************************
 */

#import <XCTest/XCTest.h>
#import "NSDictionary+Merge.h"

@interface NSDictionaryMergeCategoryTests : XCTestCase

@property (nonatomic, strong) NSDictionary *firstDict;
@property (nonatomic, strong) NSDictionary *secondDict;
@property (nonatomic, strong) NSDictionary *mergedDict;
@property (nonatomic, strong) NSDictionary *nilDict;



@end

@implementation NSDictionaryMergeCategoryTests

- (void)setUp
{
    [super setUp];
    NSString *commonKey = @"key";
    NSString *firstValue = @"first";
    NSString *secondValue = @"second";

    NSString *firstRandomKey = [[NSUUID UUID] UUIDString];
    NSString *firstRandomValue =  [[NSUUID UUID] UUIDString];

    NSString *secondRandomKey = [[NSUUID UUID] UUIDString];
    NSString *secondRandomValue =  [[NSUUID UUID] UUIDString];

    self.firstDict = @{ firstRandomKey: firstRandomValue,
                        commonKey : firstValue };

    self.secondDict = @{ secondRandomKey: secondRandomValue,
                         commonKey : secondValue };

    self.mergedDict = @{ firstRandomKey: firstRandomValue,
                         secondRandomKey: secondRandomValue,
                         commonKey : firstValue };
    self.nilDict = nil;
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testMerge
{
    NSDictionary *instanceTestDict = [self.firstDict dictionaryByMergingWith:self.secondDict];

    XCTAssert([instanceTestDict isEqualToDictionary:self.mergedDict], @"Merge result is not as expected");

    NSDictionary *staticTestDict = [NSDictionary dictionaryByMerging:self.firstDict with:self.secondDict];
    XCTAssert([staticTestDict isEqualToDictionary:self.mergedDict], @"Merge result is not as expected");

}

- (void)testFirstIsNil
{
    NSDictionary *staticTestDict = [NSDictionary dictionaryByMerging:self.nilDict with:self.secondDict];

    XCTAssert([staticTestDict isEqualToDictionary:self.secondDict], @"Merge result is not as expected");
}

- (void)testSecondIsNil
{
    NSDictionary *instanceTestDict = [self.firstDict dictionaryByMergingWith:self.nilDict];

    XCTAssert([instanceTestDict isEqualToDictionary:self.firstDict], @"Merge result is not as expected");

    NSDictionary *staticTestDict = [NSDictionary dictionaryByMerging:self.firstDict with:self.nilDict];
    XCTAssert([staticTestDict isEqualToDictionary:self.firstDict], @"Merge result is not as expected");
}



@end
