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

@objc public protocol MendeleyKitHelperDelegate {
    var networkProvider: MendeleyNetworkProvider! { get set }
    var baseAPIURL: URL! { get set }
}

@objc public class MendeleyKitHelper: NSObject {
    private var delegate: MendeleyKitHelperDelegate?

    public override init() {
        super.init()
    }
    
    init(withDelegate delegate: MendeleyKitHelperDelegate) {
        self.delegate = delegate
    }
    
    // inout isn't translatable into Objective-C so provider convenience method for
    // older Objective-C methods.
    @objc public func isSuccess(forResponse response: MendeleyResponse?) throws -> NSNumber {
        var error: Error? = nil
        let success = isSuccess(forResponse: response, error: &error)
        
        if let error = error {
            throw error
        }
        
        return NSNumber(value: success)
    }
    
    func isSuccess(forResponse response: MendeleyResponse?, error: inout Error?) -> Bool {
        if response == nil {
            if error == nil {
                error = NSError(code: MendeleyErrorCode(rawValue: MendeleyErrorCode.dataNotAvailableErrorCode.rawValue)!)
            }
            return false
        } else if (error as NSError?)?.code == NSURLErrorCancelled {
            return false
        } else if response!.isSuccess == false {
            if error == nil {
                error = NSError(code: MendeleyErrorCode(rawValue: MendeleyErrorCode.responseTypeUnknownErrorCode.rawValue)!, localizedDescription: response?.responseMessage)
            }
            return false
        }
        
        return true
    }
    
    // MARK: - Get Object List
    
    func mendeleyObjectList<T: MendeleySecureObject & Decodable>
        (ofType type: T.Type,
         api: String,
         queryParameters: [String: Any]?,
         additionalHeaders: [String: Any]?,
         task: MendeleyTask?,
         completionBlock: @escaping MendeleyArrayCompletionBlock) {
        
        let blockExec = MendeleyBlockExecutor(arrayCompletionBlock: completionBlock)
        
        guard let networkProvider = delegate?.networkProvider, let baseURL = delegate?.baseAPIURL
            else { blockExec?.execute(with: nil, syncInfo: nil, error: nil); return }
        
        networkProvider.invokeGET(baseURL,
                                  api: api,
                                  additionalHeaders: additionalHeaders,
                                  queryParameters: queryParameters,
                                  authenticationRequired: true,
                                  task: task) { (response, error) in
                                    var error = error
                                    if self.isSuccess(forResponse: response, error: &error) == false || response?.rawResponseBody == nil {
                                        blockExec?.execute(with: nil, syncInfo: nil, error: error)
                                    } else {
                                        do {
                                            let decoder = JSONDecoder()
                                            let arrayDict = try decoder.decode([String: [T]].self, from: response!.rawResponseBody)
                                            blockExec?.execute(with: arrayDict[kMendeleyJSONData], syncInfo: response?.syncHeader, error: nil)
                                        } catch {
                                            print(error)
                                            blockExec?.execute(with: nil, syncInfo: response?.syncHeader, error: error)
                                        }
                                    }
        }
    }
    
    func mendeleyIDStringList(forAPI api: String,
                              queryParameters: [String: Any]?,
                              additionalHeaders: [String: Any]?,
                              task: MendeleyTask?,
                              completionBlock: @escaping MendeleyArrayCompletionBlock) {
        
        let blockExec = MendeleyBlockExecutor(arrayCompletionBlock: completionBlock)
        
        guard let networkProvider = delegate?.networkProvider, let baseURL = delegate?.baseAPIURL
            else { blockExec?.execute(with: nil, syncInfo: nil, error: nil); return }
        
        networkProvider.invokeGET(baseURL,
                                  api: api,
                                  additionalHeaders: additionalHeaders,
                                  queryParameters: queryParameters,
                                  authenticationRequired: true,
                                  task: task) { (response, error) in
                                    var error = error
                                    if self.isSuccess(forResponse: response, error: &error) == false || response?.rawResponseBody == nil {
                                        blockExec?.execute(with: nil, syncInfo: nil, error: error)
                                    } else {
                                        let decoder = JSONDecoder()
                                        
                                        do {
                                            let arrayDict = try decoder.decode([String: [[String: String]]].self, from: response!.rawResponseBody)
                                            blockExec?.execute(with: arrayDict[kMendeleyJSONData], syncInfo: response?.syncHeader, error: nil)
                                        } catch {
                                            blockExec?.execute(with: nil, syncInfo: nil, error: error)
                                        }
                                    }
        }
    }
    
    // MARK: - Get single Mendeley Object
    
