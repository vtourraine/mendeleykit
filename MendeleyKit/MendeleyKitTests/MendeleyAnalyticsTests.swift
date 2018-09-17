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

import XCTest
#if os(iOS)
import MendeleyKitiOS
#elseif os(OSX)
import MendeleyKitOSX
#endif

class MendeleyAnalyticsTests: XCTestCase {

    let manager = MendeleyAnalyticsCacheManager()

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        manager.clearCache()
        super.tearDown()
    }
    
    func testClearCache()
    {
        manager.clearCache()
        let fileManager = FileManager.default
        let exists = fileManager.fileExists(atPath: manager.cacheFilePath)
        XCTAssertFalse(exists, "file should not exist at the specified file path")
        
        let events = manager.eventsFromArchive()
        XCTAssertTrue(0 == events.count, "We should have 0 events but got \(events.count)")
    }
    
    func testAddEvent()
    {
        let testEvent = MendeleyAnalyticsEvent(name: "TestPDFEvent")
        let profileID = UUID().uuidString
        testEvent.profile_uuid = profileID
        manager.addMendeleyAnalyticsEvent(testEvent)
        
        let events = manager.eventsFromArchive()
        XCTAssertTrue(0 < events.count, "We should have at least 1 event but got \(events.count)")
        if 1 == events.count
        {
            let returnedEvent = events[0]
            XCTAssertTrue(returnedEvent.profile_uuid == profileID, "expected profile ID\(profileID) but got \(returnedEvent.profile_uuid ?? "nil")")
            XCTAssertTrue(returnedEvent.name == "TestPDFEvent", "Expected name 'TestPDFEvent' but got \(returnedEvent.name ?? "nil")")
        }
    }
    
    func testAddEvents()
    {
        var array = [MendeleyAnalyticsEvent]()
        for count in 0 ..< 20
        {
            let event = MendeleyAnalyticsEvent(name: "TestPDFEvent\(count)")
            event.profile_uuid = "ProfileID_\(count)"
            array.append(event)
        }
        
        manager.addMendeleyAnalyticsEvents(array)
        
        let cachedEvents = manager.eventsFromArchive()
        XCTAssertTrue(20 == cachedEvents.count,"expected 20 events but got \(cachedEvents.count)")
        for (index, event) in cachedEvents.enumerated()
        {
            let name = "TestPDFEvent\(index)"
            let profile = "ProfileID_\(index)"
            XCTAssertTrue(name == event.name,"expected name \(name) but got \(event.name ?? "nil")")
            XCTAssertTrue(profile == event.profile_uuid,"expected name \(profile) but got \(event.profile_uuid ?? "nil")")
        }
    }
    
    func testLogEvent()
    {
        let analytics = MendeleyDefaultAnalytics.sharedInstance
        let profileID = UUID().uuidString
        analytics.configureMendeleyAnalytics(profileID, clientVersionString: "2.6.0")

        analytics.logMendeleyAnalyticsEvent("TestPDFEvent")

        let cachedEvents = manager.eventsFromArchive()
        XCTAssertTrue(0 < cachedEvents.count, "We should have at least 1 event but got \(cachedEvents.count)")
        if 1 == cachedEvents.count
        {
            let returnedEvent = cachedEvents[0]
            XCTAssertTrue(returnedEvent.profile_uuid == profileID, "expected profile ID\(profileID) but got \(returnedEvent.profile_uuid ?? "nil")")
            XCTAssertTrue(returnedEvent.name == "TestPDFEvent", "Expected name 'TestPDFEvent' but got \(returnedEvent.name ?? "nil")")
        }
    }
    
    func testLogEvents()
    {
        let analytics = MendeleyDefaultAnalytics.sharedInstance
        let profileID = UUID().uuidString
        analytics.configureMendeleyAnalytics(profileID, clientVersionString: "2.6.0")
        var array = [MendeleyAnalyticsEvent]()
        for count in 0 ..< 20
        {
            let event = MendeleyAnalyticsEvent(name: "TestPDFEvent\(count)")
            array.append(event)
        }
        analytics.logMendeleyAnalyticsEvents(array)
        let cachedEvents = manager.eventsFromArchive()
        XCTAssertTrue(20 == cachedEvents.count, "We should have 20 events but got \(cachedEvents.count)")
    }
}
