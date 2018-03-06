/*
 ******************************************************************************
 * Copyright (C) 2014-2017 Elsevier/Mendeley.
 *
 * This file is part of the Mendeley iOS SDK.
 *
 * Licensed under the Apache License, Version 2.0 (the "License"):
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

@objc open class MendeleyDocument : MendeleyObject {
    /*
     NSNumber types (integer)
     */
    @objc public var month: NSNumber?
    @objc public var year: NSNumber?
    @objc public var day: NSNumber?
    
    /*
     NSNumber types (boolean)
     */
    @objc public var file_attached: NSNumber?
    @objc public var read: NSNumber?
    @objc public var starred: NSNumber?
    @objc public var authored: NSNumber?
    @objc public var confirmed: NSNumber?
    @objc public var hidden: NSNumber?
    
    /*
     NSArray types
     */
    @objc public var authors: [MendeleyPerson]?
    @objc public var editors: [MendeleyPerson]?
    @objc public var translators: [MendeleyPerson]?
    @objc public var websites: [String]?
    @objc public var keywords: [String]?
    @objc public var tags: [String]?
    
    /*
     NSDictionary type (Identifiers, e.g. arxiv)
     */
    @objc public var identifiers: [String: String]?
    
    /*
     NSDate types (stringDate)
     */
    @objc public var last_modified: Date?
    @objc public var created: Date?
    
    /*
     String? types (string)
     */
    @objc public var type: String?
    @objc public var group_id: String?
    @objc public var source: String?
    @objc public var title: String?
    @objc public var revision: String?
    @objc public var abstract: String?
    @objc public var profile_id: String?
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
    @objc public var citation_key: String?
    @objc public var source_type: String?
    @objc public var language: String?
    @objc public var short_title: String?
    @objc public var reprint_edition: String?
    @objc public var genre: String?
    @objc public var country: String?
    @objc public var series_editor: String?
    @objc public var code: String?
    @objc public var medium: String?
    @objc public var user_context: String?
    @objc public var department: String?
    @objc public var patent_owner: String?
    @objc public var patent_application_number: String?
    @objc public var patent_legal_status: String?
    @objc public var notes: String?
    @objc public var series_number: String?
    
    private enum CodingKeys: String, CodingKey {
        case objectDescription
        case month
        case year
        case day
        case file_attached
        case read
        case starred
        case authored
        case confirmed
        case hidden
        case authors
        case editors
        case translators
        case websites
        case keywords
        case tags
        case identifiers
        case last_modified
        case created
        case type
        case group_id
        case source
        case title
        case revision
        case abstract
        case profile_id
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
        case citation_key
        case source_type
        case language
        case short_title
        case reprint_edition
        case genre
        case country
        case series_editor
        case code
        case medium
        case user_context
        case department
        case patent_owner
        case patent_application_number
        case patent_legal_status
        case notes
        case series_number
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
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
        if let readBool = try container.decodeIfPresent(Bool.self, forKey: .read) {
            read = NSNumber(value: readBool)
        }
        if let starredBool = try container.decodeIfPresent(Bool.self, forKey: .starred) {
            starred = NSNumber(value: starredBool)
        }
        if let authoredBool = try container.decodeIfPresent(Bool.self, forKey: .authored) {
            authored = NSNumber(value: authoredBool)
        }
        if let confirmedBool = try container.decodeIfPresent(Bool.self, forKey: .confirmed) {
            confirmed = NSNumber(value: confirmedBool)
        }
        if let hiddenBool = try container.decodeIfPresent(Bool.self, forKey: .hidden) {
            hidden = NSNumber(value: hiddenBool)
        }
        authors = try container.decodeIfPresent([MendeleyPerson].self, forKey: .authors)
        editors = try container.decodeIfPresent([MendeleyPerson].self, forKey: .editors)
        translators = try container.decodeIfPresent([MendeleyPerson].self, forKey: .translators)
        websites = try container.decodeIfPresent([String].self, forKey: .websites)
        keywords = try container.decodeIfPresent([String].self, forKey: .keywords)
        tags = try container.decodeIfPresent([String].self, forKey: .keywords)
        identifiers = try container.decodeIfPresent([String: String].self, forKey: .keywords)
        last_modified = try container.decodeIfPresent(Date.self, forKey: .keywords)
        created = try container.decodeIfPresent(Date.self, forKey: .created)
        type = try container.decodeIfPresent(String.self, forKey: .type)
        group_id = try container.decodeIfPresent(String.self, forKey: .group_id)
        source = try container.decodeIfPresent(String.self, forKey: .source)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        revision = try container.decodeIfPresent(String.self, forKey: .revision)
        abstract = try container.decodeIfPresent(String.self, forKey: .abstract)
        profile_id = try container.decodeIfPresent(String.self, forKey: .profile_id)
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
        citation_key = try container.decodeIfPresent(String.self, forKey: .citation_key)
        source_type = try container.decodeIfPresent(String.self, forKey: .source_type)
        language = try container.decodeIfPresent(String.self, forKey: .language)
        short_title = try container.decodeIfPresent(String.self, forKey: .short_title)
        reprint_edition = try container.decodeIfPresent(String.self, forKey: .reprint_edition)
        genre = try container.decodeIfPresent(String.self, forKey: .genre)
        country = try container.decodeIfPresent(String.self, forKey: .country)
        series_editor = try container.decodeIfPresent(String.self, forKey: .series_editor)
        code = try container.decodeIfPresent(String.self, forKey: .code)
        medium = try container.decodeIfPresent(String.self, forKey: .medium)
        user_context = try container.decodeIfPresent(String.self, forKey: .user_context)
        department = try container.decodeIfPresent(String.self, forKey: .department)
        patent_owner = try container.decodeIfPresent(String.self, forKey: .patent_owner)
        patent_application_number = try container.decodeIfPresent(String.self, forKey: .patent_application_number)
        patent_legal_status = try container.decodeIfPresent(String.self, forKey: .patent_legal_status)
        notes = try container.decodeIfPresent(String.self, forKey: .notes)
        series_number = try container.decodeIfPresent(String.self, forKey: .series_number)
        try super.init(from: decoder)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(objectDescription, forKey: .objectDescription)
        try container.encodeIfPresent(month?.intValue, forKey: .month)
        try container.encodeIfPresent(year?.intValue, forKey: .year)
        try container.encodeIfPresent(day?.intValue, forKey: .day)
        try container.encodeIfPresent(file_attached?.boolValue, forKey: .file_attached)
        try container.encodeIfPresent(read?.boolValue, forKey: .read)
        try container.encodeIfPresent(starred?.boolValue, forKey: .starred)
        try container.encodeIfPresent(authored?.boolValue, forKey: .authored)
        try container.encodeIfPresent(confirmed?.boolValue, forKey: .confirmed)
        try container.encodeIfPresent(hidden?.boolValue, forKey: .hidden)
        try container.encodeIfPresent(authors, forKey: .authors)
        try container.encodeIfPresent(editors, forKey: .editors)
        try container.encodeIfPresent(translators, forKey: .translators)
        try container.encodeIfPresent(websites, forKey: .websites)
        try container.encodeIfPresent(keywords, forKey: .keywords)
        try container.encodeIfPresent(tags, forKey: .tags)
        try container.encodeIfPresent(identifiers, forKey: .identifiers)
        try container.encodeIfPresent(last_modified, forKey: .last_modified)
        try container.encodeIfPresent(created, forKey: .created)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(group_id, forKey: .group_id)
        try container.encodeIfPresent(source, forKey: .source)
        try container.encodeIfPresent(title, forKey: .title)
        try container.encodeIfPresent(revision, forKey: .revision)
        try container.encodeIfPresent(abstract, forKey: .abstract)
        try container.encodeIfPresent(profile_id, forKey: .profile_id)
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
        try container.encodeIfPresent(citation_key, forKey: .citation_key)
        try container.encodeIfPresent(source_type, forKey: .source_type)
        try container.encodeIfPresent(language, forKey: .language)
        try container.encodeIfPresent(short_title, forKey: .short_title)
        try container.encodeIfPresent(reprint_edition, forKey: .reprint_edition)
        try container.encodeIfPresent(genre, forKey: .genre)
        try container.encodeIfPresent(country, forKey: .country)
        try container.encodeIfPresent(series_editor, forKey: .series_editor)
        try container.encodeIfPresent(code, forKey: .code)
        try container.encodeIfPresent(medium, forKey: .medium)
        try container.encodeIfPresent(user_context, forKey: .user_context)
        try container.encodeIfPresent(department, forKey: .department)
        try container.encodeIfPresent(patent_owner, forKey: .patent_owner)
        try container.encodeIfPresent(patent_application_number, forKey: .patent_application_number)
        try container.encodeIfPresent(patent_legal_status, forKey: .patent_legal_status)
        try container.encodeIfPresent(notes, forKey: .notes)
        try container.encodeIfPresent(series_number, forKey: .series_number)
    }
    
}
