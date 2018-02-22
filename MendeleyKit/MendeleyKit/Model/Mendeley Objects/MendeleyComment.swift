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

// MARK: - MendeleyComment

open class MendeleyComment: MendeleySwiftObject {
    public var news_item_id: String?
    public var profile_id: String?
    public var text: String?
    public var created: String?
    public var last_modified: String?
    public var news_item_owner: Int?
    public var tagged_users: [MendeleySocialProfile]?
    
    private enum CodingKeys: String, CodingKey {
        case news_item_id
        case profile_id
        case text
        case created
        case last_modified
        case news_item_owner
        case tagged_users
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        news_item_id = try container.decodeIfPresent(String.self, forKey: .news_item_id)
        profile_id = try container.decodeIfPresent(String.self, forKey: .profile_id)
        text = try container.decodeIfPresent(String.self, forKey: .text)
        created = try container.decodeIfPresent(String.self, forKey: .created)
        last_modified = try container.decodeIfPresent(String.self, forKey: .last_modified)
        news_item_owner = try container.decodeIfPresent(Int.self, forKey: .news_item_owner)
//        tagged_users = try container.decodeIfPresent(MendeleySocialProfile.self, forKey: .text)
        try super.init(from: decoder)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(news_item_id, forKey: .news_item_id)
        try container.encodeIfPresent(profile_id, forKey: .profile_id)
        try container.encodeIfPresent(text, forKey: .text)
        try container.encodeIfPresent(created, forKey: .created)
        try container.encodeIfPresent(last_modified, forKey: .last_modified)
        try container.encodeIfPresent(news_item_owner, forKey: .news_item_owner)
        try container.encodeIfPresent(tagged_users, forKey: .tagged_users)
    }
}

// MARK: - MendeleyExpandedComment

open class MendeleyExpandedComment: MendeleyComment {
    public var profile: MendeleySocialProfile?
    
    private enum CodingKeys: String, CodingKey {
        case profile
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
//        profile = try container.decodeIfPresent(MendeleySocialProfile.self, forKey: .profile)
        try super.init(from: decoder)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(profile, forKey: .profile)
    }
}

// MARK: - MendeleyCommentUpdate

open class MendeleyCommentUpdate: MendeleySwiftSecureObject {
    public var text: String?
    public var tagged_users: [String]?
    
    private enum CodingKeys: String, CodingKey {
        case text
        case tagged_users
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        text = try container.decodeIfPresent(String.self, forKey: .text)
        tagged_users = try container.decodeIfPresent([String].self, forKey: .tagged_users)
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(text, forKey: .text)
        try container.encodeIfPresent(tagged_users, forKey: .tagged_users)
    }
}


