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

@objc open class MendeleyAnnotationsAPI: MendeleySwiftObjectAPI {
    /**
     @name MendeleyAnnotationsAPI
     This class provides access methods to the REST annotations API
     All of the methods are accessed via MendeleyKit.
     Developers should use the methods provided in MendeleyKit rather
     than the methods listed here.
     */
    
    private let defaultServiceRequestHeaders = [kMendeleyRESTRequestAccept: kMendeleyRESTRequestJSONAnnotationType]
    private let defaultUploadRequestHeaders = [kMendeleyRESTRequestAccept: kMendeleyRESTRequestJSONAnnotationType,
    kMendeleyRESTRequestContentType: kMendeleyRESTRequestJSONAnnotationType]
    
    private var defaultQueryParameters: [String: String] {
        return MendeleyAnnotationParameters().valueStringDictionary()
    }

    /**
     @param annotationID
     @param task
     @param completionBlock
     */
    @objc public func annotation(withAnnotationID annotationID: String,
                                 task: MendeleyTask?,
                                 completionBlock: @escaping MendeleyObjectCompletionBlock) {
        let apiEndPoint = String(format: kMendeleyRESTAPIAnnotationWithID, annotationID)
        
        helper.mendeleyObject(ofType: MendeleyAnnotation.self,
                              queryParameters: nil,
                              api: apiEndPoint,
                              additionalHeaders: defaultServiceRequestHeaders,
                              task: task,
                              completionBlock: completionBlock)
    }
    
    /**
     @param annotationID
     @param task
     @param completionBlock
     */
    @objc public func delete(annotationWithID annotationID: String,
                             task: MendeleyTask?,
                             completionBlock: @escaping MendeleyCompletionBlock) {
        let apiEndPoint = String(format: kMendeleyRESTAPIAnnotationWithID, annotationID)
        
        helper.deleteMendeleyObject(withAPI: apiEndPoint,
                                    task: task,
                                    completionBlock: completionBlock)
    }
    
    /**
     @param updatedMendeleyAnnotation
     @param task
     @param completionBlock
     */
    @objc public func update(annotation updatedMendeleyAnnotation: MendeleyAnnotation,
                             task: MendeleyTask?,
                             completionBlock: @escaping MendeleyObjectCompletionBlock) {
        let apiEndPoint = String(format: kMendeleyRESTAPIAnnotationWithID, updatedMendeleyAnnotation.object_ID ?? "")
        
        helper.update(mendeleyObject: updatedMendeleyAnnotation,
                      api: apiEndPoint,
                      additionalHeaders: defaultUploadRequestHeaders,
                      expectedType: MendeleyAnnotation.self,
                      task: task,
                      completionBlock: completionBlock)
    }
    
    /**
     @param mendeleyAnnotation
     @param task
     @param completionBlock
     */
    @objc public func create(annotation mendeleyAnnotation: MendeleyAnnotation,
                             task: MendeleyTask?,
                             completionBlock: @escaping MendeleyObjectCompletionBlock) {
        helper.create(mendeleyObject: mendeleyAnnotation,
                      api: kMendeleyRESTAPIAnnotations,
                      additionalHeaders: defaultUploadRequestHeaders,
                      expectedType: MendeleyAnnotation.self,
                      task: task,
                      completionBlock: completionBlock)
    }
    
    /**
     @param linkURL
     @param task
     @param completionBlock
     */
    @objc public func annotationList(withLinkedURL linkURL: URL,
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
                        let arrayDict = try decoder.decode([String: [MendeleyAnnotation]].self, from: response!.rawResponseBody)
                        blockExec?.execute(with: arrayDict[kMendeleyJSONData], syncInfo: response?.syncHeader, error: nil)
                    } catch {
                        blockExec?.execute(with: nil, syncInfo: nil, error: error)
                    }
                }
        }
    }
    
    /**
     @param queryParameters
     @param task
     @param completionBlock
     */
    @objc public func annotationList(withQueryParameters queryParameters: MendeleyAnnotationParameters,
                                     task: MendeleyTask?,
                                     completionBlock: @escaping MendeleyArrayCompletionBlock) {
        var mergedQuery = queryParameters.valueStringDictionary()
        defaultQueryParameters.forEach { (key, value) in mergedQuery[key] = value }
        
        helper.mendeleyObjectList(ofType: MendeleyAnnotation.self,
                                  api: kMendeleyRESTAPIAnnotations,
                                  queryParameters: mergedQuery,
                                  additionalHeaders: defaultServiceRequestHeaders,
                                  task: task,
                                  completionBlock: completionBlock)
    }
    
    /**
     This method returns a list of annotations IDs that were permanently deleted. The list of deleted IDs will be kept on
     the server for a limited period of time.
     @param deletedSince the parameter set to be used in the request
     @param task
     @param completionBlock
     */
    @objc public func deletedAnnotations(since deletedSince: Date,
                                         groupID: String?,
                                         task: MendeleyTask?,
                                         completionBlock: @escaping MendeleyArrayCompletionBlock) {
        let deletedSinceString = MendeleyObjectHelper.jsonDateFormatter().string(from: deletedSince)
        var mergedQuery = [kMendeleyRESTAPIQueryDeletedSince: deletedSinceString]
        
        if let groupID = groupID {
            mergedQuery[kMendeleyRESTAPIQueryGroupID] = groupID
        }
        defaultQueryParameters.forEach { (key, value) in mergedQuery[key] = value }
        
        networkProvider.invokeGET(baseAPIURL,
                                  api: kMendeleyRESTAPIAnnotations,
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
}
