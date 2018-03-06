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

@objc open class MendeleyCatalogDocument: MendeleyObject {
    @objc public var link: String?
    @objc public var reader_count: NSNumber?
    @objc public var reader_count_by_academic_status: [String: Int]?
    @objc public var reader_count_by_subdiscipline: [String: Int]?
    
    // Ints
    @objc public var month: NSNumber?
    @objc public var year: NSNumber?
    @objc public var day: NSNumber?
    
    // Booleans
    @objc public var file_attached: NSNumber?
    
    // Person
    @objc public var authors: [MendeleyPerson]?
    @objc public var editors: [MendeleyPerson]?
    @objc public var websites: [String]?
    @objc public var keywords: [String]?
    
    // Indentifiers (e.g. arxiv)
    @objc public var identifiers: [String: String]?
    
    // Dates
    @objc public var created: Date?
    
    // Strings
    @objc public var type: String?
    @objc public var source: String?
    @objc public var title: String?
    @objc public var revision: String?
    @objc public var abstract: String?
    @objc public var pages: String?
    @objc public var volume: String?
    @objc public var issue: String?
    @objc public var publisher: String?
    @objc public var city: String?
    @objc public var edition: String?
    @objc public var institution: String?
    @objc public var series: String?
    @objc public var chapter: String?
    @objc public var accessed: String?
    
    private enum CodingKeys: String, CodingKey {
        case link
        case reader_count
        case reader_count_by_academic_status
        case reader_count_by_subdiscipline
        case month
        case year
        case day
        case file_attached
        case authors
        case editors
        case websites
        case keywords
        case identifiers
        case created
        case type
        case source
        case title
        case revision
        case abstract
        case pages
        case volume
        case issue
        case publisher
        case city
        case edition
        case institution
        case series
        case chapter
        case accessed
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        link = try container.decodeIfPresent(String.self, forKey: .link)
        if let reader_countInt = try container.decodeIfPresent(Int.self, forKey: .reader_count) {
            reader_count = NSNumber(value: reader_countInt)
        }
        reader_count_by_academic_status = try container.decodeIfPresent([String: Int].self, forKey: .reader_count_by_academic_status)
        reader_count_by_subdiscipline = try container.decodeIfPresent([String: Int].self, forKey: .reader_count_by_subdiscipline)
        
        if let monthInt = try container.decodeIfPresent(Int.self, forKey: .month) {
            month = NSNumber(value: monthInt)
        }
        if let yearInt = try container.decodeIfPresent(Int.self, forKey: .year) {
            year = NSNumber(value: yearInt)
        }
        if let dayInt = try container.decodeIfPresent(Int.self, forKey: .day) {
            day = NSNumber(value: dayInt)
        }
        
        if let file_attachedBool = try container.decodeIfPresent(Bool.self, forKey: .file_attached) {
            file_attached = NSNumber(value: file_attachedBool)
        }
        
        authors = try container.decodeIfPresent([MendeleyPerson].self, forKey: .authors)
        editors = try container.decodeIfPresent([MendeleyPerson].self, forKey: .editors)
        websites = try container.decodeIfPresent([String].self, forKey: .websites)
        keywords = try container.decodeIfPresent([String].self, forKey: .keywords)
        
        identifiers = try container.decodeIfPresent([String: String].self, forKey: .identifiers)
        
        created = try container.decodeIfPresent(Date.self, forKey: .created)
        
        type = try container.decodeIfPresent(String.self, forKey: .type)
        source = try container.decodeIfPresent(String.self, forKey: .source)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        revision = try container.decodeIfPresent(String.self, forKey: .revision)
        abstract = try container.decodeIfPresent(String.self, forKey: .abstract)
        pages = try container.decodeIfPresent(String.self, forKey: .pages)
        volume = try container.decodeIfPresent(String.self, forKey: .volume)
        issue = try container.decodeIfPresent(String.self, forKey: .issue)
        publisher = try container.decodeIfPresent(String.self, forKey: .publisher)
        city = try container.decodeIfPresent(String.self, forKey: .city)
        edition = try container.decodeIfPresent(String.self, forKey: .edition)
        institution = try container.decodeIfPresent(String.self, forKey: .institution)
        series = try container.decodeIfPresent(String.self, forKey: .series)
        chapter = try container.decodeIfPresent(String.self, forKey: .chapter)
        accessed = try container.decodeIfPresent(String.self, forKey: .accessed)
        
        try super.init(from: decoder)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeIfPresent(link, forKey: .link)
        try container.encodeIfPresent(reader_count?.intValue, forKey: .reader_count)
        try container.encodeIfPresent(reader_count_by_academic_status, forKey: .reader_count_by_academic_status)
        try container.encodeIfPresent(reader_count_by_subdiscipline, forKey: .reader_count_by_subdiscipline)
        
        try container.encodeIfPresent(month?.intValue, forKey: .month)
        try container.encodeIfPresent(year?.intValue, forKey: .year)
        try container.encodeIfPresent(day?.intValue, forKey: .day)
        
        try container.encodeIfPresent(file_attached?.boolValue, forKey: .file_attached)
        
        try container.encodeIfPresent(authors, forKey: .authors)
        try container.encodeIfPresent(editors, forKey: .editors)
        try container.encodeIfPresent(websites, forKey: .websites)
        try container.encodeIfPresent(keywords, forKey: .keywords)
        
        try container.encodeIfPresent(identifiers, forKey: .identifiers)
        
        try container.encodeIfPresent(created, forKey: .created)
        
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(source, forKey: .source)
        try container.encodeIfPresent(title, forKey: .title)
        try container.encodeIfPresent(revision, forKey: .revision)
        try container.encodeIfPresent(abstract, forKey: .abstract)
        try container.encodeIfPresent(pages, forKey: .pages)
        try container.encodeIfPresent(volume, forKey: .volume)
        try container.encodeIfPresent(issue, forKey: .issue)
        try container.encodeIfPresent(publisher, forKey: .publisher)
        try container.encodeIfPresent(city, forKey: .city)
        try container.encodeIfPresent(edition, forKey: .edition)
        try container.encodeIfPresent(institution, forKey: .institution)
        try container.encodeIfPresent(series, forKey: .series)
        try container.encodeIfPresent(chapter, forKey: .chapter)
        try container.encodeIfPresent(accessed, forKey: .accessed)
    }
}
