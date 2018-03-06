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

@objc open class MendeleyFollowersAPI: MendeleyObjectAPI {
    /**
     @name MendeleyFollowersAPI
     This class provides access methods to the REST followers API
     All of the methods are accessed via MendeleyKit.
     Developers should use the methods provided in MendeleyKit rather
     than the methods listed here.
     */
    
    private var defaultQueryParamters: [String: String] {
        return MendeleyFollowersParameters().valueStringDictionary()
    }
    
    private let followRequestUploadHeaders = [kMendeleyRESTRequestAccept: kMendeleyRESTRequestJSONFollowType,
            kMendeleyRESTRequestContentType: kMendeleyRESTRequestJSONFollowRequestType]
    
    private let followAcceptanceUploadHeaders = [kMendeleyRESTRequestAccept: kMendeleyRESTRequestJSONFollowType,
            kMendeleyRESTRequestContentType: kMendeleyRESTRequestJSONFollowAcceptancesRequestType]

    private let defaultServiceRequestHeaders = [kMendeleyRESTRequestContentType: kMendeleyRESTRequestJSONFollowType]
    
    /**
     Obtain a list of followers for a given user.
     @param profileID
     @param parameters
     @param task
     @param completionBlock - the array contained in the completionBlock will be an array of MendeleyFollow objects
     */
    @objc (followersForUserWithID:parameters:task:completionBlock:)
    public func followers(forUserWithID profileID: String,
                                queryParameters: MendeleyFollowersParameters?,
                                task: MendeleyTask?,
                                completionBlock: @escaping MendeleyArrayCompletionBlock) {
        let parameters = queryParameters != nil ? queryParameters! : MendeleyFollowersParameters()
        
        parameters.status = kMendeleyRESTAPIQueryFollowersTypeFollowing
        parameters.followed = profileID
        
        let query = parameters.valueStringDictionary()
        
        helper.mendeleyObjectList(ofType: MendeleyFollow.self,
                                  api: kMendeleyRESTAPIFollowers,
                                  queryParameters: query,
                                  additionalHeaders: defaultServiceRequestHeaders,
                                  task: task,
                                  completionBlock: completionBlock)
    }
    
    /**
     Obtain a list of users followed by a given user.
     @param profileID
     @param parameters
     @param task
     @param completionBlock - the array contained in the completionBlock will be an array of MendeleyFollow objects
     */
    @objc (followedByUserWithID:parameters:task:completionBlock:)
    public func followedBy(userWithID profileID: String,
                                 queryParameters: MendeleyFollowersParameters?,
                                 task: MendeleyTask?,
                                 completionBlock: @escaping MendeleyArrayCompletionBlock) {
        let parameters = queryParameters != nil ? queryParameters! : MendeleyFollowersParameters()
        
        parameters.status = kMendeleyRESTAPIQueryFollowersTypeFollowing
        parameters.follower = profileID
        
        let query = parameters.valueStringDictionary()
        
        helper.mendeleyObjectList(ofType: MendeleyFollow.self,
                                  api: kMendeleyRESTAPIFollowers,
                                  queryParameters: query,
                                  additionalHeaders: defaultServiceRequestHeaders,
                                  task: task,
                                  completionBlock: completionBlock)
    }
    
    /**
     Obtain a list of pending followers for a given user.
     @param profileID
     @param parameters
     @param task
     @param completionBlock - the array contained in the completionBlock will be an array of MendeleyFollow objects
     */
    @objc (pendingFollowersForUserWithID:parameters:task:completionBlock:)
    public func pendingFollowers(forUserWithID profileID: String,
                                       queryParameters: MendeleyFollowersParameters?,
                                       task: MendeleyTask?,
                                       completionBlock: @escaping MendeleyArrayCompletionBlock) {
        let parameters = queryParameters != nil ? queryParameters! : MendeleyFollowersParameters()
        
        parameters.status = kMendeleyRESTAPIQueryFollowersTypePending
        parameters.follower = profileID
        
        let query = parameters.valueStringDictionary()
        
        helper.mendeleyObjectList(ofType: MendeleyFollow.self,
                                  api: kMendeleyRESTAPIFollowers,
                                  queryParameters: query,
                                  additionalHeaders: defaultServiceRequestHeaders,
                                  task: task,
                                  completionBlock: completionBlock)
    }
    
