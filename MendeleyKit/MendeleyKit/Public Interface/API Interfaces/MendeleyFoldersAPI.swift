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

    }
    
    /**
     Add a previously created document in a specific folder
     @param mendeleyDocumentId
     @param folderID
     @param task
     @param completionBlock
     */
    @objc public func add(document mendeleyDocumentID: String,
                          folderID: String,
                          task: MendeleyTask?,
                          completionBlock: @escaping MendeleyCompletionBlock) {
        let apiEndPoint = String(format: kMendeleyRESTAPIDocumentsInFolderWithID, folderID)
        let blockExec = MendeleyBlockExecutor(completionBlock: completionBlock)
        let encoder = JSONEncoder()
        
        do {
            let jsonData = try encoder.encode(mendeleyDocumentID)
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
    @objc public func create(folder mendeleyFolder: MendeleyFolder,
                             task: MendeleyTask?,
                             completionBlock: @escaping MendeleyObjectCompletionBlock) {
        
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
        
    }
    
    /**
     Obtain a list of folders for the logged-in user
     @param queryParameters
     @param task
     @param completionBlock
     */
    @objc public func foldersList(withQueryParamenters queryParameters: MendeleyFolderParameters,
                                  taks: MendeleyTask?,
                                  completionBlock: @escaping MendeleyArrayCompletionBlock) {
        
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
        
    }
    
    /**
     Delete a folder identified by the given folderID
     @param folderID
     @param task
     @param completionBlock
     */
    @objc public func delete(folderWithID folderID: String,
                             task: MendeleyTask?,
                             completionBlock: @escaping MendeleyCompletionBlock) {
        
    }
    
    /**
     Update a folder's name, or move it to a new parent
     @param updatedFolder
     @param task
     @param completionBlock
     */
    @objc public func update(folder updatedFolder: MendeleyFolder,
                             task: MendeleyTask?,
                             completionBlock: MendeleyCompletionBlock) {
        
    }
    
    /**
     Delete a document identified by the given documentID and belonging to a folder identified by the given folderID
     @param documentID
     @param folderID
     @param task
     @param completionBlock
     */
    @objc public func delete(documentWithID documentID: String,
                             fromFolderWithID folderID: String,
                             task: MendeleyTask?,
                             completionBlock: @escaping MendeleyCompletionBlock) {
        
    }

}
