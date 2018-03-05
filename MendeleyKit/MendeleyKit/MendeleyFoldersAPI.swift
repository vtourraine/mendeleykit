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

@objc open class MendeleyFoldersAPI: MendeleySwiftObjectAPI {
    /**
     @name MendeleyFoldersAPI
     This class provides access methods to the REST folders API
     All of the methods are accessed via MendeleyKit.
     Developers should use the methods provided in MendeleyKit rather
     than the methods listed here.
     */
    
    private let defaultServiceRequestHeaders = [kMendeleyRESTRequestAccept: kMendeleyRESTRequestJSONFolderType]
    private let defaultUploadRequestHeaders = [kMendeleyRESTRequestAccept: kMendeleyRESTRequestJSONFolderType,
    kMendeleyRESTRequestContentType: kMendeleyRESTRequestJSONFolderType];
    private let defaultFolderDocumentIDsRequestHeaders = [kMendeleyRESTRequestAccept: kMendeleyRESTRequestJSONDocumentType]
    private let defaultAddDocumentToFolderRequestHeaders = [kMendeleyRESTRequestAccept: kMendeleyRESTRequestJSONDocumentType,
    kMendeleyRESTRequestContentType: kMendeleyRESTRequestJSONDocumentType]
        
    private var defaultQueryParameters: [String: String] {
        return MendeleyFolderParameters().valueStringDictionary()
    }
    
    /**
     Obtain a list of documents belonging to a specific folder.
     @param folderID
     @param parameters
     @param task
     @param completionBlock - the array contained in the completionBlock will be an array of strings
     */
    @objc public func documentList(fromFolderWithID folderID: String,
                                   parameters: MendeleyFolderParameters,
                                   task: MendeleyTask?,
                                   completionBlock: @escaping MendeleyArrayCompletionBlock) {
        var mergedQuery = parameters.valueStringDictionary()
        let apiEndPoint = String(format: kMendeleyRESTAPIDocumentsInFolderWithID, folderID)
        
        defaultQueryParameters.forEach { (key, value) in mergedQuery[key] = value }
        
        helper.mendeleyIDStringList(forAPI: apiEndPoint,
                                    queryParameters: mergedQuery,
                                    additionalHeaders: defaultFolderDocumentIDsRequestHeaders,
                                    task: task,
                                    completionBlock: completionBlock)
    }
    
