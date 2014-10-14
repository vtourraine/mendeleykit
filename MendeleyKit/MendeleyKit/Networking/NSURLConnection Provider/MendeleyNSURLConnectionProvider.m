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
    }
    return self;
}

- (void)cancelAllTasks:(MendeleyCompletionBlock)completionBlock
{
}

- (void) cancelTask:(MendeleyTask *)mendeleyTask
    completionBlock:(MendeleyCompletionBlock)completionBlock
{
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
    
    return nil;
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
    
    
    return nil;
    
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
    
    return nil;
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
    
    return nil;
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
    
    return nil;
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
    
    return nil;
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
    
    return nil;
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
    
    return nil;
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
    
    return nil;
}

- (MendeleyTask *)invokeHEAD:(NSURL *)baseURL api:(NSString *)api authenticationRequired:(BOOL)authenticationRequired completionBlock:(MendeleyResponseCompletionBlock)completionBlock
{
    [NSError assertArgumentNotNil:baseURL argumentName:@"baseURL"];
    [NSError assertArgumentNotNil:completionBlock argumentName:@"completionBlock"];
    
    return nil;
}

@end
