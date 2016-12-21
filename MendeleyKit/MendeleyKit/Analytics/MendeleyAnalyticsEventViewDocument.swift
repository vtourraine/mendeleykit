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

@objc public enum MendeleyViewDocumentFromScreen : Int {
    case All
    case Documents
    case Favorities
    case Folder
    case Group
    case MyPublications
    case RecentlyAdded
    case RecentlyRead
    case Tag
    case Trash
    case Search
    
    func name() -> String {
        switch self {
        case .All: return "all"
        case .Documents: return "documents"
        case .Favorities: return "favorites"
        case .Folder: return "folder"
        case .Group: return "group"
        case .MyPublications: return "my_publications"
        case .RecentlyAdded: return "recently_added"
        case .RecentlyRead: return "recently_read"
        case .Tag: return "tag"
        case .Trash: return "trash"
        case .Search: return "search"
        }
    }
}

open class MendeleyAnalyticsEventViewDocument : MendeleyAnalyticsEvent
{
    open var from_screen: String!
}

