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

open class MendeleyDataset : MendeleyObject {
    public var name: String?
    public var doi: MendeleyDOI?
    public var object_version: Int?
    public var contributors: [MendeleyPublicContributorDetails]?
    public var versions: [MendeleyVersionMetadata]?
    public var files: [MendeleyFileMetadata]?
    public var articles: [MendeleyEmbeddedArticleView]?
    public var categories: [MendeleyCategory]?
    public var institutions: [MendeleyInstitution]?
    public var metrics: MendeleyDatasetMetrics?
    public var available: Bool?
    public var method: String?
    public var related_links: [MendeleyRelatedLink]?
    public var publish_date: Date?
    public var data_licence: MendeleyLicenceInfo?
    public var owner_id: String?
    public var embargo_date: Date?
    
    private enum CodingKeys: String, CodingKey {
        case name
        case doi
        case object_version
        case contributors
        case versions
        case files
        case articles
        case categories
        case institutions
        case metrics
        case available
        case method
        case related_links
        case publish_date
        case data_licence
        case owner_id
        case embargo_date
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        doi = try container.decodeIfPresent(MendeleyDOI.self, forKey: .doi)
        object_version = try container.decodeIfPresent(Int.self, forKey: .object_version)
        contributors = try container.decodeIfPresent([MendeleyPublicContributorDetails].self, forKey: .contributors)
        versions = try container.decodeIfPresent([MendeleyVersionMetadata].self, forKey: .versions)
        files = try container.decodeIfPresent([MendeleyFileMetadata].self, forKey: .files)
        articles = try container.decodeIfPresent([MendeleyEmbeddedArticleView].self, forKey: .articles)
        categories = try container.decodeIfPresent([MendeleyCategory].self, forKey: .categories)
        institutions = try container.decodeIfPresent([MendeleyInstitution].self, forKey: .institutions)
        metrics = try container.decodeIfPresent(MendeleyDatasetMetrics.self, forKey: .metrics)
        available = try container.decodeIfPresent(Bool.self, forKey: .available)
        method = try container.decodeIfPresent(String.self, forKey: .method)
        related_links = try container.decodeIfPresent([MendeleyRelatedLink].self, forKey: .related_links)
        publish_date = try container.decodeIfPresent(Date.self, forKey: .publish_date)
        data_licence = try container.decodeIfPresent(MendeleyLicenceInfo.self, forKey: .data_licence)
        owner_id = try container.decodeIfPresent(String.self, forKey: .owner_id)
        embargo_date = try container.decodeIfPresent(Date.self, forKey: .embargo_date)
        try super.init(from: decoder)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(doi, forKey: .doi)
        try container.encodeIfPresent(object_version, forKey: .object_version)
        try container.encodeIfPresent(contributors, forKey: .contributors)
        try container.encodeIfPresent(versions, forKey: .versions)
        try container.encodeIfPresent(files, forKey: .files)
        try container.encodeIfPresent(articles, forKey: .articles)
        try container.encodeIfPresent(categories, forKey: .categories)
        try container.encodeIfPresent(institutions, forKey: .institutions)
        try container.encodeIfPresent(metrics, forKey: .metrics)
        try container.encodeIfPresent(available, forKey: .available)
        try container.encodeIfPresent(method, forKey: .method)
        try container.encodeIfPresent(related_links, forKey: .related_links)
        try container.encodeIfPresent(publish_date, forKey: .publish_date)
        try container.encodeIfPresent(data_licence, forKey: .data_licence)
        try container.encodeIfPresent(owner_id, forKey: .owner_id)
        try container.encodeIfPresent(embargo_date, forKey: .embargo_date)
    }
}


open class MendeleyDOI : MendeleyObject {
    public var status: String?
    
    private enum CodingKeys: String, CodingKey {
        case status
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        status = try container.decodeIfPresent(String.self, forKey: .status)
        try super.init(from: decoder)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(status, forKey: .status)
    }
}


open class MendeleyPublicContributorDetails : MendeleyObject {
    public var contribution: String?
    public var institution: String?
    public var profile_id: String?
    public var first_name: String?
    public var last_name: String?
    
    private enum CodingKeys: String, CodingKey {
        case contribution
        case institution
        case profile_id
        case first_name
        case last_name
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        contribution = try container.decodeIfPresent(String.self, forKey: .contribution)
        institution = try container.decodeIfPresent(String.self, forKey: .institution)
        profile_id = try container.decodeIfPresent(String.self, forKey: .profile_id)
        first_name = try container.decodeIfPresent(String.self, forKey: .first_name)
        last_name = try container.decodeIfPresent(String.self, forKey: .last_name)
        try super.init(from: decoder)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(contribution, forKey: .contribution)
        try container.encodeIfPresent(institution, forKey: .institution)
        try container.encodeIfPresent(profile_id, forKey: .profile_id)
        try container.encodeIfPresent(first_name, forKey: .first_name)
        try container.encodeIfPresent(last_name, forKey: .last_name)
    }
}


