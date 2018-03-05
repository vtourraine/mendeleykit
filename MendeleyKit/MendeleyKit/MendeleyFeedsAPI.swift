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

import Foundation

@objc public class MendeleyFeedsAPI: MendeleySwiftObjectAPI {
    
    private let defaultServiceRequestHeaders = [kMendeleyRESTRequestAccept: kMendeleyRESTRequestJSONNewsItemListType]
    private let singleFeedServiceRequestHeaders = [kMendeleyRESTRequestAccept: kMendeleyRESTRequestJSONNewsItemType]
    private let sharersServiceRequestHeaders = [kMendeleyRESTRequestAccept: kMendeleyRESTRequestJSONNewsItemSharerListType]
    private let likersServiceRequestHeaders = [kMendeleyRESTRequestAccept: kMendeleyRESTRequestJSONNewsItemLikerListType]
    
    /**
     This method is only used when paging through a list of documents on the server.
     All required parameters are provided in the linkURL, which should not be modified
     @param linkURL the full HTTP link to the document listings page
     @param task
     @param completionBlock
     */
    @objc public func feedList(withLinkedURL linkURL: URL, task: MendeleyTask?, completionBlock: @escaping MendeleyArrayCompletionBlock) {
        helper?.mendeleyObjectList(ofType: MendeleyNewsFeed.self,
                                   api: linkURL.absoluteString,
                                   queryParameters: nil,
                                   additionalHeaders: defaultServiceRequestHeaders,
                                   task: task,
                                   completionBlock: completionBlock)
    }
    
    /**
     obtains a list of feeds for the first page.
     @param parameters the parameter set to be used in the request
     @param task
     @param completionBlock
     */
    @objc public func feedList(withQueryParameters parameters: MendeleyFeedsParameters, task: MendeleyTask, completionBlock: @escaping MendeleyArrayCompletionBlock) {
        helper?.mendeleyObjectList(ofType: MendeleyNewsFeed.self,
                                   api: kMendeleyRESTAPIFeeds,
                                   queryParameters: parameters.valueStringDictionary(),
                                   additionalHeaders: defaultServiceRequestHeaders,
                                   task: task,
                                   completionBlock: completionBlock)
    }
    
    /**
     obtains feed with a given identifier
     @param feedID
     @param task
     @param completionBlock
     */
    @objc public func feed(withId feedId: String, task: MendeleyTask, completionBlock: @escaping MendeleyObjectCompletionBlock) {
        helper?.mendeleyObject(ofType: MendeleyNewsFeed.self,
                               queryParameters: nil,
                               api: kMendeleyRESTAPIFeeds + "/" + feedId,
                               additionalHeaders: singleFeedServiceRequestHeaders,
                               task: task,
                               completionBlock: completionBlock)
        
    }
    
    /**
     likes a feed item.
     @param feedID
     @param task
     @param completionBlock
     */
    @objc public func likeFeed(withID feedID: String, task: MendeleyTask, completionBlock: @escaping MendeleyCompletionBlock) {
        helper?.create(withAPI: String(format: kMendeleyRESTAPILikeFeed, feedID),
                       task: task,
                       completionBlock: completionBlock
        )
    }
    
    /**
     likes a feed item.
     @param feedID
     @param task
     @param completionBlock
     */
    @objc public func unlikeFeed(withID feedID: String, task: MendeleyTask, completionBlock: @escaping MendeleyCompletionBlock) {
        helper?.deleteMendeleyObject(withAPI: String(format: kMendeleyRESTAPILikeFeed, feedID),
                                     task: task,
                                     completionBlock: completionBlock
        )
    }
    
    /**
     List of users that like given item.
     @param feedID
     @param task
     @param completionBlock
     */
    
    @objc public func likersForFeed(withID feedID: String, task: MendeleyTask, completionBlock: @escaping MendeleyArrayCompletionBlock) {
        helper?.mendeleyObjectList(ofType: MendeleySocialProfile.self,
                                   api: baseAPIURL.appendingPathComponent(kMendeleyRESTAPIFeeds).appendingPathComponent(feedID).absoluteString,
                                   queryParameters: nil,
                                   additionalHeaders: likersServiceRequestHeaders,
                                   task: task,
                                   completionBlock: completionBlock)
    }
    
    /**
     List of users that have shared given item.
     @param feedID
     @param task
     @param completionBlock
     */
    
    @objc public func sharersForFeed(withID feedID: String, task: MendeleyTask, completionBlock: @escaping MendeleyArrayCompletionBlock) {
        helper?.mendeleyObjectList(ofType: MendeleySocialProfile.self,
                                   api: baseAPIURL.appendingPathComponent(kMendeleyRESTAPISharersFeed).appendingPathComponent(feedID).absoluteString,
                                   queryParameters: nil,
                                   additionalHeaders: sharersServiceRequestHeaders,
                                   task: task,
                                   completionBlock: completionBlock)
    }
}
