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

// MARK: -

open class MendeleyFollow: MendeleyObject {
    public var follower_id: String?
    public var followed_id: String?
    public var status: String?
    
    private enum CodingKeys: String, CodingKey {
        case follower_id
        case followed_id
        case status
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        follower_id = try container.decodeIfPresent(String.self, forKey: .follower_id)
        followed_id = try container.decodeIfPresent(String.self, forKey: .followed_id)
        status = try container.decodeIfPresent(String.self, forKey: .status)
        try super.init(from: decoder)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(follower_id, forKey: .follower_id)
        try container.encodeIfPresent(followed_id, forKey: .followed_id)
        try container.encodeIfPresent(status, forKey: .status)
    }
}
// MARK: -

open class MendeleyFollowRequest: MendeleySwiftSecureObject, Codable {
    public var followed: String?
    
    private enum CodingKeys: String, CodingKey {
        case followed
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        followed = try container.decodeIfPresent(String.self, forKey: .followed)
        try super.init(from: decoder)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(followed, forKey: .followed)
    }
}

// MARK: -

open class MendeleyFollowAcceptance: MendeleySwiftSecureObject, Codable {
    public var status: String?
    
    private enum CodingKeys: String, CodingKey {
        case status
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        status = try container.decodeIfPresent(String.self, forKey: .status)
        try super.init(from: decoder)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(status, forKey: .status)
    }
}
