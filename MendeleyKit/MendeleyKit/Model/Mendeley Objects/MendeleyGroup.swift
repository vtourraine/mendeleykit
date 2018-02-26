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

// MARK: - Mendeley Group

open class MendeleyGroup: MendeleySwiftObject {
    public var created: Date?
    public var owning_profile_id: String?
    public var link: String?
    public var access_level: String?
    public var name: String?
    public var role: String?
    public var photo: MendeleyPhoto?
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
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        created = try container.decodeIfPresent(Date.self, forKey: .created)
        owning_profile_id = try container.decodeIfPresent(String.self, forKey: .owning_profile_id)
        link = try container.decodeIfPresent(String.self, forKey: .link)
        access_level = try container.decodeIfPresent(String.self, forKey: .access_level)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        role = try container.decodeIfPresent(String.self, forKey: .role)
        photo = try container.decodeIfPresent(MendeleyPhoto.self, forKey: .photo)
        webpage = try container.decodeIfPresent(String.self, forKey: .webpage)
        disciplines = try container.decodeIfPresent([MendeleyDiscipline].self, forKey: .disciplines)
        tags = try container.decodeIfPresent([String].self, forKey: .tags)
        try super.init(from: decoder)
    }
    
    public required init?(coder aDecoder: NSCoder) {
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

// MARK: - Mendeley Photo

open class MendeleyPhoto: MendeleySwiftObject {
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
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        original = try container.decodeIfPresent(String.self, forKey: .original)
        square = try container.decodeIfPresent(String.self, forKey: .square)
        standard = try container.decodeIfPresent(String.self, forKey: .standard)
        originalImageData = try container.decodeIfPresent(Data.self, forKey: .originalImageData)
        squareImageData = try container.decodeIfPresent(Data.self, forKey: .squareImageData)
        standardImageData = try container.decodeIfPresent(Data.self, forKey: .standardImageData)
        try super.init(from: decoder)
    }
    
    public required init?(coder aDecoder: NSCoder) {
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
