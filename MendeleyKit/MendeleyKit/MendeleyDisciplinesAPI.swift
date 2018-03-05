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

@objc open class MendeleyDisciplinesAPI: MendeleySwiftObjectAPI {
    /**
     This method is deprecated. It returns data from a new endpoint. See method below.
     This method gets all registered Mendeley disciplines (and their subdisciplines)
     @param task the cancellable MendeleyTask
     @param completionBlock will return an array of MendeleyDiscipline objects
     */
    @available(*, deprecated, message: "Use subjectAreas(withTask:completionBlock:) instead")
    @objc public func disciplines(withTask task: MendeleyTask?,
                                  completionBlock: @escaping MendeleyArrayCompletionBlock) {
        MendeleyKitConfiguration.sharedInstance().oauthProvider.authenticateClient { (credentials, error) in
            
            guard let credentials = credentials
                else { completionBlock(nil, nil, error); return }
            
            let requestHeader = self.defaultServiceRequestHeaders(fromCredentials: credentials)
            let blockExec = MendeleyBlockExecutor(arrayCompletionBlock: completionBlock)
            
            self.networkProvider.invokeGET(self.baseAPIURL,
                                           api: kMendeleyRESTAPIDisciplines,
                                           additionalHeaders: requestHeader,
                                           queryParameters: nil,
                                           authenticationRequired: false,
                                           task: task) { (response, error) in
                                            var error = error
                                            if self.helper.isSuccess(forResponse: response, error: &error) == false || response?.rawResponseBody == nil {
                                                blockExec?.execute(with: nil, syncInfo: nil, error: error)
                                            } else {
                                                let decoder = JSONDecoder()
                                                do {
                                                    let arrayDict = try decoder.decode([String: [MendeleyDiscipline]].self, from: response!.rawResponseBody)
                                                    blockExec?.execute(with: arrayDict[kMendeleyJSONData], syncInfo: response?.syncHeader, error: nil)
                                                } catch {
                                                    blockExec?.execute(with: nil, syncInfo: nil, error: error)
                                                }
                                            }
            }
        }
    }
    
    /**
     NOTE: this method uses the new and preferred API for obtaining "disciplines" or
     "subject areas". The other method returns the same value, but uses a server side
     redirect to the new API.
     This method gets all registered Elsevier subject areas.
     @param task the cancellable MendeleyTask
     @param completionBlock will return an array of MendeleyDiscipline objects
     */
    @objc public func subjectAreas(withTask task: MendeleyTask?,
                                   completionBlock: @escaping MendeleyArrayCompletionBlock) {
        MendeleyKitConfiguration.sharedInstance().oauthProvider.authenticateClient { (credentials, error) in
            guard let credentials = credentials
                else { completionBlock(nil, nil, error); return }
            
            let requestHeader = self.defaultRequestHeaders(fromCredentials: credentials)
            
            let blockExec = MendeleyBlockExecutor(arrayCompletionBlock: completionBlock)
            
            self.networkProvider.invokeGET(self.baseAPIURL,
                                           api: kMendeleyRESTAPISubjectAreas,
                                           additionalHeaders: requestHeader,
                                           queryParameters: nil,
                                           authenticationRequired: false,
                                           task: task) { (response, error) in
                                            var error = error
                                            if self.helper.isSuccess(forResponse: response, error: &error) == false || response?.rawResponseBody == nil {
                                                blockExec?.execute(with: nil, syncInfo: nil, error: error)
                                            } else {
                                                let decoder = JSONDecoder()
                                                do {
                                                    let arrayDict = try decoder.decode([String: [MendeleyDiscipline]].self, from: response!.rawResponseBody)
                                                    blockExec?.execute(with: arrayDict[kMendeleyJSONData], syncInfo: response?.syncHeader, error: nil)
                                                } catch {
                                                    blockExec?.execute(with: nil, syncInfo: nil, error: error)
                                                }
                                            }
            }
        }
    }

    @available(*, deprecated, message: "Use subjectAreas(withTask:completionBlock:) instead")
    private func defaultServiceRequestHeaders(fromCredentials credentials: MendeleyOAuthCredentials) -> [String: String]
    {
        guard var requestHeader = credentials.authenticationHeader() as? [String: String]
            else { return [String: String]() }
        
        requestHeader[kMendeleyRESTRequestAccept] = kMendeleyRESTRequestJSONDisciplineType
        
        return requestHeader
    }
    
    private func defaultRequestHeaders(fromCredentials credentials: MendeleyOAuthCredentials) -> [String: String] {
        guard var requestHeader = credentials.authenticationHeader() as? [String: String]
            else { return [String: String]() }
        
        requestHeader[kMendeleyRESTRequestAccept] = kMendeleyRESTRequestJSONSubjectArea
        
        return requestHeader
    }
}
