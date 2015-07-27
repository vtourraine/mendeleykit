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

public enum CacheFileError: ErrorType
{
    case FileNotFound
}

public class MendeleyAnalyticsCacheManager: NSObject
{
    var preferredBatchSize = 50
    let maxBatchSize = 1000
    var eventHeader = [kMendeleyRESTRequestContentType : kMendeleyRESTRequestJSONType]
    
    var cacheFilePath: String{
        get{
            let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
                .UserDomainMask, true)
            
            let docsDir = dirPaths[0] as String
            let path = docsDir.stringByAppendingPathComponent("MendeleyAnalyticsEvents.cache")
            return path
        }
    }
    
    public func addMendeleyAnalyticsEvent(event:MendeleyAnalyticsEvent)
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

    public func addMendeleyAnalyticsEvents(events:[MendeleyAnalyticsEvent])
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
    
    public func sendAndClearAnalyticsEvents(completionHandler: MendeleySuccessClosure)
    {
        let events = eventsFromArchive()
        if 0 == events.count
        {
            completionHandler(success: true, error: nil)
            return
        }
        
        let sdk = MendeleyKit.sharedInstance()
        if sdk.isAuthenticated
        {
            MendeleyOAuthTokenHelper.refreshTokenWithRefreshBlock({ (success, error) -> Void in
                let blockExecutor = MendeleyBlockExecutor(completionBlock: completionHandler)
                if success
                {
                    let kit = MendeleyKitConfiguration.sharedInstance()
                    let baseURL = kit.baseAPIURL
                    let provider = kit.networkProvider
                    let modeller = MendeleyModeller.sharedInstance()
                    let task = MendeleyTask()
                    do{
                        let data = try modeller.jsonObjectFromModelOrModels(events) as NSData!
                        provider.invokePOST(baseURL, api: kMendeleyAnalyticsAPIEventsBatch, additionalHeaders: self.eventHeader, jsonData: data, authenticationRequired: true, task: task, completionBlock: { (response, responseError ) -> Void in
                            
                            do{
                                let helper = MendeleyKitHelper()
                                try helper.isSuccessForResponse(response!)
                                self.clearCache()
                                blockExecutor.executeWithBool(true, error: nil)
                            }catch let responseFault as NSError
                            {
                                blockExecutor.executeWithBool(false, error: responseFault)
                            }
                            catch{
                                let innerError = NSError(code: MendeleyErrorCode.ResponseTypeUnknownErrorCode)
                                blockExecutor.executeWithBool(false, error: innerError)
                            }
                        })
                    }catch let jsonError as NSError
                    {
                        blockExecutor.executeWithBool(false, error: jsonError)
                    }
                    catch{
                        let jsonError = NSError(code: MendeleyErrorCode.JSONTypeNotMappedToModelErrorCode)
                        blockExecutor.executeWithBool(false, error: jsonError)
                    }
                }
                else
                {
                    blockExecutor.executeWithBool(false, error: error)
                }
            })
        }
        else
        {
            let error = NSError(code: MendeleyErrorCode.UnauthorizedErrorCode)
            completionHandler(success: false, error: error)
        }
    }
    
    func clearCache()
    {
        let path = cacheFilePath
        let fileManager = NSFileManager.defaultManager()
        if fileManager.fileExistsAtPath(path)
        {
            do{
                try fileManager.removeItemAtPath(path)
            }catch let error as NSError
            {
                print("\(error.localizedDescription)")
            }
        }
        
    }
    
    func eventsFromArchive() -> [MendeleyAnalyticsEvent]
    {
        let path = cacheFilePath
        let fileManager = NSFileManager.defaultManager()
        if fileManager.fileExistsAtPath(path)
        {
            let data = NSKeyedUnarchiver.unarchiveObjectWithFile(path)
            if nil != data
            {
                return data as! [MendeleyAnalyticsEvent]
            }
        }
        return [MendeleyAnalyticsEvent]()
    }
    
    func eventsToArchive(events: [MendeleyAnalyticsEvent])
    {
        let path = cacheFilePath
        NSKeyedArchiver.archiveRootObject(events, toFile: path)
    }
    
}
