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

@objc open class MendeleyDocumentsAPI: MendeleyObjectAPI {
    /**
     @name MendeleyDocumentsAPI
     This class provides access methods to the REST documents API
     All of the methods are accessed via MendeleyKit.
     Developers should use the methods provided in MendeleyKit rather
     than the methods listed here.
     */
    
    private let defaultServiceRequestHeaders = [kMendeleyRESTRequestAccept: kMendeleyRESTRequestJSONDocumentType]
    
    private let defaultUploadRequestHeaders = [kMendeleyRESTRequestAccept: kMendeleyRESTRequestJSONDocumentType,
    kMendeleyRESTRequestContentType: kMendeleyRESTRequestJSONDocumentType]
    
    private let defaultCloneDocumentHeaders = [kMendeleyRESTRequestAccept: kMendeleyRESTRequestJSONDocumentType,
    kMendeleyRESTRequestContentType: kMendeleyRESTRequestJSONDocumentCloneType]
    
    private let defaultCloneFileToHeaders = [kMendeleyRESTRequestContentType: kMendeleyRESTRequestJSONDocumentType]
    
    private var defaultQueryParameters: [String: String] {
        return MendeleyDocumentParameters().valueStringDictionary()
    }
    
    private var defaultQueryParametersWithoutViewParameter: [String: String] {
        let params = MendeleyDocumentParameters()
        params.view = nil
        
        return params.valueStringDictionary()
    }
    
    private var defaultViewQueryParameters: [String: String]? {
        let params = MendeleyDocumentParameters()
        
        if let view = params.view {
            return ["view": view]
        }
        
        return nil
    }
    
    private var defaultCatalogViewQueryParameters: [String: String]? {
        let params = MendeleyCatalogParameters()
        
        if let view = params.view {
            return ["view": view]
        }
        
        return nil
    }
    
    /**
     This method is only used when paging through a list of documents on the server.
     All required parameters are provided in the linkURL, which should not be modified
     
     @param linkURL the full HTTP link to the document listings page
     @param task
     @param completionBlock
     */
    @objc public func documentList(withLinkedURL linkURL: URL,
                                   task: MendeleyTask?,
                                   completionBlock: @escaping MendeleyArrayCompletionBlock) {
        networkProvider.invokeGET(linkURL,
                                  additionalHeaders: defaultServiceRequestHeaders,
                                  queryParameters: nil, // we don't need to specify parameters because are inehrits from the previous call
                                  authenticationRequired: true,
                                  task: task) { (response, error) in
                                    let blockExec = MendeleyBlockExecutor(arrayCompletionBlock: completionBlock)
                                    
                                    var error = error
                                    if self.helper.isSuccess(forResponse: response, error: &error) == false || response?.rawResponseBody == nil {
                                        blockExec?.execute(with: nil, syncInfo: nil, error: error)
                                    } else {
                                        let decoder = JSONDecoder()
                                        do {
                                            let arrayDict = try decoder.decode([String: [MendeleyDocument]].self, from: response!.rawResponseBody)
                                            blockExec?.execute(with: arrayDict[kMendeleyJSONData], syncInfo: response?.syncHeader, error: nil)
                                        } catch {
                                            blockExec?.execute(with: nil, syncInfo: nil, error: error)
                                        }
                                    }
        }
    }
    
    /**
     obtains a list of documents for the first page.
     @param parameters the parameter set to be used in the request
     @param task
     @param completionBlock
     */
    @objc public func documentList(withQueryParameters queryParameters: MendeleyDocumentParameters,
                                   task: MendeleyTask?,
                                   completionBlock: @escaping MendeleyArrayCompletionBlock) {
        var mergedQuery = queryParameters.valueStringDictionary()
        defaultQueryParameters.forEach { (key, value) in mergedQuery[key] = value }
        
        helper.mendeleyObjectList(ofType: MendeleyDocument.self,
                                  api: kMendeleyRESTAPIDocuments,
                                  queryParameters: mergedQuery,
                                  additionalHeaders: defaultServiceRequestHeaders,
                                  task: task,
                                  completionBlock: completionBlock)
    }
    
