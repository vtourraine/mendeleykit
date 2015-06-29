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

#import "MendeleyOAuthConstants.h"
#import "MendeleyOAuthStore.h"


@interface MendeleyOAuthStoreTests : MendeleyKitTestBaseClass

@property (nonatomic, strong) MendeleyOAuthCredentials *testCredentials;

@end

@implementation MendeleyOAuthStoreTests

- (void)setUp
{
    [super setUp];
    self.testCredentials = [[MendeleyOAuthCredentials alloc] init];
    self.testCredentials.access_token = @"123456";
    self.testCredentials.refresh_token = @"refresh123456";
    self.testCredentials.token_type = @"token";
    self.testCredentials.expires_in = @(3600);
}

- (void)tearDown
{
    [super tearDown];
    self.testCredentials = nil;
}

- (void)testStoreOAuthCredentials
{
    MendeleyOAuthStore *store = [[MendeleyOAuthStore alloc] init];

    BOOL storeSuccess = [store storeOAuthCredentials:self.testCredentials];

    XCTAssertTrue(storeSuccess, @"storing the credentials should return YES for success");

    MendeleyOAuthCredentials *retrievedCredentials = [store retrieveOAuthCredentials];
    XCTAssertTrue(nil != retrievedCredentials, @"we expect the retrieved credentials to be NOT nil");

    if (nil != retrievedCredentials)
    {
        XCTAssertTrue([retrievedCredentials.access_token isEqualToString:self.testCredentials.access_token], @"We expected the access token to be %@ but got %@", self.testCredentials.access_token, retrievedCredentials.access_token);
        XCTAssertTrue([retrievedCredentials.refresh_token isEqualToString:self.testCredentials.refresh_token], @"We expected the refresh token to be %@ but got %@", self.testCredentials.refresh_token, retrievedCredentials.refresh_token);
        XCTAssertTrue([retrievedCredentials.token_type isEqualToString:self.testCredentials.token_type], @"We expected the access token to be %@ but got %@", self.testCredentials.token_type, retrievedCredentials.token_type);
    }

    BOOL removeSuccess = [store removeOAuthCredentials];
    XCTAssertTrue(removeSuccess, @"removing the credentials should be successful");

    MendeleyOAuthCredentials *removedCredentials = [store retrieveOAuthCredentials];
    XCTAssertTrue(nil == removedCredentials, @"We removed the credentials, so the retrieved credentials should be nil (but isn't");
}

- (void)testStoreOAuthWithNilCredentials
{
    MendeleyOAuthStore *store = [[MendeleyOAuthStore alloc] init];

    [store storeOAuthCredentials:nil];

    MendeleyOAuthCredentials *retrievedCredentials = [store retrieveOAuthCredentials];
    XCTAssertTrue(nil == retrievedCredentials, @"we should not be able to get any credentials from the store");
}

- (void)testRemoveWithNoCredentials
{
    MendeleyOAuthStore *store = [[MendeleyOAuthStore alloc] init];
    MendeleyOAuthCredentials *retrieved = [store retrieveOAuthCredentials];

    BOOL removeSuccess = [store removeOAuthCredentials];

    if (nil == retrieved)
    {
        XCTAssertFalse(removeSuccess, @"removing non-existing credentials should return NO");
    }
    else
    {
        XCTAssertTrue(removeSuccess, @"removing existing credentials should return YES");
    }


}
@end
