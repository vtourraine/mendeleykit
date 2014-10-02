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

#import "MendeleyConnectionReachability.h"
#import "MendeleyKitConfiguration.h"
#import "MendeleyKitTestBaseClass.h"

@interface MendeleyReachabilityTests : MendeleyKitTestBaseClass

@end

@implementation MendeleyReachabilityTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testConnectionAvailability
{
    MendeleyConnectionReachability *reachability = [MendeleyConnectionReachability sharedInstance];
    BOOL isConnectionAvailable = [reachability isNetworkReachable];

    NSError *error;

    [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:[MendeleyKitConfiguration sharedInstance].baseAPIURL] returningResponse:nil error:&error];

    BOOL isDataConnectionError = ((nil != error) && (NSURLErrorNotConnectedToInternet == error.code));
    BOOL bothConnectionOK = (isConnectionAvailable && !isDataConnectionError);
    BOOL bothConnectionError = (!isConnectionAvailable && isDataConnectionError);

    XCTAssert((bothConnectionOK || bothConnectionError), @"expected same result");
}

- (void)testServerAvailability
{
    MendeleyConnectionReachability *reachability = [MendeleyConnectionReachability sharedInstance];
    __block BOOL serverIsAvailable;
    __block NSError *serverError;
    __block NSError *testError;
    __block NSURLResponse *testResponse;

    waitForBlock ( ^(BOOL *hasCalledBack) {
                       [reachability mendeleyServerIsReachableWithCompletionBlock: ^(BOOL success, NSError *error) {
                            serverIsAvailable = success;
                            serverError = error;
                        }];

                       NSURL *serviceURL = [NSURL URLWithString:@"" relativeToURL:[MendeleyKitConfiguration sharedInstance].baseAPIURL];
                       NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
                       NSURLSessionTask *task = [session dataTaskWithRequest:[NSURLRequest requestWithURL:serviceURL] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                     testResponse = response;
                                                     testError = error;
                                                     *hasCalledBack = YES;
                                                 }];
                       [task resume];
                   });
    BOOL isDataConnectionError = ( testError || nil == testResponse);
    BOOL bothConnectionOK = (serverIsAvailable && !isDataConnectionError);
    BOOL bothConnectionError = (!serverIsAvailable && isDataConnectionError);

    XCTAssert((bothConnectionOK || bothConnectionError), @"expected same result");
}

- (void)testDocumentServiceAvailability
{
    MendeleyConnectionReachability *reachability = [MendeleyConnectionReachability sharedInstance];
    __block BOOL serverIsAvailable;
    __block NSError *serverError;
    __block NSError *testError;
    __block NSURLResponse *testResponse;

    waitForBlock ( ^(BOOL *hasCalledBack) {
                       [reachability mendeleyDocumentServiceIsReachableWithCompletionBlock: ^(BOOL success, NSError *error) {
                            serverIsAvailable = success;
                            serverError = error;
                        }];

                       NSURL *serviceURL = [NSURL URLWithString:@"documents" relativeToURL:[MendeleyKitConfiguration sharedInstance].baseAPIURL];
                       NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
                       NSURLSessionTask *task = [session dataTaskWithRequest:[NSURLRequest requestWithURL:serviceURL] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                     testResponse = response;
                                                     testError = error;
                                                     *hasCalledBack = YES;
                                                 }];
                       [task resume];
                   });
    BOOL isDataConnectionError = ( testError || nil == testResponse);
    BOOL bothConnectionOK = (serverIsAvailable && !isDataConnectionError);
    BOOL bothConnectionError = (!serverIsAvailable && isDataConnectionError);

    XCTAssert((bothConnectionOK || bothConnectionError), @"expected same result");
}

- (void)testFolderServiceAvailability
{
    MendeleyConnectionReachability *reachability = [MendeleyConnectionReachability sharedInstance];
    __block BOOL serverIsAvailable;
    __block NSError *serverError;
    __block NSError *testError;
    __block NSURLResponse *testResponse;

    waitForBlock ( ^(BOOL *hasCalledBack) {
                       [reachability mendeleyFolderServiceIsReachableWithCompletionBlock: ^(BOOL success, NSError *error) {
                            serverIsAvailable = success;
                            serverError = error;
                        }];

                       NSURL *serviceURL = [NSURL URLWithString:@"folders" relativeToURL:[MendeleyKitConfiguration sharedInstance].baseAPIURL];
                       NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
                       NSURLSessionTask *task = [session dataTaskWithRequest:[NSURLRequest requestWithURL:serviceURL] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                     testResponse = response;
                                                     testError = error;
                                                     *hasCalledBack = YES;
                                                 }];
                       [task resume];
                   });
    BOOL isDataConnectionError = ( testError || nil == testResponse);
    BOOL bothConnectionOK = (serverIsAvailable && !isDataConnectionError);
    BOOL bothConnectionError = (!serverIsAvailable && isDataConnectionError);

    XCTAssert((bothConnectionOK || bothConnectionError), @"expected same result");
}