    /**
     obtains the first page of authored documents for another user.
     @param profileID profile ID of the user
     @param parameters the parameter set to be used in the request
     @param task
     @param completionBlock
     */
    @objc public func authoredDocumentList(forUserWithProfileID profileID: String,
                                           queryParameters: MendeleyDocumentParameters,
                                           task: MendeleyTask?,
                                           completionBlock: @escaping MendeleyArrayCompletionBlock) {
        queryParameters.profile_id = profileID
        queryParameters.authored = "true"
        var mergedQuery = queryParameters.valueStringDictionary()
        defaultQueryParameters.forEach { (key, value) in mergedQuery[key] = value }
        
        helper.mendeleyObjectList(ofType: MendeleyDocument.self,
                                  api: kMendeleyRESTAPIDocuments,
                                  queryParameters: mergedQuery,
                                  additionalHeaders: defaultServiceRequestHeaders,
                                  task: task,
                                  completionBlock: completionBlock)
    }
    
    /**
     obtains a document for given ID from the library
     @param documentID
     @param task
     @param completionBlock
     */
    @objc public func document(documentID: String,
                               task: MendeleyTask?,
                               completionBlock: @escaping MendeleyObjectCompletionBlock) {
        let apiEndPoint = String(format: kMendeleyRESTAPIDocumentWithID, documentID)
        
        helper.mendeleyObject(ofType: MendeleyDocument.self,
                              queryParameters: defaultViewQueryParameters,
                              api: apiEndPoint,
                              additionalHeaders: defaultServiceRequestHeaders,
                              task: task,
                              completionBlock: completionBlock)
    }
    
    /**
     This method returns a catalog document for a given catalog ID
     @param catalogID
     @param task
     @param completionBlock
     */
    @objc public func catalogDocument(withCatalogID catalogID: String,
                                      task: MendeleyTask?,
                                      completionBlock: @escaping MendeleyObjectCompletionBlock) {
        let apiEndPoint = String(format: kMendeleyRESTAPICatalogWithID, catalogID)

        helper.mendeleyObject(ofType: MendeleyCatalogDocument.self,
                              queryParameters: defaultCatalogViewQueryParameters,
                              api: apiEndPoint,
                              additionalHeaders: defaultServiceRequestHeaders,
                              task: task,
                              completionBlock: completionBlock)
    }
    
    /**
     This method obtains a list of documents based on a filter. The filter should not be nil or empty
     @param queryParameters
     @param task
     @param completionBlock
     */
    @objc public func catalogDocument(withParameters queryParameters: MendeleyCatalogParameters,
                                      task: MendeleyTask?,
                                      completionBlock: @escaping MendeleyArrayCompletionBlock) {
        let query = queryParameters.valueStringDictionary()
        
        helper.mendeleyObjectList(ofType: MendeleyCatalogDocument.self,
                                  api: kMendeleyRESTAPICatalog,
                                  queryParameters: query,
                                  additionalHeaders: defaultServiceRequestHeaders,
                                  task: task,
                                  completionBlock: completionBlock)
    }
    
    /**
     this creates a document based on the mendeley object model provided in the argument.
     The server will respond with the JSON data structure for the new object
     @param mendeleyDocument
     @param task
     @param completionBlock
     */
    @objc (createDocument:task:completionBlock:)
    public func create(document mendeleyDocument: MendeleyDocument,
                             task: MendeleyTask?,
                             completionBlock: @escaping MendeleyObjectCompletionBlock) {
        helper.create(mendeleyObject: mendeleyDocument,
                      api: kMendeleyRESTAPIDocuments,
                      additionalHeaders: defaultUploadRequestHeaders,
                      expectedType: MendeleyDocument.self,
                      task: task,
                      completionBlock: completionBlock)
    }
    
    /**
     modify/update a document with ID. The server will return a JSON object with the updated data
     @param updatedMendeleyDocument
     @param task
     @param completionBlock
     */
    @objc (updateDocument:task:completionBlock:)
    public func update(document updatedMendeleyDocument: MendeleyDocument,
                             task: MendeleyTask?,
                             completionBlock: @escaping MendeleyObjectCompletionBlock) {
        let apiEndPoint = String(format: kMendeleyRESTAPIDocumentWithID, updatedMendeleyDocument.object_ID ?? "")
        
        helper.update(mendeleyObject: updatedMendeleyDocument,
                      api: apiEndPoint,
                      additionalHeaders: defaultUploadRequestHeaders,
                      expectedType: MendeleyDocument.self,
                      task: task,
                      completionBlock: completionBlock)
    }
    
