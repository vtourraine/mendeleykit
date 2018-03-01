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

@objc open class MendeleyFilesAPI: MendeleySwiftObjectAPI {
    /**
     @name MendeleyFilesAPI
     This class provides access methods to the REST file API
     All of the methods are accessed via MendeleyKit.
     Developers should use the methods provided in MendeleyKit rather
     than the methods listed here.
     */
    
    private let defaultServiceRequestHeaders = [kMendeleyRESTRequestAccept: kMendeleyRESTRequestJSONFileType]
        
    private let recentlyReadServiceHeaders = [kMendeleyRESTRequestContentType: kMendeleyRESTRequestJSONRecentlyRead,
    kMendeleyRESTRequestAccept: kMendeleyRESTRequestJSONRecentlyRead]
    
    private var defaultQueryParameters: [String: String] {
        return MendeleyFileParameters().valueStringDictionary()
    }
    
    private func uploadFileHeaders(withLinkRel linkRel: String,
                                   filename: String?,
                                   contentType: String?) -> [String: String] {
        let fileAttachment = filename == nil ? String(format: "; filename=\"example.pdf\"") : String(format: "; filename=\"%@\"", filename!)
        
        let type = contentType == nil ? kMendeleyRESTRequestValuePDF : contentType!
        
        let contentDisposition = kMendeleyRESTRequestValueAttachment + fileAttachment
        
        return [kMendeleyRESTRequestContentDisposition: contentDisposition,
                kMendeleyRESTRequestContentType: type,
                kMendeleyRESTRequestLink: linkRel,
                kMendeleyRESTRequestAccept: kMendeleyRESTRequestJSONFileType]
    }
    
    /**
     obtains a list of files for the first page.
     @param parameters the parameter set to be used in the request
     @param task
     @param completionBlock
     */
    @objc public func fileList(withQueryParameters queryParameters: MendeleyFileParameters,
                               task: MendeleyTask?,
                               completionBlock: @escaping MendeleyArrayCompletionBlock) {
        var mergedQuery = queryParameters.valueStringDictionary()
        
        defaultQueryParameters.forEach { (key, value) in mergedQuery[key] = value }
        
        helper.mendeleyObjectList(ofType: MendeleyFile.self,
                                  api: kMendeleyRESTAPIFiles,
                                  queryParameters: mergedQuery,
                                  additionalHeaders: defaultServiceRequestHeaders,
                                  task: task,
                                  completionBlock: completionBlock)
    }
    
    /**
     obtains a file for given ID from the library
     @param fileID
     @param fileURL
     @param task
     @param progressBlock
     @param completionBlock
     */
    @objc public func file(withFileID fileID: String,
                           saveToURL fileURL: URL,
                           task: MendeleyTask?,
                           progressBlock: MendeleyResponseProgressBlock?,
                           completionBlock: @escaping MendeleyCompletionBlock) {
        let apiEndPoint = String(format: kMendeleyRESTAPIFileWithID, fileID)
        
        helper.downloadFile(withAPI: apiEndPoint,
                            saveToURL: fileURL,
                            task: task,
                            progressBlock: progressBlock,
                            completionBlock: completionBlock)
    }
    
    /**
     this creates a file based on the mendeley object model provided in the argument.
     The server will respond with the JSON data structure for the new object
     @param fileURL
     @param filename the name of the file to be given when uploading. maybe different from fileURL
     @param contentType the contentType to be used. If none is provided, PDF will be taken
     @param documentURLPath
     @param task
     @param progressBlock
     @param completionBlock
     */
    @objc public func create(file fileURL: URL,
                             filename: String,
                             contentType: String,
                             relativeToDocumentURLPath documentURLPath: String,
                             task: MendeleyTask?,
                             progressBlock: MendeleyResponseProgressBlock?,
                             completionBlock: @escaping MendeleyObjectCompletionBlock) {
        let linkRel = String(format: "<%@>; rel=\"document\"", documentURLPath)
        let uploadHeader = uploadFileHeaders(withLinkRel: linkRel,
                                             filename: filename,
                                             contentType: contentType)
        
        networkProvider.invokeUpload(forFileURL: fileURL,
                                     baseURL: baseAPIURL,
                                     api: kMendeleyRESTAPIFiles,
                                     additionalHeaders: uploadHeader,
                                     authenticationRequired: true,
                                     task: task,
                                     progressBlock: progressBlock) { (response, error) in
                                        let blockExec = MendeleyBlockExecutor(objectCompletionBlock: completionBlock)
                                        let (success, combinedError) = self.helper.isSuccess(forResponse: response, error: error)
                                        if success == false || response?.rawResponseBody == nil {
                                            blockExec?.execute(withMendeleyObject: nil, syncInfo: nil, error: combinedError)
                                        } else {
                                            let decoder = JSONDecoder()
                                            do {
                                                let fileDict = try decoder.decode([String: MendeleyFile].self, from: response!.rawResponseBody)
                                                blockExec?.execute(withMendeleyObject: fileDict[kMendeleyJSONData], syncInfo: response?.syncHeader, error: nil)
                                            } catch {
                                                blockExec?.execute(withMendeleyObject: nil, syncInfo: nil, error: error)
                                            }
                                        }
        }
    }
    
    
    /**
     this method will remove a file with given ID permanently. The file data cannot be retrieved.
     However, the user will be able to get a list of permanently removed IDs
     @param documentID
     @param task
     @param completionBlock
     */
    @objc public func delete(fileWithID fileID: String,
                             task: MendeleyTask?,
                             completionBlock: @escaping MendeleyCompletionBlock) {
        let apiEndPoint = String(format: kMendeleyRESTAPIFileWithID, fileID)
        
        helper.deleteMendeleyObject(withAPI: apiEndPoint,
                                    task: task,
                                    completionBlock: completionBlock)
    }
    
