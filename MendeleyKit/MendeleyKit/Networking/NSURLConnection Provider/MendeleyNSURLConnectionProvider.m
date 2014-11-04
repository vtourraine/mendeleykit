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

#import "MendeleyNSURLConnectionProvider.h"
#import "MendeleyRequest.h"
#import "MendeleyLog.h"
#import "NSError+MendeleyError.h"
#import "MendeleyURLBuilder.h"
#import "MendeleyNSURLRequestHelper.h"
#import "MendeleyNSURLRequestDownloadHelper.h"
#import "MendeleyNSURLRequestUploadHelper.h"

@interface MendeleyNSURLConnectionProvider ()
@property (nonatomic, strong, readwrite) NSMutableArray *tasks;
@end

@implementation MendeleyNSURLConnectionProvider
+ (MendeleyNSURLConnectionProvider *)sharedInstance
{
    static MendeleyNSURLConnectionProvider *sharedInstance = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
                      sharedInstance = [[MendeleyNSURLConnectionProvider alloc] init];
                      // Do any other initialisation stuff here
                  });
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (nil != self)
    {
        _tasks = [NSMutableArray array];
    }
    return self;
}

- (void)cancelAllTasks:(MendeleyCompletionBlock)completionBlock
{
    if (nil == self.tasks || 0 == self.tasks.count)
    {
        if (nil != completionBlock)
        {
            NSError *error = [[MendeleyErrorManager sharedInstance] errorWithDomain:kMendeleyErrorDomain code:kMendeleyCancelledRequestErrorCode];
            completionBlock(NO, error);
        }
        return;
    }

    [self.tasks enumerateObjectsUsingBlock:^(MendeleyTask *task, NSUInteger idx, BOOL *stop) {
         id<MendeleyCancellableRequest>cancellableTask = task.requestObject;
         if (nil != cancellableTask)
         {
             [cancellableTask cancelConnection];
         }
     }];

    [self.tasks removeAllObjects];


    if (completionBlock)
    {
        completionBlock(YES, nil);
    }
}

- (void) cancelTask:(MendeleyTask *)mendeleyTask
    completionBlock:(MendeleyCompletionBlock)completionBlock
{
    if (nil == mendeleyTask || nil == mendeleyTask.requestObject)
    {
        if (nil != completionBlock)
        {
            NSError *error = [[MendeleyErrorManager sharedInstance] errorWithDomain:kMendeleyErrorDomain code:kMendeleyCancelledRequestErrorCode];
            completionBlock(NO, error);
        }
        return;
    }
    id<MendeleyCancellableRequest>cancellableTask = mendeleyTask.requestObject;
    if (nil != cancellableTask)
    {
        [cancellableTask cancelConnection];
    }

    if (nil != self.tasks && 0 < self.tasks.count && [self.tasks containsObject:mendeleyTask])
    {
        [self.tasks removeObject:mendeleyTask];
    }

    if (completionBlock)
    {
        completionBlock(YES, nil);
    }

}

- (MendeleyTask *)invokeDownloadToFileURL:(NSURL *)fileURL
                                  baseURL:(NSURL *)baseURL
                                      api:(NSString *)api
                        additionalHeaders:(NSDictionary *)additionalHeaders
                          queryParameters:(NSDictionary *)queryParameters
                   authenticationRequired:(BOOL)authenticationRequired
                            progressBlock:(MendeleyResponseProgressBlock)progressBlock
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

    MendeleyNSURLRequestDownloadHelper *downloadHelper = [[MendeleyNSURLRequestDownloadHelper alloc]
                                                          initWithMendeleyRequest:request
                                                                        toFileURL:fileURL
                                                                    progressBlock:progressBlock
                                                                  completionBlock:completionBlock];
    MendeleyTask *task = [[MendeleyTask alloc] initWithRequestObject:downloadHelper];
    BOOL hasStarted = [downloadHelper startRequest];
    if (!hasStarted)
    {
        return nil;
    }
    else
    {
        [self.tasks addObject:task];
        return task;
    }
}

- (MendeleyTask *)invokeUploadForFileURL:(NSURL *)fileURL
                                 baseURL:(NSURL *)baseURL
                                     api:(NSString *)api
                       additionalHeaders:(NSDictionary *)additionalHeaders
                  authenticationRequired:(BOOL)authenticationRequired
                           progressBlock:(MendeleyResponseProgressBlock)progressBlock
                         completionBlock:(MendeleyResponseCompletionBlock)completionBlock
{
    [NSError assertArgumentNotNil:baseURL argumentName:@"fileURL"];
    [NSError assertArgumentNotNil:baseURL argumentName:@"baseURL"];
    [NSError assertArgumentNotNil:api argumentName:@"api"];
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
        request = [MendeleyRequest requestWithBaseURL:baseURL
                                                  api:api
                                          requestType:HTTP_POST];
    }
    if (nil != additionalHeaders)
    {
        [request addHeaderWithParameters:additionalHeaders];
    }

    MendeleyNSURLRequestUploadHelper *uploadHelper = [[MendeleyNSURLRequestUploadHelper alloc]
                                                      initWithMendeleyRequest:request
                                                                  fromFileURL:fileURL
                                                                progressBlock:progressBlock
                                                              completionBlock:completionBlock];
    MendeleyTask *task = [[MendeleyTask alloc] initWithRequestObject:uploadHelper];
    BOOL hasStarted = [uploadHelper startRequest];
    if (!hasStarted)
    {
        return nil;
    }
    else
    {
        [self.tasks addObject:task];
        return task;
    }
}

