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

#import "MendeleyDefaultNetworkProvider.h"
#import "MendeleyRequest.h"
#import "MendeleyLog.h"
#import "NSError+MendeleyError.h"
#import "MendeleyNetworkTask.h"
#import "MendeleyURLBuilder.h"
#import "MendeleyUploadHelper.h"
#import "MendeleyDownloadHelper.h"
#import "MendeleyTaskProvider.h"
#include "MendeleyDataHelper.h"


@interface MendeleyDefaultNetworkProvider () <NSURLSessionDownloadDelegate>

@property (nonatomic, strong, readwrite) NSURLSession *currentSession;
@property (nonatomic, strong, readwrite) NSMutableDictionary *networkTaskDictionary;
@property (nonatomic, strong, readwrite) NSMutableDictionary *cancellationTaskDictionary;
@property (nonatomic, strong, readwrite) MendeleyUploadHelper *uploadHelper;
@property (nonatomic, strong, readwrite) MendeleyDownloadHelper *downloadHelper;
@property (nonatomic, strong, readwrite) MendeleyDataHelper *dataHelper;

@end

@implementation MendeleyDefaultNetworkProvider

#pragma mark - Initialization
+ (MendeleyDefaultNetworkProvider *)sharedInstance
{
    static MendeleyDefaultNetworkProvider *sharedInstance = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
                      sharedInstance = [[MendeleyDefaultNetworkProvider alloc] init];
                  });
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _networkTaskDictionary = [NSMutableDictionary dictionary];
        _cancellationTaskDictionary = [NSMutableDictionary dictionary];
        _uploadHelper = [MendeleyUploadHelper new];
        _downloadHelper = [MendeleyDownloadHelper new];
        _dataHelper = [MendeleyDataHelper new];
        [self createSession];
    }
    return self;
}

- (NSMutableSet *)onGoingTasks
{
    return [NSMutableSet setWithArray:self.networkTaskDictionary.allValues];
}

- (NSString *)cancellationTaskFromNetworkTaskID:(NSNumber *)networkTaskID
{
    return nil;
}

- (NSNumber *)networkTaskFromCancellationTaskID:(NSString *)cancellationTaskID
{
    return nil;
}

- (void)createSession
{
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];

    [sessionConfig setRequestCachePolicy:kMendeleyDefaultCachePolicy];
    [sessionConfig setHTTPAdditionalHeaders:[MendeleyURLBuilder defaultHeader]];
    [self setCurrentSession:[NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil]];
}

#pragma mark - Public Methods

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
    [NSError assertArgumentNotNil:fileURL argumentName:@"fileURL"];
    [NSError assertArgumentNotNil:baseURL argumentName:@"baseURL"];
    [NSError assertArgumentNotNil:api argumentName:@"api"];
    [NSError assertArgumentNotNil:completionBlock argumentName:@"completionBlock"];

    MendeleyRequest *request = nil;
    if (authenticationRequired)
    {
        request = [MendeleyRequest authenticatedRequestWithBaseURL:baseURL
                                                               api:api
                                                       requestType:HTTP_GET
            ];
    }
    else
    {
        request = [MendeleyRequest requestWithBaseURL:baseURL
                                                  api:api
                                          requestType:HTTP_GET
            ];
    }
    if (nil != additionalHeaders)
    {
        [request addHeaderWithParameters:additionalHeaders];
    }
    if (nil != queryParameters)
    {
        [request addParametersToURL:queryParameters isQuery:YES];
    }

    MendeleyNetworkDownloadTask *networkTask = [[MendeleyNetworkDownloadTask alloc] initDownloadTaskWithRequest:request.mutableURLRequest
                                                                                                        session:self.currentSession
                                                                                                        fileURL:(NSURL *) fileURL
                                                                                                  progressBlock:progressBlock
                                                                                                completionBlock:completionBlock
        ];
    [self executeNetworkTask:networkTask cancellationID:task.taskID];
}

