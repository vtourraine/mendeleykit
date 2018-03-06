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

@objc open class MendeleyDatasetsAPI: MendeleyObjectAPI {
    /**
     @name MendeleyDatasetsAPI
     This class provides access methods to the REST datasets API
     All of the methods are accessed via MendeleyKit.
     Developers should use the methods provided in MendeleyKit rather
     than the methods listed here.
     */
    
    private let defaultServiceRequestHeaders = [kMendeleyRESTRequestAccept: kMendeleyRESTRequestJSONDatasetType]
    
    private let licencesServiceRequestHeaders = [kMendeleyRESTRequestAccept: kMendeleyRESTRequestJSONLicenceInfoType]

    private var defaultQueryParameters: [String: String] {
        return MendeleyDatasetParameters().valueStringDictionary()
    }
    
    private var defaultViewQueryParameters: [String: String]? {
        return nil
    }
    
    /**
     obtains a list of datasets for the first page.
     @param parameters the parameter set to be used in the request
     @param task
     @param completionBlock
     */
    @objc public func datasetList(withQueryParameters queryParameters: MendeleyDatasetParameters,
                                  task: MendeleyTask?,
                                  completionBlock: @escaping MendeleyArrayCompletionBlock) {
        var mergedQuery = queryParameters.valueStringDictionary()
        defaultQueryParameters.forEach { (key, value) in mergedQuery[key] = value }
        
        helper.mendeleyObjectList(ofType: MendeleyDataset.self,
                                  api: kMendeleyRESTAPIDatasets,
                                  queryParameters: mergedQuery,
                                  additionalHeaders: defaultServiceRequestHeaders,
                                  task: task,
                                  completionBlock: completionBlock)
    }
    
    /**
     This method is only used when paging through a list of datasets on the server.
     All required parameters are provided in the linkURL, which should not be modified
     
     @param linkURL the full HTTP link to the dataset listings page
     @param task
     @param completionBlock
     */
    @objc public func datasetList(withLinkedURL linkURL: URL,
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
                                            let arrayDict = try decoder.decode([String: [MendeleyDataset]].self, from: response!.rawResponseBody)
                                            blockExec?.execute(with: arrayDict[kMendeleyJSONData], syncInfo: response?.syncHeader, error: nil)
                                        } catch {
                                            blockExec?.execute(with: nil, syncInfo: nil, error: error)
                                        }
                                    }
        }
    }
    
    /**
     obtains a dataset for given ID from the library
     @param datasetID
     @param task
     @param completionBlock
     */
    @objc public func dataset(withDatasetID datasetID: String,
                              task: MendeleyTask?,
                              completionBlock: @escaping MendeleyObjectCompletionBlock) {
        let apiEndPoint = String(format: kMendeleyRESTAPIDatasetWithID, datasetID)
        
        helper.mendeleyObject(ofType: MendeleyDataset.self,
                              queryParameters: defaultViewQueryParameters,
                              api: apiEndPoint,
                              additionalHeaders: defaultServiceRequestHeaders,
                              task: task,
                              completionBlock: completionBlock)
    }
    
    /**
     Creates a dataset based on the mendeley object model provided in the argument.
     The server will respond with the JSON data structure for the new object
     @param mendeleyDataset The dataset model
     @param task The networking task
     @param completionBlock The completion block
     */
    @objc (createDataset:task:completionBlock:)
    public func create(dataset mendeleyDataset: MendeleyDataset,
                             task: MendeleyTask?,
                             completionBlock: @escaping MendeleyObjectCompletionBlock) {
        let header = [kMendeleyRESTRequestContentType: kMendeleyRESTRequestJSONDatasetCreationRequestType]
        
        helper.create(mendeleyObject: mendeleyDataset,
                      api: kMendeleyRESTAPIDatasetsDrafts,
                      additionalHeaders: header,
                      expectedType: MendeleyDataset.self,
                      task: task,
                      completionBlock: completionBlock)
    }
    
    /**
     creates a dataset file by uploading a file, and configuring the file metadata object with the uploaded file ticket (you can then use these file metadata objects to create or update a dataset)
     @param fileURL The local URL of the file to upload
     @param filename The file name for the uploaded file (optional)
     @param contentType The file MIME type (optional)
     @param task The network task
     @param progressBlock The progress block
     @param completionBlock The completion block
     */
    @objc (createDatasetFile:filename:contentType:task:progressBlock:completionBlock:)
    public func create(datasetFile fileURL: URL,
                             filename: String?,
                             contentType: String?,
                             task: MendeleyTask?,
                             progressBlock: MendeleyResponseProgressBlock?,
                             completionBlock: @escaping MendeleyObjectCompletionBlock) {
        var additionalHeaders = [String: Any]()
        
        if let filename = filename {
            let fileAttachment = String(format: "; filename=\"%@\"", filename)
            let contentDisposition = kMendeleyRESTRequestValueAttachment + fileAttachment
            additionalHeaders[kMendeleyRESTRequestContentDisposition] = contentDisposition
        }
        
        if let contentType = contentType {
            additionalHeaders[kMendeleyRESTRequestContentType] = contentType
        }
        
        networkProvider.invokeUpload(forFileURL: fileURL,
                                     baseURL: baseAPIURL,
                                     api: kMendeleyRESTAPIFileContents,
                                     additionalHeaders: additionalHeaders,
                                     authenticationRequired: true,
                                     task: task,
                                     progressBlock: progressBlock) { (response, error) in
                                        let blockExec = MendeleyBlockExecutor(objectCompletionBlock: completionBlock)
                                        var error = error
                                        if self.helper.isSuccess(forResponse: response, error: &error) == false || response?.rawResponseBody == nil {
                                            blockExec?.execute(withMendeleyObject: nil, syncInfo: nil, error: error)
                                        } else {
                                            let decoder = JSONDecoder()
                                            do {
                                                let objectDict = try decoder.decode([String: MendeleyContentTicket].self, from: response!.rawResponseBody)
                                                blockExec?.execute(withMendeleyObject: objectDict[kMendeleyJSONData], syncInfo: response!.syncHeader, error: nil)
                                            } catch {
                                                blockExec?.execute(withMendeleyObject: nil, syncInfo: nil, error: error)
                                            }
                                        }
        }
    }
    
    /**
     obtains a list of licences that can be applied to datasets
     @param task
     @param completionBlock
     */
    @objc public func datasetLicencesList(withTask task: MendeleyTask?,
                                          completionBlock: @escaping MendeleyArrayCompletionBlock) {
        helper.mendeleyObjectList(ofType: MendeleyLicenceInfo.self,
                                  api: kMendeleyRESTAPIDatasetsLicences,
                                  queryParameters: nil,
                                  additionalHeaders: licencesServiceRequestHeaders,
                                  task: task,
                                  completionBlock: completionBlock)
    }
}
