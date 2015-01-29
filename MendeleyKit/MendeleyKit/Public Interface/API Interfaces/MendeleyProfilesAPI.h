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
   @param task
   @param completionBlock
 */
- (void)pullMyProfileWithTask:(MendeleyTask *)task
              completionBlock:(MendeleyObjectCompletionBlock)completionBlock;

/**
   Pulls the profile of a user with a given ID
   @param profileID
   @param task
   @param completionBlock
 */
- (void)pullProfile:(NSString *)profileID
               task:(MendeleyTask *)task
    completionBlock:(MendeleyObjectCompletionBlock)completionBlock;

/**
   Creates a new profile
   Six mandatory fields must be provided to create a new profile successfully:
   first_name, last_name, email, password, main discipline and academic status.
   The email must be unique
   @param profile - the new profile to be created
   @param task - the cancellable MendeleyTask
   @param completionBlock - returns the created object from the server (does it?)
   @return a MendeleyTask object used for cancelling the operation
 */

- (void)createProfile:(MendeleyProfile *)profile
                 task:(MendeleyTask *)task
      completionBlock:(MendeleyObjectCompletionBlock)completionBlock;

/**
   This updates the user's existing profile
   @param myProfile - the user's profile with updated entries
   @param task - the cancellable MendeleyTask
   @param completionBlock - the completion handler
   @return a MendeleyTask object used for cancelling the operation
 */
- (void)updateMyProfile:(MendeleyProfile *)myProfile
                   task:(MendeleyTask *)task
        completionBlock:(MendeleyObjectCompletionBlock)completionBlock;

@end
