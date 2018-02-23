//
//  MendeleyUserPostsAPI.swift
//  MendeleyKit
//
//  Created by Tunney, Aaron (ELS) on 23/02/2018.
//  Copyright © 2018 Mendeley. All rights reserved.
//

import UIKit

class MendeleyUserPostsAPI: MendeleySwiftObjectAPI {
    let newUserPostServiceHeaders = [kMendeleyRESTRequestContentType: kMendeleyRESTRequestJSONNewUserPostType,
                                     kMendeleyRESTRequestAccept: kMendeleyRESTRequestJSONUserPostType]
    let groupUserPostServiceHeaders = [kMendeleyRESTRequestContentType: kMendeleyRESTRequestJSONNewGroupPostType,
                                       kMendeleyRESTRequestAccept: kMendeleyRESTRequestJSONGroupPostType]
    
    func create(userPost newPost: MendeleyNewUserPost,
                task: MendeleyTask?,
                completionBlock: @escaping MendeleySwiftObjectCompletionBlock) {
        helper.create(mendeleyObject: newPost,
                      api: kMendeleyRESTAPICreateUserPost,
                      additionalHeaders: newUserPostServiceHeaders,
                      expectedType: MendeleyUserPost.self,
                      task: task,
                      completionBlock: completionBlock)
    }
    
    func deleteUserPost(withPostID postID: String,
                        task: MendeleyTask?,
                        completionBlock: @escaping MendeleyCompletionBlock) {
        helper.deleteMendeleyObject(withAPI: String(format: kMendeleyRESTAPIDeleteUserPost, postID),
                                    task: task,
                                    completionBlock: completionBlock)
    }
    
    func create(groupPost: MendeleyNewGroupPost,
                task: MendeleyTask?,
                completionBlock: @escaping MendeleySwiftObjectCompletionBlock) {
        helper.create(mendeleyObject: groupPost,
                      api: kMendeleyRESTAPICreateGroupPost,
                      additionalHeaders: groupUserPostServiceHeaders,
                      expectedType: MendeleyGroupPost.self,
                      task: task,
                      completionBlock: completionBlock)
    }
    
    func deleteGroupPost(withPostID postID: String,
                         task: MendeleyTask?,
                         completionBlock: @escaping MendeleyCompletionBlock) {
        helper.deleteMendeleyObject(withAPI: String(format: kMendeleyRESTAPIDeleteGroupPost, postID),
                                    task: task,
                                    completionBlock: completionBlock)
    }
}