    /**
     this method will remove a document with given ID permanently. The document data cannot be retrieved.
     However, the user will be able to get a list of permanently removed IDs
     @param documentID
     @param task
     @param completionBlock
     */
    @objc (deleteDocumentWithID:task:completionBlock:)
    public func delete(documentWithID documentID: String,
                             task: MendeleyTask?,
                             completionBlock: @escaping MendeleyCompletionBlock) {
        let apiEndPoint = String(format: kMendeleyRESTAPIDocumentWithID, documentID)
        
        helper.deleteMendeleyObject(withAPI: apiEndPoint,
                                    task: task,
                                    completionBlock: completionBlock)
    }
    
    /**
     This method will move a document of given ID into the trash on the server. Data in trash can be restored
     (as opposed to using the deleteDocumentWithID:completionBlock: method which permanently removes them)
     @param documentID
     @param task
     @param completionBlock
     */
    @objc (trashDocumentWithID:task:completionBlock:)
    public func trash(documentWithID documentID: String,
                            task: MendeleyTask?,
                            completionBlock: @escaping MendeleyCompletionBlock) {
        let apiEndPoint = String(format: kMendeleyRESTAPIDocumentWithIDToTrash, documentID)
        
        networkProvider.invokePOST(baseAPIURL,
                                   api: apiEndPoint,
                                   additionalHeaders: defaultServiceRequestHeaders,
                                   bodyParameters: nil,
                                   isJSON: false,
                                   authenticationRequired: true,
                                   task: task) { (response, error) in
                                    let blockExec = MendeleyBlockExecutor(completionBlock: completionBlock)
                                    
                                    var error = error
                                    if self.helper.isSuccess(forResponse: response, error: &error) == false {
                                        blockExec?.execute(with: false, error: error)
                                    } else {
                                        blockExec?.execute(with: true, error: nil)
                                    }
        }
    }
    
    /**
     This method returns a list of document IDs that were permanently deleted. The list of deleted IDs will be kept on
     the server for a limited period of time.
     @param deletedSince
     @param task
     @param completionBlock
     */
    @objc public func deletedDocuments(since deletedSince: Date,
                                       groupID: String?,
                                       task: MendeleyTask?,
                                       completionBlock: @escaping MendeleyArrayCompletionBlock) {
        let deletedSinceString = MendeleyObjectHelper.jsonDateFormatter().string(from: deletedSince)
        var mergedQuery = [kMendeleyRESTAPIQueryDeletedSince: deletedSinceString]

        if let groupID = groupID {
            mergedQuery[kMendeleyRESTAPIQueryGroupID] = groupID
        }
        
        defaultQueryParametersWithoutViewParameter.forEach { (key, value) in mergedQuery[key] = value }
        
        networkProvider.invokeGET(baseAPIURL,
                                  api: kMendeleyRESTAPIDocuments,
                                  additionalHeaders: defaultServiceRequestHeaders,
                                  queryParameters: mergedQuery,
                                  authenticationRequired: true,
                                  task: task) { (response, error) in
                                    let blockExec = MendeleyBlockExecutor(arrayCompletionBlock: completionBlock)
                                    var error = error
                                    if self.helper.isSuccess(forResponse: response, error: &error) == false || response?.rawResponseBody == nil {
                                        blockExec?.execute(with: nil, syncInfo: nil, error: error)
                                    } else {
                                        let decoder = JSONDecoder()
                                        do {
                                            let arrayDict = try decoder.decode([String: [String]].self, from: response!.rawResponseBody)
                                            blockExec?.execute(with: arrayDict[kMendeleyJSONData], syncInfo: response?.syncHeader, error: nil)
                                        } catch {
                                            blockExec?.execute(with: nil, syncInfo: nil, error: error)
                                        }
                                    }
        }
    }
    
