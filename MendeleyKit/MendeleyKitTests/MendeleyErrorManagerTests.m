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
#import "MendeleyKitTestBaseClass.h"
#import "MendeleyErrorManager.h"
#import "MendeleyKitConfiguration.h"

@interface FakeUserInfoManager : NSObject <MendeleyUserInfoProvider>

@end

@implementation FakeUserInfoManager

- (NSDictionary *)userInfoWithErrorCode:(NSInteger)errorCode
{
    return @{
               NSLocalizedDescriptionKey: @"",
               NSLocalizedFailureReasonErrorKey: @"",
               NSLocalizedRecoverySuggestionErrorKey: @""
    };
}

@end

@interface MendeleyErrorManagerTests : MendeleyKitTestBaseClass

@end

@implementation MendeleyErrorManagerTests

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

- (void)testCreateSimpleError
{
    NSError *error = [[MendeleyErrorManager sharedInstance] errorWithDomain:kMendeleyErrorDomain code:kMendeleyJSONTypeNotMappedToModelErrorCode];

    XCTAssertNotNil(error, @"error should not be nil");
    XCTAssertEqualObjects(error.domain, kMendeleyErrorDomain, @"error domain should be %@, but is %@", kMendeleyErrorDomain, error.domain);
    XCTAssertEqual(error.code, kMendeleyJSONTypeNotMappedToModelErrorCode, @"error code should be %d, but is %ld", kMendeleyJSONTypeNotMappedToModelErrorCode, (long) error.code);
}

- (void)testCreateFakeError
{
    XCTAssertThrows([[MendeleyErrorManager sharedInstance] errorWithDomain:kMendeleyErrorDomain code:MendeleyErrorMultipleErrors], @"there should be an exception");
}

- (void)testCreateMultipleErrorInSameDomain
{
    NSError *error1 = [[MendeleyErrorManager sharedInstance] errorWithDomain:kMendeleyErrorDomain code:kMendeleyJSONTypeNotMappedToModelErrorCode];
    NSError *error2 = [[MendeleyErrorManager sharedInstance] errorWithDomain:kMendeleyErrorDomain code:MendeleyErrorUnknown];
    NSError *error3 = [[MendeleyErrorManager sharedInstance] errorFromOriginalError:error1 error:error2];
    NSError *error4 = [[MendeleyErrorManager sharedInstance] errorWithDomain:kMendeleyErrorDomain code:MendeleyErrorUnknown];
    NSError *error5 = [[MendeleyErrorManager sharedInstance] errorFromOriginalError:error3 error:error4];

    XCTAssertNotNil(error5, @"error should not be nil");
    XCTAssertEqual(error5.domain, kMendeleyErrorDomain, @"error domain should be %@, but is %@", kMendeleyErrorDomain, error5.domain);
    XCTAssertEqual(error5.code, MendeleyErrorMultipleErrors, @"error code should be %ld, but is %ld", (long) MendeleyErrorMultipleErrors, (long) error5.code);
    XCTAssertTrue([[error5.userInfo objectForKey:MendeleyDetailedErrorsKey] count] == 3, @"there should be 3 errors, but there are %lu errors", (unsigned long) [[error5.userInfo objectForKey:MendeleyDetailedErrorsKey] count]);
}

- (void)testCreateMultipleErrorInSeparateDomains
{
    NSString *fakeDomain = @"fakeDomain";
    FakeUserInfoManager *fakeManager = [FakeUserInfoManager new];
    NSString *anotherFakeDomain = @"anotherFakeDomain";
    FakeUserInfoManager *anotherFakeManager = [FakeUserInfoManager new];

    [[MendeleyErrorManager sharedInstance] addUserInfoHelper:fakeManager errorDomain:fakeDomain];
    [[MendeleyErrorManager sharedInstance] addUserInfoHelper:anotherFakeManager errorDomain:anotherFakeDomain];


    NSError *error1 = [[MendeleyErrorManager sharedInstance] errorWithDomain:kMendeleyErrorDomain code:kMendeleyJSONTypeNotMappedToModelErrorCode];
    NSError *error2 = [[MendeleyErrorManager sharedInstance] errorWithDomain:fakeDomain code:MendeleyErrorUnknown];
    NSError *error3 = [[MendeleyErrorManager sharedInstance] errorFromOriginalError:error1 error:error2];
    NSError *error4 = [[MendeleyErrorManager sharedInstance] errorWithDomain:anotherFakeDomain code:MendeleyErrorUnknown];
    NSError *error5 = [[MendeleyErrorManager sharedInstance] errorFromOriginalError:error3 error:error4];

    XCTAssertNotNil(error5, @"error should not be nil");
    XCTAssertEqualObjects(error5.domain, MendeleyErrorDomainMultiple, @"error domain should be %@, but is %@", MendeleyErrorDomainMultiple, error5.domain);
    XCTAssertEqual(error5.code, MendeleyErrorMultipleErrors, @"error code should be %ld, but is %ld", (long) MendeleyErrorMultipleErrors, (long) error5.code);
    NSArray *errors = [error5.userInfo objectForKey:MendeleyDetailedErrorsKey];
    XCTAssertTrue(errors.count == 3, @"there should be 3 errors, but there are %lu errors", (unsigned long) errors.count);
    XCTAssertTrue([errors containsObject:error1], @"");
    XCTAssertTrue([errors containsObject:error2], @"");
    XCTAssertTrue([errors containsObject:error4], @"");
}

@end