- (void)invokeUploadForFileURL:(NSURL *)fileURL
                       baseURL:(NSURL *)baseURL
                           api:(NSString *)api
             additionalHeaders:(NSDictionary *)additionalHeaders
        authenticationRequired:(BOOL)authenticationRequired
                          task:(MendeleyTask *)task
                 progressBlock:(MendeleyResponseProgressBlock)progressBlock
               completionBlock:(MendeleyResponseCompletionBlock)completionBlock
{
    [NSError assertURLArgumentNotNilOrMissing:fileURL argumentName:@"fileURL"];
    [NSError assertArgumentNotNil:baseURL argumentName:@"baseURL"];
    [NSError assertArgumentNotNil:api argumentName:@"api"];
    [NSError assertArgumentNotNil:completionBlock argumentName:@"completionBlock"];

#warning HTTP_POST could be not specified
    MendeleyRequest *request = nil;
    if (authenticationRequired)
    {
        request = [MendeleyRequest authenticatedRequestWithBaseURL:baseURL
                                                               api:api
                                                       requestType:HTTP_POST
            ];
    }
    else
    {
        request = [MendeleyRequest requestWithBaseURL:baseURL
                                                  api:api
                                          requestType:HTTP_POST
            ];
    }
    if (nil != additionalHeaders)
    {
        [request addHeaderWithParameters:additionalHeaders];
    }
    __block MendeleyNetworkUploadTask *networkTask = [[MendeleyNetworkUploadTask alloc] initUploadTaskWithRequest:request.mutableURLRequest
                                                                                                          session:self.currentSession
                                                                                                          fileURL:fileURL
                                                                                                    progressBlock:progressBlock
                                                                                                  completionBlock: ^(MendeleyResponse *response, NSError *error) {
                                                          [self.networkTaskDictionary removeObjectForKey:task.taskID];
                                                          completionBlock(response, error);
                                                      }];
    [self executeNetworkTask:networkTask cancellationID:task.taskID];
}

- (void)         invokeGET:(NSURL *)linkURL
         additionalHeaders:(NSDictionary *)additionalHeaders
           queryParameters:(NSDictionary *)queryParameters
    authenticationRequired:(BOOL)authenticationRequired
                      task:(MendeleyTask *)task
           completionBlock:(MendeleyResponseCompletionBlock)completionBlock
{
    return [self invokeGET:linkURL
                               api:nil
                 additionalHeaders:additionalHeaders
                   queryParameters:queryParameters
            authenticationRequired:authenticationRequired
                              task:task
                   completionBlock:completionBlock];
}

- (void)         invokeGET:(NSURL *)baseURL
                       api:(NSString *)api
         additionalHeaders:(NSDictionary *)additionalHeaders
           queryParameters:(NSDictionary *)queryParameters
    authenticationRequired:(BOOL)authenticationRequired
                      task:(MendeleyTask *)task
           completionBlock:(MendeleyResponseCompletionBlock)completionBlock
{
    [NSError assertArgumentNotNil:baseURL argumentName:@"baseURL"];
    [NSError assertArgumentNotNil:completionBlock argumentName:@"completionBlock"];

    MendeleyRequest *request = nil;
    if (authenticationRequired)
    {
        request = [MendeleyRequest authenticatedRequestWithBaseURL:baseURL
                                                               api:api
                                                       requestType:HTTP_GET];
    }
    else
    {
        request = [MendeleyRequest requestWithBaseURL:baseURL
                                                  api:api
                                          requestType:HTTP_GET];
    }

    if (nil != additionalHeaders)
    {
        [request addHeaderWithParameters:additionalHeaders];
    }
    if (nil != queryParameters)
    {
        [request addParametersToURL:queryParameters isQuery:YES];
    }

    __block MendeleyNetworkTask *networkTask = [[MendeleyNetworkTask alloc] initTaskWithRequest:request.mutableURLRequest
                                                                                        session:self.currentSession
                                                                                completionBlock: ^(MendeleyResponse *response, NSError *error) {
                                                    [self.networkTaskDictionary removeObjectForKey:task.taskID];
                                                    completionBlock(response, error);
                                                }];
    [self executeNetworkTask:networkTask cancellationID:task.taskID];
}