    /**
     this is getting the list of document IDs in a paged form
     @param linkURL
     @param task
     @param completionBlock - the array contained in the completionBlock will be an array of strings
     */
    @objc public func documentList(inFolderWithLinkedURL linkURL: URL,
                                   task: MendeleyTask?,
                                   completionBlock: @escaping MendeleyArrayCompletionBlock) {
        networkProvider.invokeGET(linkURL,
                                  api: nil,
                                  additionalHeaders: defaultFolderDocumentIDsRequestHeaders,
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
                                            let arrayDict = try decoder.decode([String: [[String: Any]]].self, from: response!.rawResponseBody)
                                            blockExec?.execute(with: arrayDict[kMendeleyJSONData], syncInfo: response?.syncHeader, error: nil)
                                        } catch {
                                            blockExec?.execute(with: nil, syncInfo: nil, error: error)
                                        }
                                    }
        }
    }
    
    /**
     Add a previously created document in a specific folder
     @param mendeleyDocumentId
     @param folderID
     @param task
     @param completionBlock
     */
    @objc (addDocument:folderID:task:completionBlock:)
    public func add(document mendeleyDocumentID: String,
                          folderID: String,
                          task: MendeleyTask?,
                          completionBlock: @escaping MendeleyCompletionBlock) {
        let apiEndPoint = String(format: kMendeleyRESTAPIDocumentsInFolderWithID, folderID)
        let blockExec = MendeleyBlockExecutor(completionBlock: completionBlock)
        let encoder = JSONEncoder()
        
        do {
            let jsonData = try encoder.encode(mendeleyDocumentID)
            networkProvider.invokePOST(baseAPIURL,
                                       api: apiEndPoint,
                                       additionalHeaders: defaultAddDocumentToFolderRequestHeaders,
                                       jsonData: jsonData,
                                       authenticationRequired: true,
                                       task: task) { (response, error) in
                                        var error = error
                                        let success = self.helper.isSuccess(forResponse: response, error: &error)
                                        if success == true {
                                            blockExec?.execute(with: true, error: nil)
                                        } else {
                                            blockExec?.execute(with: false, error: error)
                                        }
            }
        } catch {
            blockExec?.execute(with: false, error: error)
        }
    }
    
    /**
     Create a folder
     @param mendeleyFolder
     @param task
     @param completionBlock
     */
    @objc (createFolder:task:completionBlock:)
    public func create(folder mendeleyFolder: MendeleyFolder,
                             task: MendeleyTask?,
                             completionBlock: @escaping MendeleyObjectCompletionBlock) {
        
        helper.create(mendeleyObject: mendeleyFolder,
                      api: kMendeleyRESTAPIFolders,
                      additionalHeaders: defaultUploadRequestHeaders,
                      expectedType: MendeleyFolder.self,
                      task: task,
                      completionBlock: completionBlock)
    }
    
    /**
     This method is only used when paging through a list of folders on the server.
     All required parameters are provided in the linkURL, which should not be modified
     
     @param linkURL the full HTTP link to the document listings page
     @param task
     @param completionBlock
     */
    @objc public func folderList(withLinkedURL linkURL: URL,
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
                                            let arrayDict = try decoder.decode([String: [MendeleyFolder]].self, from: response!.rawResponseBody)
                                            blockExec?.execute(with: arrayDict[kMendeleyJSONData], syncInfo: response?.syncHeader, error: nil)
                                        } catch {
                                            blockExec?.execute(with: nil, syncInfo: nil, error: error)
                                        }
                                    }
        }
    }
    
    /**
     Obtain a list of folders for the logged-in user
     @param queryParameters
     @param task
     @param completionBlock
     */
    @objc public func folderList(withQueryParameters queryParameters: MendeleyFolderParameters,
                                  task: MendeleyTask?,
                                  completionBlock: @escaping MendeleyArrayCompletionBlock) {
        var mergedQuery = queryParameters.valueStringDictionary()
        
        defaultQueryParameters.forEach { (key, value) in mergedQuery[key] = value }
        
        helper.mendeleyObjectList(ofType: MendeleyFolder.self,
                                  api: kMendeleyRESTAPIFolders,
                                  queryParameters: mergedQuery,
                                  additionalHeaders: defaultServiceRequestHeaders,
                                  task: task,
                                  completionBlock: completionBlock)
    }
    
    /**
     Obtain a folder identified by the given folderID
     @param folderID
     @param task
     @param completionBlock
     */
    @objc public func folder(withFolderID folderID: String,
                             task: MendeleyTask?,
                             completionBlock: @escaping MendeleyObjectCompletionBlock) {
        let apiEndPoint = String(format: kMendeleyRESTAPIFolderWithID, folderID)
        
        helper.mendeleyObject(ofType: MendeleyFolder.self,
                              queryParameters: nil,
                              api: apiEndPoint,
                              additionalHeaders: defaultServiceRequestHeaders,
                              task: task,
                              completionBlock: completionBlock)
    }
    
    /**
     Delete a folder identified by the given folderID
     @param folderID
     @param task
     @param completionBlock
     */
    @objc (deleteFolderWithID:task:completionBlock:)
    public func delete(folderWithID folderID: String,
                             task: MendeleyTask?,
                             completionBlock: @escaping MendeleyCompletionBlock) {
        let apiEndPoint = String(format: kMendeleyRESTAPIFolderWithID, folderID)
        
        helper.deleteMendeleyObject(withAPI: apiEndPoint,
                                    task: task,
                                    completionBlock: completionBlock)
    }
    
    /**
     Update a folder's name, or move it to a new parent
     @param updatedFolder
     @param task
     @param completionBlock
     */
    @objc (updateFolder:task:completionBlock:)
    public func update(folder updatedFolder: MendeleyFolder,
                             task: MendeleyTask?,
                             completionBlock: @escaping MendeleyCompletionBlock) {
        let apiEndPoint = String(format: kMendeleyRESTAPIFolderWithID, updatedFolder.object_ID ?? "")
        
        helper.update(mendeleyObject: updatedFolder,
                      api: apiEndPoint,
                      additionalHeaders: defaultUploadRequestHeaders,
                      task: task,
                      completionBlock: completionBlock)
    }
    
    /**
     Delete a document identified by the given documentID and belonging to a folder identified by the given folderID
     @param documentID
     @param folderID
     @param task
     @param completionBlock
     */
    @objc (deleteDocumentWithID:fromFolderWithID:task:completionBlock:)
    public func delete(documentWithID documentID: String,
                             fromFolderWithID folderID: String,
                             task: MendeleyTask?,
                             completionBlock: @escaping MendeleyCompletionBlock) {
        let apiEndPoint = String(format: kMendeleyRESTAPIDocumentWithIDInFolderWithID, folderID, documentID)
        
        helper.deleteMendeleyObject(withAPI: apiEndPoint,
                                    task: task,
                                    completionBlock: completionBlock)
    }
}
