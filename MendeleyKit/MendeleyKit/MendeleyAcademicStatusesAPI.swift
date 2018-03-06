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

@objc open class MendeleyAcademicStatusesAPI: MendeleyObjectAPI {
    
    @available(*, deprecated, message: "Use defaultRequestHeaders(fromCredentials:) instead")
    private func defaultServiceRequestHeaders(fromCredentials credentials: MendeleyOAuthCredentials) -> [String: String] {
        guard var requestHeader = credentials.authenticationHeader() as? [String: String]
            else { return [String: String]() }
        
        requestHeader[kMendeleyRESTRequestAccept] = kMendeleyRESTRequestJSONAcademicStatuses
        
        return requestHeader
    }
    
    private func defaultRequestHeaders(fromCredentials credentials: MendeleyOAuthCredentials) -> [String: String] {
        guard var requestHeader = credentials.authenticationHeader() as? [String: String]
            else { return [String: String]() }
        
        requestHeader[kMendeleyRESTRequestAccept] = kMendeleyRESTRequestJSONUserRole
        
        return requestHeader
    }
    
    /**
     This method gets all registered Mendeley academic statuses
     @param task the cancellable MendeleyTask
     @param completionBlock will return an array of MendeleyAcademicStatus objects
     */
    @available(*, deprecated, message: "Use userRoles(withTask:completionBlock:) instead")
    @objc public func academicStatuses(withTask task: MendeleyTask?,
                                       completionBlock: @escaping MendeleyArrayCompletionBlock) {
        MendeleyKitConfiguration.sharedInstance().oauthProvider.authenticateClient { (credentials, error) in
            guard let credentials = credentials
                else { completionBlock(nil, nil, error); return }
            
            let requestHeader = self.defaultServiceRequestHeaders(fromCredentials: credentials)
            let blockExecutor = MendeleyBlockExecutor(arrayCompletionBlock: completionBlock)
            
            self.networkProvider.invokeGET(self.baseAPIURL,
                                           api: kMendeleyRESTAPIAcademicStatuses,
                                           additionalHeaders: requestHeader,
                                           queryParameters: nil,
                                           authenticationRequired: false,
                                           task: task) { (response, error) in
                                            var error = error
                                            if self.helper.isSuccess(forResponse: response, error: &error) == false || response?.rawResponseBody == nil {
                                                blockExecutor?.execute(with: nil, syncInfo: nil, error: error)
                                            } else {
                                                let decoder = JSONDecoder()
                                                do {
                                                    let arrayDict = try decoder.decode([String: [MendeleyAcademicStatus]].self, from: response!.rawResponseBody)
                                                    blockExecutor?.execute(with: arrayDict[kMendeleyJSONData], syncInfo: response?.syncHeader, error: nil)
                                                } catch {
                                                    blockExecutor?.execute(with: nil, syncInfo: nil, error: error)
                                                }
                                            }
            }
        }
    }
    
    /**
     This method gets all registered Elsevier user roles.
     @param task the cancellable MendeleyTask
     @param completionBlock will return an array of MendeleyAcademicStatus objects
     */
    @objc public func userRoles(withTask task: MendeleyTask?,
                                completionBlock: @escaping MendeleyArrayCompletionBlock) {
        MendeleyKitConfiguration.sharedInstance().oauthProvider.authenticateClient { (credentials, error) in
            guard let credentials = credentials
                else { completionBlock(nil, nil, error); return }
            
            let requestHeader = self.defaultRequestHeaders(fromCredentials: credentials)
            let blockExec = MendeleyBlockExecutor(arrayCompletionBlock: completionBlock)
            
            self.networkProvider.invokeGET(self.baseAPIURL,
                                           api: kMendeleyRESTAPIUserRoles,
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
                                                    let arrayDict = try decoder.decode([String: [MendeleyAcademicStatus]].self, from: response!.rawResponseBody)
                                                    blockExec?.execute(with: arrayDict[kMendeleyJSONData], syncInfo: response?.syncHeader, error: nil)
                                                } catch {
                                                    blockExec?.execute(with: nil, syncInfo: nil, error: error)
                                                }
                                            }
            }
        }
    }
}
