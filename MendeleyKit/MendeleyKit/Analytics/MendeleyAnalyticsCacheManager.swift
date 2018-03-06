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

import Foundation

public enum CacheFileError: Error
{
    case fileNotFound
}

open class MendeleyAnalyticsCacheManager: NSObject
{
    var preferredBatchSize = 50
    let maxBatchSize = 1000
    var eventHeader = [kMendeleyRESTRequestContentType : kMendeleyRESTRequestJSONType]
    
    open var cacheFilePath: String{
        get{
            let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                .userDomainMask, true)
            
            let docsDir = dirPaths[0] as NSString
            let path = docsDir.appendingPathComponent("MendeleyAnalyticsEvents.cache")
            return path
        }
    }
    
    open func addMendeleyAnalyticsEvent(_ event:MendeleyAnalyticsEvent)
    {
        var currentEvents = eventsFromArchive()
        currentEvents.append(event)
        
        
        eventsToArchive(currentEvents)
        if preferredBatchSize < currentEvents.count || maxBatchSize < currentEvents.count
        {
            sendAndClearAnalyticsEvents({ (success, error) -> Void in
                if success
                {
                    self.clearCache()
                }
            })
        }
    }

    open func addMendeleyAnalyticsEvents(_ events:[MendeleyAnalyticsEvent])
    {
        var currentEvents = eventsFromArchive()
        currentEvents += events
        eventsToArchive(currentEvents)
        if preferredBatchSize < currentEvents.count || maxBatchSize < currentEvents.count
        {
            sendAndClearAnalyticsEvents({ (success, error) -> Void in
                if success
                {
                    self.clearCache()
                }
            })
        }
    }
    
    open func sendAndClearAnalyticsEvents(_ completionHandler: MendeleyCompletionBlock?)
    {
        let events = eventsFromArchive()
        if 0 == events.count
        {
            if nil != completionHandler
            {
                completionHandler!(true, nil)
            }
            return
        }
        
        let sdk = MendeleyKit.sharedInstance()
        if (sdk?.isAuthenticated)!
        {
            MendeleyOAuthTokenHelper.refreshToken(refreshBlock: { (success, error) -> Void in
                let blockExecutor = MendeleyBlockExecutor(completionBlock: completionHandler)
                if success
                {
                    let kit = MendeleyKitConfiguration.sharedInstance()
                    let baseURL = kit?.baseAPIURL
                    let provider = kit?.networkProvider
                    let task = MendeleyTask()
                    let encoder = JSONEncoder()
                    do {
                        let data = try encoder.encode(events)
                        
                        provider?.invokePOST(baseURL,
                                             api: kMendeleyAnalyticsAPIEventsBatch,
                                             additionalHeaders: self.eventHeader,
                                             jsonData: data,
                                             authenticationRequired: true,
                                             task: task) { (response, responseError ) -> Void in
                            let helper = MendeleyKitHelper()
                            var error = responseError
                            if helper.isSuccess(forResponse: response, error: &error) == true {
                                self.clearCache()
                                blockExecutor?.execute(with: true, error: nil)
                            } else {
                                blockExecutor?.execute(with: false, error: error)
                            }
                        }
                    } catch {
                        blockExecutor?.execute(with: false, error: error)
                    }
                } else {
                    blockExecutor?.execute(with: false, error: error)
                }
            })
        }
        else
        {
            let error = NSError(code: MendeleyErrorCode.unauthorizedErrorCode)
            if nil != completionHandler
            {
                completionHandler!(false, error)
            }
        }
    }
    
    open func clearCache()
    {
        let path = cacheFilePath
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: path)
        {
            do{
                try fileManager.removeItem(atPath: path)
            }catch let error as NSError
            {
                print("\(error.localizedDescription)")
            }
            catch{
                
            }
        }
        
    }
    
    public func eventsFromArchive() -> [MendeleyAnalyticsEvent]
    {
        let path = cacheFilePath
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: path)
        {
            let data = NSKeyedUnarchiver.unarchiveObject(withFile: path)
            if nil != data
            {
                return data as! [MendeleyAnalyticsEvent]
            }
        }
        return [MendeleyAnalyticsEvent]()
    }
    
    public func eventsToArchive(_ events: [MendeleyAnalyticsEvent])
    {
        let path = cacheFilePath
        NSKeyedArchiver.archiveRootObject(events, toFile: path)
    }
    
}
