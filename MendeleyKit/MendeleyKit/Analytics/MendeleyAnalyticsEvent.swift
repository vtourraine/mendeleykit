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

import Foundation

open class MendeleyAnalyticsEvent: MendeleySecureObject, Encodable
{
    open var name: String!
    open var timestamp = Date()
    open var profileID: String!
    open var session_ID: String!
    open var profile_uuid: String!
    open var origin = [kMendeleyAnalyticsJSONOriginOS : kOriginOS,
        kMendeleyAnalyticsJSONOriginType: kOriginType]
    public var properties = [String:Any]()
    
    public var duration_milliseconds: Int? {
        get {
            return properties[kMendeleyAnalyticsJSONDuration] as? Int
        }
        set {
            properties[kMendeleyAnalyticsJSONDuration] = newValue
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case name
        case timestamp
        case profileID
        case session_ID
        case profile_uuid
        case origin
        case properties
    }

    public init(name: String) {
        super.init()
        self.name = name
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(profileID, forKey: .profileID)
        try container.encode(session_ID, forKey: .session_ID)
        try container.encode(profile_uuid, forKey: .profile_uuid)
        try container.encode(origin, forKey: .origin)
        try container.encode(properties, forKey: .properties)
    }
}
