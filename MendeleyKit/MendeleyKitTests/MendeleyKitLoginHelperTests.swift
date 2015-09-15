//
//  MendeleyKitLoginHelperTests.swift
//  MendeleyKit
//
//  Created by Peter Schmidt on 24/06/2015.
//  Copyright © 2015 Mendeley. All rights reserved.
//

import XCTest
import MendeleyKitiOS

class MendeleyKitLoginHelperTests: XCTestCase
{
    
    override func setUp()
    {
        super.setUp()
    }
    
    override func tearDown()
    {
        super.tearDown()
    }
    
    func testGetOAuthRequest()
    {
        let helper = MendeleyKitLoginHelper()
        let request = helper.getOAuthRequest("http://redirect", clientID: "somenumber")
        
        XCTAssertEqual(request.HTTPMethod!, "GET", "http method should be GET")
        let header = request.allHTTPHeaderFields
        XCTAssertNotNil(header, "header should not be nil")
        
        let url = request.URL
        XCTAssertNotNil(url, "request url should not be nil")
        
    }
    
    
    func testAuthenticationCodeFromRequest()
    {
        let url = NSURL(string: "http://localhost/auth_return?code=1234")
        
        let helper = MendeleyKitLoginHelper()
        
        let codeString = helper.getAuthenticationCode(url!)
        
        
        XCTAssertNotNil(codeString, "We should get a string back")
        if nil != codeString
        {
            XCTAssertTrue(codeString! == "1234", "We should get back '1234' but instead get \(codeString)")
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
