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

@objc open class MendeleyDataset : MendeleyObject {
    @objc public var name: String?
    @objc public var doi: MendeleyDOI?
    @objc public var object_version: NSNumber?
    @objc public var contributors: [MendeleyPublicContributorDetails]?
    @objc public var versions: [MendeleyVersionMetadata]?
    @objc public var files: [MendeleyFileMetadata]?
    @objc public var articles: [MendeleyEmbeddedArticleView]?
    @objc public var categories: [MendeleyCategory]?
    @objc public var institutions: [MendeleyInstitution]?
    @objc public var metrics: MendeleyDatasetMetrics?
    @objc public var available: NSNumber?
    @objc public var method: String?
    @objc public var related_links: [MendeleyRelatedLink]?
    @objc public var publish_date: Date?
    @objc public var data_licence: MendeleyLicenceInfo?
    @objc public var owner_id: String?
    @objc public var embargo_date: Date?
    
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
        if let object_versionInt = try container.decodeIfPresent(Int.self, forKey: .object_version) {
            object_version = NSNumber(value: object_versionInt)
        }
        contributors = try container.decodeIfPresent([MendeleyPublicContributorDetails].self, forKey: .contributors)
        versions = try container.decodeIfPresent([MendeleyVersionMetadata].self, forKey: .versions)
        files = try container.decodeIfPresent([MendeleyFileMetadata].self, forKey: .files)
        articles = try container.decodeIfPresent([MendeleyEmbeddedArticleView].self, forKey: .articles)
        categories = try container.decodeIfPresent([MendeleyCategory].self, forKey: .categories)
        institutions = try container.decodeIfPresent([MendeleyInstitution].self, forKey: .institutions)
        metrics = try container.decodeIfPresent(MendeleyDatasetMetrics.self, forKey: .metrics)
        if let availableBool = try container.decodeIfPresent(Bool.self, forKey: .available) {
            available = NSNumber(value: availableBool)
        }
        method = try container.decodeIfPresent(String.self, forKey: .method)
        related_links = try container.decodeIfPresent([MendeleyRelatedLink].self, forKey: .related_links)
        publish_date = try container.decodeIfPresent(Date.self, forKey: .publish_date)
        data_licence = try container.decodeIfPresent(MendeleyLicenceInfo.self, forKey: .data_licence)
        owner_id = try container.decodeIfPresent(String.self, forKey: .owner_id)
        embargo_date = try container.decodeIfPresent(Date.self, forKey: .embargo_date)
        try super.init(from: decoder)
    }
    
    @objc public override init() {
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(doi, forKey: .doi)
        try container.encodeIfPresent(object_version?.intValue, forKey: .object_version)
        try container.encodeIfPresent(contributors, forKey: .contributors)
        try container.encodeIfPresent(versions, forKey: .versions)
        try container.encodeIfPresent(files, forKey: .files)
        try container.encodeIfPresent(articles, forKey: .articles)
        try container.encodeIfPresent(categories, forKey: .categories)
        try container.encodeIfPresent(institutions, forKey: .institutions)
        try container.encodeIfPresent(metrics, forKey: .metrics)
        try container.encodeIfPresent(available?.boolValue, forKey: .available)
        try container.encodeIfPresent(method, forKey: .method)
        try container.encodeIfPresent(related_links, forKey: .related_links)
        try container.encodeIfPresent(publish_date, forKey: .publish_date)
        try container.encodeIfPresent(data_licence, forKey: .data_licence)
        try container.encodeIfPresent(owner_id, forKey: .owner_id)
        try container.encodeIfPresent(embargo_date, forKey: .embargo_date)
    }
}


@objc open class MendeleyDOI : MendeleyObject {
    @objc public var status: String?
    
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


@objc open class MendeleyPublicContributorDetails : MendeleyObject {
    @objc public var contribution: String?
    @objc public var institution: String?
    @objc public var profile_id: String?
    @objc public var first_name: String?
    @objc public var last_name: String?
    
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


@objc open class MendeleyInstitution : MendeleyObject {
    @objc public var scival_id: NSNumber?
    @objc public var name: String?
    @objc public var city: String?
    @objc public var state: String?
    @objc public var country: String?
    @objc public var parent_id: String?
    @objc public var urls: [String]?
    @objc public var profile_url: String?
    @objc public var alt_names: [MendeleyAlternativeName]?
    
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
        if let scival_idInt = try container.decodeIfPresent(Int.self, forKey: .scival_id) {
            scival_id = NSNumber(value: scival_idInt)
        }
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


@objc open class MendeleyAlternativeName : MendeleyObject {
    @objc public var name: String?
    
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


@objc open class MendeleyVersionMetadata : MendeleyObject {
    @objc public var object_version: NSNumber?
    @objc public var available: NSNumber?
    @objc public var publish_date: Date?
    @objc public var embargo_date: Date?
    
