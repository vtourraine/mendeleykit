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

@class MendeleyFollowersParameters;

@interface MendeleyFollowersAPI : MendeleyObjectAPI
/**
   @name MendeleyFollowersAPI
   This class provides access methods to the REST followers API
   All of the methods are accessed via MendeleyKit.
   Developers should use the methods provided in MendeleyKit rather
   than the methods listed here.
 */


/**
   Obtain a list of followers for a given user.
   @param profileID
   @param parameters
   @param task
   @param completionBlock - the array contained in the completionBlock will be an array of MendeleyFollow objects
 */
- (void)followersForUserWithID:(NSString *)profileID
                    parameters:(MendeleyFollowersParameters *)parameters
                          task:(MendeleyTask *)task
               completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

/**
   Obtain a list of users followed by a given user.
   @param profileID
   @param parameters
   @param task
   @param completionBlock - the array contained in the completionBlock will be an array of MendeleyFollow objects
 */
- (void)followedByUserWithID:(NSString *)profileID
                  parameters:(MendeleyFollowersParameters *)parameters
                        task:(MendeleyTask *)task
             completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

/**
   Obtain a list of pending followers for a given user.
   @param profileID
   @param parameters
   @param task
   @param completionBlock - the array contained in the completionBlock will be an array of MendeleyFollow objects
 */
- (void)pendingFollowersForUserWithID:(NSString *)profileID
                           parameters:(MendeleyFollowersParameters *)parameters
                                 task:(MendeleyTask *)task
                      completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

/**
   Obtain a list of pending users followed by a given user.
   @param profileID
   @param parameters
   @param task
   @param completionBlock - the array contained in the completionBlock will be an array of MendeleyFollow objects
 */
- (void)pendingFollowedByUserWithID:(NSString *)profileID
                         parameters:(MendeleyFollowersParameters *)parameters
                               task:(MendeleyTask *)task
                    completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

/**
   Start following another user.
   @param followedID
   @param task
   @param completionBlock - the object contained in the completionBlock will be a MendeleyFollow object
 */
- (void)followUserWithID:(NSString *)followedID
                    task:(MendeleyTask *)task
         completionBlock:(MendeleyObjectCompletionBlock)completionBlock;


/**
   Accept a pending follow request
   @param requestID
   @param task
   @param completionBlock
 
 */
- (void)acceptFollowRequestWithID:(NSString *)requestID
                             task:(MendeleyTask *)task
                  completionBlock:(MendeleyCompletionBlock)completionBlock;

/**
   Stop following a profile, cancel a follow request or reject a follow request
   @param relationshipID
   @param task
   @param completionBlock
 */
- (void)stopOrDenyRelationshipWithID:(NSString *)relationshipID
                          task:(MendeleyTask *)task
               completionBlock:(MendeleyCompletionBlock)completionBlock;

/**
    Check whether a given user is following another one.
    @param followerID
    @param followedID
    @param task
    @param completionBlock
 */
- (void)profileWithID:(NSString *)followerID
   isFollowingProfile:(NSString *)followedID
                 task:(MendeleyTask *)task
      completionBlock:(MendeleyCompletionBlock)completionBlock;

@end
