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

@objc open class MendeleyGroupsAPI: MendeleySwiftObjectAPI {
    private let defaultServiceRequestHeaders = [kMendeleyRESTRequestAccept: kMendeleyRESTRequestJSONGroupType]
    private let membersRequestHeaders = [kMendeleyRESTRequestAccept: kMendeleyRESTRequestJSONUserRoleType]
    
    private var defaultQueryParameters: [String: Any] {
        return MendeleyGroupParameters().valueStringDictionary()
    }
    
    /**
     @name MendeleyGroupsAPI
     This class provides access methods to the REST groups API
     All of the methods are accessed via MendeleyKit.
     Developers should use the methods provided in MendeleyKit rather
     than the methods listed here.
     */
    
    /**
     @param queryParameters
     @param iconType
     @param task
     @param completionBlock
     */
    @objc public func groupList(withQueryParameters queryParameters: MendeleyGroupParameters,
                                iconType: MendeleyIconType,
                                task: MendeleyTask?,
                                completionBlock: @escaping MendeleyArrayCompletionBlock) {
        let query = queryParameters.valueStringDictionary()
        
        let mergedQuery = NSDictionary(byMerging: query, with: defaultQueryParameters) as! [String: String]

        networkProvider.invokeGET(baseAPIURL,
                                  api: kMendeleyRESTAPIGroups,
                                  additionalHeaders: defaultServiceRequestHeaders,
                                  queryParameters: mergedQuery,
                                  authenticationRequired: true, task: task) { (response, error) in
                                    let blockExec = MendeleyBlockExecutor(arrayCompletionBlock: completionBlock)
                                    let (success, combinedError) = self.helper.isSuccess(forResponse: response, error: error)

                                    if success == false || response?.rawResponseBody == nil {
                                        blockExec?.execute(with: nil, syncInfo: nil, error: combinedError)
                                    } else {
                                        let decoder = JSONDecoder()
                                        do {
                                            let groupsDict = try decoder.decode(response, from: [String: [MendeleyGroup]].self)

                                            if let groups = groupsDict[kMendeleyJSONData] {
                                                let firstIndex = 0
                                                groupIcon(forGroupArray: groups,
                                                           groupIndex: firstIndex,
                                                           iconType: iconType,
                                                           previousError: nil,
                                                           task: task) { (_, _) in
                                                            blockExec?.execute(with: groups,
                                                                               syncInfo: response?.syncHeader,
                                                                               error: nil)
                                                }
                                            } else {
                                                blockExec?.execute(with: nil, syncInfo: response?.syncHeader, error: nil)
                                            }
                                        } catch {
                                            blockExec?.execute(with: nil, syncInfo: nil, error: error)
                                        }
                                    }
        }
    }
    
    /**
     This method is only used when paging through a list of groups on the server.
     All required parameters are provided in the linkURL, which should not be modified
     
     @param linkURL the full HTTP link to the document listings page
     @param iconType
     @param task
     @param completionBlock
     */
    @objc public func groupList(withLinkedURL linkURL: URL,
                                iconType: MendeleyIconType,
                                task: MendeleyTask?,
                                completionBlock: @escaping MendeleyArrayCompletionBlock) {
        networkProvider.invokeGET(linkURL,
                                  api: nil,
                                  additionalHeaders: defaultServiceRequestHeaders,
                                  queryParameters: nil,
                                  authenticationRequired: true,
                                  task: task) { (response, error) in
                                    let blockExec = MendeleyBlockExecutor(arrayCompletionBlock: completionBlock)
                                    let (success, combinedError) = self.helper.isSuccess(forResponse: response, error: error)
                                    if success == false || response?.rawResponseBody == nil {
                                        blockExec?.execute(with: nil, syncInfo: nil, error: combinedError)
                                    } else {
                                        let decoder = JSONDecoder()
                                        do {
                                            let groupsDict = try decoder.decode(response, from: [String: [MendeleyGroup]].self)
                                            
                                            if let groups = groupsDict[kMendeleyJSONData] {
                                                let firstIndex = 0
                                                groupIcon(forGroupArray: groups,
                                                          groupIndex: firstIndex,
                                                          iconType: iconType,
                                                          previousError: nil,
                                                          task: task) { (_, _) in
                                                            blockExec?.execute(with: groups,
                                                                               syncInfo: response?.syncHeader,
                                                                               error: nil)
                                                }
                                            } else {
                                                blockExec?.execute(with: nil, syncInfo: response?.syncHeader, error: nil)
                                            }
                                        } catch {
                                            blockExec?.execute(with: nil, syncInfo: nil, error: error)
                                        }
                                    }
        }
    }
        
    /**
     @param groupID
     @param iconType
     @param task
     @param completionBlock
     */
    @objc public func group(withGroupID groupID: String,
                            iconType: MendeleyIconType,
                            task: MendeleyTask?,
                            completionBlock: @escaping MendeleySwiftObjectCompletionBlock) {
//        networkProvider.invokeGET
    }
    
    /**
     @param groupID
     @param queryParameters
     @param task
     @param completionBlock
     */
    @objc public func groupMemberList(withGroupID groupID: String,
                                      queryParameters: MendeleyGroupParameters,
                                      completionBlock: @escaping MendeleyArrayCompletionBlock) {
        
    }
    
    /**
     Obtain a list of groups where the logged in user is a member
     If provided, it will include the square icon for the group
     @param queryParameters the parameters to be used in the API request
     @param task
     @param completionBlock the list of groups if found
     */
    @objc public func groupList(withQueryParameters: MendeleyGroupParameters,
                                task: MendeleyTask?,
                                completionBlock: @escaping MendeleyArrayCompletionBlock) {
        
    }
    
    /**
     This method is only used when paging through a list of groups on the server.
     All required parameters are provided in the linkURL, which should not be modified
     
     @param linkURL the full HTTP link to the document listings page
     @param task
     @param completionBlock the list of groups if found
     */
    @objc public func groupList(withLinkedURL linkURL: URL,
                                task: MendeleyTask?,
                                completionBlock: @escaping MendeleyArrayCompletionBlock) {
        
    }
    
    /**
     Obtain details for the group identified by the given groupID
     @param groupID the group UUID
     @param task
     @param completionBlock the group
     */
    @objc public func group(withGroupID groupID: String,
                            task: MendeleyTask?,
                            completionBlock: @escaping MendeleySwiftObjectCompletionBlock) {
        
    }
    
    /**
     Obtains a group icon for a specified MendeleyGroup and icon type (maybe standard, square, original)
     @param group
     @param iconType
     @param task
     @param completionBlock returning the image data as NSData
     */
    @objc public func groupIcon(forGroup group: MendeleyGroup,
                                task: MendeleyTask?,
                                completionBlock: @escaping MendeleyBinaryDataCompletionBlock) {
        
    }
    
    /**
     Obtains a group icon based on the given link URL string
     @param iconURLString
     @param task
     @param completionBlock returning the image data as NSData
     */
    @objc public func groupIcon(forIconURLString iconURLString: String,
                                task: MendeleyTask?,
                                completionBlock: @escaping MendeleyBinaryDataCompletionBlock) {
        
    }
    
}
