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

@objc open class MendeleyMetadataLookup: MendeleyObject {
    @objc public var score: NSNumber?
    @objc public var catalog_id: String?
    
    private enum CodingKeys: String, CodingKey {
        case score
        case catalog_id
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let scoreInt = try container.decodeIfPresent(Int.self, forKey: .score) {
            score = NSNumber(value: scoreInt)
        }
        catalog_id = try container.decodeIfPresent(String.self, forKey: .catalog_id)
        try super.init(from: decoder)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(score?.intValue, forKey: .score)
        try container.encodeIfPresent(catalog_id, forKey: .catalog_id)
    }
}
