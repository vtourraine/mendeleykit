//
//  MendeleyUserPostsAPI.swift
//  MendeleyKit
//
//  Created by Tunney, Aaron (ELS) on 23/02/2018.
//  Copyright © 2018 Mendeley. All rights reserved.
//

import UIKit

@objc public class MendeleyUserPostsAPI: MendeleySwiftObjectAPI {
    let newUserPostServiceHeaders = [kMendeleyRESTRequestContentType: kMendeleyRESTRequestJSONNewUserPostType,
                                     kMendeleyRESTRequestAccept: kMendeleyRESTRequestJSONUserPostType]
    let groupUserPostServiceHeaders = [kMendeleyRESTRequestContentType: kMendeleyRESTRequestJSONNewGroupPostType,
                                       kMendeleyRESTRequestAccept: kMendeleyRESTRequestJSONGroupPostType]
    
    @objc public func create(userPost newPost: MendeleyNewUserPost,
                task: MendeleyTask?,
                completionBlock: @escaping MendeleyObjectCompletionBlock) {
        helper.create(mendeleyObject: newPost,
                      api: kMendeleyRESTAPICreateUserPost,
                      additionalHeaders: newUserPostServiceHeaders,
                      expectedType: MendeleyUserPost.self,
                      task: task,
                      completionBlock: completionBlock)
    }
    
    @objc public func deleteUserPost(withPostID postID: String,
                        task: MendeleyTask?,
                        completionBlock: @escaping MendeleyCompletionBlock) {
        helper.deleteMendeleyObject(withAPI: String(format: kMendeleyRESTAPIDeleteUserPost, postID),
                                    task: task,
                                    completionBlock: completionBlock)
    }
    
    @objc public func create(groupPost: MendeleyNewGroupPost,
                task: MendeleyTask?,
                completionBlock: @escaping MendeleyObjectCompletionBlock) {
        helper.create(mendeleyObject: groupPost,
                      api: kMendeleyRESTAPICreateGroupPost,
                      additionalHeaders: groupUserPostServiceHeaders,
                      expectedType: MendeleyGroupPost.self,
                      task: task,
                      completionBlock: completionBlock)
    }
    
    @objc public func deleteGroupPost(withPostID postID: String,
                         task: MendeleyTask?,
                         completionBlock: @escaping MendeleyCompletionBlock) {
        helper.deleteMendeleyObject(withAPI: String(format: kMendeleyRESTAPIDeleteGroupPost, postID),
                                    task: task,
                                    completionBlock: completionBlock)
    }
}