    /**
     @param linkURL
     @param task
     @param completionBlock
     */
    @objc public func fileList(withLinkedURL linkURL: URL,
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
                                            let arrayDict = try decoder.decode([String: [MendeleyFile]].self, from: response!.rawResponseBody)
                                            blockExec?.execute(with: arrayDict[kMendeleyJSONData], syncInfo: response?.syncHeader, error: nil)
                                        } catch {
                                            blockExec?.execute(with: nil, syncInfo: nil, error: error)
                                        }
                                    }
                                    
        }
    }
    
    /**
     This method returns a list of files IDs that were permanently deleted. The list of deleted IDs will be kept on
     the server for a limited period of time.
     @param deletedSince the parameter set to be used in the request
     @param task
     @param completionBlock
     */
    @objc public func deletedFiles(since deletedSince: Date,
                                   groupID: String?,
                                   task: MendeleyTask?,
                                   completionBlock: @escaping MendeleyArrayCompletionBlock) {
        let deletedSinceString = MendeleyObjectHelper.jsonDateFormatter().string(from: deletedSince)
        
        var mergedQuery = [kMendeleyRESTAPIQueryDeletedSince : deletedSinceString]
        if groupID != nil {
            mergedQuery[kMendeleyRESTAPIQueryGroupID] = groupID
        }
        defaultQueryParameters.forEach { (key, value) in mergedQuery[key] = value }
        
        networkProvider.invokeGET(baseAPIURL,
                                  api: kMendeleyRESTAPIFiles,
                                  additionalHeaders: defaultServiceRequestHeaders,
                                  queryParameters: mergedQuery,
                                  authenticationRequired: true,
                                  task: task) { (response, error) in
                                    let blockExec = MendeleyBlockExecutor(arrayCompletionBlock: completionBlock)
                                    let (success, combinedError) = self.helper.isSuccess(forResponse: response, error: error)
                                    
                                    if success == false || response?.rawResponseBody == nil {
                                        blockExec?.execute(with: nil, syncInfo: nil, error: combinedError)
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
     This method returns a list of recently showed files on any device running a version
     of Mendeley (or a third part app) that support this feature.
     The objects are sorted by date with the most recent first.
     By default 20 items are returned.
     The number of records saved on the server is limited.
     @param queryParameters the parameter set to be used in the request
     @param task
     @param completionBlock
     */
    @objc public func recentlyRead(withParameters queryParameters: MendeleyRecentlyReadParameters,
                                   task: MendeleyTask?,
                                   completionBlock: @escaping MendeleyArrayCompletionBlock) {
        networkProvider.invokeGET(baseAPIURL,
                                  api: kMendeleyRESTAPIRecentlyRead,
                                  additionalHeaders: recentlyReadServiceHeaders,
                                  queryParameters: queryParameters.valueStringDictionary(),
                                  authenticationRequired: true,
                                  task: task) { (response, error) in
                                    let blockExec = MendeleyBlockExecutor(arrayCompletionBlock: completionBlock)
                                    let (success, combinedError) = self.helper.isSuccess(forResponse: response, error: error)
                                    
                                    if success == false || response?.rawResponseBody == nil {
                                        blockExec?.execute(with: nil, syncInfo: nil, error: combinedError)
                                    } else {
                                        let decoder = JSONDecoder()
                                        do {
                                            let arrayDict = try decoder.decode([String: [MendeleyRecentlyRead]].self, from: response!.rawResponseBody)
                                            blockExec?.execute(with: arrayDict[kMendeleyJSONData], syncInfo: response?.syncHeader, error: nil)
                                        } catch {
                                            blockExec?.execute(with: nil, syncInfo: nil, error: error)
                                        }
                                    }
        }
    }
    
    /**
     This method create/replace an entry of recently read for a file.
     Any existing entry with a matching id if present is removed, and a new one is created.
     The new one is inserted into the list at a position determined by the
     current server time or at the time provided by the client if specified.
     @param recentlyRead the recently read object to create
     @param task
     @param completionBlock
     */
    @objc public func add(recentlyRead: MendeleyRecentlyRead,
                          task: MendeleyTask?,
                          completionBlock: @escaping MendeleyObjectCompletionBlock) {
        let blockExec = MendeleyBlockExecutor(objectCompletionBlock: completionBlock)
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(recentlyRead)
            
            networkProvider.invokePOST(baseAPIURL,
                                       api: kMendeleyRESTAPIRecentlyRead,
                                       additionalHeaders: recentlyReadServiceHeaders,
                                       jsonData: jsonData,
                                       authenticationRequired: true,
                                       task: task) { (response, error) in
                                        let (success, combinedError) = self.helper.isSuccess(forResponse: response, error: error)
                                        
                                        if success == false || response?.rawResponseBody == nil {
                                            blockExec?.execute(withMendeleyObject: nil, syncInfo: nil, error: combinedError)
                                        } else {
                                            let decoder = JSONDecoder()
                                            do {
                                                let recentlyReadDict = try decoder.decode([String: MendeleyRecentlyRead].self, from: response!.rawResponseBody)
                                                blockExec?.execute(withMendeleyObject: recentlyReadDict[kMendeleyJSONData], syncInfo: response?.syncHeader, error: nil)
                                            } catch {
                                                blockExec?.execute(withMendeleyObject: nil, syncInfo: nil, error: error)
                                            }
                                        }
            }
        } catch {
            blockExec?.execute(withMendeleyObject: nil, syncInfo: nil, error: error)
        }
        
    }
}
