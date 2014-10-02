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
#import "MendeleyNetworkProvider.h"

@protocol MendeleyKitHelperDelegate <NSObject>

@required
- (id <MendeleyNetworkProvider> )networkProvider;
- (NSURL *)baseAPIURL;

@end

@class MendeleyQueryRequestParameters;
@class MendeleyKitHelperDelegate;

@interface MendeleyKitHelper : NSObject

- (instancetype)initWithDelegate:(id <MendeleyKitHelperDelegate> )delegate;

- (BOOL)isSuccessForResponse:(MendeleyResponse *)response
                       error:(NSError **)error;

- (void)mendeleyObjectListOfType:(NSString *)objectTypeString
                             api:(NSString *)apiString
                      parameters:(NSDictionary *)queryParameters
               additionalHeaders:(NSDictionary *)additionalHeaders
                 completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

- (void)mendeleyIDStringListForAPI:(NSString *)apiString
                        parameters:(NSDictionary *)queryParameters
                 additionalHeaders:(NSDictionary *)additionalHeaders
                   completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

- (void)mendeleyObjectOfType:(NSString *)objectTypeString
                  parameters:(NSDictionary *)queryParameters
                         api:(NSString *)apiString
           additionalHeaders:(NSDictionary *)additionalHeaders
             completionBlock:(MendeleyObjectCompletionBlock)completionBlock;

- (void)createMendeleyObject:(MendeleyObject *)mendeleyObject
                         api:(NSString *)apiString
             completionBlock:(MendeleyCompletionBlock)completionBlock;

- (void)createMendeleyObject:(MendeleyObject *)mendeleyObject
                         api:(NSString *)apiString
           additionalHeaders:(NSDictionary *)additionalHeaders
                expectedType:(NSString *)objectTypeString
             completionBlock:(MendeleyObjectCompletionBlock)completionBlock;

- (void)updateMendeleyObject:(MendeleyObject *)updatedMendeleyObject
                         api:(NSString *)apiString
             completionBlock:(MendeleyCompletionBlock)completionBlock;

- (void)updateMendeleyObject:(MendeleyObject *)updatedMendeleyObject
                         api:(NSString *)apiString
           additionalHeaders:(NSDictionary *)additionalHeaders
             completionBlock:(MendeleyCompletionBlock)completionBlock;


- (void)updateMendeleyObject:(MendeleyObject *)updatedMendeleyObject
                         api:(NSString *)apiString
           additionalHeaders:(NSDictionary *)additionalHeaders
                expectedType:(NSString *)objectTypeString
             completionBlock:(MendeleyObjectCompletionBlock)completionBlock;

- (void)deleteMendeleyObjectWithAPI:(NSString *)apiString
                    completionBlock:(MendeleyCompletionBlock)completionBlock;

- (MendeleyTask *)downloadFileWithAPI:(NSString *)apiString
                            saveToURL:(NSURL *)fileURL
                        progressBlock:(MendeleyResponseProgressBlock)progressBlock
                      completionBlock:(MendeleyCompletionBlock)completionBlock;

@end
