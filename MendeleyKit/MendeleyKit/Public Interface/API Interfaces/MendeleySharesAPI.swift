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

@objc public class MendeleySharesAPI: MendeleySwiftObjectAPI {
    private let defaultServiceRequestHeaders = [kMendeleyRESTRequestContentType: kMendeleyRESTRequestJSONNewsItemsShareType]
    private let shareDocumentServiceRequestHeaders = [kMendeleyRESTRequestContentType: kMendeleyRESTRequestJSONDocumentShareType]
    
    /**
     shares a feed item.
     @param queryParameters
     @param task
     @param completionBlock
     */
    @objc public func shareFeed(withQueryParameters queryParameters: MendeleySharesParameters,
                   task: MendeleyTask?,
                   completionBlock: @escaping MendeleyCompletionBlock) {
        
        networkProvider.invokePOST(baseAPIURL,
                                   api: kMendeleyRESTAPIShareFeed,
                                   additionalHeaders: defaultServiceRequestHeaders,
                                   bodyParameters: queryParameters.valueStringDictionary(),
                                   isJSON: true,
                                   authenticationRequired: true,
                                   task: task) { (response, error) in
                                    let blockExec = MendeleyBlockExecutor(completionBlock: completionBlock)
                                    let (isSuccess, combinedError) = self.helper.isSuccess(forResponse: response, error: error)
                                    
                                    blockExec?.execute(with: isSuccess, error: combinedError)
        }
    }
    
    /**
     Shares a document.
     @param documentID
     @param task
     @param completionBlock
     */
    @objc public func shareDocument(withDocumentID documentID: String,
                                    task: MendeleyTask?,
                                    completionBlock: @escaping MendeleyCompletionBlock) {
        let parameters = MendeleyShareDocumentParameters()
        parameters.document_id = documentID
        
        shareDocument(withQueryParameters: parameters, task: task, completionBlock: completionBlock)
    }
    
    /**
     Shares a document.
     @param doi
     @param task
     @param completionBlock
     */
    @objc public func shareDocument(withDOI doi: String,
                                    task: MendeleyTask?,
                                    completionBlock: @escaping MendeleyCompletionBlock) {
        let parameters = MendeleyShareDocumentParameters()
        parameters.doi = doi
        
        shareDocument(withQueryParameters: parameters, task: task, completionBlock: completionBlock)
    }
    
    /**
     Shares a document.
     @param scopus
     @param task
     @param completionBlock
     */
    @objc public func shareDocument(withScopus scopus: String,
                                    task: MendeleyTask?,
                                    completionBlock: @escaping MendeleyCompletionBlock) {
        let parameters = MendeleyShareDocumentParameters()
        parameters.scopus = scopus
        
        shareDocument(withQueryParameters: parameters, task: task, completionBlock: completionBlock)
    }
    
    
    private func shareDocument(withQueryParameters queryParameters: MendeleyShareDocumentParameters,
                               task: MendeleyTask?,
                               completionBlock: @escaping MendeleyCompletionBlock) {
        networkProvider.invokePOST(baseAPIURL,
                                   api: kMendeleyRESTAPIShareFeed,
                                   additionalHeaders: shareDocumentServiceRequestHeaders,
                                   bodyParameters: queryParameters.valueStringDictionary(),
                                   isJSON: true,
                                   authenticationRequired: true,
                                   task: task) { (response, error) in
                                    let blockExec = MendeleyBlockExecutor(completionBlock: completionBlock)
                                    let (isSuccess, combinedError) = self.helper.isSuccess(forResponse: response, error: error)
                                    
                                    blockExec?.execute(with: isSuccess, error: combinedError)
        }
    }
}