- (void)         invokePUT:(NSURL *)baseURL
                       api:(NSString *)api
         additionalHeaders:(NSDictionary *)additionalHeaders
            bodyParameters:(NSDictionary *)bodyParameters
    authenticationRequired:(BOOL)authenticationRequired
                      task:(MendeleyTask *)task
           completionBlock:(MendeleyResponseCompletionBlock)completionBlock
{
    [NSError assertArgumentNotNil:baseURL argumentName:@"baseURL"];
    [NSError assertArgumentNotNil:api argumentName:@"api"];
    [NSError assertArgumentNotNil:completionBlock argumentName:@"completionBlock"];

    MendeleyRequest *request = nil;
    if (authenticationRequired)
    {
        request = [MendeleyRequest authenticatedRequestWithBaseURL:baseURL
                                                               api:api
                                                       requestType:HTTP_PUT
            ];
    }
    else
    {
        request = [MendeleyRequest requestWithBaseURL:baseURL
                                                  api:api
                                          requestType:HTTP_PUT
            ];
    }
    if (nil != additionalHeaders)
    {
        [request addHeaderWithParameters:additionalHeaders];
    }
    if (nil != bodyParameters)
    {
        [request addBodyWithParameters:bodyParameters
                                isJSON:NO];
    }


    __block MendeleyNetworkTask *networkTask = [[MendeleyNetworkTask alloc] initTaskWithRequest:request.mutableURLRequest
                                                                                        session:self.currentSession
                                                                                completionBlock: ^(MendeleyResponse *response, NSError *error) {
                                                    [self.networkTaskDictionary removeObjectForKey:task.taskID];
                                                    completionBlock(response, error);
                                                }];
    [self executeNetworkTask:networkTask cancellationID:task.taskID];
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
    [NSError assertArgumentNotNil:baseURL argumentName:@"baseURL"];
    [NSError assertArgumentNotNil:completionBlock argumentName:@"completionBlock"];

    MendeleyRequest *request = nil;
    if (authenticationRequired)
    {
        request = [MendeleyRequest authenticatedRequestWithBaseURL:baseURL
                                                               api:api
                                                       requestType:HTTP_POST];
    }
    else
    {
        request = [MendeleyRequest requestWithBaseURL:baseURL api:api
                                          requestType:HTTP_POST];
    }

    if (nil != additionalHeaders)
    {
        [request addHeaderWithParameters:additionalHeaders];
    }
    if (nil != bodyParameters)
    {
        [request addBodyWithParameters:bodyParameters
                                isJSON:isJSON];
    }

    __block MendeleyNetworkTask *networkTask = [[MendeleyNetworkTask alloc] initTaskWithRequest:request.mutableURLRequest
                                                                                        session:self.currentSession
                                                                                completionBlock: ^(MendeleyResponse *response, NSError *error) {
                                                    [self.networkTaskDictionary removeObjectForKey:task.taskID];
                                                    completionBlock(response, error);
                                                }];
    [self executeNetworkTask:networkTask cancellationID:task.taskID];
}

- (void)        invokePOST:(NSURL *)baseURL
                       api:(NSString *)api
         additionalHeaders:(NSDictionary *)additionalHeaders
                  jsonData:(NSData *)jsonData
    authenticationRequired:(BOOL)authenticationRequired
                      task:(MendeleyTask *)task
           completionBlock:(MendeleyResponseCompletionBlock)completionBlock
{
    [NSError assertArgumentNotNil:baseURL argumentName:@"baseURL"];
    [NSError assertArgumentNotNil:api argumentName:@"api"];
    [NSError assertArgumentNotNil:jsonData argumentName:@"bodyData"];
    [NSError assertArgumentNotNil:completionBlock argumentName:@"completionBlock"];


    MendeleyRequest *request = nil;
    if (authenticationRequired)
    {
        request = [MendeleyRequest authenticatedRequestWithBaseURL:baseURL
                                                               api:api
                                                       requestType:HTTP_POST
            ];
    }
    else
    {
        request = [MendeleyRequest requestWithBaseURL:baseURL
                                                  api:api
                                          requestType:HTTP_POST
            ];
    }

    if (nil != additionalHeaders)
    {
        [request addHeaderWithParameters:additionalHeaders];
    }
    [request addBodyData:jsonData];

    __block MendeleyNetworkTask *networkTask = [[MendeleyNetworkTask alloc] initTaskWithRequest:request.mutableURLRequest
                                                                                        session:self.currentSession
                                                                                completionBlock: ^(MendeleyResponse *response, NSError *error) {
                                                    [self.networkTaskDictionary removeObjectForKey:task.taskID];
                                                    completionBlock(response, error);
                                                }];
    [self executeNetworkTask:networkTask cancellationID:task.taskID];
}

