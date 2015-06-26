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

#ifndef MendeleyKitiOSFramework
#import "MendeleyKitConfiguration.h"
#import "MendeleyKit.h"
#import "MendeleyAnnotationsAPI.h"
#import "MendeleyModels.h"
#import "NSError+MendeleyError.h"
#endif


@interface MendeleyAnnotationsAPITests : MendeleyKitTestBaseClass

@property (nonatomic, strong) MendeleyAnnotationsAPI *annotationsAPI;
@property (nonatomic, strong) MendeleyMockNetworkProvider *provider;

@end

@implementation MendeleyAnnotationsAPITests

- (void)setUp
{
    [super setUp];
    MendeleyMockNetworkProvider *provider = [[MendeleyMockNetworkProvider alloc] init];
    MendeleyAnnotationsAPI *api = [[MendeleyAnnotationsAPI alloc] initWithNetworkProvider:provider baseURL:[NSURL URLWithString:kMendeleyBaseAPIURLKey]];
    self.annotationsAPI = api;
    self.provider = provider;

}

- (void)tearDown
{
    [super tearDown];
}

- (void)testDeleteAnnotationWithID
{

    self.provider.expectedSuccess = YES;
    self.provider.expectedStatusCode = 204;

    [self.annotationsAPI deleteAnnotationWithID:@"12345" task:[MendeleyTask new] completionBlock:^(BOOL success, NSError *error) {
         XCTAssertTrue(success, @"The call is expected to succeed, but didn't");
         XCTAssertNil(error, @"The error is expected to be NIL");
     }];
}

- (void)testFailToDeleteAnnotationWithID
{

    self.provider.expectedSuccess = NO;
    self.provider.expectedStatusCode = 404;
    self.provider.expectedError = [NSError errorWithCode:kMendeleyUnknownDataTypeErrorCode localizedDescription:@"Annotations not found"];

    [self.annotationsAPI deleteAnnotationWithID:@"12345" task:[MendeleyTask new] completionBlock:^(BOOL success, NSError *error) {
         XCTAssertFalse(success, @"The call is expected to fail, but didn't");
         XCTAssertNotNil(error, @"The error is expected not to be NIL");
         if (nil != error)
         {
             XCTAssertTrue(error.code == kMendeleyUnknownDataTypeErrorCode, @"We got the wrong error code back");
             XCTAssertTrue([error.localizedDescription isEqualToString:@"Annotations not found"], @"We got the wrong error description back");
         }
     }];
}

@end
