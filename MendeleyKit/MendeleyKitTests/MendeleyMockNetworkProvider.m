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

#ifndef MendeleyKitiOSFramework
#import "MendeleyTask.h"
#import "NSError+MendeleyError.h"
#endif

@interface MendeleyResponse ()
@property (nonatomic, assign, readwrite) BOOL success;
@property (nonatomic, strong, readwrite) id responseBody;
@property (nonatomic, strong, readwrite) NSString *responseMessage;
@property (nonatomic, assign, readwrite) NSUInteger statusCode;
@end


@interface MendeleyMockNetworkProvider ()
@property (nonatomic, strong) NSMutableArray *taskArray;
@property (nonatomic, assign) NSUInteger taskCounter;
@property (nonatomic, strong) MendeleyResponse *mockResponse;
@end


@implementation MendeleyMockNetworkProvider

- (id)init
{
    self = [super init];
    if (nil != self)
    {
        _taskArray = [NSMutableArray array];
        _taskCounter = 0;
        _mockResponse = [[MendeleyResponse alloc] init];
        _mockResponse.success = NO;
        _mockResponse.statusCode = 401;
        _mockResponse.responseBody = nil;
        _mockResponse.responseMessage = @"No Valid Response set";
    }
    return self;
}


- (void)invokeDownloadToFileURL:(NSURL *)fileURL
                        baseURL:(NSURL *)baseURL
                            api:(NSString *)api
              additionalHeaders:(NSDictionary *)additionalHeaders
                queryParameters:(NSDictionary *)queryParameters
         authenticationRequired:(BOOL)authenticationRequired
                           task:(MendeleyTask *)task
                  progressBlock:(MendeleyResponseProgressBlock)progressBlock
                completionBlock:(MendeleyResponseCompletionBlock)completionBlock
{
    [self executeMockTaskWithCompletionBlock:completionBlock];
}

- (void)invokeUploadForFileURL:(NSURL * )fileURL
                       baseURL:(NSURL *)baseURL
                           api:(NSString *)api
             additionalHeaders:(NSDictionary *)additionalHeaders
        authenticationRequired:(BOOL)authenticationRequired
                          task:(MendeleyTask *)task
                 progressBlock:(MendeleyResponseProgressBlock)progressBlock
               completionBlock:(MendeleyResponseCompletionBlock)completionBlock
{
    [self executeMockTaskWithCompletionBlock:completionBlock];
}


- (void)         invokeGET:(NSURL *)linkURL
         additionalHeaders:(NSDictionary *)additionalHeaders
           queryParameters:(NSDictionary *)queryParameters
    authenticationRequired:(BOOL)authenticationRequired
                      task:(MendeleyTask *)task
           completionBlock:(MendeleyResponseCompletionBlock)completionBlock
{
    [self executeMockTaskWithCompletionBlock:completionBlock];
}

- (void)         invokeGET:(NSURL *)baseURL
                       api:(NSString *)api
         additionalHeaders:(NSDictionary *)additionalHeaders
           queryParameters:(NSDictionary *)queryParameters
    authenticationRequired:(BOOL)authenticationRequired
                      task:(MendeleyTask *)task
           completionBlock:(MendeleyResponseCompletionBlock)completionBlock
{
    [self executeMockTaskWithCompletionBlock:completionBlock];
}


- (void)         invokePUT:(NSURL *)baseURL
                       api:(NSString *)api
         additionalHeaders:(NSDictionary *)additionalHeaders
            bodyParameters:(NSDictionary *)bodyParameters
    authenticationRequired:(BOOL)authenticationRequired
                      task:(MendeleyTask *)task
           completionBlock:(MendeleyResponseCompletionBlock)completionBlock
{
    [self executeMockTaskWithCompletionBlock:completionBlock];
}

- (void)        invokePOST:(NSURL *)baseURL
                       api:(NSString *)api
         additionalHeaders:(NSDictionary *)additionalHeaders
            bodyParameters:(NSDictionary *)bodyParameters
                    isJSON:(BOOL)isJSON
    authenticationRequired:(BOOL)authenticationRequired
                      task:(MendeleyTask *)task
           completionBlock:(MendeleyResponseCompletionBlock)completionBlock
{
    [self executeMockTaskWithCompletionBlock:completionBlock];
}


