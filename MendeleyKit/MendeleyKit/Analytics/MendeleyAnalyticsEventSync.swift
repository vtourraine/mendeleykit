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

open class MendeleyAnalyticsEventSync : MendeleyAnalyticsEvent
{
    public var connection_type: String {
        get {
            return properties[kMendeleyAnalyticsJSONConnectionType] as? String ?? ""
        }
        set {
            properties[kMendeleyAnalyticsJSONConnectionType] = newValue
        }
    }
    
    public var finish_condition: String {
        get {
            return properties[kMendeleyAnalyticsJSONFinishCondition] as? String ?? ""
        }
        set {
            properties[kMendeleyAnalyticsJSONFinishCondition] = newValue
        }
    }
    
    public init(connectionType: String) {
        super.init(name: kMendeleyAnalyticsEventSync)
        self.connection_type = connectionType
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
}
