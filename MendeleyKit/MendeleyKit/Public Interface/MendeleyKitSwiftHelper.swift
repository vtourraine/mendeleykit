//
//  MendeleyKitSwiftHelper.swift
//  MendeleyKit
//
//  Created by Tunney, Aaron (ELS) on 21/02/2018.
//  Copyright © 2018 Mendeley. All rights reserved.
//

import UIKit

protocol MendeleyKitSwiftHelperDelegate {
    var networkProvider: MendeleyNetworkProvider? { get set }
    var baseAPIURL: URL? { get set }
}

class MendeleyKitSwiftHelper {
    private var delegate: MendeleyKitSwiftHelperDelegate?
    
    init(withDelegate delegate: MendeleyKitSwiftHelperDelegate) {
        self.delegate = delegate
    }
    
    func isSuccess(forResponse response: MendeleyResponse?, error: Error?) -> (Bool, Error?) {
        var returnedError = error
        
        if response == nil {
            if error == nil {
                returnedError = NSError(code: MendeleyErrorCode(rawValue: MendeleyErrorCode.dataNotAvailableErrorCode.rawValue)!)
            }
            return (false, returnedError)
        } else if (error as NSError?)?.code == NSURLErrorCancelled {
            return (false, returnedError)
        } else if response!.isSuccess == false {
            if error == nil {
                returnedError = NSError(code: MendeleyErrorCode(rawValue: MendeleyErrorCode.responseTypeUnknownErrorCode.rawValue)!, localizedDescription: response?.responseMessage)
            }
            return (false, returnedError)
        }
        
        return (true, returnedError)
    }
    