- (void)        invokePOST:(NSURL *)baseURL
                       api:(NSString *)api
         additionalHeaders:(NSDictionary *)additionalHeaders
                  jsonData:(NSData *)jsonData
    authenticationRequired:(BOOL)authenticationRequired
                      task:(MendeleyTask *)task
           completionBlock:(MendeleyResponseCompletionBlock)completionBlock
{
    if (self.checkValidJSONInputData)
    {
        NSError *parseError = nil;
        id expectedObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&parseError];
        if (nil == expectedObject)
        {
            completionBlock(nil, parseError);
            return;
        }
        if (![expectedObject isKindOfClass:[NSDictionary class]] && ![expectedObject isKindOfClass:[NSArray class]])
        {
            NSError *error = [NSError errorWithCode:kMendeleyJSONTypeUnrecognisedErrorCode];
            completionBlock(nil, error);
            return;
        }
    }
    [self executeMockTaskWithCompletionBlock:completionBlock];
}

- (void)      invokeDELETE:(NSURL *)baseURL
                       api:(NSString *)api
         additionalHeaders:(NSDictionary *)additionalHeaders
            bodyParameters:(NSDictionary *)bodyParameters
    authenticationRequired:(BOOL)authenticationRequired
                      task:(MendeleyTask *)task
           completionBlock:(MendeleyResponseCompletionBlock)completionBlock
{

    [self executeMockTaskWithCompletionBlock:completionBlock];
}

- (void)       invokePATCH:(NSURL *)baseURL
                       api:(NSString *)api
         additionalHeaders:(NSDictionary *)additionalHeaders
            bodyParameters:(NSDictionary *)bodyParameters
    authenticationRequired:(BOOL)authenticationRequired
                      task:(MendeleyTask *)task
           completionBlock:(MendeleyResponseCompletionBlock)completionBlock
{

    [self executeMockTaskWithCompletionBlock:completionBlock];
}

- (void)       invokePATCH:(NSURL *)baseURL
                       api:(NSString *)api
         additionalHeaders:(NSDictionary *)additionalHeaders
                  jsonData:(NSData *)jsonData
    authenticationRequired:(BOOL)authenticationRequired
                      task:(MendeleyTask *)task
           completionBlock:(MendeleyResponseCompletionBlock)completionBlock
{
    if (self.checkValidJSONInputData)
    {
        NSError *parseError = nil;
        id expectedObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&parseError];
        if (nil == expectedObject)
        {
            completionBlock(nil, parseError);
            return;
        }
        if (![expectedObject isKindOfClass:[NSDictionary class]] && ![expectedObject isKindOfClass:[NSArray class]])
        {
            NSError *error = [NSError errorWithCode:kMendeleyJSONTypeUnrecognisedErrorCode];
            completionBlock(nil, error);
            return;
        }
    }
    [self executeMockTaskWithCompletionBlock:completionBlock];
}

- (void)        invokeHEAD:(NSURL *)baseURL
                       api:(NSString *)api
    authenticationRequired:(BOOL)authenticationRequired
                      task:(MendeleyTask *)task
           completionBlock:(MendeleyResponseCompletionBlock)completionBlock
{
    [self executeMockTaskWithCompletionBlock:completionBlock];
}


- (void) cancelTask:(MendeleyTask *)task
    completionBlock:(MendeleyCompletionBlock)completionBlock
{
    [self executeMockCompletionBlock:completionBlock];
}

- (void)cancelAllTasks:(MendeleyCompletionBlock)completionBlock
{
    [self executeMockCompletionBlock:completionBlock];
}

- (void)executeMockCompletionBlock:(MendeleyCompletionBlock)completionBlock
{
    if (self.expectedSuccess)
    {
        completionBlock(YES, nil);
    }
    else
    {
        NSError *mockError = self.expectedError;
        if (nil == mockError)
        {
            mockError = [NSError errorWithCode:kMendeleyResponseTypeUnknownErrorCode];
        }
        completionBlock(NO, mockError);
    }
}

- (void)executeMockTaskWithCompletionBlock:(MendeleyResponseCompletionBlock)completionBlock
{
    [NSError assertArgumentNotNil:completionBlock argumentName:@"completionBlock"];
    self.mockResponse.success = self.expectedSuccess;
    self.mockResponse.statusCode = self.expectedStatusCode;
    self.mockResponse.responseBody = self.expectedResponseBody;
    if (self.mockResponse.success)
    {
        completionBlock(self.mockResponse, nil);
    }
    else
    {
        NSError *mockError = self.expectedError;
        if (nil == mockError)
        {
            mockError = [NSError errorWithCode:kMendeleyResponseTypeUnknownErrorCode];
        }
        completionBlock(nil, mockError);
    }

    self.taskCounter++;
    MendeleyTask *task = [[MendeleyTask alloc] initWithTaskID:[NSString stringWithFormat:@"%lu", (unsigned long) self.taskCounter]];
    [self.taskArray addObject:task];
}

@end
