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

#import <Foundation/Foundation.h>
#import "MendeleyResponse.h"
#import "MendeleyTask.h"

@protocol MendeleyNetworkProvider <NSObject>
/**
   @name MendeleyNetworkProvider
   This protocol provides general network methods used in the MendeleyKit
   Any custom provider implementation must implement the required methods
   to ensure proper execution of network operations.
 */
@required

/**
   this method will GET HTTP method to download data from the server
   @param fileURL
   @param baseURL
   @param api
   @param additionalHeaders any additional headers to be used in the request
   @param queryParameters this will be a set of query parameters
   @param authenticationRequired
   @param progressBlock
   @param completionBlock
   @return a cancellable request
 */
- (MendeleyTask *)invokeDownloadToFileURL:(NSURL *)fileURL
                                  baseURL:(NSURL *)baseURL
                                      api:(NSString *)api
                        additionalHeaders:(NSDictionary *)additionalHeaders
                          queryParameters:(NSDictionary *)queryParameters
                   authenticationRequired:(BOOL)authenticationRequired
                            progressBlock:(MendeleyResponseProgressBlock)progressBlock
                          completionBlock:(MendeleyResponseCompletionBlock)completionBlock;

/**
   uploading files method
   @param fileURL
   @param baseURL
   @param api
   @param additionalHeaders any additional headers to be used in the request
   @param progressBlock
   @param completionBlock
   @return a cancellable request
 */
- (MendeleyTask *)invokeUploadForFileURL:(NSURL * )fileURL
                                 baseURL:(NSURL *)baseURL
                                     api:(NSString *)api
                       additionalHeaders:(NSDictionary *)additionalHeaders
                  authenticationRequired:(BOOL)authenticationRequired
                           progressBlock:(MendeleyResponseProgressBlock)progressBlock
                         completionBlock:(MendeleyResponseCompletionBlock)completionBlock;


/**
   this method will GET HTTP method to download data from the server based on a
   complete link URL
   This method assumes that authentication is required
   @param linkURL
   @param api
   @param additionalHeaders any additional headers to be used in the request
   @param queryParameters this will be a set of query parameters
   @param completionBlock
   @return a cancellable request
 */
- (MendeleyTask *)invokeGET:(NSURL *)linkURL
          additionalHeaders:(NSDictionary *)additionalHeaders
            queryParameters:(NSDictionary *)queryParameters
     authenticationRequired:(BOOL)authenticationRequired
            completionBlock:(MendeleyResponseCompletionBlock)completionBlock;

/**
   this method will GET HTTP method to download data from the server
   @param baseURL
   @param api
   @param additionalHeaders any additional headers to be used in the request
   @param queryParameters this will be a set of query parameters
   @param authenticationRequired - some GET methods may not require authentication
   @param completionBlock
   @return a cancellable request
 */
- (MendeleyTask *)invokeGET:(NSURL *)baseURL
                        api:(NSString *)api
          additionalHeaders:(NSDictionary *)additionalHeaders
            queryParameters:(NSDictionary *)queryParameters
     authenticationRequired:(BOOL)authenticationRequired
            completionBlock:(MendeleyResponseCompletionBlock)completionBlock;

/**
   this method will PUT HTTP method to upload & update data to the server.
   Used to update existing data on the server. All PUT methods are assumed to require authentication
   @param baseURL
   @param api
   @param additionalHeaders any additional headers to be used in the request
   @param bodyParameters
   @param completionBlock
   @return a cancellable request
 */
- (MendeleyTask *)invokePUT:(NSURL *)baseURL
                        api:(NSString *)api
          additionalHeaders:(NSDictionary *)additionalHeaders
             bodyParameters:(NSDictionary *)bodyParameters
     authenticationRequired:(BOOL)authenticationRequired
            completionBlock:(MendeleyResponseCompletionBlock)completionBlock;

/**
   this method will POST HTTP method to upload data to the server.
    Use this to store data on the server.
   @param baseURL
   @param api
   @param additionalHeaders any additional headers to be used in the request
   @param bodyParameters a body consisting of NSString based key-value pairs
   @param usesAuthentication
   @param isJSON
   @param completionBlock
   @return a cancellable request
 */
- (MendeleyTask *)invokePOST:(NSURL *)baseURL
                         api:(NSString *)api
           additionalHeaders:(NSDictionary *)additionalHeaders
              bodyParameters:(NSDictionary *)bodyParameters
                      isJSON:(BOOL)isJSON
      authenticationRequired:(BOOL)authenticationRequired
             completionBlock:(MendeleyResponseCompletionBlock)completionBlock;

/**
   this method will POST HTTP method to upload data to the server.
   Use this to store data on the server. All POST requests are assumed to require authentication
   @param baseURL
   @param api
   @param additionalHeaders any additional headers to be used in the request
   @param jsonData
   @param completionBlock
   @return a cancellable request
 */
- (MendeleyTask *)invokePOST:(NSURL *)baseURL
                         api:(NSString *)api
           additionalHeaders:(NSDictionary *)additionalHeaders
                    jsonData:(NSData *)jsonData
      authenticationRequired:(BOOL)authenticationRequired
             completionBlock:(MendeleyResponseCompletionBlock)completionBlock;

/**
   this method will create a DELETE HTTP request.
   Use this to store data on the server.
   Delete methods require authentication
   @param baseURL
   @param api
   @param completionBlock
   @return a cancellable request
 */
- (MendeleyTask *)invokeDELETE:(NSURL *)baseURL
                           api:(NSString *)api
             additionalHeaders:(NSDictionary *)additionalHeaders
                bodyParameters:(NSDictionary *)bodyParameters
        authenticationRequired:(BOOL)authenticationRequired
               completionBlock:(MendeleyResponseCompletionBlock)completionBlock;

/**
   this method will create a PATCH HTTP request.
   Use this to store data on the server
   @param baseURL
   @param api
   @param additionalHeaders any additional headers to be used in the request
   @param bodyParameters
   @param completionBlock
   @return a cancellable request
 */
- (MendeleyTask *)invokePATCH:(NSURL *)baseURL
                          api:(NSString *)api
            additionalHeaders:(NSDictionary *)additionalHeaders
               bodyParameters:(NSDictionary *)bodyParameters
       authenticationRequired:(BOOL)authenticationRequired
              completionBlock:(MendeleyResponseCompletionBlock)completionBlock;

/**
   this method will create a PATCH HTTP request.
   Use this to update data on the server
   @param baseURL
   @param api
   @param additionalHeaders any additional headers to be used in the request
   @param jsonData
   @param completionBlock
   @return a cancellable request
 */
- (MendeleyTask *)invokePATCH:(NSURL *)baseURL
                          api:(NSString *)api
            additionalHeaders:(NSDictionary *)additionalHeaders
                     jsonData:(NSData *)jsonData
       authenticationRequired:(BOOL)authenticationRequired
              completionBlock:(MendeleyResponseCompletionBlock)completionBlock;

/**
   this method will create a HEAD request.
   @param baseURL
   @param api
   @param completionBlock
 */
- (MendeleyTask *)invokeHEAD:(NSURL *)baseURL
                         api:(NSString *)api
      authenticationRequired:(BOOL)authenticationRequired
             completionBlock:(MendeleyResponseCompletionBlock)completionBlock;

/**
   cancels a specific MendeleyTask
   @param task
   @param completionBlock
 */
- (void) cancelTask:(MendeleyTask *)task
    completionBlock:(MendeleyCompletionBlock)completionBlock;

/**
   cancels ALL existing tasks
   @param completionBlock
 */
- (void)cancelAllTasks:(MendeleyCompletionBlock)completionBlock;


@end