- (void)      invokeDELETE:(NSURL *)baseURL
                       api:(NSString *)api
         additionalHeaders:(NSDictionary *)additionalHeaders
            bodyParameters:(NSDictionary *)bodyParameters
    authenticationRequired:(BOOL)authenticationRequired
                      task:(MendeleyTask *)task
           completionBlock:(MendeleyResponseCompletionBlock)completionBlock
{
    [NSError assertArgumentNotNil:baseURL argumentName:@"baseURL"];
    [NSError assertArgumentNotNil:api argumentName:@"api"];
    [NSError assertArgumentNotNil:completionBlock argumentName:@"completionBlock"];

    MendeleyRequest *request = nil;
    if (authenticationRequired)
    {
        request = [MendeleyRequest authenticatedRequestWithBaseURL:baseURL
                                                               api:api
                                                       requestType:HTTP_DELETE
            ];
    }
    else
    {
        request = [MendeleyRequest requestWithBaseURL:baseURL
                                                  api:api
                                          requestType:HTTP_DELETE
            ];
    }

    if (nil != additionalHeaders)
    {
        [request addHeaderWithParameters:additionalHeaders];
    }
    if (nil != bodyParameters)
    {
        [request addBodyWithParameters:bodyParameters
                                isJSON:NO];
    }

    __block MendeleyNetworkTask *networkTask = [[MendeleyNetworkTask alloc] initTaskWithRequest:request.mutableURLRequest
                                                                                        session:self.currentSession
                                                                                completionBlock: ^(MendeleyResponse *response, NSError *error) {
                                                    [self.networkTaskDictionary removeObjectForKey:task.taskID];
                                                    completionBlock(response, error);
                                                }];
    [self executeNetworkTask:networkTask cancellationID:task.taskID];
}

- (void)       invokePATCH:(NSURL *)baseURL
                       api:(NSString *)api
         additionalHeaders:(NSDictionary *)additionalHeaders
            bodyParameters:(NSDictionary *)bodyParameters
    authenticationRequired:(BOOL)authenticationRequired
                      task:(MendeleyTask *)task
           completionBlock:(MendeleyResponseCompletionBlock)completionBlock
{
    [NSError assertArgumentNotNil:baseURL argumentName:@"baseURL"];
    [NSError assertArgumentNotNil:api argumentName:@"api"];
    [NSError assertArgumentNotNil:completionBlock argumentName:@"completionBlock"];

    MendeleyRequest *request = nil;
    if (authenticationRequired)
    {
        request = [MendeleyRequest authenticatedRequestWithBaseURL:baseURL
                                                               api:api
                                                       requestType:HTTP_PATCH
            ];
    }
    else
    {
        request = [MendeleyRequest requestWithBaseURL:baseURL
                                                  api:api
                                          requestType:HTTP_PATCH
            ];
    }
    if (nil != additionalHeaders)
    {
        [request addHeaderWithParameters:additionalHeaders];
    }
    if (nil != bodyParameters)
    {
        [request addBodyWithParameters:bodyParameters
                                isJSON:NO];
    }

    __block MendeleyNetworkTask *networkTask = [[MendeleyNetworkTask alloc] initTaskWithRequest:request.mutableURLRequest
                                                                                        session:self.currentSession
                                                                                completionBlock: ^(MendeleyResponse *response, NSError *error) {
                                                    [self.networkTaskDictionary removeObjectForKey:task.taskID];
                                                    completionBlock(response, error);
                                                }];
    [self executeNetworkTask:networkTask cancellationID:task.taskID];
}

