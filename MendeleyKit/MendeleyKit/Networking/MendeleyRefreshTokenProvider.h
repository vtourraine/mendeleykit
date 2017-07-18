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

@protocol MendeleyRefreshTokenProvider <NSObject>

/**
 used when refreshing the access token. The completion block returns the OAuth credentials - or nil
 if unsuccessful. When nil, an error object will be provided.
 Threading note: refresh maybe handled on main as well as background thread.
 @param credentials the current credentials (to be updated with the refresh)
 @param completionBlock
 */
- (void)refreshTokenWithOAuthCredentials:(nonnull MendeleyOAuthCredentials *)credentials
                         completionBlock:(nullable MendeleyOAuthCompletionBlock)completionBlock;

/**
 used when refreshing the access token. The completion block returns the OAuth credentials - or nil
 if unsuccessful. When nil, an error object will be provided.
 Threading note: refresh maybe handled on main as well as background thread.
 @param credentials the current credentials (to be updated with the refresh)
 @param task the task corresponding to the current operation
 @param completionBlock
 */
- (void)refreshTokenWithOAuthCredentials:(nonnull MendeleyOAuthCredentials *)credentials
                                    task:(nullable MendeleyTask *)task
                         completionBlock:(nullable MendeleyOAuthCompletionBlock)completionBlock;

@end
