//
//  ColorExtensionTests.swift
//  MendeleyKit
//
//  Created by Piamonti, Stefano (ELS) on 22/01/2016.
//  Copyright © 2016 Mendeley. All rights reserved.
//

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
                counter++
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
                counter++
            }
        }
        
        XCTAssertEqual(counter, 256, "All the possible combination for a color channel need to match")
    }
    
    func testExtractIntComponent()
    {
        var counter = 0
        
        for i in 0...255
        {
            let rgb:UInt32 = (UInt32)((Int)(i)<<16)
                        
            let color = UIColor(redInt: (UInt32)(i), greenInt: 0, blueInt: 0)
            
            if (color.redComponentInt() == (UInt32)(i))
            {
                counter++
            }
        }
        
        XCTAssertEqual(counter, 256, "All the possible combination for a color channel need to match")
    }
}


