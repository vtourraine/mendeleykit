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
}