    /**
     This method obtains a list for a given page link of 'trashed' documents
     based on a list of query parameters.
     All required parameters are provided in the linkURL, which should not be modified
     
     @param linkURL the full HTTP link to the document listings page
     @param task
     @param completionBlock
     */
    @objc public func trashedDocumentList(withLinkedURL linkURL: URL,
                                          task: MendeleyTask?,
                                          completionBlock: @escaping MendeleyArrayCompletionBlock) {
        networkProvider.invokeGET(linkURL,
                                  additionalHeaders: defaultServiceRequestHeaders,
                                  queryParameters: defaultQueryParameters,
                                  authenticationRequired: true,
                                  task: task) { (response, error) in
                                    let blockExec = MendeleyBlockExecutor(arrayCompletionBlock: completionBlock)
                                    var error = error
                                    if self.helper.isSuccess(forResponse: response, error: &error) == false || response?.rawResponseBody == nil {
                                        blockExec?.execute(with: nil, syncInfo: nil, error: error)
                                    } else {
                                        let decoder = JSONDecoder()
                                        do {
                                            let arrayDict = try decoder.decode([String: [MendeleyDocument]].self, from: response!.rawResponseBody)
                                            blockExec?.execute(with: arrayDict[kMendeleyJSONData], syncInfo: response?.syncHeader, error: nil)
                                        } catch {
                                            blockExec?.execute(with: nil, syncInfo: nil, error: error)
                                        }
                                    }
        }
    }
    
    /**
     This method obtains a list for the 'first' page of 'trashed' documents
     based on a list of query parameters.
     @param parameters the parameter set to be used in the request
     @param task
     @param completionBlock
     */
    @objc public func trashedDocumentList(withQueryParameters queryParameters: MendeleyDocumentParameters,
                                          task: MendeleyTask?,
                                          completionBlock: @escaping MendeleyArrayCompletionBlock) {
        var mergedQuery = queryParameters.valueStringDictionary()
        
        defaultQueryParameters.forEach { (key, value) in mergedQuery[key] = value }
        
        helper.mendeleyObjectList(ofType: MendeleyDocument.self,
                                  api: kMendeleyRESTAPITrashedDocuments,
                                  queryParameters: mergedQuery,
                                  additionalHeaders: defaultServiceRequestHeaders,
                                  task: task,
                                  completionBlock: completionBlock)
    }
    
    /**
     this method will remove a trashed document with given ID permanently.
     The document data cannot be retrieved.
     However, the user will be able to get a list of permanently removed IDs
     @param documentID
     @param task
     @param completionBlock
     */
    @objc (deleteTrashedDocumentWithID:task:completionBlock:)
    public func delete(trashedDocumentWithID documentID: String,
                            task: MendeleyTask?,
                            completionBlock: @escaping MendeleyCompletionBlock) {
        let apiEndPoint = String(format: kMendeleyRESTAPITrashedDocumentWithID, documentID)
        
        helper.deleteMendeleyObject(withAPI: apiEndPoint,
                                    task: task,
                                    completionBlock: completionBlock)
    }
    
    /**
     this method will restore a trashed document.
     In essence this means the document must be retrieved using the /documents API
     @param documentID
     @param task
     @param completionBlock
     */
    @objc (restoreTrashedDocumentWithID:task:completionBlock:)
    public func restore(trashedDocumentWithID documentID: String,
                              task: MendeleyTask?,
                              completionBlock: @escaping MendeleyCompletionBlock) {
        let apiEndPoint = String(format: kMendeleyRESTAPIRestoreTrashedDocumentWithID, documentID)
        
        networkProvider.invokePOST(baseAPIURL,
                                   api: apiEndPoint,
                                   additionalHeaders: nil,
                                   bodyParameters: nil,
                                   isJSON: false,
                                   authenticationRequired: true,
                                   task: task) { (response, error) in
                                    let blockExec = MendeleyBlockExecutor(completionBlock: completionBlock)
                                    var error = error
                                    if self.helper.isSuccess(forResponse: response, error: &error) == false {
                                        blockExec?.execute(with: false, error: error)
                                    } else {
                                        blockExec?.execute(with: true, error: nil)
                                    }
        }
        
    }
    
    /**
     obtains a document for given ID from the library
     @param documentID
     @param task
     @param completionBlock
     */
    @objc public func trashedDocument(withDocumentID documentID: String,
                                      task: MendeleyTask?,
                                      completionBlock: @escaping MendeleyObjectCompletionBlock) {
        let apiEndPoint = String(format: kMendeleyRESTAPITrashedDocumentWithID, documentID)
        
        helper.mendeleyObject(ofType: MendeleyDocument.self,
                              queryParameters: defaultViewQueryParameters,
                              api: apiEndPoint,
                              additionalHeaders: defaultServiceRequestHeaders,
                              task: task,
                              completionBlock: completionBlock)
    }
    