    func mendeleyObject<T: MendeleySecureObject & Decodable>
        (ofType type: T.Type,
         queryParameters: [String: Any]?,
         api: String,
         additionalHeaders: [String: Any]?,
         task: MendeleyTask?,
         completionBlock: @escaping MendeleyObjectCompletionBlock) {
        
        let blockExec = MendeleyBlockExecutor(objectCompletionBlock: completionBlock)
        
        guard let networkProvider = delegate?.networkProvider, let baseURL = delegate?.baseAPIURL
            else { blockExec?.execute(withMendeleyObject: nil, syncInfo: nil, error: nil); return }
        
        networkProvider.invokeGET(baseURL,
                                  api: api,
                                  additionalHeaders: additionalHeaders,
                                  queryParameters: queryParameters,
                                  authenticationRequired: true,
                                  task: task) { (response, error) in
                                    var error = error
                                    if self.isSuccess(forResponse: response, error: &error) == false || response?.rawResponseBody == nil {
                                        blockExec?.execute(withMendeleyObject: nil, syncInfo: nil, error: error)
                                    } else {
                                        do {
                                            let decoder = JSONDecoder()
                                            let objectDict = try decoder.decode([String: T].self, from: response!.rawResponseBody)
                                            
                                            blockExec?.execute(withMendeleyObject: objectDict[kMendeleyJSONData], syncInfo: response?.syncHeader, error: nil)
                                        } catch {
                                            print(error)
                                            blockExec?.execute(withMendeleyObject: nil, syncInfo: response?.syncHeader, error: error)
                                        }
                                    }
        }
    }
    
    // MARK: - Create Mendeley Object
    
    func create<T: MendeleySecureObject & Encodable>
        (mendeleyObject: T,
         api: String,
         task: MendeleyTask?,
         completionBlock: @escaping MendeleyCompletionBlock) {
    
        let blockExec = MendeleyBlockExecutor(completionBlock: completionBlock)
        
        guard let networkProvider = delegate?.networkProvider, let baseURL = delegate?.baseAPIURL
            else { blockExec?.execute(with: false, error: nil); return }
    
        let encoder = JSONEncoder()
        
        do {
            let jsonData = try encoder.encode(mendeleyObject)
            
            networkProvider.invokePOST(baseURL,
                                       api: api,
                                       additionalHeaders: nil,
                                       jsonData: jsonData,
                                       authenticationRequired: true,
                                       task: task) { (response, error) in
                                        var error = error
                                        if self.isSuccess(forResponse: response, error: &error) == false {
                                            blockExec?.execute(with: false, error: error)
                                        } else {
                                            blockExec?.execute(with: true, error: nil)
                                        }
            }
        } catch {
            blockExec?.execute(with: false, error: error)
        }
    }
    
    func create<T: MendeleySecureObject & Encodable, U: MendeleySecureObject & Decodable>
        (mendeleyObject: T,
         api: String,
         additionalHeaders: [String: Any]?,
         expectedType: U.Type,
         task: MendeleyTask?,
         completionBlock: @escaping MendeleyObjectCompletionBlock) {
        
        let blockExec = MendeleyBlockExecutor(objectCompletionBlock: completionBlock)
        
        guard let networkProvider = delegate?.networkProvider, let baseURL = delegate?.baseAPIURL
            else { blockExec?.execute(with: false, error: nil); return }
        
        let encoder = JSONEncoder()
        
        do {
            let jsonData = try encoder.encode(mendeleyObject)
            
            networkProvider.invokePOST(baseURL,
                                       api: api,
                                       additionalHeaders: nil,
                                       jsonData: jsonData,
                                       authenticationRequired: true,
                                       task: task) { (response, error) in
                                        var error = error
                                        if self.isSuccess(forResponse: response, error: &error) == false || response?.rawResponseBody == nil {
                                            blockExec?.execute(withMendeleyObject: nil, syncInfo: nil, error: error)
                                        } else {
                                            let decoder = JSONDecoder()
                                            do {
                                                let objectDict = try decoder.decode([String: U].self, from: response!.rawResponseBody)
                                                
                                                blockExec?.execute(withMendeleyObject: objectDict[kMendeleyJSONData], syncInfo: response?.syncHeader, error: nil)
                                            } catch {
                                                blockExec?.execute(withMendeleyObject: nil, syncInfo: nil, error: error)
                                            }
                                        }
            }
        } catch {
            blockExec?.execute(withMendeleyObject: nil, syncInfo: nil, error: error)
        }
    }
    
    func create(withAPI api: String,
                task: MendeleyTask?,
                completionBlock: @escaping MendeleyCompletionBlock) {
        let blockExec = MendeleyBlockExecutor(completionBlock: completionBlock)
        
        guard let networkProvider = delegate?.networkProvider, let baseURL = delegate?.baseAPIURL
            else { blockExec?.execute(with: false, error: nil); return }
        
        networkProvider.invokePOST(baseURL,
                                   api: api,
                                   additionalHeaders: nil,
                                   jsonData: nil,
                                   authenticationRequired: true,
                                   task: task) { (response, error) in
                                    var error = error
                                    if self.isSuccess(forResponse: response, error: &error) == false {
                                        blockExec?.execute(with: false, error: error)
                                    } else {
                                        blockExec?.execute(with: true, error: nil)
                                    }
        }
    }
    
    // MARK: - Update Mendeley Object
    
