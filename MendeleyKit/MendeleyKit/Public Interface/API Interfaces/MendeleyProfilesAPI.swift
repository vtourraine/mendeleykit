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

@objc open class MendeleyProfilesAPI: MendeleySwiftObjectAPI {
    
    /**
     @name MendeleyProfilesAPI
     This class provides access methods to the REST profiles API
     All of the methods are accessed via MendeleyKit.
     Developers should use the methods provided in MendeleyKit rather
     than the methods listed here.
     */
    /**
     Pulls the users profile
     @param task
     @param completionBlock
     */
    @objc public func pullMyProfile(withTask task: MendeleyTask?,
                                    completionBlock: @escaping MendeleyObjectCompletionBlock) {
        helper.mendeleyObject(ofType: MendeleyUserProfile.self,
            queryParameters: nil,
            api: kMendeleyRESTAPIProfilesMe,
            additionalHeaders: defaultServiceRequestHeaders,
            task: task,
            completionBlock: completionBlock)
    }
    
    /**
     Pulls the profile of a user with a given ID
     @param profileID
     @param task
     @param completionBlock
     */
    @objc public func pull(profile profileID: String,
                           task: MendeleyTask?,
                           completionBlock: @escaping MendeleyObjectCompletionBlock) {
        helper.mendeleyObject(ofType: MendeleyProfile.self,
                              queryParameters: nil,
                              api: String(format: kMendeleyRESTAPIProfilesWithID, profileID),
                              additionalHeaders: defaultServiceRequestHeaders,
                              task: task,
                              completionBlock: completionBlock)
    }
    
    /**
     Obtains a profile icon for a specified MendeleyProfile and icon type (maybe standard, square, original)
     @param profile
     @param iconType
     @param task
     @param completionBlock returning the image data as NSData
     */
    @objc public func profileIcon(forProfile profile: MendeleyProfile, iconType: MendeleyIconType, task: MendeleyTask?, completionBlock: @escaping MendeleyBinaryDataCompletionBlock) {
        do {
            let linkURLString = try link(fromPhoto: profile.photo, iconType: iconType, task: task)
            profileIcon(forIconURLString: linkURLString, task: task, completionBlock: completionBlock)
        } catch {
            completionBlock(nil, error)
        }
    }
    
    /**
     Obtains a profile icon based on the given link URL string
     @param iconURLString
     @param task
     @param completionBlock returning the image data as NSData
     */
    @objc public func profileIcon(forIconURLString iconURLString: String, task: MendeleyTask?, completionBlock: @escaping MendeleyBinaryDataCompletionBlock) {
        let url = URL(string: iconURLString)
        let header = requestHeader(forImageLink: iconURLString)
        
        networkProvider.invokeGET(url,
                                  api: nil,
                                  additionalHeaders: header,
                                  queryParameters: nil,
                                  authenticationRequired: false,
                                  task: task) { (response, error) in
                                    let blockExec = MendeleyBlockExecutor(binaryDataCompletionBlock: completionBlock)
                                    let (isSuccess, combinedError) = self.helper.isSuccess(forResponse: response, error: error)
                                    
                                    if isSuccess == false {
                                        blockExec?.execute(withBinaryData: nil, error: combinedError)
                                    } else {
                                        if let bodyData = response?.responseBody as? Data {
                                            blockExec?.execute(withBinaryData: bodyData, error: nil)
                                        } else {
                                            blockExec?.execute(withBinaryData: nil, error: error)
                                        }
                                    }
        }
    }
    
    /**
     Creates a new profile based on the MendeleyNewProfile argument passed in. The following properties MUST be
     provided to be able to create a new profile
     first_name, last_name, email, password, main discipline, academic status
     Note: the email MUST be unique
     @param profile - containing at least the 6 mandatory properties given above
     @param task
     @param completionBlock - the completionHandler.
     */
    @objc public func create(profile: MendeleyNewProfile, task: MendeleyTask?, completionBlock: @escaping MendeleyObjectCompletionBlock) {
        MendeleyKitConfiguration.sharedInstance().oauthProvider.authenticateClient() { (credentials, error) in
            let blockExec = MendeleyBlockExecutor(swiftObjectCompletionBlock: completionBlock)
            
            if credentials == nil {
                blockExec?.execute(with: nil, syncInfo: nil, error: error)
                return
            }
            
            let encoder = JSONEncoder()
            
            do {
                let jsonData = try encoder.encode(profile)
                
                self.networkProvider.invokePOST(self.baseAPIURL,
                                           api: kMendeleyRESTAPIProfiles,
                                           additionalHeaders: self.newProfileRequestHeader(fromCreditials: credentials!),
                                           jsonData: jsonData,
                                           authenticationRequired: false,
                                           task: task) { (response, error) in
                                            let (isSuccess, combinedError) = self.helper.isSuccess(forResponse: response, error: error)
                                            
                                            if isSuccess == false || response?.rawResponseBody == nil {
                                                blockExec?.execute(withMendeleySwiftObject: nil, syncInfo: nil, error: combinedError)
                                            } else {
                                                let decoder = JSONDecoder()
                                                do {
                                                    let objectDict = try decoder.decode([String: MendeleyProfile].self, from: response!.rawResponseBody)
                                                    blockExec?.execute(withMendeleySwiftObject: objectDict[kMendeleyJSONData], syncInfo: response?.syncHeader, error: nil)
                                                } catch {
                                                    blockExec?.execute(withMendeleySwiftObject: nil, syncInfo: nil, error: error)
                                                }
                                            }
                }
            } catch {
                blockExec?.execute(withMendeleySwiftObject: nil, syncInfo: nil, error: error)
            }
        }
    }
    
    /**
     Updates an existing user's profile based on the MendeleyAmendmentProfile argument passed in.
     If the user wants to update his password the following properties must be provided
     - password (i.e. the new password)
     - old_password (i.e the previous password to be replaced)
     @param profile - the profile containing the updated parameters.
     @param task
     @param completionBlock - the completionHandler.
     */
    @objc public func update(myProfile: MendeleyAmendmentProfile, task: MendeleyTask?, completionBlock: @escaping MendeleyObjectCompletionBlock) {
        helper.update(mendeleyObject: myProfile,
                      api: kMendeleyRESTAPIProfilesMe,
                      additionalHeaders: updateProfileRequestHeader(),
                      expectedType: MendeleyProfile.self,
                      task: task,
                      completionBlock: completionBlock)
    }
    
    private func newProfileRequestHeader(fromCreditials credentials: MendeleyOAuthCredentials) -> [String: String] {
        var mergedHeader = [String: String]()
        
        guard let authenticationHeader = credentials.authenticationHeader() as? [String: String]
            else { return mergedHeader }
        
        authenticationHeader.forEach { (key, value) in mergedHeader[key] = value }
        
        mergedHeader[kMendeleyRESTRequestAccept] = kMendeleyRESTRequestJSONProfilesType
        mergedHeader[kMendeleyRESTRequestContentType] = kMendeleyRESTRequestJSONNewProfilesType
        
        return mergedHeader
    }
    
    private func updateProfileRequestHeader() -> [String: String] {
        var requestHeader = defaultServiceRequestHeaders
        
        requestHeader[kMendeleyRESTRequestContentType] = kMendeleyRESTRequestJSONProfileUpdateType
        
        return requestHeader
    }
    
    private let defaultServiceRequestHeaders = [kMendeleyRESTRequestAccept: kMendeleyRESTRequestJSONProfilesType]
}