open class MendeleyInstitution : MendeleyObject {
    public var scival_id: Int?
    public var name: String?
    public var city: String?
    public var state: String?
    public var country: String?
    public var parent_id: String?
    public var urls: [String?]?
    public var profile_url: String?
    public var alt_names: [MendeleyAlternativeName]?
    
    private enum CodingKeys: String, CodingKey {
        case scival_id
        case name
        case city
        case state
        case country
        case parent_id
        case urls
        case profile_url
        case alt_names
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        scival_id = try container.decodeIfPresent(Int.self, forKey: .scival_id)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        city = try container.decodeIfPresent(String.self, forKey: .city)
        state = try container.decodeIfPresent(String.self, forKey: .state)
        country = try container.decodeIfPresent(String.self, forKey: .country)
        parent_id = try container.decodeIfPresent(String.self, forKey: .parent_id)
        urls = try container.decodeIfPresent([String].self, forKey: .urls)
        profile_url = try container.decodeIfPresent(String.self, forKey: .profile_url)
        alt_names = try container.decodeIfPresent([MendeleyAlternativeName].self, forKey: .alt_names)
        try super.init(from: decoder)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(scival_id, forKey: .scival_id)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(city, forKey: .city)
        try container.encodeIfPresent(state, forKey: .state)
        try container.encodeIfPresent(country, forKey: .country)
        try container.encodeIfPresent(parent_id, forKey: .parent_id)
        try container.encodeIfPresent(urls, forKey: .urls)
        try container.encodeIfPresent(profile_url, forKey: .profile_url)
        try container.encodeIfPresent(alt_names, forKey: .alt_names)
    }
}


open class MendeleyAlternativeName : MendeleyObject {
    public var name: String?
    
    private enum CodingKeys: String, CodingKey {
        case name
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        try super.init(from: decoder)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(name, forKey: .name)
    }
}


open class MendeleyVersionMetadata : MendeleyObject {
    public var object_version: Int?
    public var available: Bool?
    public var publish_date: Date?
    public var embargo_date: Date?
    
    private enum CodingKeys: String, CodingKey {
        case object_version
        case available
        case publish_date
        case embargo_date
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        object_version = try container.decodeIfPresent(Int.self, forKey: .object_version)
        available = try container.decodeIfPresent(Bool.self, forKey: .available)
        publish_date = try container.decodeIfPresent(Date.self, forKey: .publish_date)
        embargo_date = try container.decodeIfPresent(Date.self, forKey: .embargo_date)
        try super.init(from: decoder)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(object_version, forKey: .object_version)
        try container.encodeIfPresent(available, forKey: .available)
        try container.encodeIfPresent(publish_date, forKey: .publish_date)
        try container.encodeIfPresent(embargo_date, forKey: .embargo_date)
    }
}


open class MendeleyFileMetadata : MendeleyObject {
    public var filename: String?
    public var metrics: MendeleyFileMetrics?
    public var content_details: MendeleyFileData?
    
    private enum CodingKeys: String, CodingKey {
        case filename
        case metrics
        case content_details
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        filename = try container.decodeIfPresent(String.self, forKey: .filename)
        metrics = try container.decodeIfPresent(MendeleyFileMetrics.self, forKey: .metrics)
        content_details = try container.decodeIfPresent(MendeleyFileData.self, forKey: .content_details)
        try super.init(from: decoder)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(filename, forKey: .filename)
        try container.encodeIfPresent(metrics, forKey: .metrics)
        try container.encodeIfPresent(content_details, forKey: .content_details)
    }
}


open class MendeleyContentTicket : MendeleyObject {
}


open class MendeleyFileMetrics : MendeleyObject {
    public var downloads: Int?
    public var previews: Int?
    public var fileId: String?
    
    private enum CodingKeys: String, CodingKey {
        case downloads
        case previews
        case fileId
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        downloads = try container.decodeIfPresent(Int.self, forKey: .downloads)
        previews = try container.decodeIfPresent(Int.self, forKey: .previews)
        fileId = try container.decodeIfPresent(String.self, forKey: .fileId)
        try super.init(from: decoder)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(downloads, forKey: .downloads)
        try container.encodeIfPresent(previews, forKey: .previews)
        try container.encodeIfPresent(fileId, forKey: .fileId)
    }
}


open class MendeleyFileData : MendeleyObject {
    public var size: Int?
    public var content_type: String?
    public var download_url: String?
    public var sha256_hash: String?
    public var sha1_hash: String?
    public var view_url: String?
    public var download_expiry_time: String?
    public var created_date: Date?
    