    func mendeleyObjectList<T: MendeleySwiftSecureObject>(ofType type: T.Type, api: String, queryParameters: [String: Any], addtionalHeaders: [String: Any]?, task: MendeleyTask, completionBlock: @escaping MendeleyArrayCompletionBlock) where T : Decodable {
        
        let blockExec = MendeleyBlockExecutor(arrayCompletionBlock: completionBlock)
        
        guard let networkProvider = delegate?.networkProvider, let baseURL = delegate?.baseAPIURL
            else { blockExec?.execute(with: nil, syncInfo: nil, error: nil); return }
        
        networkProvider.invokeGET(baseURL,
                                  api: api,
                                  additionalHeaders: addtionalHeaders,
                                  queryParameters: queryParameters,
                                  authenticationRequired: true,
                                  task: task) { (response, error) in
                                    let (isSuccess, combinedError) = self.isSuccess(forResponse: response, error: error)
                                    
                                    if isSuccess == false || response?.rawResponseBody == nil {
                                        blockExec?.execute(with: nil, syncInfo: nil, error: combinedError)
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
    
    // mendeleyObjectOfType
    func mendeleyObject<T: MendeleySwiftSecureObject>(ofType type: T.Type, queryParamters: [String: Any], api: String, additionalHeaders: [String: Any]?, task: MendeleyTask, completionBlock: @escaping MendeleySwiftObjectCompletionBlock) where T : Decodable {
        
        let blockExec = MendeleyBlockExecutor(swiftObjectCompletionBlock: completionBlock)
        
        guard let networkProvider = delegate?.networkProvider, let baseURL = delegate?.baseAPIURL
            else { blockExec?.execute(withMendeleyObject: nil, syncInfo: nil, error: nil); return }
        
        networkProvider.invokeGET(baseURL,
                                  api: api,
                                  additionalHeaders: additionalHeaders,
                                  queryParameters: queryParamters,
                                  authenticationRequired: true,
                                  task: task) { (response, error) in
                                    let (isSuccess, combinedError) = self.isSuccess(forResponse: response, error: error)
                                    
                                    if isSuccess == false || response?.rawResponseBody == nil {
                                        blockExec?.execute(withMendeleyObject: nil, syncInfo: nil, error: combinedError)
                                    } else {
                                        do {
                                            let decoder = JSONDecoder()
                                            let objectDict = try decoder.decode([String: T].self, from: response!.rawResponseBody)
                                            
                                            blockExec?.execute(withMendeleySwiftObject: objectDict[kMendeleyJSONData], syncInfo: response?.syncHeader, error: nil)
                                        } catch {
                                            print(error)
                                            blockExec?.execute(withMendeleyObject: nil, syncInfo: response?.syncHeader, error: error)
                                        }
                                    }
        }
    }
    
    //createMendeleyObject
    func create<T: MendeleySwiftSecureObject>(mendeleyObject: T, api: String, task: MendeleyTask, completionBlock: @escaping MendeleyCompletionBlock) where T: Encodable {
    
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
                                        let (isSuccess, combinedError) = self.isSuccess(forResponse: response, error: error)
                                        
                                        if isSuccess == false {
                                            blockExec?.execute(with: false, error: combinedError)
                                        } else {
                                            blockExec?.execute(with: true, error: nil)
                                        }
            }
        } catch {
            completionBlock(false, error)
        }
    }
    
    //updateMendeletObject
    func update<T: MendeleySwiftSecureObject>(mendeleyObject: T, api: String, additionalHeaders: [String: Any]?, task: MendeleyTask?, completionBlock: @escaping MendeleyCompletionBlock) where T: Encodable {
        
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
                                            let (isSuccess, combinedError) = self.isSuccess(forResponse: response, error: error)
                                            
                                            if isSuccess == false {
                                                blockExec?.execute(with: false, error: combinedError)
                                            } else {
                                                blockExec?.execute(with: true, error: nil)
                                            }
            }
        } catch {
            blockExec?.execute(with: false, error: error)
        }
    }
    
    func update<T: MendeleySwiftSecureObject, U: MendeleySwiftSecureObject>(mendeleyObject: T, api: String, additionalHeaders: [String: Any]?, expectedType: U, task: MendeleyTask?, completionBlock: @escaping MendeleySwiftObjectCompletionBlock) where T: Encodable, U: Decodable {
        
        let blockExec = MendeleyBlockExecutor(swiftObjectCompletionBlock: completionBlock)
        
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
                                            let (isSuccess, combinedError) = self.isSuccess(forResponse: response, error: error)

                                            if isSuccess == false {
                                                blockExec?.execute(withMendeleyObject: nil, syncInfo: nil, error: combinedError)
                                            } else {
                                                let decoder = JSONDecoder()
                                                
                                                do {
                                                    let objectDict = try decoder.decode([String: U].self, from: response!.rawResponseBody)
                                                    
                                                    blockExec?.execute(withMendeleySwiftObject: objectDict[kMendeleyJSONData], syncInfo: response?.syncHeader, error: nil)
                                                } catch {
                                                    blockExec?.execute(withMendeleyObject: nil, syncInfo: nil, error: error)
                                                }
                                            }
            }
        } catch {
            blockExec?.execute(withMendeleyObject: nil, syncInfo: nil, error: error)
        }
    }
    
    // deleteMeneleyObject
    func deleteMendeleyObject(withAPI api: String, task: MendeleyTask?, completionBlock: @escaping MendeleyCompletionBlock) {
        let blockExec = MendeleyBlockExecutor(completionBlock: completionBlock)
        
        guard let networkProvider = delegate?.networkProvider, let baseURL = delegate?.baseAPIURL
            else { blockExec?.execute(with: false, error: nil); return }
        
        networkProvider.invokeDELETE(baseURL,
                                     api: api,
                                     additionalHeaders: nil,
                                     bodyParameters: nil,
                                     authenticationRequired: true,
                                     task: task) { (response, error) in
                                        let (isSuccess, combinedError) = self.isSuccess(forResponse: response, error: error)
                                        if isSuccess == false {
                                            blockExec?.execute(with: false, error: combinedError)
                                        } else {
                                            blockExec?.execute(with: true, error: nil)
                                        }
        }
    }
}
