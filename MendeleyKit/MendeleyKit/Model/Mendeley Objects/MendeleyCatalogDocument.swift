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

import UIKit

open class MendeleyCatalogDocument: MendeleySwiftObject {
    public var link: String?
    public var reader_count: Int?
    public var reader_count_by_academic_status: [String: Int]?
    public var reader_count_by_subdiscipline: [String: Int]?
    
    // Ints
    public var month: Int?
    public var year: Int?
    public var day: Int?
    
    // Booleans
    public var file_attached: Bool?
    
    // Person
    public var authors: [MendeleySwiftPerson]?
    public var editors: [MendeleySwiftPerson]?
    public var websites: [String]?
    public var keywords: [String]?
    
    // Indentifiers (e.g. arxiv)
    public var identifiers: [String: String]?
    
    // Dates
    public var created: Date?
    
    // Strings
    public var type: String?
    public var source: String?
    public var title: String?
    public var revision: String?
    public var abstract: String?
    public var pages: String?
    public var volume: String?
    public var issue: String?
    public var publisher: String?
    public var city: String?
    public var edition: String?
    public var institution: String?
    public var series: String?
    public var chapter: String?
    public var accessed: String?
}
