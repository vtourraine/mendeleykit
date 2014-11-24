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

#import "MendeleySimpleNetworkProvider.h"
#import "MendeleyKitTestBaseClass.h"

#define TIMEINTERVAL 120


@interface MendeleySimpleNetworkProviderTests : MendeleyKitTestBaseClass

@property (nonatomic, strong) NSURL *testURL;
@property (nonatomic, strong) NSDictionary *queryParameters;
@property (nonatomic, strong) NSDictionary *additionalHeaders;
@property (nonatomic, strong) NSDictionary *bodyParameters;
@property (nonatomic, assign) BOOL callbackCompleted;

@end

@implementation MendeleySimpleNetworkProviderTests

- (void)setUp
{
    [super setUp];
    self.testURL = [NSURL URLWithString:@"http://httpbin.org"];

    self.queryParameters = @{ @"Parameter1": [[NSUUID UUID] UUIDString],
                              @"Parameter2": [[NSUUID UUID] UUIDString],
                              @"Parameter3": [[NSUUID UUID] UUIDString] };

    self.additionalHeaders = @{ @"Parameter1": [[NSUUID UUID] UUIDString],
                                @"Parameter2": [[NSUUID UUID] UUIDString],
                                @"Parameter3": [[NSUUID UUID] UUIDString] };

    self.bodyParameters = @{ @"Parameter1": [[NSUUID UUID] UUIDString],
                             @"Parameter2": [[NSUUID UUID] UUIDString],
                             @"Parameter3": [[NSUUID UUID] UUIDString] };

    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testInvokeGet
{
    MendeleySimpleNetworkProvider *provider = [MendeleySimpleNetworkProvider sharedInstance];

    XCTAssertNotNil(provider, @"we expected the provider to be not nil");
    waitForBlock ( ^(BOOL *hasCalledBack) {
                       [provider invokeGET:self.testURL
                                           api:@"get"
                             additionalHeaders:self.additionalHeaders
                               queryParameters:self.queryParameters
                        authenticationRequired:NO
                                          task:[MendeleyTask new]
                               completionBlock:^(MendeleyResponse *response, NSError *error) {
                            XCTAssertNil(error, @"We expected the error to be nil, but got back %@", error);
                            XCTAssertNotNil(response, @"we expected a valid response but got back nil");
                            *hasCalledBack = YES;
                        }];
                   });
}
@end
