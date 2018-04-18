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

#import <UIKit/UIKit.h>
#import "MendeleyOAuthProvider.h"

@interface MendeleyLoginViewController : UIViewController
/**
   @name MendeleyLoginViewController is a helper class for iOS based clients.
   It provides a UIViewController with a UIWebView for user authentication
 */
/**
   initialises the login view controller with Client App details
   @param completionBlock
 */

- (id)initWithCompletionBlock:(MendeleyCompletionBlock)completionBlock;



/**
   custom initialisers
   The completion block BOOL variable is set to YES if login has been successful
   NO otherwise
   @param completionBlock
 */
- (id)initWithCompletionBlock:(MendeleyCompletionBlock)completionBlock
          customOAuthProvider:(id<MendeleyOAuthProvider>)customOAuthProvider;

@end