    private enum CodingKeys: String, CodingKey {
        case size
        case content_type
        case download_url
        case sha256_hash
        case sha1_hash
        case view_url
        case download_expiry_time
        case created_date
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        size = try container.decodeIfPresent(Int.self, forKey: .size)
        content_type = try container.decodeIfPresent(String.self, forKey: .content_type)
        download_url = try container.decodeIfPresent(String.self, forKey: .download_url)
        sha256_hash = try container.decodeIfPresent(String.self, forKey: .sha256_hash)
        sha1_hash = try container.decodeIfPresent(String.self, forKey: .sha1_hash)
        view_url = try container.decodeIfPresent(String.self, forKey: .view_url)
        download_expiry_time = try container.decodeIfPresent(String.self, forKey: .download_expiry_time)
        created_date = try container.decodeIfPresent(Date.self, forKey: .created_date)
        try super.init(from: decoder)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(size, forKey: .size)
        try container.encodeIfPresent(content_type, forKey: .content_type)
        try container.encodeIfPresent(download_url, forKey: .download_url)
        try container.encodeIfPresent(sha256_hash, forKey: .sha256_hash)
        try container.encodeIfPresent(sha1_hash, forKey: .sha1_hash)
        try container.encodeIfPresent(view_url, forKey: .view_url)
        try container.encodeIfPresent(download_expiry_time, forKey: .download_expiry_time)
        try container.encodeIfPresent(created_date, forKey: .created_date)
    }
}


open class MendeleyEmbeddedArticleView : MendeleyObject {
    public var journal: MendeleyEmbeddedJournalView?
    public var title: String?
    public var doi: String?
    
    private enum CodingKeys: String, CodingKey {
        case journal
        case title
        case doi
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        journal = try container.decodeIfPresent(MendeleyEmbeddedJournalView.self, forKey: .journal)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        doi = try container.decodeIfPresent(String.self, forKey: .doi)
        try super.init(from: decoder)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(journal, forKey: .journal)
        try container.encodeIfPresent(title, forKey: .title)
        try container.encodeIfPresent(doi, forKey: .doi)
    }
}


open class MendeleyEmbeddedJournalView : MendeleyObject {
    public var url: String?
    public var issn: String?
    public var name: String?
    
    private enum CodingKeys: String, CodingKey {
        case url
        case issn
        case name
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        url = try container.decodeIfPresent(String.self, forKey: .url)
        issn = try container.decodeIfPresent(String.self, forKey: .issn)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        try super.init(from: decoder)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(url, forKey: .url)
        try container.encodeIfPresent(issn, forKey: .issn)
        try container.encodeIfPresent(name, forKey: .name)
    }
}


open class MendeleyCategory : MendeleyObject {
    public var label: String?
    
    private enum CodingKeys: String, CodingKey {
        case label
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        label = try container.decodeIfPresent(String.self, forKey: .label)
        try super.init(from: decoder)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(label, forKey: .label)
    }
}


open class MendeleyDatasetMetrics : MendeleyObject {
    public var views: Int?
    public var file_downloads: Int?
    public var file_previews: Int?
    
    private enum CodingKeys: String, CodingKey {
        case views
        case file_downloads
        case file_previews
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        views = try container.decodeIfPresent(Int.self, forKey: .views)
        file_downloads = try container.decodeIfPresent(Int.self, forKey: .file_downloads)
        file_previews = try container.decodeIfPresent(Int.self, forKey: .file_previews)
        try super.init(from: decoder)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(views, forKey: .views)
        try container.encodeIfPresent(file_downloads, forKey: .file_downloads)
        try container.encodeIfPresent(file_previews, forKey: .file_previews)
    }
}


open class MendeleyRelatedLink : MendeleyObject {
    public var type: String?
    public var rel: String?
    public var href: String?
    
    private enum CodingKeys: String, CodingKey {
        case type
        case rel
        case href
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decodeIfPresent(String.self, forKey: .type)
        rel = try container.decodeIfPresent(String.self, forKey: .rel)
        href = try container.decodeIfPresent(String.self, forKey: .href)
        try super.init(from: decoder)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(rel, forKey: .rel)
        try container.encodeIfPresent(href, forKey: .href)
    }
}


open class MendeleyLicenceInfo : MendeleyObject {
    public var url: String?
    public var full_name: String?
    public var short_name: String?
    
    private enum CodingKeys: String, CodingKey {
        case url
        case full_name
        case short_name
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        url = try container.decodeIfPresent(String.self, forKey: .url)
        full_name = try container.decodeIfPresent(String.self, forKey: .full_name)
        short_name = try container.decodeIfPresent(String.self, forKey: .short_name)
        try super.init(from: decoder)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(url, forKey: .url)
        try container.encodeIfPresent(full_name, forKey: .full_name)
        try container.encodeIfPresent(short_name, forKey: .short_name)
    }
}

