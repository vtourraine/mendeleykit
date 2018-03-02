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
                                    var error = error
                                    if self.helper.isSuccess(forResponse: response, error: &error) == false || response?.rawResponseBody == nil {
                                        blockExec?.execute(with: nil, syncInfo: nil, error: error)
                                    } else {
                                        let decoder = JSONDecoder()
                                        do {
                                            let groupsDict = try decoder.decode([String: [MendeleyGroup]].self, from: response!.rawResponseBody)

                                            if let groups = groupsDict[kMendeleyJSONData] {
                                                let firstIndex = 0
                                                self.groupIcon(forGroupArray: groups,
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
                                    var error = error
                                    if self.helper.isSuccess(forResponse: response, error: &error) == false || response?.rawResponseBody == nil {
                                        blockExec?.execute(with: nil, syncInfo: nil, error: error)
                                    } else {
                                        let decoder = JSONDecoder()
                                        do {
                                            let groupsDict = try decoder.decode([String: [MendeleyGroup]].self, from: response!.rawResponseBody)
                                            
                                            if let groups = groupsDict[kMendeleyJSONData] {
                                                let firstIndex = 0
                                                self.groupIcon(forGroupArray: groups,
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
                            completionBlock: @escaping MendeleyObjectCompletionBlock) {
        let apiEndPoint = String(format: kMendeleyRESTAPIGroupWithID, groupID)
        
        networkProvider.invokeGET(baseAPIURL,
                                  api: apiEndPoint,
                                  additionalHeaders: defaultServiceRequestHeaders,
                                  queryParameters: nil,
                                  authenticationRequired: true,
                                  task: task) { (response, error) in
                                    let blockExec = MendeleyBlockExecutor(objectCompletionBlock: completionBlock)
                                    var error = error
                                    if self.helper.isSuccess(forResponse: response, error: &error) == false || response?.rawResponseBody == nil {
                                        blockExec?.execute(withMendeleyObject: nil, syncInfo: nil, error: error)
                                    } else {
                                        let decoder = JSONDecoder()
                                        
                                        do {
                                            let groupDict = try decoder.decode([String: MendeleyGroup].self, from: response!.rawResponseBody)
                                            if let group = groupDict[kMendeleyJSONData] {
                                                self.groupIcon(forGroup: group,
                                                               iconType: iconType,
                                                               task: task) { (binaryData, dataError) in
                                                                if let binaryData = binaryData {
                                                                    switch iconType {
                                                                    case .StandardIcon:
                                                                        group.photo?.standardImageData = binaryData
                                                                    case .SquareIcon:
                                                                        group.photo?.squareImageData = binaryData
                                                                    case .OriginalIcon:
                                                                        group.photo?.originalImageData = binaryData
                                                                    }
                                                                }
                                                                blockExec?.execute(withMendeleyObject: group, syncInfo: response?.syncHeader, error: nil)
                                                }
                                                
                                            } else {
                                                blockExec?.execute(withMendeleyObject: nil, syncInfo: nil, error: nil)
                                            }
                                            
                                        } catch {
                                            blockExec?.execute(withMendeleyObject: nil, syncInfo: nil, error: error)
                                        }
                                    }
        }
    }
    
    /**
     @param groupID
     @param queryParameters
     @param task
     @param completionBlock
     */
    @objc public func groupMemberList(withGroupID groupID: String,
                                      queryParameters: MendeleyGroupParameters,
                                      task: MendeleyTask?,
                                      completionBlock: @escaping MendeleyArrayCompletionBlock) {
        let apiEndPoint = String(format: kMendeleyRESTAPIMembersInGroupWithID, groupID)
        var query: [String: Any] = queryParameters.valueStringDictionary()
        
        // Merge dictionaries
        defaultQueryParameters.forEach { (key, value) in query[key] = value }
        
        helper.mendeleyObjectList(ofType: MendeleyUserRole.self,
                                  api: apiEndPoint,
                                  queryParameters: query,
                                  additionalHeaders: membersRequestHeaders,
                                  task: task,
                                  completionBlock: completionBlock)
    }
    
    /**
     Obtain a list of groups where the logged in user is a member
     If provided, it will include the square icon for the group
     @param queryParameters the parameters to be used in the API request
     @param task
     @param completionBlock the list of groups if found
     */
    @objc public func groupList(withQueryParameters queryParameters: MendeleyGroupParameters,
                                task: MendeleyTask?,
                                completionBlock: @escaping MendeleyArrayCompletionBlock) {
        
        var query: [String: Any] = queryParameters.valueStringDictionary()
        defaultQueryParameters.forEach { (key, value) in query[key] = value }
        
        networkProvider.invokeGET(baseAPIURL,
                                  api: kMendeleyRESTAPIGroups,
                                  additionalHeaders: defaultServiceRequestHeaders,
                                  queryParameters: query,
                                  authenticationRequired: true,
                                  task: task) { (response, error) in
                                    let blockExec = MendeleyBlockExecutor(arrayCompletionBlock: completionBlock)
                                    var error = error
                                    if self.helper.isSuccess(forResponse: response, error: &error) == false || response?.rawResponseBody == nil {
                                        blockExec?.execute(with: nil, syncInfo: nil, error: error)
                                    } else {
                                        let decoder = JSONDecoder()
                                        
                                        do {
                                            let groupsDict = try decoder.decode([String: [MendeleyGroup]].self, from: response!.rawResponseBody)
                                            blockExec?.execute(with: groupsDict[kMendeleyJSONData], syncInfo: response?.syncHeader, error: nil)
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
     @param task
     @param completionBlock the list of groups if found
     */
    @objc public func groupList(withLinkedURL linkURL: URL,
                                task: MendeleyTask?,
                                completionBlock: @escaping MendeleyArrayCompletionBlock) {
        networkProvider.invokeGET(linkURL,
                                  additionalHeaders: defaultServiceRequestHeaders,
                                  queryParameters: nil,
                                  authenticationRequired: true,
                                  task: task) { (response, error) in
                                    let blockExec = MendeleyBlockExecutor(arrayCompletionBlock: completionBlock)
                                    var error = error
                                    if self.helper.isSuccess(forResponse: response, error: &error) == false || response?.rawResponseBody == nil {
                                        blockExec?.execute(with: nil, syncInfo: nil, error: error)
                                    } else {
                                        let decoder = JSONDecoder()
                                        do {
                                            let groupsDict = try decoder.decode([String: [MendeleyGroup]].self, from: response!.rawResponseBody)
                                            blockExec?.execute(with: groupsDict[kMendeleyJSONData], syncInfo: nil, error: nil)
                                            
                                        } catch {
                                            blockExec?.execute(with: nil, syncInfo: nil, error: error)
                                        }
                                    }
        }
    }
    
    /**
     Obtain details for the group identified by the given groupID
     @param groupID the group UUID
     @param task
     @param completionBlock the group
     */
    @objc public func group(withGroupID groupID: String,
                            task: MendeleyTask?,
                            completionBlock: @escaping MendeleyObjectCompletionBlock) {
        let apiEndPoint = String(format: kMendeleyRESTAPIGroupWithID, groupID)
        
        helper.mendeleyObject(ofType: MendeleyGroup.self,
                              queryParameters: nil,
                              api: apiEndPoint,
                              additionalHeaders: defaultServiceRequestHeaders,
                              task: task,
                              completionBlock: completionBlock)
    }
    
    @objc public func groupIcon(forGroupArray groups: [MendeleyGroup],
                                 groupIndex: Int,
                                 iconType: MendeleyIconType,
                                 previousError: Error?,
                                 task: MendeleyTask?,
                                 completionBlock: @escaping MendeleyCompletionBlock) {
        if groups.count <= groupIndex {
            completionBlock(previousError == nil, previousError)
            return
        }
        
        let group = groups[groupIndex]
        
        groupIcon(forGroup: group,
                  iconType: iconType,
                  task: task) { (imageData, error) in
                    var nextError: Error? = nil
                    let nextIndex = groupIndex + 1
                    
                    if previousError == nil {
                        nextError = error
                    } else {
                        nextError = previousError
                    }
                    
                    if imageData != nil {
                        switch iconType {
                        case .OriginalIcon:
                            group.photo?.originalImageData = imageData
                        case .SquareIcon:
                            group.photo?.squareImageData = imageData
                        case .StandardIcon:
                            group.photo?.standardImageData = imageData
                        }
                    }
                    
                    self.groupIcon(forGroupArray: groups,
                                   groupIndex: nextIndex,
                                   iconType: iconType,
                                   previousError: nextError,
                                   task: task,
                                   completionBlock: completionBlock)
        }
    }
    
    /**
     Obtains a group icon for a specified MendeleyGroup and icon type (maybe standard, square, original)
     @param group
     @param iconType
     @param task
     @param completionBlock returning the image data as NSData
     */
    @objc public func groupIcon(forGroup group: MendeleyGroup,
                                iconType: MendeleyIconType,
                                task: MendeleyTask?,
                                completionBlock: @escaping MendeleyBinaryDataCompletionBlock) {
        do {
            let linkURLString = try link(fromPhoto: group.photo, iconType: iconType, task: task)
            
            groupIcon(forIconURLString: linkURLString, task: task, completionBlock: completionBlock)
        } catch {
            completionBlock(nil, error)
        }
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
        let url = URL(string: iconURLString)
        let header = requestHeader(forImageLink: iconURLString)
        
        networkProvider.invokeGET(url,
                                  api: nil,
                                  additionalHeaders: header,
                                  queryParameters: nil,
                                  authenticationRequired: true,
                                  task: task) { (response, error) in
                                    let blockExec = MendeleyBlockExecutor(binaryDataCompletionBlock: completionBlock)
                                    var error = error
                                    if self.helper.isSuccess(forResponse: response, error: &error) == false {
                                        blockExec?.execute(withBinaryData: nil, error: error)
                                    } else {
                                        if let bodyData = response?.responseBody as? Data {
                                            blockExec?.execute(withBinaryData: bodyData, error: nil)
                                        } else {
                                            blockExec?.execute(withBinaryData: nil, error: error)
                                        }
                                    }
        }
    }
}