- (void)       invokePATCH:(NSURL *)baseURL
                       api:(NSString *)api
         additionalHeaders:(NSDictionary *)additionalHeaders
                  jsonData:(NSData *)jsonData
    authenticationRequired:(BOOL)authenticationRequired
                      task:(MendeleyTask *)task
           completionBlock:(MendeleyResponseCompletionBlock)completionBlock
{
    [NSError assertArgumentNotNil:baseURL argumentName:@"baseURL"];
    [NSError assertArgumentNotNil:api argumentName:@"api"];
    [NSError assertArgumentNotNil:jsonData argumentName:@"jsonData"];
    [NSError assertArgumentNotNil:completionBlock argumentName:@"completionBlock"];

    MendeleyRequest *request = nil;
    if (authenticationRequired)
    {
        request = [MendeleyRequest authenticatedRequestWithBaseURL:baseURL
                                                               api:api
                                                       requestType:HTTP_PATCH
            ];
    }
    else
    {
        request = [MendeleyRequest requestWithBaseURL:baseURL
                                                  api:api
                                          requestType:HTTP_PATCH
            ];
    }
    if (nil != additionalHeaders)
    {
        [request addHeaderWithParameters:additionalHeaders];
    }
    if (nil != jsonData)
    {
        [request.mutableURLRequest setHTTPBody:jsonData];
    }

    __block MendeleyNetworkTask *networkTask = [[MendeleyNetworkTask alloc] initTaskWithRequest:request.mutableURLRequest
                                                                                        session:self.currentSession
                                                                                completionBlock: ^(MendeleyResponse *response, NSError *error) {
                                                    [self.networkTaskDictionary removeObjectForKey:task.taskID];
                                                    completionBlock(response, error);
                                                }];
    [self executeNetworkTask:networkTask cancellationID:task.taskID];
}

- (void)        invokeHEAD:(NSURL *)baseURL
                       api:(NSString *)api
    authenticationRequired:(BOOL)authenticationRequired
                      task:(MendeleyTask *)task
           completionBlock:(MendeleyResponseCompletionBlock)completionBlock
{
    [NSError assertArgumentNotNil:baseURL argumentName:@"baseURL"];
    [NSError assertArgumentNotNil:api argumentName:@"api"];
    [NSError assertArgumentNotNil:completionBlock argumentName:@"completionBlock"];
    MendeleyRequest *request = nil;
    if (authenticationRequired)
    {
        request = [MendeleyRequest authenticatedRequestWithBaseURL:baseURL api:api requestType:HTTP_HEAD];
    }
    else
    {
        request = [MendeleyRequest requestWithBaseURL:baseURL api:api requestType:HTTP_HEAD];
    }

    __block MendeleyNetworkTask *networkTask = [[MendeleyNetworkTask alloc] initTaskWithRequest:request.mutableURLRequest
                                                                                        session:self.currentSession
                                                                                completionBlock: ^(MendeleyResponse *response, NSError *error) {
                                                    [self.networkTaskDictionary removeObjectForKey:task.taskID];
                                                    completionBlock(response, error);
                                                }];
    [self executeNetworkTask:networkTask cancellationID:task.taskID];
}

- (void) cancelTask:(MendeleyTask *)task
    completionBlock:(MendeleyCompletionBlock)completionBlock;
{
    MendeleyNetworkTask *networkTask = [self.cancellationTaskDictionary objectForKey:task.taskID];
    if (networkTask)
    {
        [self.cancellationTaskDictionary removeObjectForKey:task.taskID];
        [networkTask cancelTaskWithCompletionBlock:completionBlock];
    }
}

