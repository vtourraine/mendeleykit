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
    var link: String?
    var reader_count: Int?
    var reader_count_by_academic_status: [String: Int]?
    var reader_count_by_subdiscipline: [String: Int]?
    
    // Ints
    var month: Int?
    var year: Int?
    var day: Int?
    
    // Booleans
    var file_attached: Bool?
    
    // Person
    var authors: [MendeleySwiftPerson]?
    var editors: [MendeleySwiftPerson]?
    var websites: [String]?
    var keywords: [String]?
    
    // Indentifiers (e.g. arxiv)
    var identifiers: [String: String]?
    
    // Dates
    var created: Date?
    
    // Strings
    var type: String?
    var source: String?
    var title: String?
    var revision: String?
    var abstract: String?
    var pages: String?
    var volume: String?
    var issue: String?
    var publisher: String?
    var city: String?
    var edition: String?
    var institution: String?
    var series: String?
    var chapter: String?
    var accessed: String?
}
