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

open class MendeleyObject: MendeleySecureObject, Codable {
    public var object_ID: String?
    public var objectDescription: String?
    
    private enum CodingKeys: String, CodingKey {
        case object_ID = "id"
        case objectDescription = "description"
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        object_ID = try container.decodeIfPresent(String.self, forKey: .object_ID)
        objectDescription = try container.decodeIfPresent(String.self, forKey: .objectDescription)
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(object_ID, forKey: .object_ID)
        try container.encodeIfPresent(objectDescription, forKey: .objectDescription)
    }
}