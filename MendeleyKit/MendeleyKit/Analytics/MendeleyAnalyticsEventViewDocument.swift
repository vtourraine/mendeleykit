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

public enum MendeleyViewDocumentFromScreen : String {
    case All = "all"
    case Documents = "documents"
    case Favorities = "favorites"
    case Folder = "folder"
    case Group = "group"
    case MyPublications = "my_publications"
    case RecentlyAdded = "recently_added"
    case RecentlyRead = "recently_read"
    case Tag = "tag"
    case Trash = "trash"
    case Search = "search"
}

open class MendeleyAnalyticsEventViewDocument : MendeleyAnalyticsEvent
{
    open var from_screen: String!
}

