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

#import "MendeleyMockNetworkProvider.h"
#import "MendeleyKitTestBaseClass.h"

@interface MendeleyMockNetworkProviderTests : MendeleyKitTestBaseClass

@property (nonatomic, strong) MendeleyMockNetworkProvider *provider;
@property (nonatomic, strong) NSDictionary *expectedBody;

@end

@implementation MendeleyMockNetworkProviderTests

- (void)setUp
{
    [super setUp];
    self.provider = [[MendeleyMockNetworkProvider alloc] init];
    NSDictionary *parameters = @{ @"Parameter1": [[NSUUID UUID] UUIDString],
                                  @"Parameter2": [[NSUUID UUID] UUIDString],
                                  @"Parameter3": [[NSUUID UUID] UUIDString] };
    self.expectedBody = parameters;
}

- (void)tearDown
{
    [super tearDown];
}

/**
   No need for threadhelpers as all calls to the Mock provider are done on main
 */
- (void)testMockInvokeGET
{

    self.provider.expectedStatusCode = 200;
    self.provider.expectedSuccess = YES;
    self.provider.expectedResponseBody = self.expectedBody;

    [self.provider invokeGET:nil additionalHeaders:nil queryParameters:nil authenticationRequired:NO completionBlock:^(MendeleyResponse *response, NSError *error) {
         XCTAssertNotNil(response, @"The response should not be nil, ie successful");
         if (nil != response)
         {
             XCTAssertEqual(response.statusCode, 200, @"The response statusCode should be 200 but is %lu instead", (unsigned long) response.statusCode);
             XCTAssertTrue(response.success, @"The response should be successful, but isn't");
             id responseBody = response.responseBody;
             XCTAssertNotNil(responseBody, @"the responseBody shouldn't be nil");
             if (nil != responseBody)
             {
                 XCTAssertTrue([responseBody isKindOfClass:[NSDictionary class]], @"responseBody should be of type NSDictionary");
                 if ([responseBody isKindOfClass:[NSDictionary class]])
                 {
                     XCTAssertTrue([responseBody objectForKey:@"Parameter1"], @"We should have a Parameter1 in the expected object");
                 }
             }
         }
     }];


}

@end
