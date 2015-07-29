//
//  MendeleyAnalyticsTests.swift
//  MendeleyKit
//
//  Created by Peter Schmidt on 27/07/2015.
//  Copyright © 2015 Mendeley. All rights reserved.
//

import XCTest
import MendeleyKitiOS

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
        let fileManager = NSFileManager.defaultManager()
        let exists = fileManager.fileExistsAtPath(manager.cacheFilePath)
        XCTAssertFalse(exists, "file should not exist at the specified file path")
        
        let events = manager.eventsFromArchive()
        XCTAssertTrue(0 == events.count, "We should have 0 events but got \(events.count)")
    }
    
    func testAddEvent()
    {
        let testEvent = MendeleyAnalyticsEvent()
        let profileID = NSUUID().UUIDString
        testEvent.profile_uuid = profileID
        testEvent.name = "TestPDFEvent"
        manager.addMendeleyAnalyticsEvent(testEvent)
        
        let events = manager.eventsFromArchive()
        XCTAssertTrue(0 < events.count, "We should have at least 1 event but got \(events.count)")
        if 1 == events.count
        {
            let returnedEvent = events[0]
            XCTAssertTrue(returnedEvent.profile_uuid == profileID, "expected profile ID\(profileID) but got \(returnedEvent.profile_uuid)")
            XCTAssertTrue(returnedEvent.name == "TestPDFEvent", "Expected name 'TestPDFEvent' but got \(returnedEvent.name)")
        }
    }
    
    func testAddEvents()
    {
        var array = [MendeleyAnalyticsEvent]()
        for var count = 0; count < 20; count++
        {
            let event = MendeleyAnalyticsEvent()
            event.name = "TestPDFEvent\(count)"
            event.profile_uuid = "ProfileID_\(count)"
            array.append(event)
        }
        
        manager.addMendeleyAnalyticsEvents(array)
        
        let cachedEvents = manager.eventsFromArchive()
        XCTAssertTrue(20 == cachedEvents.count,"expected 20 events but got \(cachedEvents.count)")
        var index = 0
        for event in cachedEvents
        {
            let name = "TestPDFEvent\(index)"
            let profile = "ProfileID_\(index)"
            XCTAssertTrue(name == event.name,"expected name \(name) but got \(event.name)")
            XCTAssertTrue(profile == event.profile_uuid,"expected name \(profile) but got \(event.profile_uuid)")
            index++
        }

    }
    
    func testLogEvent()
    {
        let analytics = MendeleyDefaultAnalytics.sharedInstance
        let profileID = NSUUID().UUIDString
        analytics.configureMendeleyAnalytics(profileID, clientVersionString: "2.6.0", clientIdentityString: "7")
        
        analytics.logMendeleyAnalyticsEvent("TestPDFEvent")
        

        let cachedEvents = manager.eventsFromArchive()
        XCTAssertTrue(0 < cachedEvents.count, "We should have at least 1 event but got \(cachedEvents.count)")
        if 1 == cachedEvents.count
        {
            let returnedEvent = cachedEvents[0]
            XCTAssertTrue(returnedEvent.profile_uuid == profileID, "expected profile ID\(profileID) but got \(returnedEvent.profile_uuid)")
            XCTAssertTrue(returnedEvent.name == "TestPDFEvent", "Expected name 'TestPDFEvent' but got \(returnedEvent.name)")
        }
        
        
    }
    
    func testLogEvents()
    {
        let analytics = MendeleyDefaultAnalytics.sharedInstance
        let profileID = NSUUID().UUIDString
        analytics.configureMendeleyAnalytics(profileID, clientVersionString: "2.6.0", clientIdentityString: "7")
        var array = [MendeleyAnalyticsEvent]()
        for var count = 0; count < 20; count++
        {
            let event = MendeleyAnalyticsEvent()
            event.name = "TestPDFEvent\(count)"
            array.append(event)
        }
        analytics.logMendeleyAnalyticsEvents(array)
        let cachedEvents = manager.eventsFromArchive()
        XCTAssertTrue(20 == cachedEvents.count, "We should have 20 events but got \(cachedEvents.count)")
        
    }
    
}
