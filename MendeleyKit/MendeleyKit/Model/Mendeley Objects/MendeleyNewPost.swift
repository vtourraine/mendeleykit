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

// MARK: - MendeleyNewPost

open class MendeleyNewPost: MendeleySwiftSecureObject {
    public var text: String?
    public var document_ids: [String]?
    public var tagged_users: [String]?
    public var hide_link_snippet: Bool?
    
    private enum CodingKeys: String, CodingKey {
        case text
        case document_ids
        case tagged_users
        case hide_link_snippet
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        text = try container.decodeIfPresent(String.self, forKey: .text)
        document_ids = try container.decodeIfPresent([String].self, forKey: .document_ids)
        tagged_users = try container.decodeIfPresent([String].self, forKey: .tagged_users)
        hide_link_snippet = try container.decodeIfPresent(Bool.self, forKey: .hide_link_snippet)
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(text, forKey: .text)
        try container.encodeIfPresent(document_ids, forKey: .document_ids)
        try container.encodeIfPresent(tagged_users, forKey: .tagged_users)
        try container.encodeIfPresent(hide_link_snippet, forKey: .hide_link_snippet)
    }
}

// MARK: - MendeleyNewUserPost

open class MendeleyNewUserPost: MendeleyNewPost {
    
}

// MARK: - MendeleyNewGroupPost

open class MendeleyNewGroupPost: MendeleyNewPost {
    public var group_id: String?
    public var poster_id: String?
    
    private enum CodingKeys: String, CodingKey {
        case group_id
        case poster_id
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        group_id = try container.decodeIfPresent(String.self, forKey: .group_id)
        poster_id = try container.decodeIfPresent(String.self, forKey: .poster_id)
        try super.init(from: decoder)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(group_id, forKey: .group_id)
        try container.encodeIfPresent(poster_id, forKey: .poster_id)
    }
}

// MARK: - MendeleyUserPost

open class MendeleyUserPost: MendeleySwiftObject {
    public var text: String?
    public var post_id: String?
    public var tagged_users: [MendeleyProfileLink]?
    public var created_date_time: String?
    public var document: MendeleySocialDocument?
    public var documents: [MendeleySocialDocument]?
    public var images: [MendeleyUserPostImage]?
    public var last_modified_date_time: String?
    public var hide_link_snippet: Bool?
    
    private enum CodingKeys: String, CodingKey {
        case text
        case post_id
        case tagged_users
        case created_date_time
        case document
        case documents
        case images
        case last_modified_date_time
        case hide_link_snippet
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        text = try container.decodeIfPresent(String.self, forKey: .text)
        post_id = try container.decodeIfPresent(String.self, forKey: .post_id)
        tagged_users = try container.decodeIfPresent([MendeleyProfileLink].self, forKey: .tagged_users)
        created_date_time = try container.decodeIfPresent(String.self, forKey: .created_date_time)
        document = try container.decodeIfPresent(MendeleySocialDocument.self, forKey: .document)
        documents = try container.decodeIfPresent([MendeleySocialDocument].self, forKey: .documents)
        images = try container.decodeIfPresent([MendeleyUserPostImage].self, forKey: .images)
        last_modified_date_time = try container.decodeIfPresent(String.self, forKey: .last_modified_date_time)
        hide_link_snippet = try container.decodeIfPresent(Bool.self, forKey: .hide_link_snippet)
        
        try super.init(from: decoder)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(text, forKey: .text)
        try container.encodeIfPresent(post_id, forKey: .post_id)
        try container.encodeIfPresent(tagged_users, forKey: .tagged_users)
        try container.encodeIfPresent(created_date_time, forKey: .created_date_time)
        try container.encodeIfPresent(document, forKey: .document)
        try container.encodeIfPresent(documents, forKey: .documents)
        try container.encodeIfPresent(images, forKey: .images)
        try container.encodeIfPresent(last_modified_date_time, forKey: .last_modified_date_time)
        try container.encodeIfPresent(hide_link_snippet, forKey: .hide_link_snippet)
    }
}

// MARK: - MendeleyProfileLink

open class MendeleyProfileLink: MendeleySwiftObject {
    public var first_name: String?
    public var last_name: String?
    public var link: String?
    public var photos: [MendeleyImage]?
    
    private enum CodingKeys: String, CodingKey {
        case first_name
        case last_name
        case link
        case photos
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        first_name = try container.decodeIfPresent(String.self, forKey: .first_name)
        last_name = try container.decodeIfPresent(String.self, forKey: .last_name)
        link = try container.decodeIfPresent(String.self, forKey: .link)
        photos = try container.decodeIfPresent([MendeleyImage].self, forKey: .photos)
        try super.init(from: decoder)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(first_name, forKey: .first_name)
        try container.encodeIfPresent(last_name, forKey: .last_name)
        try container.encodeIfPresent(link, forKey: .link)
        try container.encodeIfPresent(photos, forKey: .photos)
    }
}

// MARK: - MendeleySocialDocument

