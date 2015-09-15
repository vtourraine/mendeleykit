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

#ifndef MendeleyKitiOSFramework
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MendeleyGlobals.h"

@interface MendeleyLoginHandleriOS7 : NSObject <UIWebViewDelegate>
- (void)startLoginProcessWithClientID:(NSString *)clientID
                          redirectURI:(NSString *)redirectURI
                           controller:(UIViewController *)controller
                      completionBlock:(MendeleyCompletionBlock)completionBlock
                 oauthCompletionBlock:(MendeleyOAuthCompletionBlock)oauthCompletionBlock;

@end
#endif