- (void)cancelAllTasks:(MendeleyCompletionBlock)completionBlock
{
    for (MendeleyTask *task in self.networkTaskDictionary.allValues)
    {
        [self cancelTask:task
         completionBlock:completionBlock];
    }
}

#pragma mark - Task Lifecycle Methods

- (void)executeNetworkTask:(MendeleyNetworkTask *)task cancellationID:(NSString *)taskID
{
    [self.networkTaskDictionary setObject:task forKey:task.taskID];
    [task executeTask];
}

#pragma mark -
#pragma mark NSURLSessionTaskDelegate methods

- (void)      URLSession:(NSURLSession *)session
                    task:(NSURLSessionTask *)task
    didCompleteWithError:(NSError *)error
{
    MendeleyNetworkTask *mendeleyTask = [self.networkTaskDictionary objectForKey:@(task.taskIdentifier)];

    if (mendeleyTask)
    {
        [self.networkTaskDictionary removeObjectForKey:@(task.taskIdentifier)];
        [self.dataHelper URLSession:session task:mendeleyTask didCompleteWithError:error];
    }
}

- (void)          URLSession:(NSURLSession *)session
                        task:(NSURLSessionTask *)task
             didSendBodyData:(int64_t)bytesSent
              totalBytesSent:(int64_t)totalBytesSent
    totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    [self.uploadHelper URLSession:session
                             task:[self.networkTaskDictionary objectForKey:@(task.taskIdentifier)]
                  didSendBodyData:bytesSent totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
}

#pragma mark -
#pragma mark NSURLSessionDownloadDelegate methods

- (void)           URLSession:(NSURLSession *)session
                 downloadTask:(NSURLSessionDownloadTask *)downloadTask
                 didWriteData:(int64_t)bytesWritten
            totalBytesWritten:(int64_t)totalBytesWritten
    totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    [self.downloadHelper URLSession:session
                       downloadTask:[self.networkTaskDictionary objectForKey:@(downloadTask.taskIdentifier)]
                       didWriteData:bytesWritten
                  totalBytesWritten:totalBytesWritten
          totalBytesExpectedToWrite:totalBytesExpectedToWrite];
}

- (void)           URLSession:(NSURLSession *)session
                 downloadTask:(NSURLSessionDownloadTask *)downloadTask
    didFinishDownloadingToURL:(NSURL *)location
{
    [self.downloadHelper URLSession:session
                       downloadTask:[self.networkTaskDictionary objectForKey:@(downloadTask.taskIdentifier)]
          didFinishDownloadingToURL:location];
}

#warning needs implementing
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
{
}

- (void)            URLSession:(NSURLSession *)session
                          task:(NSURLSessionTask *)task
    willPerformHTTPRedirection:(NSHTTPURLResponse *)response
                    newRequest:(NSURLRequest *)request
             completionHandler:(void (^)(NSURLRequest *))completionHandler
{
    NSURLRequest *redirectRequest = request;

    if (nil != response)
    {
        if (303 == response.statusCode)
        {
            redirectRequest = [NSURLRequest requestWithURL:request.URL];
        }
    }

    if (nil != completionHandler)
    {
        completionHandler(redirectRequest);
    }
}

#pragma mark -
#pragma mark - NSURLSessionDataDelegate methods

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{
}

- (void)    URLSession:(NSURLSession *)session
              dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveResponse:(NSURLResponse *)response
     completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    [self.dataHelper URLSession:session
                       dataTask:[self.networkTaskDictionary objectForKey:@(dataTask.taskIdentifier)]
             didReceiveResponse:response completionHandler:completionHandler];
}

- (void)       URLSession:(NSURLSession *)session
                 dataTask:(NSURLSessionDataTask *)dataTask
    didBecomeDownloadTask:(NSURLSessionDownloadTask *)downloadTask
{
    MendeleyNetworkDownloadTask *mendeleyDataTask = [self.networkTaskDictionary objectForKey:@(dataTask.taskIdentifier)];

    [mendeleyDataTask addRealDownloadTask:downloadTask];
}

@end
