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

#if os(iOS)
    import UIKit
    typealias MendeleyKitColor = UIColor
#else
    import Cocoa
    typealias MendeleyKitColor = NSColor
#endif

public extension MendeleyKitColor {
    
    @objc convenience init(redInt: UInt32, greenInt: UInt32, blueInt:UInt32, alpha: CGFloat = 1) {
        
        self.init(
            red:   (CGFloat(redInt))/255.0,
            green: (CGFloat(greenInt))/255.0,
            blue:  (CGFloat(blueInt))/255.0,
            alpha: alpha)
    }
    
    @objc convenience init(hex: String, alpha: CGFloat = 1) {
        assert(hex[hex.startIndex] == "#", "Expected hex string of format #RRGGBB")
        
        let scanner = NSScanner(string: hex)
        scanner.scanLocation = 1  // skip #
        
        var rgb: UInt32 = 0
        scanner.scanHexInt(&rgb)
        
        let red = ((rgb & 0xFF0000) >> 16)
        let green = ((rgb &   0xFF00) >>  8)
        let blue = (rgb &     0xFF)
        
        self.init(redInt:red, greenInt:green, blueInt:blue, alpha:alpha)
    }

    @objc func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return NSString(format:"#%06x", rgb) as String
    }
    
    @objc func redComponentInt() -> UInt32
    {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0

        getRed(&r, green: &g, blue: &b, alpha: &a)
        return (UInt32)(r*255)
    }
    
    @objc func greenComponentInt() -> UInt32
    {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        return (UInt32)(g*255)
    }
    
    @objc func blueComponentInt() -> UInt32
    {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        return (UInt32)(b*255)
    }
}
