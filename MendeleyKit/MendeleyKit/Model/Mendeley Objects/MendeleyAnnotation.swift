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
#elseif os(OSX)
import AppKit
#endif

import Foundation

open class MendeleyAnnotation : MendeleySwiftObject {
    public var created: Date?
#if os(iOS)
    public var color: UIColor?
#elseif os(OSX)
    public var color: NSColor?
#endif

    public var document_id: String?
    public var filehash: String?
    public var last_modified: Date?
    public var positions: [MendeleyHighlightBox]?
    public var privacy_level: String?
    public var profile_id: String?
    public var text: String?
    public var type: String?
    
    private enum CodingKeys: String, CodingKey {
        case created
        case color
        case document_id
        case filehash
        case last_modified
        case positions
        case privacy_level
        case profile_id
        case text
        case type
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        created = try container.decodeIfPresent(Date.self, forKey: .created)
        if let colorDict = try container.decodeIfPresent([String: UInt32].self, forKey: .color) {
            color = try MendeleyAnnotation.color(fromParameters: colorDict)
        }
        document_id = try container.decodeIfPresent(String.self, forKey: .document_id)
        filehash = try container.decodeIfPresent(String.self, forKey: .filehash)
        last_modified = try container.decodeIfPresent(Date.self, forKey: .last_modified)
        positions = try container.decodeIfPresent([MendeleyHighlightBox].self, forKey: .positions)
        privacy_level = try container.decodeIfPresent(String.self, forKey: .privacy_level)
        profile_id = try container.decodeIfPresent(String.self, forKey: .profile_id)
        text = try container.decodeIfPresent(String.self, forKey: .text)
        type = try container.decodeIfPresent(String.self, forKey: .type)
        try super.init(from: decoder)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(created, forKey: .created)
        let colorDict = try MendeleyAnnotation.jsonColor(fromColor: color)
        try container.encodeIfPresent(colorDict, forKey: .color)
        try container.encodeIfPresent(document_id, forKey: .document_id)
        try container.encodeIfPresent(filehash, forKey: .filehash)
        try container.encodeIfPresent(last_modified, forKey: .last_modified)
        try container.encodeIfPresent(positions, forKey: .positions)
        try container.encodeIfPresent(privacy_level, forKey: .privacy_level)
        try container.encodeIfPresent(profile_id, forKey: .profile_id)
        try container.encodeIfPresent(text, forKey: .text)
        try container.encodeIfPresent(type, forKey: .type)
    }
    
    /**
     Annotations have color components, which are stored as map<string, integer>, where string is
     either r,g,b
     This method converts the color JSON map into a UIColor object (iOS) or NSColor object (Mac OSX)
     @param colorParameters
     @param error
     @return a UIColor/NSColor object or nil if error
     */
#if os(iOS)
    class func color(fromParameters colorParameters: [String: UInt32]) throws -> UIColor {
        if (3 != colorParameters.values.count) {
            throw NSError(code: MendeleyErrorCode.jsonTypeObjectNilErrorCode, localizedDescription: "Annotation color components are either nil or not in the correct format.")
        }
        let red = colorParameters[kMendeleyJSONColorRed]!
        let green = colorParameters[kMendeleyJSONColorGreen]!
        let blue = colorParameters[kMendeleyJSONColorBlue]!
        return UIColor(redInt: red, greenInt: green, blueInt: blue, alpha: 1)
    }
#elseif os(OSX)
    class func color(fromParameters colorParameters: [String: UInt32]) throws -> NSColor {
        if (3 != colorParameters.values.count) {
        throw NSError(code: MendeleyErrorCode.jsonTypeObjectNilErrorCode, localizedDescription: "Annotation color components are either nil or not in the correct format.")
        }
        let red = colorParameters[kMendeleyJSONColorRed]!
        let green = colorParameters[kMendeleyJSONColorGreen]!
        let blue = colorParameters[kMendeleyJSONColorBlue]!
        return NSColor(redInt: red, greenInt: green, blueInt: blue, alpha: 1)
    }
#endif
    
    
    /**
     converts a color object (UIColor/NSColor) back into JSON
     @param color
     @param error
     @return JSON map of color components
     */
#if os(iOS)
    class func jsonColor(fromColor color: UIColor!) throws -> [String: UInt32] {
    return [kMendeleyJSONColorRed: color.redComponentInt(),
            kMendeleyJSONColorGreen: color.greenComponentInt(),
            kMendeleyJSONColorBlue: color.blueComponentInt()]
    }
#elseif os(OSX)
    class func jsonColor(fromColor color: NSColor) throws -> [String: UInt32] {
        return [kMendeleyJSONColorRed: color.redComponentInt(),
                kMendeleyJSONColorGreen: color.greenComponentInt(),
                kMendeleyJSONColorBlue: color.blueComponentInt()]
    }
#endif
}
    
    
open class MendeleyHighlightBox : MendeleySwiftSecureObject, Codable {
    public var box: CGRect?
    public var page: Int?
    
    private enum CodingKeys: String, CodingKey {
        case box
        case page
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        box = try container.decodeIfPresent(CGRect.self, forKey: .box)
        page = try container.decodeIfPresent(Int.self, forKey: .page)
        super.init()
    }
    
    override init() {
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(box, forKey: .box)
        try container.encodeIfPresent(page, forKey: .page)
    }
    
    /**
     Annotations store position details as a map with parameters such as top_left etc.
     This converts a JSON map containing position metadata into a MendeleyHighlightBox object
     @param boxParameters
     @param error
     @return a highlight box object
     */
    public class func box(fromJSONParameters boxParameters: [String: Any]) -> MendeleyHighlightBox {
        let box = MendeleyHighlightBox()
        var topX = 0.0, topY = 0.0, botX = 0.0, botY = 0.0
        
        if let topDict = boxParameters[kMendeleyJSONTopLeft] as? [String: Double] {
            topX = topDict[kMendeleyJSONPositionX] ?? 0.0
            topY = topDict[kMendeleyJSONPositionY] ?? 0.0
        }
        
        if let botDict = boxParameters[kMendeleyJSONBottomRight] as? [String: Double] {
            botX = botDict[kMendeleyJSONPositionX] ?? 0.0
            botY = botDict[kMendeleyJSONPositionY] ?? 0.0
        }
        
        let width = botX - topX
        let height = botY - topY
        
        box.box = CGRect(x: topX, y: topY, width: width, height: height)
        
        if let page = boxParameters[kMendeleyJSONPage] as? Int {
            box.page = page
        }
        
        return box
    }
    
    /**
     converts a highlight box object back into a NSDictionary (JSON map)
     @param box
     @param error
     @return a map to be used in JSON
     */
    public class func jsonBox(fromHighlightBox box: MendeleyHighlightBox) throws -> [String: Any] {
        var boxDictionary = [String: Any]()
        
        guard let frame = box.box
            else { return boxDictionary }
        
        let botX = frame.origin.x + frame.size.width
        let botY = frame.origin.y + frame.size.height
        
        let topLeft = [kMendeleyJSONPositionX: frame.origin.x,
                       kMendeleyJSONPositionY: frame.origin.y]
        
        let botRight = [kMendeleyJSONPositionX: botX,
                        kMendeleyJSONPositionY: botY]
        if let boxPage = box.page {
            boxDictionary[kMendeleyJSONPage] = boxPage
        }
        boxDictionary[kMendeleyJSONTopLeft] = topLeft
        boxDictionary[kMendeleyJSONBottomRight] = botRight
        return boxDictionary;
    }
}
