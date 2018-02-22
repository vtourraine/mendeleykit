//
//  MendeleySwiftGroup.swift
//  MendeleyKit
//
//  Created by Trevisi, Luigi (ELS-LON) on 21/02/2018.
//  Copyright © 2018 Mendeley. All rights reserved.
//

import Foundation

open class MendeleySwiftGroup : MendeleySwiftObject {
    public var created: Date?
    public var owning_profile_id: String?
    public var link: String?
    public var access_level: String?
    public var name: String?
    public var role: String?
    public var photo: MendeleySwiftPhoto?
    public var webpage: String?
    public var disciplines: [MendeleyDiscipline]?
    public var tags: [String]?
    
    private enum CodingKeys: String, CodingKey {
        case created
        case owning_profile_id
        case link
        case access_level
        case name
        case role
        case photo
        case webpage
        case disciplines
        case tags
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        created = try container.decodeIfPresent(Date.self, forKey: .created)
        owning_profile_id = try container.decodeIfPresent(String.self, forKey: .owning_profile_id)
        link = try container.decodeIfPresent(String.self, forKey: .link)
        access_level = try container.decodeIfPresent(String.self, forKey: .access_level)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        role = try container.decodeIfPresent(String.self, forKey: .role)
        photo = try container.decodeIfPresent(MendeleySwiftPhoto.self, forKey: .photo)
        webpage = try container.decodeIfPresent(String.self, forKey: .webpage)
        disciplines = try container.decodeIfPresent([MendeleyDiscipline].self, forKey: .disciplines)
        tags = try container.decodeIfPresent([String].self, forKey: .tags)
        try super.init(from: decoder)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(created, forKey: .created)
        try container.encodeIfPresent(owning_profile_id, forKey: .owning_profile_id)
        try container.encodeIfPresent(link, forKey: .link)
        try container.encodeIfPresent(access_level, forKey: .access_level)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(role, forKey: .role)
        try container.encodeIfPresent(photo, forKey: .photo)
        try container.encodeIfPresent(webpage, forKey: .webpage)
        try container.encodeIfPresent(disciplines, forKey: .disciplines)
        try container.encodeIfPresent(tags, forKey: .tags)
    }
}

open class MendeleySwiftPhoto : MendeleySwiftObject {
    public var original: String?
    public var square: String?
    public var standard: String?
    public var originalImageData: Data?
    public var squareImageData: Data?
    public var standardImageData: Data?
    
    private enum CodingKeys: String, CodingKey {
        case original
        case square
        case standard
        case originalImageData
        case squareImageData
        case standardImageData
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        original = try container.decodeIfPresent(String.self, forKey: .original)
        square = try container.decodeIfPresent(String.self, forKey: .square)
        standard = try container.decodeIfPresent(String.self, forKey: .standard)
        originalImageData = try container.decodeIfPresent(Data.self, forKey: .originalImageData)
        squareImageData = try container.decodeIfPresent(Data.self, forKey: .squareImageData)
        standardImageData = try container.decodeIfPresent(Data.self, forKey: .standardImageData)
        try super.init(from: decoder)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(original, forKey: .original)
        try container.encodeIfPresent(square, forKey: .square)
        try container.encodeIfPresent(standard, forKey: .standard)
        try container.encodeIfPresent(originalImageData, forKey: .originalImageData)
        try container.encodeIfPresent(squareImageData, forKey: .squareImageData)
        try container.encodeIfPresent(standardImageData, forKey: .standardImageData)
    }
}