- (MendeleyTask *)invokeGET:(NSURL *)linkURL
          additionalHeaders:(NSDictionary *)additionalHeaders
            queryParameters:(NSDictionary *)queryParameters
     authenticationRequired:(BOOL)authenticationRequired
            completionBlock:(MendeleyResponseCompletionBlock)completionBlock
{
    return [self invokeGET:linkURL
                               api:nil
                 additionalHeaders:additionalHeaders
                   queryParameters:queryParameters
            authenticationRequired:authenticationRequired
                   completionBlock:completionBlock];
}

- (MendeleyTask *)invokeGET:(NSURL *)baseURL
                        api:(NSString *)api
          additionalHeaders:(NSDictionary *)additionalHeaders
            queryParameters:(NSDictionary *)queryParameters
     authenticationRequired:(BOOL)authenticationRequired
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
    MendeleyTask *task = [self executeTastWithRequest:request completionBlock:completionBlock];
    return task;
}

- (MendeleyTask *)invokePATCH:(NSURL *)baseURL
                          api:(NSString *)api
            additionalHeaders:(NSDictionary *)additionalHeaders
               bodyParameters:(NSDictionary *)bodyParameters
       authenticationRequired:(BOOL)authenticationRequired
              completionBlock:(MendeleyResponseCompletionBlock)completionBlock
{
    [NSError assertArgumentNotNil:baseURL argumentName:@"baseURL"];
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
    MendeleyTask *task = [self executeTastWithRequest:request completionBlock:completionBlock];
    return task;
}

- (MendeleyTask *)invokePATCH:(NSURL *)baseURL
                          api:(NSString *)api
            additionalHeaders:(NSDictionary *)additionalHeaders
                     jsonData:(NSData *)jsonData
       authenticationRequired:(BOOL)authenticationRequired
              completionBlock:(MendeleyResponseCompletionBlock)completionBlock
{
    [NSError assertArgumentNotNil:baseURL argumentName:@"baseURL"];
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
    MendeleyTask *task = [self executeTastWithRequest:request completionBlock:completionBlock];
    return task;
}


- (MendeleyTask *)invokePOST:(NSURL *)baseURL
                         api:(NSString *)api
           additionalHeaders:(NSDictionary *)additionalHeaders
              bodyParameters:(NSDictionary *)bodyParameters
                      isJSON:(BOOL)isJSON
      authenticationRequired:(BOOL)authenticationRequired
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
    MendeleyTask *task = [self executeTastWithRequest:request completionBlock:completionBlock];
    return task;
}

- (MendeleyTask *)invokePOST:(NSURL *)baseURL
                         api:(NSString *)api
           additionalHeaders:(NSDictionary *)additionalHeaders
                    jsonData:(NSData *)jsonData
      authenticationRequired:(BOOL)authenticationRequired
             completionBlock:(MendeleyResponseCompletionBlock)completionBlock
{
    [NSError assertArgumentNotNil:jsonData argumentName:@"jsonData"];
    [NSError assertArgumentNotNil:baseURL argumentName:@"baseURL"];
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
    MendeleyTask *task = [self executeTastWithRequest:request completionBlock:completionBlock];
    return task;
}

- (MendeleyTask *)invokePUT:(NSURL *)baseURL
                        api:(NSString *)api
          additionalHeaders:(NSDictionary *)additionalHeaders
             bodyParameters:(NSDictionary *)bodyParameters
     authenticationRequired:(BOOL)authenticationRequired
            completionBlock:(MendeleyResponseCompletionBlock)completionBlock
{
    [NSError assertArgumentNotNil:baseURL argumentName:@"baseURL"];
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
    MendeleyTask *task = [self executeTastWithRequest:request completionBlock:completionBlock];
    return task;
}

- (MendeleyTask *)invokeDELETE:(NSURL *)baseURL
                           api:(NSString *)api
             additionalHeaders:(NSDictionary *)additionalHeaders
                bodyParameters:(NSDictionary *)bodyParameters
        authenticationRequired:(BOOL)authenticationRequired
               completionBlock:(MendeleyResponseCompletionBlock)completionBlock
{
    [NSError assertArgumentNotNil:baseURL argumentName:@"baseURL"];
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
    MendeleyTask *task = [self executeTastWithRequest:request completionBlock:completionBlock];
    return task;
}

- (MendeleyTask *)invokeHEAD:(NSURL *)baseURL api:(NSString *)api authenticationRequired:(BOOL)authenticationRequired completionBlock:(MendeleyResponseCompletionBlock)completionBlock
{
    [NSError assertArgumentNotNil:baseURL argumentName:@"baseURL"];
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

    MendeleyTask *task = [self executeTastWithRequest:request completionBlock:completionBlock];
    return task;
}

- (MendeleyTask *)executeTastWithRequest:(MendeleyRequest *)request
                         completionBlock:(MendeleyResponseCompletionBlock)completionBlock
{
    MendeleyNSURLRequestHelper *requestHelper = [[MendeleyNSURLRequestHelper alloc] initWithMendeleyRequest:request completionBlock:completionBlock];
    MendeleyTask *task = [[MendeleyTask alloc] initWithRequestObject:requestHelper];
    BOOL hasStarted = [requestHelper startRequest];

    if (!hasStarted)
    {
        return nil;
    }
    else
    {
        [self.tasks addObject:task];
        return task;
    }
}

@end
