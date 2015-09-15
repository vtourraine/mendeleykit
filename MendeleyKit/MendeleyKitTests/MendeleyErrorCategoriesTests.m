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

#import "MendeleyKitTestBaseClass.h"

#import "NSError+MendeleyError.h"
#import "MendeleyKitConfiguration.h"

@interface MendeleyErrorCategoriesTests : MendeleyKitTestBaseClass

@end

@implementation MendeleyErrorCategoriesTests

- (void)setUp
{
    [super setUp];
    [MendeleyKitConfiguration sharedInstance];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCreateErrorFromCode
{
    NSError *testError = [NSError errorWithCode:kMendeleyJSONTypeUnrecognisedErrorCode];

    XCTAssertNotNil(testError, @"error shouldn't be nil");
    XCTAssertNotNil(testError.localizedDescription, @"error  localizedDescription shouldn't be nil");
    if (nil != testError.localizedDescription)
    {
        XCTAssertTrue([testError.localizedDescription isEqualToString:@"Unrecognised JSON object"], @"Unexpected error description %@", testError.localizedDescription);
    }
}

@end
