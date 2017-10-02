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

open class MendeleyDefaultAnalytics: NSObject, MendeleyAnalytics
{
    struct MendeleyAnalyticsEventInfo {
        var event : MendeleyAnalyticsEvent
        var startTime : Date
    }
    
    var cacheManager = MendeleyAnalyticsCacheManager()
    open var versionString = String()
    open var identityString = String()
    open var profileUUID = String()
    
    var timedEvents = [String : MendeleyAnalyticsEventInfo]()
    
    open class var sharedInstance : MendeleyDefaultAnalytics
    {
        struct Static
        {
            static let instance : MendeleyDefaultAnalytics = MendeleyDefaultAnalytics()
        }
        return Static.instance
    }
    
    open func configureMendeleyAnalytics(_ profileID: String, clientVersionString: String, clientIdentityString: String)
    {
        profileUUID = profileID
        versionString = clientVersionString
        identityString = clientIdentityString
    }
    
    open func configureMendeleyAnalytics(_ profileID: String, clientVersionString: String, clientIdentityString: String, batchSize: Int)
    {
        profileUUID = profileID
        versionString = clientVersionString
        identityString = clientIdentityString
        cacheManager.preferredBatchSize = batchSize
    }
    
    
    open func logMendeleyAnalyticsEvent(_ name: String)
    {
        if let event = self.createEvent(name: name) {
            cacheManager.addMendeleyAnalyticsEvent(event)
        }
    }
    
    
    open func logMendeleyAnalyticsEvents(_ events:[MendeleyAnalyticsEvent])
    {
        if versionString.characters.count == 0 || identityString.characters.count == 0 || profileUUID.characters.count == 0
        {
            return
        }
        for event in events
        {
            event.origin[kMendeleyAnalyticsJSONOriginVersion] = versionString
            event.origin[kMendeleyAnalyticsJSONOriginIdentity] = identityString
            event.profile_uuid = profileUUID
        }
        cacheManager.addMendeleyAnalyticsEvents(events)
    }
    
    open func logMendeleyAnalyticsEvent(_ name: String, timed: Bool)
    {
        if (timed) {
            if let event = self.createEvent(name: name) {
                let eventInfo = MendeleyAnalyticsEventInfo(event: event, startTime: Date.init())
                
                timedEvents[event.name] = eventInfo
            }
        } else {
            self.logMendeleyAnalyticsEvent(name)
        }
    }
    
    open func logMendeleyAnalyticsEvents(_ events:[MendeleyAnalyticsEvent], timed: Bool)
    {
        if (timed) {
            for event in events {
                let eventInfo = MendeleyAnalyticsEventInfo(event:event, startTime: Date.init())
                
                timedEvents[event.name] = eventInfo
            }
        } else {
            self.logMendeleyAnalyticsEvents(events)
        }
    }
    
    open func endTimedEvent(_ name: String)
    {
        if let eventInfo = timedEvents[name] {
            let millisecondsElapsed = Date.init().timeIntervalSince(eventInfo.startTime) * 1000
            
            let event = eventInfo.event
            event.duration_milliseconds = Int(round(millisecondsElapsed))
            
            cacheManager.addMendeleyAnalyticsEvent(event)
            
            timedEvents.removeValue(forKey: name)
        }
    }
    
    open func endTimedEvents(_ events:[MendeleyAnalyticsEvent])
    {
        for event in events {
            if let eventInfo = timedEvents[event.name] {
                let millisecondsElapsed = Date.init().timeIntervalSince(eventInfo.startTime) * 1000
                
                event.duration_milliseconds = Int(round(millisecondsElapsed))
                
                cacheManager.addMendeleyAnalyticsEvent(event)
                
                timedEvents.removeValue(forKey: event.name)
            }
        }
    }
    
    open func dispatchMendeleyAnalyticsEvents(_ completionHandler: MendeleyCompletionBlock?)
    {
        cacheManager.sendAndClearAnalyticsEvents(completionHandler)
    }
    
    private func createEvent(name: String) -> MendeleyAnalyticsEvent?
    {
        let event = MendeleyAnalyticsEvent(name: name)
        
        if versionString.characters.count == 0 || identityString.characters.count == 0 || profileUUID.characters.count == 0
        {
            return nil
        }
        
        event.origin[kMendeleyAnalyticsJSONOriginVersion] = versionString
        event.origin[kMendeleyAnalyticsJSONOriginIdentity] = identityString
        event.profile_uuid = profileUUID

        return event
    }

}