- (void)testAnnotationServiceAvailability
{
    MendeleyConnectionReachability *reachability = [MendeleyConnectionReachability sharedInstance];
    __block BOOL serverIsAvailable;
    __block NSError *serverError;
    __block NSError *testError;
    __block NSURLResponse *testResponse;

    waitForBlock ( ^(BOOL *hasCalledBack) {
                       [reachability mendeleyAnnotationServiceIsReachableWithCompletionBlock: ^(BOOL success, NSError *error) {
                            serverIsAvailable = success;
                            serverError = error;
                        }];

                       NSURL *serviceURL = [NSURL URLWithString:@"annotations" relativeToURL:[MendeleyKitConfiguration sharedInstance].baseAPIURL];
                       NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
                       NSURLSessionTask *task = [session dataTaskWithRequest:[NSURLRequest requestWithURL:serviceURL] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                     testResponse = response;
                                                     testError = error;
                                                     *hasCalledBack = YES;
                                                 }];
                       [task resume];
                   });
    BOOL isDataConnectionError = ( testError || nil == testResponse);
    BOOL bothConnectionOK = (serverIsAvailable && !isDataConnectionError);
    BOOL bothConnectionError = (!serverIsAvailable && isDataConnectionError);

    XCTAssert((bothConnectionOK || bothConnectionError), @"expected same result");
}

- (void)testGroupServiceAvailability
{
    MendeleyConnectionReachability *reachability = [MendeleyConnectionReachability sharedInstance];
    __block BOOL serverIsAvailable;
    __block NSError *serverError;
    __block NSError *testError;
    __block NSURLResponse *testResponse;

    waitForBlock ( ^(BOOL *hasCalledBack) {
                       [reachability mendeleyGroupServiceIsReachableWithCompletionBlock: ^(BOOL success, NSError *error) {
                            serverIsAvailable = success;
                            serverError = error;
                        }];

                       NSURL *serviceURL = [NSURL URLWithString:@"groups" relativeToURL:[MendeleyKitConfiguration sharedInstance].baseAPIURL];
                       NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
                       NSURLSessionTask *task = [session dataTaskWithRequest:[NSURLRequest requestWithURL:serviceURL] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                     testResponse = response;
                                                     testError = error;
                                                     *hasCalledBack = YES;
                                                 }];
                       [task resume];
                   });
    BOOL isDataConnectionError = ( testError || nil == testResponse);
    BOOL bothConnectionOK = (serverIsAvailable && !isDataConnectionError);
    BOOL bothConnectionError = (!serverIsAvailable && isDataConnectionError);

    XCTAssert((bothConnectionOK || bothConnectionError), @"expected same result");
}

- (void)testFileServiceAvailability
{
    MendeleyConnectionReachability *reachability = [MendeleyConnectionReachability sharedInstance];
    __block BOOL serverIsAvailable;
    __block NSError *serverError;
    __block NSError *testError;
    __block NSURLResponse *testResponse;

    waitForBlock ( ^(BOOL *hasCalledBack) {
                       [reachability mendeleyFileServiceIsReachableWithCompletionBlock: ^(BOOL success, NSError *error) {
                            serverIsAvailable = success;
                            serverError = error;
                        }];

                       NSURL *serviceURL = [NSURL URLWithString:@"files" relativeToURL:[MendeleyKitConfiguration sharedInstance].baseAPIURL];
                       NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
                       NSURLSessionTask *task = [session dataTaskWithRequest:[NSURLRequest requestWithURL:serviceURL] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                     testResponse = response;
                                                     testError = error;
                                                     *hasCalledBack = YES;
                                                 }];
                       [task resume];
                   });
    BOOL isDataConnectionError = ( testError || nil == testResponse);
    BOOL bothConnectionOK = (serverIsAvailable && !isDataConnectionError);
    BOOL bothConnectionError = (!serverIsAvailable && isDataConnectionError);

    XCTAssert((bothConnectionOK || bothConnectionError), @"expected same result");
}


@end