open class MendeleySocialDocument: MendeleySwiftObject {
    public var title: String?
    public var year: Int?
    public var link: String?
    public var type: String?
    public var source: String?
    public var authors: [MendeleyFeedAuthor]?
    public var doi: String?
    public var trace: String?
    public var reader_count: Int?
    public var file_summary: [MendeleyFileSummary]?
    public var abstract: String?
    
    private enum CodingKeys: String, CodingKey {
        case title
        case year
        case link
        case type
        case source
        case authors
        case doi
        case trace
        case reader_count
        case file_summary
        case abstract
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
           title = try container.decodeIfPresent(String.self, forKey: .title)
           year = try container.decodeIfPresent(Int.self, forKey: .year)
           link = try container.decodeIfPresent(String.self, forKey: .link)
           type = try container.decodeIfPresent(String.self, forKey: .type)
           source = try container.decodeIfPresent(String.self, forKey: .source)
           authors = try container.decodeIfPresent([MendeleyFeedAuthor].self, forKey: .authors)
           doi = try container.decodeIfPresent(String.self, forKey: .doi)
           trace = try container.decodeIfPresent(String.self, forKey: .trace)
           reader_count = try container.decodeIfPresent(Int.self, forKey: .reader_count)
//           file_summary = try container.decodeIfPresent(MendeleyFileSummary.self, forKey: .file_summary)
           abstract = try container.decodeIfPresent(String.self, forKey: .abstract)
        try super.init(from: decoder)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(title, forKey: .title)
        try container.encodeIfPresent(year, forKey: .year)
        try container.encodeIfPresent(link, forKey: .link)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(source, forKey: .source)
        try container.encodeIfPresent(authors, forKey: .authors)
        try container.encodeIfPresent(doi, forKey: .doi)
        try container.encodeIfPresent(trace, forKey: .trace)
        try container.encodeIfPresent(reader_count, forKey: .reader_count)
        try container.encodeIfPresent(file_summary, forKey: .file_summary)
        try container.encodeIfPresent(abstract, forKey: .abstract)
    }
}

// MARK: - MendeleySocialAuthor

open class MendeleySocialAuthor: MendeleySwiftObject {
    public var first_name: String?
    public var last_name: String?
    public var scopus_author_id: String?
    
    private enum CodingKeys: String, CodingKey {
        case first_name
        case last_name
        case scopus_author_id
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
           first_name = try container.decodeIfPresent(String.self, forKey: .first_name)
           last_name = try container.decodeIfPresent(String.self, forKey: .last_name)
           scopus_author_id = try container.decodeIfPresent(String.self, forKey: .scopus_author_id)
        try super.init(from: decoder)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(first_name, forKey: .first_name)
        try container.encodeIfPresent(last_name, forKey: .last_name)
        try container.encodeIfPresent(scopus_author_id, forKey: .scopus_author_id)
    }
}

// MARK: - MendeleyUserPostImage

open class MendeleyUserPostImage: MendeleyObject {
    
}

// MARK: - MendeleyFilesSummary

open class MendeleyFilesSummary: MendeleySwiftObject {
    public var first_files: [MendeleyFileSummary]?
    public var file_count: Int?
    
    private enum CodingKeys: String, CodingKey {
        case first_files
        case file_count
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
           first_files = try container.decodeIfPresent([MendeleyFileSummary].self, forKey: .first_files)
           file_count = try container.decodeIfPresent(Int.self, forKey: .file_count)
        try super.init(from: decoder)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(first_files, forKey: .first_files)
        try container.encodeIfPresent(file_count, forKey: .file_count)
    }
}

// MARK: - MendeleyFileSummary

open class MendeleyFileSummary: MendeleySwiftObject {
    
}

/*
// MARK: -

open class : {
    public var : ?
    public var : ?
    public var : ?
    public var : ?
    public var : ?
    public var : ?
    public var : ?
    public var : ?
    public var : ?
    public var : ?
    
    private enum CodingKeys: String, CodingKey {
        case
        case
        case
        case
        case
        case
        case
        case
        case
        case
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
         = try container.decodeIfPresent(.self, forKey: .)
            = try container.decodeIfPresent(.self, forKey: .)
            = try container.decodeIfPresent(.self, forKey: .)
            = try container.decodeIfPresent(.self, forKey: .)
            = try container.decodeIfPresent(.self, forKey: .)
            = try container.decodeIfPresent(.self, forKey: .)
            = try container.decodeIfPresent(.self, forKey: .)
            = try container.decodeIfPresent(.self, forKey: .)
            = try container.decodeIfPresent(.self, forKey: .)
            = try container.decodeIfPresent(.self, forKey: .)
        try super.init(from: decoder)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(, forKey: .)
        try container.encodeIfPresent(, forKey: .)
        try container.encodeIfPresent(, forKey: .)
        try container.encodeIfPresent(, forKey: .)
        try container.encodeIfPresent(, forKey: .)
        try container.encodeIfPresent(, forKey: .)
        try container.encodeIfPresent(, forKey: .)
        try container.encodeIfPresent(, forKey: .)
        try container.encodeIfPresent(, forKey: .)
        try container.encodeIfPresent(, forKey: .)
    }
}
*/

