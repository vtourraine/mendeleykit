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

#ifndef MendeleyKitiOSFramework
#import "MendeleyDefaultNetworkProvider.h"
#import "MendeleyKitConfiguration.h"
#import "MendeleyURLBuilder.h"
#endif

@interface MendeleyDefaultNetworkProvider (CHANGE_VISIBILITY_FOR_TEST)

@property (nonatomic, strong, readwrite) NSMutableDictionary *networkTaskDictionary;

@end

@interface MendeleyNetworkingTests : MendeleyKitTestBaseClass

@property (nonatomic, strong) NSURL *testURL;
@property (nonatomic, strong) NSDictionary *queryParameters;
@property (nonatomic, strong) NSDictionary *additionalHeaders;
@property (nonatomic, strong) NSDictionary *bodyParameters;

@end

@implementation MendeleyNetworkingTests

- (void)tearDown
{
    [super tearDown];
}

- (void)setUp
{
    [super setUp];
    [[MendeleyKitConfiguration sharedInstance] resetToDefault];
    self.testURL = [NSURL URLWithString:@"http://httpbin.org"];

    self.queryParameters = @{ @"Parameter1": [[NSUUID UUID] UUIDString],
                              @"Parameter2": [[NSUUID UUID] UUIDString],
                              @"Parameter3": [[NSUUID UUID] UUIDString] };

//    self.additionalHeaders = @{ kMendeleyRESTRequestContentType : kMendeleyRESTRequestURLType,
//                                kMendeleyRESTRequestAccept : kMendeleyRESTRequestJSONType,
//                                @"Parameter1": [[NSUUID UUID] UUIDString],
//                                @"Parameter2": [[NSUUID UUID] UUIDString],
//                                @"Parameter3": [[NSUUID UUID] UUIDString] };

    self.additionalHeaders = @{ @"Parameter1": [[NSUUID UUID] UUIDString],
                                @"Parameter2": [[NSUUID UUID] UUIDString],
                                @"Parameter3": [[NSUUID UUID] UUIDString] };

    self.bodyParameters = @{ @"Parameter1": [[NSUUID UUID] UUIDString],
                             @"Parameter2": [[NSUUID UUID] UUIDString],
                             @"Parameter3": [[NSUUID UUID] UUIDString] };

    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (void)testGETWithQueryParametersAndParseJSONResponse
{
    __block NSObject *deserializedResponse;
    __block NSError *errorResponse;

    waitForBlock( ^(BOOL *hasCalledBack) {
        [[[MendeleyKitConfiguration sharedInstance] networkProvider] invokeGET:self.testURL
                                                                           api:@"get"
                                                             additionalHeaders:nil
                                                               queryParameters:self.queryParameters
                                                        authenticationRequired:NO
                                                                          task:[MendeleyTask new]
                                                               completionBlock: ^(MendeleyResponse *response, NSError *error) {
             errorResponse = error;
             deserializedResponse = response.responseBody;
             *hasCalledBack = YES;
         }];
    });

    XCTAssertTrue(errorResponse == nil, @"An error was encounterd when downloading or parsing a JSON: %@", errorResponse);
    XCTAssertTrue(([deserializedResponse isKindOfClass:[NSDictionary class]] ||
                   [deserializedResponse isKindOfClass:[NSArray class]]), @"The object returned is not an NSDictionary or NSArray");
    BOOL parameterNotFound = NO;
    NSDictionary *queryParametersReceivedByTheServer = [(NSDictionary *) deserializedResponse objectForKey:@"args"];
    for (NSString *parameterName in[self.queryParameters allKeys])
    {
        if (![queryParametersReceivedByTheServer objectForKey:parameterName] ||
            ![[queryParametersReceivedByTheServer objectForKey:parameterName] isEqualToString:[self.queryParameters objectForKey:parameterName]])
        {
            parameterNotFound = YES;
        }
    }

    XCTAssertFalse(parameterNotFound, @"Problem with the query parameters. One or more parameters setted weren't received by the server");

    MendeleyDefaultNetworkProvider *defaultProvider = (MendeleyDefaultNetworkProvider *) [[MendeleyKitConfiguration sharedInstance] networkProvider];
    NSUInteger tasksRunning = [[[defaultProvider networkTaskDictionary] allKeys] count];

    XCTAssertTrue(tasksRunning == 0, @"Task not removed automatically");
}

- (void)testGetPDFFile
{
    NSURL *testBaseURL = [NSURL URLWithString:@"http://digitalcommons.du.edu"];

    __block NSObject *deserializedResponse;
    __block NSError *errorResponse;

    waitForBlock( ^(BOOL *hasCalledBack) {
        [[[MendeleyKitConfiguration sharedInstance] networkProvider] invokeGET:testBaseURL
                                                                           api:@"cgi/viewcontent.cgi?article=1332&context=collaborativelibrarianship"
                                                             additionalHeaders:nil
                                                               queryParameters:nil
                                                        authenticationRequired:NO
                                                                          task:[MendeleyTask new]
                                                               completionBlock: ^(MendeleyResponse *response, NSError *error) {
             errorResponse = error;
             deserializedResponse = response.responseBody;
             *hasCalledBack = YES;
         }];
    });

    XCTAssertTrue(errorResponse == nil, @"An error was encounterd while downloading the file: %@", errorResponse);
    XCTAssertTrue([deserializedResponse isKindOfClass:[NSData class]], @"The object returned is not an NSData");
    NSData *validPDF = [@"%PDF" dataUsingEncoding:NSASCIIStringEncoding];
    XCTAssertTrue(((NSData *) deserializedResponse && [[(NSData *) deserializedResponse subdataWithRange:NSMakeRange(0, 4)] isEqualToData:validPDF]), @"The object returned is not a PDF");

    MendeleyDefaultNetworkProvider *defaultProvider = (MendeleyDefaultNetworkProvider *) [[MendeleyKitConfiguration sharedInstance] networkProvider];
    NSUInteger tasksRunning = [[[defaultProvider networkTaskDictionary] allKeys] count];

    XCTAssertTrue(tasksRunning == 0, @"Task not removed automatically");
}

- (void)testPUT
{
    __block NSObject *deserializedResponse;
    __block NSError *errorResponse;


    waitForBlock( ^(BOOL *hasCalledBack) {
        [[[MendeleyKitConfiguration sharedInstance] networkProvider] invokePUT:self.testURL
                                                                           api:@"put"
                                                             additionalHeaders:self.additionalHeaders
                                                                bodyParameters:self.bodyParameters
                                                        authenticationRequired:NO
                                                                          task:[MendeleyTask new]
                                                               completionBlock: ^(MendeleyResponse *response, NSError *error) {
             errorResponse = error;
             deserializedResponse = response.responseBody;
             *hasCalledBack = YES;
         }];
    });

    XCTAssertTrue(errorResponse == nil, @"An error was encounterd during PUT request: %@", errorResponse);

    BOOL headerNotFound = NO;
    NSDictionary *headersFieldReceivedByTheServer = [(NSDictionary *) deserializedResponse objectForKey:@"headers"];

    for (NSString *headerFieldName in[self.additionalHeaders allKeys])
    {
        if (![headersFieldReceivedByTheServer objectForKey:headerFieldName] ||
            ![[headersFieldReceivedByTheServer objectForKey:headerFieldName] isEqualToString:[self.additionalHeaders objectForKey:headerFieldName]])
        {
            headerNotFound = YES;
        }
    }
    XCTAssertFalse(headerNotFound, @"Problem with the additional headers. One or more headers set weren't received by the server ");

    NSDictionary *jsonReceived = [(NSDictionary *) deserializedResponse objectForKey:@"form"];

    XCTAssertTrue([self.bodyParameters isEqualToDictionary:jsonReceived], @"Sent parameters aren't the same received");

    MendeleyDefaultNetworkProvider *defaultProvider = (MendeleyDefaultNetworkProvider *) [[MendeleyKitConfiguration sharedInstance] networkProvider];
    NSUInteger tasksRunning = [[[defaultProvider networkTaskDictionary] allKeys] count];

    XCTAssertTrue(tasksRunning == 0, @"Task not removed automatically");
}

- (void)testPOSTJSON
{
    __block NSObject *deserializedResponse;
    __block NSError *errorResponse;

    waitForBlock( ^(BOOL *hasCalledBack) {
        NSDictionary *headers = @{ kMendeleyRESTRequestContentType: kMendeleyRESTRequestJSONType };
        [[[MendeleyKitConfiguration sharedInstance] networkProvider] invokePOST:self.testURL
                                                                            api:@"post"
                                                              additionalHeaders:headers
                                                                 bodyParameters:self.bodyParameters
                                                                         isJSON:YES
                                                         authenticationRequired:NO
                                                                           task:[MendeleyTask new]
                                                                completionBlock: ^(MendeleyResponse *response, NSError *error) {
             errorResponse = error;
             deserializedResponse = response.responseBody;
             *hasCalledBack = YES;
         }];
    });
    XCTAssertTrue(errorResponse == nil, @"An error was encounterd during POST request: %@", errorResponse);
    NSDictionary *jsonReceived = [(NSDictionary *) deserializedResponse objectForKey:@"json"];

    XCTAssertTrue([self.bodyParameters isEqualToDictionary:jsonReceived], @"Sent parameters aren't the same received");

    MendeleyDefaultNetworkProvider *defaultProvider = (MendeleyDefaultNetworkProvider *) [[MendeleyKitConfiguration sharedInstance] networkProvider];
    NSUInteger tasksRunning = [[[defaultProvider networkTaskDictionary] allKeys] count];

    XCTAssertTrue(tasksRunning == 0, @"Task not removed automatically");
}

- (void)testPOSTBinary
{
    __block NSObject *deserializedResponse;
    __block NSError *errorResponse;

    NSString *testString = @"test * test * test";
    NSData *bodyData = [testString dataUsingEncoding:NSUTF8StringEncoding];

    waitForBlock( ^(BOOL *hasCalledBack) {
        [[[MendeleyKitConfiguration sharedInstance] networkProvider] invokePOST:self.testURL
                                                                            api:@"post"
                                                              additionalHeaders:nil
                                                                       jsonData:bodyData
                                                         authenticationRequired:NO
                                                                           task:[MendeleyTask new]
                                                                completionBlock: ^(MendeleyResponse *response, NSError *error) {
             errorResponse = error;
             deserializedResponse = response.responseBody;
             *hasCalledBack = YES;
         }];
    });
    XCTAssertTrue(errorResponse == nil, @"An error was encounterd during POST request: %@", errorResponse);

    NSString *dataReceived = [[[(NSDictionary *) deserializedResponse objectForKey:@"form"] allKeys] lastObject];

    XCTAssertTrue([testString isEqualToString:dataReceived], @"Sent parameters aren't the same received");

    MendeleyDefaultNetworkProvider *defaultProvider = (MendeleyDefaultNetworkProvider *) [[MendeleyKitConfiguration sharedInstance] networkProvider];
    NSUInteger tasksRunning = [[[defaultProvider networkTaskDictionary] allKeys] count];

    XCTAssertTrue(tasksRunning == 0, @"Task not removed automatically");
}

- (void)testPATCH
{
    __block NSObject *deserializedResponse;
    __block NSError *errorResponse;

    waitForBlock( ^(BOOL *hasCalledBack) {
        [[[MendeleyKitConfiguration sharedInstance] networkProvider] invokePATCH:self.testURL
                                                                             api:@"patch"
                                                               additionalHeaders:nil
                                                                  bodyParameters:self.bodyParameters
                                                          authenticationRequired:NO
                                                                            task:[MendeleyTask new]
                                                                 completionBlock: ^(MendeleyResponse *response, NSError *error) {
             errorResponse = error;
             deserializedResponse = response.responseBody;
             *hasCalledBack = YES;
         }];
    });
    XCTAssertTrue(errorResponse == nil, @"An error was encounterd during PATCH request: %@", errorResponse);

    NSDictionary *jsonReceived = [(NSDictionary *) deserializedResponse objectForKey:@"form"];

    XCTAssertTrue([self.bodyParameters isEqualToDictionary:jsonReceived], @"Sent parameters aren't the same received");

    MendeleyDefaultNetworkProvider *defaultProvider = (MendeleyDefaultNetworkProvider *) [[MendeleyKitConfiguration sharedInstance] networkProvider];
    NSUInteger tasksRunning = [[[defaultProvider networkTaskDictionary] allKeys] count];

    XCTAssertTrue(tasksRunning == 0, @"Task not removed automatically");
}

- (void)testDELETE
{
    __block NSObject *deserializedResponse;
    __block NSError *errorResponse;

    waitForBlock( ^(BOOL *hasCalledBack) {
        [[[MendeleyKitConfiguration sharedInstance] networkProvider] invokeDELETE:self.testURL
                                                                              api:@"delete"
                                                                additionalHeaders:self.additionalHeaders
                                                                   bodyParameters:self.bodyParameters
                                                           authenticationRequired:NO
                                                                             task:[MendeleyTask new]
                                                                  completionBlock: ^(MendeleyResponse *response, NSError *error) {
             errorResponse = error;
             deserializedResponse = response.responseBody;
             *hasCalledBack = YES;
         }];
    });
    XCTAssertTrue(errorResponse == nil, @"An error was encounterd during PATCH request: %@", errorResponse);

    BOOL headerNotFound = NO;
    NSDictionary *headersFieldReceivedByTheServer = [(NSDictionary *) deserializedResponse objectForKey:@"headers"];

    for (NSString *headerFieldName in[self.additionalHeaders allKeys])
    {
        if (![headersFieldReceivedByTheServer objectForKey:headerFieldName] ||
            ![[headersFieldReceivedByTheServer objectForKey:headerFieldName] isEqualToString:[self.additionalHeaders objectForKey:headerFieldName]])
        {
            headerNotFound = YES;
        }
    }
    XCTAssertFalse(headerNotFound, @"Problem with the additional headers. One or more headers setted weren't received by the server ");

    NSString *bodyParamtersstring = [MendeleyURLBuilder httpBodyStringFromParameters:self.bodyParameters];
    NSString *jsonReceived = [(NSDictionary *) deserializedResponse objectForKey:@"data"];

    XCTAssertTrue([bodyParamtersstring isEqualToString:jsonReceived], @"Sent parameters aren't the same received");

    MendeleyDefaultNetworkProvider *defaultProvider = (MendeleyDefaultNetworkProvider *) [[MendeleyKitConfiguration sharedInstance] networkProvider];
    NSUInteger tasksRunning = [[[defaultProvider networkTaskDictionary] allKeys] count];

    XCTAssertTrue(tasksRunning == 0, @"Task not removed automatically");
}

- (void)testHEAD
{
    __block NSError *errorResponse;

    waitForBlock( ^(BOOL *hasCalledBack) {
        [[MendeleyKitConfiguration sharedInstance].networkProvider invokeHEAD:self.testURL
                                                                          api:@""
                                                       authenticationRequired:NO
                                                                         task:[MendeleyTask new]
                                                              completionBlock: ^(MendeleyResponse *response, NSError *error) {
             errorResponse = error;
             *hasCalledBack = YES;
         }];
    });
    XCTAssertTrue(errorResponse == nil, @"An error was encounterd during PATCH request: %@", errorResponse);

    MendeleyDefaultNetworkProvider *defaultProvider = (MendeleyDefaultNetworkProvider *) [[MendeleyKitConfiguration sharedInstance] networkProvider];
    NSUInteger tasksRunning = [[[defaultProvider networkTaskDictionary] allKeys] count];

    XCTAssertTrue(tasksRunning == 0, @"Task not removed automatically");
}

- (void)testDownloadFile
{
    __block NSURL *fileURL;
    __block NSError *errorResponse;

    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *destinationPath = [documentsPath stringByAppendingPathComponent:@"downloadedFile"];
    NSURL *destinationURL = [NSURL fileURLWithPath:destinationPath];

    NSDictionary *delayQueryParameters = @{ @"numbytes": @"1000",
                                            @"duration": @"3",
                                            @"delay": @"1" };
    __block BOOL isProgressCalled = NO;

    waitForBlock( ^(BOOL *hasCalledBack) {
        [[[MendeleyKitConfiguration sharedInstance] networkProvider] invokeDownloadToFileURL:destinationURL
                                                                                     baseURL:self.testURL
                                                                                         api:@"drip"
                                                                           additionalHeaders:nil
                                                                             queryParameters:delayQueryParameters
                                                                      authenticationRequired:NO
                                                                                        task:[MendeleyTask new]
                                                                               progressBlock: ^(NSNumber *progress) {
             NSLog(@"Update Received: %.2f", [progress floatValue]);
             isProgressCalled = YES;
         }

                                                                             completionBlock: ^(MendeleyResponse *response, NSError *error) {
             errorResponse = error;
             fileURL = response.fileURL;
             *hasCalledBack = YES;
         }];
    });



    XCTAssertTrue(errorResponse == nil, @"An error was encounterd while downloading the file: %@", errorResponse);

    XCTAssertTrue(isProgressCalled, @"Progress status never received");

    NSError *errorOnRemoving = nil;
    [[NSFileManager defaultManager] removeItemAtURL:destinationURL error:&errorOnRemoving];

    XCTAssertTrue(errorOnRemoving == nil, @"An error was encounterd while removing the file: %@", errorResponse);

    MendeleyDefaultNetworkProvider *defaultProvider = (MendeleyDefaultNetworkProvider *) [[MendeleyKitConfiguration sharedInstance] networkProvider];
    NSUInteger tasksRunning = [[[defaultProvider networkTaskDictionary] allKeys] count];

    XCTAssertTrue(tasksRunning == 0, @"Task not removed automatically");
}

- (void)testUpload
{
    __block NSError *errorResponse;
    __block BOOL isProgressCalled = NO;

    waitForBlock( ^(BOOL *hasCalledBack) {
        NSURL *fileURL = [[NSBundle bundleForClass:[self class]] URLForResource:@"GettingStartedGuide" withExtension:@"pdf"];
        [[[MendeleyKitConfiguration sharedInstance] networkProvider] invokeUploadForFileURL:fileURL
                                                                                    baseURL:self.testURL
                                                                                        api:@"post"
                                                                          additionalHeaders:nil
                                                                     authenticationRequired:NO
                                                                                       task:[MendeleyTask new]
                                                                              progressBlock:
         ^(NSNumber *progress) {
             NSLog(@"Update received: %.2f", progress.doubleValue);
             isProgressCalled = YES;
         }

                                                                            completionBlock: ^(MendeleyResponse *response, NSError *error) {
             errorResponse = error;
             *hasCalledBack = YES;
         }];
    });
    XCTAssertTrue(errorResponse == nil, @"An error was encountered while uploading the file: %@", errorResponse);

    XCTAssertTrue(isProgressCalled, @"Progress status never called");

    MendeleyDefaultNetworkProvider *defaultProvider = (MendeleyDefaultNetworkProvider *) [[MendeleyKitConfiguration sharedInstance] networkProvider];
    NSUInteger tasksRunning = [[[defaultProvider networkTaskDictionary] allKeys] count];

    XCTAssertTrue(tasksRunning == 0, @"Task not removed automatically");
}

- (void)testCancelTask
{
    __block BOOL cancelSuccess;
    __block NSError *errorResponse;
    MendeleyTask *cancellationRequest = [MendeleyTask new];

    [[[MendeleyKitConfiguration sharedInstance] networkProvider] invokeGET:_testURL
                                                                       api:@"delay/10"
                                                         additionalHeaders:nil
                                                           queryParameters:nil
                                                    authenticationRequired:NO
                                                                      task:cancellationRequest
                                                           completionBlock: ^(MendeleyResponse *response, NSError *error) {
     }];

    waitForBlock( ^(BOOL *hasCalledBack) {
        [[[MendeleyKitConfiguration sharedInstance] networkProvider] cancelTask:cancellationRequest
                                                                completionBlock: ^(BOOL success, NSError *error) {
             cancelSuccess = success;
             errorResponse = error;
             *hasCalledBack = YES;
         }];
    });

    XCTAssertTrue(errorResponse == nil && cancelSuccess, @"An error was encounterd while cancelling the request: %@", errorResponse);

    MendeleyDefaultNetworkProvider *defaultProvider = (MendeleyDefaultNetworkProvider *) [[MendeleyKitConfiguration sharedInstance] networkProvider];
    NSUInteger tasksRunning = [[[defaultProvider networkTaskDictionary] allKeys] count];

    XCTAssertTrue(tasksRunning == 0 && cancelSuccess, @"An error was encounterd while cancelling the request: %@", errorResponse);
}

- (void)testCancelAllTask
{
    __block BOOL cancelSuccess;
    __block NSError *errorResponse;
    __block int numberOfDownloads = 5;

    for (int i = 0; i < numberOfDownloads; i++)
    {
        [[[MendeleyKitConfiguration sharedInstance] networkProvider] invokeGET:self.testURL
                                                                           api:@"delay/10"
                                                             additionalHeaders:nil
                                                               queryParameters:nil
                                                        authenticationRequired:NO
                                                                          task:[MendeleyTask new]
                                                               completionBlock: ^(MendeleyResponse *response, NSError *error) {
         }];
    }

    waitForBlock( ^(BOOL *hasCalledBack) {
        [[[MendeleyKitConfiguration sharedInstance] networkProvider] cancelAllTasks: ^(BOOL success, NSError *error) {
             cancelSuccess = success;
             errorResponse = error;
             numberOfDownloads--;
             if (numberOfDownloads == 0)
             {
                 *hasCalledBack = YES;
             }
         }];
    });

    XCTAssertTrue(errorResponse == nil && cancelSuccess, @"An error was encounterd while cancelling the requests: %@", errorResponse);

    MendeleyDefaultNetworkProvider *defaultProvider = (MendeleyDefaultNetworkProvider *) [[MendeleyKitConfiguration sharedInstance] networkProvider];
    NSUInteger tasksRunning = [[[defaultProvider networkTaskDictionary] allKeys] count];

    XCTAssertTrue(tasksRunning == 0 && cancelSuccess, @"An error was encounterd while cancelling the request: %@", errorResponse);
}

- (void)testCancelDownload
{
    __block BOOL cancelSuccess;
    __block NSError *errorResponse;

    NSDictionary *delayQueryParameters = @{ @"numbytes": @"100000",
                                            @"duration": @"3",
                                            @"delay": @"1" };

    MendeleyTask *cancellationRequest = [MendeleyTask new];

    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *destinationPath = [documentsPath stringByAppendingPathComponent:@"downloadedFile"];
    NSURL *destinationURL = [NSURL fileURLWithPath:destinationPath];

    waitForBlock( ^(BOOL *hasCalledBack) {
        [[[MendeleyKitConfiguration sharedInstance] networkProvider] invokeDownloadToFileURL:destinationURL
                                                                                     baseURL:self.testURL
                                                                                         api:@"drip"
                                                                           additionalHeaders:nil
                                                                             queryParameters:delayQueryParameters
                                                                      authenticationRequired:NO
                                                                                        task:cancellationRequest
                                                                               progressBlock:nil
                                                                             completionBlock: ^(MendeleyResponse *response, NSError *error) {
             *hasCalledBack = YES;
         }];
        [[[MendeleyKitConfiguration sharedInstance] networkProvider] cancelTask:cancellationRequest
                                                                completionBlock: ^(BOOL success, NSError *error) {
             cancelSuccess = success;
             errorResponse = error;
         }];
    });



    XCTAssertTrue(errorResponse == nil && cancelSuccess, @"An error was encounterd while cancelling the request: %@", errorResponse);

    MendeleyDefaultNetworkProvider *defaultProvider = (MendeleyDefaultNetworkProvider *) [[MendeleyKitConfiguration sharedInstance] networkProvider];
    NSUInteger tasksRunning = [[[defaultProvider networkTaskDictionary] allKeys] count];

    XCTAssertTrue(tasksRunning == 0 && cancelSuccess, @"An error was encounterd while cancelling the request: %@", errorResponse);
}

@end
