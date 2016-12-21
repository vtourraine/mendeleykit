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


@objc public enum MendeleySyncConnectionType : Int {
    case None
    case WiFi
    case Mobile
    case Ethernet
    
    public func name() -> String {
        switch self {
        case .None: return "none"
        case .WiFi: return "wifi"
        case .Mobile: return "mobile"
        case .Ethernet: return "ethernet"
        }
    }
}

@objc public enum MendeleySyncFinishCondition : Int {
    case Success
    case ConnectionProblem
    case AuthenticationError
    case ServerError
    case Failure
    case Cancel
    
    public func name() -> String {
        switch self {
        case .Success: return "success"
        case .ConnectionProblem: return "connection_problem"
        case .AuthenticationError: return "authentication_error"
        case .ServerError: return "server_error"
        case .Failure: return "failure"
        case .Cancel: return "cancel"
        }
    }
}

open class MendeleyAnalyticsEventSync : MendeleyAnalyticsEvent
{
    open var connection_type: String!
    open var finish_condition: String!
}
