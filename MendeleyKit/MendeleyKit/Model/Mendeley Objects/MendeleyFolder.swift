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

open class MendeleyFolder: MendeleyObject {
    public var name: String?
    public var parent_id: String?
    public var group_id: String?
    public var created: Date?
    public var modified: Date?
    
    private enum CodingKeys: String, CodingKey {
        case name
        case parent_id
        case group_id
        case created
        case modified
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        parent_id = try container.decodeIfPresent(String.self, forKey: .parent_id)
        group_id = try container.decodeIfPresent(String.self, forKey: .group_id)
        created = try container.decodeIfPresent(Date.self, forKey: .created)
        modified = try container.decodeIfPresent(Date.self, forKey: .modified)
        try super.init(from: decoder)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(parent_id, forKey: .parent_id)
        try container.encodeIfPresent(group_id, forKey: .group_id)
        try container.encodeIfPresent(created, forKey: .created)
        try container.encodeIfPresent(modified, forKey: .modified)
    }
}