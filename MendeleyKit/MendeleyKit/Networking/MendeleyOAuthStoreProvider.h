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

@import Foundation;
#import "MendeleyOAuthCredentials.h"

@protocol MendeleyOAuthStoreProvider <NSObject>

/**
 @name MendeleyOAuthStoreProvider interface for managing OAuth credentials in the keychain
 */

/**
 @param credentials to be stored in keychain
 @return YES if successful
 */
- (BOOL)storeOAuthCredentials:(nullable MendeleyOAuthCredentials *)credentials;

/**
 @return YES if removal of oauthdata from Keychain was successful
 */
- (BOOL)removeOAuthCredentials;

/**
 @return oauthData from keychain or nil if unsuccessful
 */
- (nullable MendeleyOAuthCredentials *)retrieveOAuthCredentials;

@end
