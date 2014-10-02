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

@interface MendeleyProfilesAPI : MendeleyObjectAPI
/**
   @name MendeleyProfilesAPI
   This class provides access methods to the REST profiles API
   All of the methods are accessed via MendeleyKit.
   Developers should use the methods provided in MendeleyKit rather
   than the methods listed here.
 */
/**
   Pulls the users profile
   @param completionBlock
 */
- (void)pullMyProfile:(MendeleyObjectCompletionBlock)completionBlock;

/**
   Pulls the profile of a user with a given ID
   @param profileID
   @param completionBlock
 */
- (void)pullProfile:(NSString *)profileID
    completionBlock:(MendeleyObjectCompletionBlock)completionBlock;

@end
