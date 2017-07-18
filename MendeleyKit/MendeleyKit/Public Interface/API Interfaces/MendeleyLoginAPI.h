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

#import "MendeleyObjectAPI.h"

@class MendeleyProfilePrivacySettingsWrapper;

@interface MendeleyLoginAPI : MendeleyObjectAPI

/**
 Checks if ID Plus profile is completed and verified. IDPlus flow will depend on the result of this call
 @param idTokem - the ID Plus id token
 @param task
 @param completionBlock - the completionHandler.
 */
- (void)checkIDPlusProfileWithIdPlusToken:(NSString *)idToken
                                     task:(MendeleyTask *)task
                          completionBlock:(MendeleyObjectAndStateCompletionBlock)completionBlock;

/**
 Updates user's privacy settings.
 @param settings - privacy settings
 @param task
 @param completionBlock - the completion handler
 */
- (void)updateCurrentProfilePrivacySettings:(MendeleyProfilePrivacySettingsWrapper *)settings
                                       task:(MendeleyTask *)task
                            completionBlock:(MendeleyObjectCompletionBlock)completionBlock;

@end