    /**
     Obtain a list of pending users followed by a given user.
     @param profileID
     @param parameters
     @param task
     @param completionBlock - the array contained in the completionBlock will be an array of MendeleyFollow objects
     */
    @objc (pendingFollowedByUserWithID:parameters:task:completionBlock:)
    public func pendingFollowedBy(userWithID profileID: String,
                                        queryParameters: MendeleyFollowersParameters?,
                                        task: MendeleyTask?,
                                        completionBlock: @escaping MendeleyArrayCompletionBlock) {
        let parameters = queryParameters != nil ? queryParameters! : MendeleyFollowersParameters()
        
        parameters.status = kMendeleyRESTAPIQueryFollowersTypePending
        parameters.followed = profileID
        
        let query = parameters.valueStringDictionary()
        
        helper.mendeleyObjectList(ofType: MendeleyFollow.self,
                                  api: kMendeleyRESTAPIFollowers,
                                  queryParameters: query,
                                  additionalHeaders: defaultServiceRequestHeaders,
                                  task: task,
                                  completionBlock: completionBlock)
    }
    
    /**
     Start following another user.
     @param followedID
     @param task
     @param completionBlock - the object contained in the completionBlock will be a MendeleyFollow object
     */
    @objc public func followUser(withID followedID: String,
                                 task: MendeleyTask?,
                                 completionBlock: @escaping MendeleyObjectCompletionBlock) {
        let followRequest = MendeleyFollowRequest()
        followRequest.followed = followedID

        helper.create(mendeleyObject: followRequest,
                      api: kMendeleyRESTAPIFollowers,
                      additionalHeaders: followRequestUploadHeaders,
                      expectedType: MendeleyFollow.self,
                      task: task,
                      completionBlock: completionBlock)
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
        let apiEndPoint = String(format: kMendeleyRESTAPIFollowersWithID, requestID)
        let followAcceptance = MendeleyFollowAcceptance()
        
        helper.update(mendeleyObject: followAcceptance,
                      api: apiEndPoint,
                      additionalHeaders: followAcceptanceUploadHeaders,
                      task: task,
                      completionBlock: completionBlock)
    }
    
    /**
     Stop following a profile, cancel a follow request or reject a follow request
     @param relationshipID
     @param task
     @param completionBlock
     */
    @objc (stopOrDenyRelationshipWithID:task:completionBlock:)
    public func stopOrDeny(relationshipWithID relationshipID: String,
                                 task: MendeleyTask?,
                                 completionBlock: @escaping MendeleyCompletionBlock) {
        let apiEndPoint = String(format: kMendeleyRESTAPIFollowersWithID, relationshipID)
        
        helper.deleteMendeleyObject(withAPI: apiEndPoint,
                                    task: task,
                                    completionBlock: completionBlock)
    }
    
    /**
     Returns a follow relationship between two profiles if it exists.
     @param followerID
     @param followedID
     @param task
     @param completionBlock
     */
    @objc (followRelationshipBetweenFollower:followed:task:completionBlock:)
    public func followRelationship(betweenFollower followerID: String,
                                         followed followedID: String,
                                         task: MendeleyTask?,
                                         completionBlock: @escaping MendeleyObjectCompletionBlock) {
        let queryParameters = MendeleyFollowersParameters()
        queryParameters.status = kMendeleyRESTAPIQueryFollowersTypeFollowing
        queryParameters.follower = followerID
        queryParameters.followed = followedID
        let query = queryParameters.valueStringDictionary()

        helper.mendeleyObjectList(ofType: MendeleyFollow.self,
                                  api: kMendeleyRESTAPIFollowers,
                                  queryParameters: query,
                                  additionalHeaders: defaultServiceRequestHeaders,
                                  task: task) { (array, syncInfo, error ) in
                                    if let mendeleyObject = array?.first as? MendeleyObject {
                                        completionBlock(mendeleyObject, syncInfo, nil)
                                    } else {
                                        completionBlock(nil, nil, error)
                                    }
        }
    }
}
