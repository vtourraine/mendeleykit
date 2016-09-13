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
import MendeleyKitiOS

class ColorExtensionTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testConversionHex() {
        var counter = 0
        
        for i in 0...255
        {
            let rgb:Int = (Int)(i)<<16 //| (Int)(i)<<8 | (Int)(i)<<0
            
            let hexString = NSString(format:"#%06x", rgb) as String
            
            let color = UIColor(hex: hexString)
            
            let calculatedHexString = color.toHexString()
            
            if (hexString == calculatedHexString)
            {
                counter += 1
            }
        }
        
        XCTAssertEqual(counter, 256, "All the possible combination for a color channel need to match")
    }
    
    func testConversionInt() {

        var counter = 0
        
        for i in 0...255
        {
            let rgb:UInt32 = (UInt32)((Int)(i)<<16)
            
            let hexString = NSString(format:"#%06x", rgb) as String
            
            let color = UIColor(redInt: (UInt32)(i), greenInt: 0, blueInt: 0)
            
            let calculatedHexString = color.toHexString()
            
            if (hexString == calculatedHexString)
            {
                counter += 1
            }
        }
        
        XCTAssertEqual(counter, 256, "All the possible combination for a color channel need to match")
    }
    
    func testExtractIntComponent()
    {
        var counter = 0
        
        for i in 0...255
        {
            // let rgb:UInt32 = (UInt32)((Int)(i)<<16)
                        
            let color = UIColor(redInt: (UInt32)(i), greenInt: 0, blueInt: 0)
            
            if (color.redComponentInt() == (UInt32)(i))
            {
                counter += 1
            }
        }
        
        XCTAssertEqual(counter, 256, "All the possible combination for a color channel need to match")
    }
}


