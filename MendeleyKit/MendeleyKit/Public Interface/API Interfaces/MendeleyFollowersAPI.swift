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

@objc open class MendeleyFollowersAPI: MendeleySwiftObjectAPI {
    /**
     @name MendeleyFollowersAPI
     This class provides access methods to the REST followers API
     All of the methods are accessed via MendeleyKit.
     Developers should use the methods provided in MendeleyKit rather
     than the methods listed here.
     */
    
    private var defaultQueryParameters: [String: Any] {
        return MendeleyFollowersParameters().valueStringDictionary()
    }
    
    /**
     Obtain a list of followers for a given user.
     @param profileID
     @param parameters
     @param task
     @param completionBlock - the array contained in the completionBlock will be an array of MendeleyFollow objects
     */
    @objc public func followers(forUserWithID profileID: String,
                                queryParameters: MendeleyFollowersParameters,
                                task: MendeleyTask?,
                                completionBlock: @escaping MendeleyArrayCompletionBlock) {
        
    }
    
    /**
     Obtain a list of users followed by a given user.
     @param profileID
     @param parameters
     @param task
     @param completionBlock - the array contained in the completionBlock will be an array of MendeleyFollow objects
     */
    @objc public func followedBy(userWithID profileID: String,
                                 queryParameters: MendeleyFollowersParameters,
                                 task: MendeleyTask?,
                                 completionBlock: @escaping MendeleyArrayCompletionBlock) {
        
    }
    
    /**
     Obtain a list of pending followers for a given user.
     @param profileID
     @param parameters
     @param task
     @param completionBlock - the array contained in the completionBlock will be an array of MendeleyFollow objects
     */
    @objc public func pendingFollowers(forUserWithID profileID: String,
                                       queryParameters: MendeleyFollowersParameters,
                                       task: MendeleyTask?,
                                       completionBlock: @escaping MendeleyArrayCompletionBlock) {
        
    }
    
    /**
     Obtain a list of pending users followed by a given user.
     @param profileID
     @param parameters
     @param task
     @param completionBlock - the array contained in the completionBlock will be an array of MendeleyFollow objects
     */
    @objc public func pendingFollowedBy(userWithID profileID: String,
                                        queryParameters: MendeleyFollowersParameters,
                                        task: MendeleyTask?,
                                        completionBlock: @escaping MendeleyArrayCompletionBlock) {
        
    }
    
    /**
     Start following another user.
     @param followedID
     @param task
     @param completionBlock - the object contained in the completionBlock will be a MendeleyFollow object
     */
    @objc public func followUser(withID followedID: String,
                                 task: MendeleyTask?,
                                 completionBlock: @escaping MendeleySwiftObjectCompletionBlock) {
        
    }
    
    /**
     Accept a pending follow request
     @param requestID
     @param task
     @param completionBlock
     
     */
    @objc public func acceptFollowRequest(withID requestID: String,
                                          task: MendeleyTask?,
                                          completionBlock: @escaping MendeleyCompletionBlock) {
        
    }
    
    /**
     Stop following a profile, cancel a follow request or reject a follow request
     @param relationshipID
     @param task
     @param completionBlock
     */
    @objc public func stopOrDeny(relationshipWithID relationshipID: String,
                                 task: MendeleyTask?,
                                 completionBlock: @escaping MendeleyCompletionBlock) {
        
    }
    
    /**
     Returns a follow relationship between two profiles if it exists.
     @param followerID
     @param followedID
     @param task
     @param completionBlock
     */
    @objc public func followRelationship(betweenFollower followerID: String,
                                         followed followedID: String,
                                         task: MendeleyTask?,
                                         completionBlock: @escaping MendeleySwiftObjectCompletionBlock) {
        
    }
}