    /**
     Method to obtain the supported document types (e.g. journal, book etc)
     @param task
     @param completionBlock
     */
    @objc public func documentTypes(withTask task: MendeleyTask?,
                                    completionBlock: @escaping MendeleyArrayCompletionBlock) {
        helper.mendeleyObjectList(ofType: MendeleyDocumentType.self,
                                  api: kMendeleyRESTAPIDocumentTypes,
                                  queryParameters: nil,
                                  additionalHeaders: nil,
                                  task: task,
                                  completionBlock: completionBlock)
    }
    
    /**
    / Method to obtain the supported identifier types (e.g. pmid, doi, arXiv etc)
     @param task
     @param completionBlock
     */
    @objc public func identifierTypes(withTask task: MendeleyTask?,
                                      completionBlock: @escaping MendeleyArrayCompletionBlock) {
        helper.mendeleyObjectList(ofType: MendeleyIdentifierType.self,
                                  api: kMendeleyRESTAPIIdentifierTypes,
                                  queryParameters: nil,
                                  additionalHeaders: nil,
                                  task: task,
                                  completionBlock: completionBlock)
    }
    
    /**
     uploads a file from a location and returns a Mendeley Document in the completion handler
     @param fileURL the location of the file
     @param mimeType e.g. 'application/pdf'
     @param task
     @param completionBlock
     */
    @objc public func document(fromFileWithURL fileURL: URL,
                               mimeType: String?,
                               task: MendeleyTask?,
                               completionBlock: @escaping MendeleyObjectCompletionBlock) {
        let mimeType = mimeType == nil ? kMendeleyRESTRequestValuePDF : mimeType!
        
        let filename = fileURL.lastPathComponent
        let contentDisposition = String(format: "%@; filename=\"%@\"", kMendeleyRESTRequestValueAttachment, filename)
        
        let header = [kMendeleyRESTRequestContentDisposition: contentDisposition,
                      kMendeleyRESTRequestContentType: mimeType,
                      kMendeleyRESTRequestAccept: kMendeleyRESTRequestJSONDocumentType]
        
        networkProvider.invokeUpload(forFileURL: fileURL,
                                     baseURL: baseAPIURL,
                                     api: kMendeleyRESTAPIDocuments,
                                     additionalHeaders: header,
                                     authenticationRequired: true,
                                     task: task,
                                     progressBlock: nil) { (response, error) in
                                        let blockExec = MendeleyBlockExecutor(objectCompletionBlock: completionBlock)
                                        
                                        var error = error
                                        if self.helper.isSuccess(forResponse: response, error: &error) == false || response?.rawResponseBody == nil {
                                            blockExec?.execute(withMendeleyObject: nil, syncInfo: nil, error: error)
                                        } else {
                                            let decoder = JSONDecoder()
                                            do {
                                                let documentDict = try decoder.decode([String: MendeleyDocument].self, from: response!.rawResponseBody)
                                                blockExec?.execute(withMendeleyObject: documentDict[kMendeleyJSONData], syncInfo: response?.syncHeader, error: nil)
                                            } catch {
                                                blockExec?.execute(withMendeleyObject: nil, syncInfo: nil, error: error)
                                            }
                                        }
        }
    }
    