    func update<T: MendeleySecureObject & Encodable>
        (mendeleyObject: T,
         api: String,
         additionalHeaders: [String: Any]?,
         task: MendeleyTask?,
         completionBlock: @escaping MendeleyCompletionBlock) {
        
        let blockExec = MendeleyBlockExecutor(completionBlock: completionBlock)
        
        guard let networkProvider = delegate?.networkProvider, let baseURL = delegate?.baseAPIURL
            else { blockExec?.execute(with: false, error: nil); return }
        
        let encoder = JSONEncoder()
        
        do {
            let jsonData = try encoder.encode(mendeleyObject)
            
            networkProvider.invokePATCH(baseURL,
                                        api: api,
                                        additionalHeaders: additionalHeaders,
                                        jsonData: jsonData,
                                        authenticationRequired: true,
                                        task: task) { (response, error) in
                                            var error = error
                                            if self.isSuccess(forResponse: response, error: &error) == false {
                                                blockExec?.execute(with: false, error: error)
                                            } else {
                                                blockExec?.execute(with: true, error: nil)
                                            }
            }
        } catch {
            blockExec?.execute(with: false, error: error)
        }
    }
    
    func update<T: MendeleySecureObject & Encodable, U: MendeleySecureObject & Decodable>
        (mendeleyObject: T,
         api: String,
         additionalHeaders: [String: Any]?,
         expectedType: U.Type,
         task: MendeleyTask?,
         completionBlock: @escaping MendeleyObjectCompletionBlock) {

        let blockExec = MendeleyBlockExecutor(objectCompletionBlock: completionBlock)

        guard let networkProvider = delegate?.networkProvider, let baseURL = delegate?.baseAPIURL
            else { blockExec?.execute(withMendeleyObject: nil, syncInfo: nil, error: nil); return }

        let encoder = JSONEncoder()

        do {
            let jsonData = try encoder.encode(mendeleyObject)

            networkProvider.invokePATCH(baseURL,
                                        api: api,
                                        additionalHeaders: additionalHeaders,
                                        jsonData: jsonData,
                                        authenticationRequired: true,
                                        task: task) { (response, error) in
                                            var error = error
                                            if self.isSuccess(forResponse: response, error: &error) == false {
                                                blockExec?.execute(withMendeleyObject: nil, syncInfo: nil, error: error)
                                            } else {
                                                let decoder = JSONDecoder()

                                                do {
                                                    let objectDict = try decoder.decode([String: U].self, from: response!.rawResponseBody)

                                                    blockExec?.execute(withMendeleyObject: objectDict[kMendeleyJSONData], syncInfo: response?.syncHeader, error: nil)
                                                } catch {
                                                    blockExec?.execute(withMendeleyObject: nil, syncInfo: nil, error: error)
                                                }
                                            }
            }
        } catch {
            blockExec?.execute(withMendeleyObject: nil, syncInfo: nil, error: error)
        }
    }
    
    // MARK: - Delete Mendeley Object
    
    func deleteMendeleyObject(withAPI api: String,
                              task: MendeleyTask?,
                              completionBlock: @escaping MendeleyCompletionBlock) {
        let blockExec = MendeleyBlockExecutor(completionBlock: completionBlock)
        
        guard let networkProvider = delegate?.networkProvider, let baseURL = delegate?.baseAPIURL
            else { blockExec?.execute(with: false, error: nil); return }
        
        networkProvider.invokeDELETE(baseURL,
                                     api: api,
                                     additionalHeaders: nil,
                                     bodyParameters: nil,
                                     authenticationRequired: true,
                                     task: task) { (response, error) in
                                        var error = error
                                        if self.isSuccess(forResponse: response, error: &error) == false {
                                            blockExec?.execute(with: false, error: error)
                                        } else {
                                            blockExec?.execute(with: true, error: nil)
                                        }
        }
    }
    
    // MARK: - Download file
    
    func downloadFile(withAPI api: String,
                      saveToURL fileURL: URL,
                      task: MendeleyTask?,
                      progressBlock: MendeleyResponseProgressBlock?,
                      completionBlock: @escaping MendeleyCompletionBlock) {
        
        let blockExec = MendeleyBlockExecutor(completionBlock: completionBlock)
        
        guard let networkProvider = delegate?.networkProvider, let baseURL = delegate?.baseAPIURL
            else { blockExec?.execute(with: false, error: nil); return }
        
        networkProvider.invokeDownload(toFileURL: fileURL,
                                       baseURL: baseURL,
                                       api: api,
                                       additionalHeaders: nil,
                                       queryParameters: nil,
                                       authenticationRequired: true,
                                       task: task,
                                       progressBlock: progressBlock) { (response, error) in
                                        var error = error
                                        if self.isSuccess(forResponse: response, error: &error) == false {
                                            do {
                                            try response?.parseFailureResponse(fromFileDownloadURL: fileURL)
                                                blockExec?.execute(with: false, error: error)
                                            } catch {
                                                blockExec?.execute(with: false, error: error)
                                            }
                                        } else if FileManager.default.fileExists(atPath: fileURL.path) == false {
                                            let pathError = NSError(code:  MendeleyErrorCode.pathNotFoundErrorCode)
                                            blockExec?.execute(with: false, error: pathError)
                                        } else {
                                            blockExec?.execute(with: true, error: nil)
                                        }
        }
    }
}