    private enum CodingKeys: String, CodingKey {
        case object_version
        case available
        case publish_date
        case embargo_date
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let object_versionInt = try container.decodeIfPresent(Int.self, forKey: .object_version) {
            object_version = NSNumber(value: object_versionInt)
        }
        if let availableBool = try container.decodeIfPresent(Bool.self, forKey: .available) {
            available = NSNumber(value: availableBool)
        }
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
        try container.encodeIfPresent(object_version?.intValue, forKey: .object_version)
        try container.encodeIfPresent(available?.boolValue, forKey: .available)
        try container.encodeIfPresent(publish_date, forKey: .publish_date)
        try container.encodeIfPresent(embargo_date, forKey: .embargo_date)
    }
}


@objc open class MendeleyFileMetadata : MendeleyObject {
    @objc public var filename: String?
    @objc public var metrics: MendeleyFileMetrics?
    @objc public var content_details: MendeleyFileData?
    
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

@objc open class MendeleyContentTicket : MendeleyObject {}

@objc open class MendeleyFileMetrics : MendeleyObject {
    @objc public var downloads: NSNumber?
    @objc public var previews: NSNumber?
    @objc public var fileId: String?
    
    private enum CodingKeys: String, CodingKey {
        case downloads
        case previews
        case fileId
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let downloadsInt = try container.decodeIfPresent(Int.self, forKey: .downloads) {
            downloads = NSNumber(value: downloadsInt)
        }
        if let previewsInt = try container.decodeIfPresent(Int.self, forKey: .previews) {
            previews = NSNumber(value: previewsInt)
        }
        fileId = try container.decodeIfPresent(String.self, forKey: .fileId)
        try super.init(from: decoder)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(downloads?.intValue, forKey: .downloads)
        try container.encodeIfPresent(previews?.intValue, forKey: .previews)
        try container.encodeIfPresent(fileId, forKey: .fileId)
    }
}


@objc open class MendeleyFileData : MendeleyObject {
    @objc public var size: NSNumber?
    @objc public var content_type: String?
    @objc public var download_url: String?
    @objc public var sha256_hash: String?
    @objc public var sha1_hash: String?
    @objc public var view_url: String?
    @objc public var download_expiry_time: String?
    @objc public var created_date: Date?
    
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
        if let sizeInt = try container.decodeIfPresent(Int.self, forKey: .size) {
            size = NSNumber(value: sizeInt)
        }
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
        try container.encodeIfPresent(size?.intValue, forKey: .size)
        try container.encodeIfPresent(content_type, forKey: .content_type)
        try container.encodeIfPresent(download_url, forKey: .download_url)
        try container.encodeIfPresent(sha256_hash, forKey: .sha256_hash)
        try container.encodeIfPresent(sha1_hash, forKey: .sha1_hash)
        try container.encodeIfPresent(view_url, forKey: .view_url)
        try container.encodeIfPresent(download_expiry_time, forKey: .download_expiry_time)
        try container.encodeIfPresent(created_date, forKey: .created_date)
    }
}


@objc open class MendeleyEmbeddedArticleView : MendeleyObject {
    @objc public var journal: MendeleyEmbeddedJournalView?
    @objc public var title: String?
    @objc public var doi: String?
    
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


@objc open class MendeleyEmbeddedJournalView : MendeleyObject {
    @objc public var url: String?
    @objc public var issn: String?
    @objc public var name: String?
    
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


@objc open class MendeleyCategory : MendeleyObject {
    @objc public var label: String?
    
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


@objc open class MendeleyDatasetMetrics : MendeleyObject {
    @objc public var views: NSNumber?
    @objc public var file_downloads: NSNumber?
    @objc public var file_previews: NSNumber?
    
    private enum CodingKeys: String, CodingKey {
        case views
        case file_downloads
        case file_previews
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let viewsInt = try container.decodeIfPresent(Int.self, forKey: .views) {
            views = NSNumber(value: viewsInt)
        }
        if let file_downloadsInt = try container.decodeIfPresent(Int.self, forKey: .file_downloads) {
            file_downloads = NSNumber(value: file_downloadsInt)
        }
        if let file_previewsInt = try container.decodeIfPresent(Int.self, forKey: .file_previews) {
            file_previews = NSNumber(value: file_previewsInt)
        }
        try super.init(from: decoder)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(views?.intValue, forKey: .views)
        try container.encodeIfPresent(file_downloads?.intValue, forKey: .file_downloads)
        try container.encodeIfPresent(file_previews?.intValue, forKey: .file_previews)
    }
}


@objc open class MendeleyRelatedLink : MendeleyObject {
    @objc public var type: String?
    @objc public var rel: String?
    @objc public var href: String?
    
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


@objc open class MendeleyLicenceInfo : MendeleyObject {
    @objc public var url: String?
    @objc public var full_name: String?
    @objc public var short_name: String?
    
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

