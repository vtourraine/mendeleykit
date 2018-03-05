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

import UIKit

@objc public class MendeleyCommentsAPI: MendeleySwiftObjectAPI {
    
    private let defaultCommentRequestHeaders = [kMendeleyRESTRequestAccept: kMendeleyRESTRequestJSONCommentType]
    private let expandedCommentsListRequestHeaders = [kMendeleyRESTRequestAccept: kMendeleyRESTRequestJSONExpandedCommentsType]
    private let postCommentRequestHeaders = [kMendeleyRESTRequestAccept: kMendeleyRESTRequestJSONCommentType,
                                             kMendeleyRESTRequestContentType: kMendeleyRESTRequestJSONCommentType]
    private let updateCommentRequestHeaders = [kMendeleyRESTRequestAccept: kMendeleyRESTRequestJSONCommentUpdateType,
                                               kMendeleyRESTRequestContentType: kMendeleyRESTRequestJSONCommentUpdateType]
    
    /**
     Get expanded (i.e. with profile information) comments.
     @param newsItemID
     @param task
     @param completionBlock
     */
    @objc public func expandedComments(withNewsItemID newsItemID: String, task: MendeleyTask?, completionBlock: @escaping MendeleyArrayCompletionBlock) {
        let queryParameters = MendeleyExpandedCommentsParameters()
        queryParameters.news_item_id = newsItemID
        
        helper?.mendeleyObjectList(ofType: MendeleyExpandedComment.self,
                                   api: kMendeleyRESTAPIComments,
                                   queryParameters:queryParameters.valueStringDictionary(),
                                   additionalHeaders:expandedCommentsListRequestHeaders,
                                   task:task,
                                   completionBlock:completionBlock)
    }
    
    /**
     Get single comment.
     @param commentID
     @param task
     @param completionBlock
     */
    @objc public func comment(withCommentID commentID: String, task: MendeleyTask?, completionBlock: @escaping MendeleyObjectCompletionBlock) {
        helper.mendeleyObject(ofType: MendeleyComment.self,
                              queryParameters: nil,
                              api: String(format: kMendeleyRESTAPICommentsWithCommentID, commentID),
                              additionalHeaders:defaultCommentRequestHeaders,
                              task: task,
                              completionBlock: completionBlock)
    }
    
    /**
     Create new comment.
     @param comment
     @param task
     @param completionBlock
     */
    @objc (createComment:task:completionBlock:)
    public func create(comment: MendeleyComment, task: MendeleyTask?, completionBlock: @escaping MendeleyObjectCompletionBlock) {
        helper.create(mendeleyObject: comment,
                      api: kMendeleyRESTAPIComments,
                      additionalHeaders: postCommentRequestHeaders,
                      expectedType: MendeleyComment.self,
                      task: task, completionBlock: completionBlock)
    }
    
    /**
     Edit existing comment.
     @param commentID
     @param update
     @param task
     @param completionBlock
     */
    @objc public func updateComment(withCommentID commentID: String, update: MendeleyCommentUpdate, task: MendeleyTask?, completionBlock: @escaping MendeleyObjectCompletionBlock) {
        helper.update(mendeleyObject: update,
                      api: String(format: kMendeleyRESTAPICommentsWithCommentID, commentID),
                      additionalHeaders: updateCommentRequestHeaders,
                      expectedType: MendeleyComment.self,
                      task: task,
                      completionBlock: completionBlock)
    }
    
    /**
     Delete comment.
     @param commentID
     @param task
     @param completionBlock
     */
    @objc public func deleteComment(withCommentID commentID: String, task: MendeleyTask?, completionBlock: @escaping MendeleyCompletionBlock) {
        helper.deleteMendeleyObject(withAPI: String(format: kMendeleyRESTAPICommentsWithCommentID, commentID),
                                    task: task,
                                    completionBlock: completionBlock)
    }
}