    /**
     Method clones document metadata to a new group/lib. The returned metadata contain the user document metadata including the document ID for the cloned document
     @param document the document to be cloned
     @param toGroup the target group ID. Use nil if you want to clone to the users' library. In this case the profile ID must be provided
     @param toFolder the target folder ID.
     @param profileID must be provided if the groupID is nil (this means clone to user library). Otherwise values are ignored
     @param completionBlock
     */
    @objc (cloneDocumentWithID:groupID:folderID:profileID:task:completionBlock:)
    public func clone(documentWithID documentID: String,
                            groupID: String?,
                            folderID: String?,
                            profileID: String?,
                            task: MendeleyTask?,
                            completionBlock: @escaping MendeleyObjectCompletionBlock) {
        let blockExec = MendeleyBlockExecutor(objectCompletionBlock: completionBlock)
        var arguments = [String: String]()
        
        if groupID == nil && profileID == nil {
            let argumentError = MendeleyErrorManager.sharedInstance().error(withDomain: kMendeleyErrorDomain, code: MendeleyErrorCode.dataNotAvailableErrorCode.rawValue)
            blockExec?.execute(withMendeleyObject: nil, syncInfo: nil, error: argumentError)
            return
        }
        
        if let groupID = groupID {
            arguments[kMendeleyJSONGroupID] = groupID
        } else if let profileID = profileID {
            arguments[kMendeleyJSONUserID] = profileID
        }
        
        if let folderID = folderID {
            arguments[kMendeleyJSONFolderID] = folderID
        }
        
        if arguments.count == 0 {
            let argumentError = MendeleyErrorManager.sharedInstance().error(withDomain: kMendeleyErrorDomain, code: MendeleyErrorCode.dataNotAvailableErrorCode.rawValue)
            blockExec?.execute(withMendeleyObject: nil, syncInfo: nil, error: argumentError)
            return
        }
        
        let encoder = JSONEncoder()
        
        do {
            let jsonData = try encoder.encode(arguments)
            
            let apiEndPoint = String(format: kMendeleyRESTAPIDocumentCloneTo, documentID)
            
            networkProvider.invokePOST(baseAPIURL,
                                       api: apiEndPoint,
                                       additionalHeaders: defaultCloneDocumentHeaders,
                                       jsonData: jsonData,
                                       authenticationRequired: true,
                                       task: task) { (response, error) in
                                        var error = error
                                        if self.helper.isSuccess(forResponse: response, error: &error) == false || response?.rawResponseBody == nil {
                                            blockExec?.execute(withMendeleyObject: nil, syncInfo: nil, error: error)
                                        } else {
                                            let decoder = JSONDecoder()
                                            do {
                                                let documentDict = try decoder.decode([String: MendeleyDocument].self, from: response!.rawResponseBody)
                                                blockExec?.execute(withMendeleyObject: documentDict[kMendeleyJSONData], syncInfo: nil, error: nil)
                                            } catch {
                                                blockExec?.execute(withMendeleyObject: nil, syncInfo: nil, error: error)
                                            }
                                        }
            }
        } catch {
            blockExec?.execute(withMendeleyObject: nil, syncInfo: nil, error: error)
        }
    }
    
    /**
     Method clones files associated with a document from source to target.
     The target document must exist - otherwise the completionBlock will return an error
     @param document the source document with files
     @param toDocument the target document ID
     @param completionBlock
     */
    @objc (cloneDocumentFiles:targetDocumentID:task:completionBlock:)
    public func clone(documentFiles sourceDocumentID: String,
                            targetDocumentID: String,
                            task: MendeleyTask?,
                            completionBlock: @escaping MendeleyCompletionBlock) {
        let blockExec = MendeleyBlockExecutor(completionBlock: completionBlock)
        let apiEndPoint = String(format: kMendeleyRESTAPIDocumentCloneFilesTo, sourceDocumentID)
        
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(targetDocumentID)
            
            networkProvider.invokePOST(baseAPIURL,
                                       api: apiEndPoint,
                                       additionalHeaders: defaultCloneFileToHeaders,
                                       jsonData: jsonData,
                                       authenticationRequired: true,
                                       task: task) { (response, error) in
                                        if error == nil {
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
     Method clones document metadata to a new group/lib. It also clones any associated files from source to target document
     The returned metadata contain the user document metadata including the document ID for the cloned document
     @param document the document to be cloned
     @param toGroup the target group ID. Use nil if you want to clone to the users' library. In this case the profile ID must be provided
     @param toFolder the target folder ID.
     @param profileID must be provided if the groupID is nil (this means clone to user library). Otherwise values are ignored
     @param completionBlock
     */
    @objc (cloneDocumentAndFiles:groupID:folderID:profileID:task:completionBlock:)
    public func clone(documentAndFiles documentID: String,
                            groupID: String?,
                            folderID: String?,
                            profileID: String?,
                            task: MendeleyTask?,
                            completionBlock: @escaping MendeleyObjectCompletionBlock) {
        clone(documentWithID: documentID,
              groupID: groupID,
              folderID: folderID,
              profileID: profileID,
              task: task) { (mendeleyObject, syncInfo, error) in
                if error != nil {
                    completionBlock(nil, nil, error)
                } else {
                    guard let clonedDocumentID = mendeleyObject?.object_ID
                        else { completionBlock(nil, nil, error); return }
                    
                    self.clone(documentFiles: documentID,
                               targetDocumentID: clonedDocumentID,
                               task: task) { (success, error) in
                                if error == nil {
                                    completionBlock(mendeleyObject, syncInfo, nil)
                                } else {
                                    completionBlock(nil, nil, error)
                                }
                    }
                }
        }
    }
}
