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

open class MendeleyNewsFeed : MendeleySwiftObject {
    public var likeable: Bool?
    public var commentable: Bool?
    public var sharable: Bool?
    public var source: MendeleyNewsFeedSource?
    public var content: MendeleyJsonNode?
    public var created: String?
    public var share: MendeleyShare?
    public var like: MendeleyLike?
    public var comments: MendeleyExpandedComments?
    
    private enum CodingKeys: String, CodingKey {
        case likeable
        case commentable
        case sharable
        case source
        case content
        case created
        case share
        case like
        case comments
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        likeable = try container.decodeIfPresent(Bool.self, forKey: .likeable)
        commentable = try container.decodeIfPresent(Bool.self, forKey: .commentable)
        sharable = try container.decodeIfPresent(Bool.self, forKey: .sharable)
        source = try container.decodeIfPresent(MendeleyNewsFeedSource.self, forKey: .source)
        content = try container.decodeIfPresent(MendeleyJsonNode.self, forKey: .content)
        created = try container.decodeIfPresent(String.self, forKey: .created)
        share = try container.decodeIfPresent(MendeleyShare.self, forKey: .share)
        like = try container.decodeIfPresent(MendeleyLike.self, forKey: .like)
        comments = try container.decodeIfPresent(MendeleyExpandedComments.self, forKey: .comments)
        try super.init(from: decoder)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(likeable, forKey: .likeable)
        try container.encodeIfPresent(commentable, forKey: .commentable)
        try container.encodeIfPresent(sharable, forKey: .sharable)
        try container.encodeIfPresent(source, forKey: .source)
        try container.encodeIfPresent(content, forKey: .content)
        try container.encodeIfPresent(created, forKey: .created)
        try container.encodeIfPresent(share, forKey: .share)
        try container.encodeIfPresent(like, forKey: .like)
        try container.encodeIfPresent(comments, forKey: .comments)
    }
}

open class MendeleyNewsFeedSource : MendeleySwiftSecureObject, Codable {
    public var type: String?
    
    private enum CodingKeys: String, CodingKey {
        case type
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decodeIfPresent(String.self, forKey: .type)
        super.init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(type, forKey: .type)
    }
}

open class MendeleyNewsFeedProfileSource : MendeleyNewsFeedSource {
    public var profile: MendeleySocialProfile?
    
    private enum CodingKeys: String, CodingKey {
        case profile
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        profile = try container.decodeIfPresent(MendeleySocialProfile.self, forKey: .profile)
        try super.init(from: decoder)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(profile, forKey: .profile)
    }
}

open class MendeleyNewsFeedRSSSource : MendeleyNewsFeedSource {
    public var rss_feed: MendeleyFeedRSSFeed?
    
    private enum CodingKeys: String, CodingKey {
        case rss_feed
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        rss_feed = try container.decodeIfPresent(MendeleyFeedRSSFeed.self, forKey: .rss_feed)
        try super.init(from: decoder)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(rss_feed, forKey: .rss_feed)
    }
}

open class MendeleyFeedRSSFeed : MendeleySwiftSecureObject, Codable {
    public var name: String?
    public var link: String?
    
    private enum CodingKeys: String, CodingKey {
        case name
        case link
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        link = try container.decodeIfPresent(String.self, forKey: .link)
        super.init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(link, forKey: .link)
    }
}

open class MendeleyJsonNode : MendeleySwiftSecureObject, Codable {
    public var type: String?
    
    private enum CodingKeys: String, CodingKey {
        case type
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decodeIfPresent(String.self, forKey: .type)
        super.init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(type, forKey: .type)
    }
}

open class MendeleyCountableJsonNode : MendeleyJsonNode {
    public var total_count: Int?
    
    private enum CodingKeys: String, CodingKey {
        case total_count
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        total_count = try container.decodeIfPresent(Int.self, forKey: .total_count)
        try super.init(from: decoder)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(total_count, forKey: .total_count)
    }
}

open class MendeleyDocumentRecommendationJsonNode : MendeleyCountableJsonNode {
    public var subtype: String?
    public var user_document: MendeleyUserDocument?
    public var recommendations: [MendeleyRecommendedDocument]?
    
    private enum CodingKeys: String, CodingKey {
        case subtype
        case user_document = "user_documents"
        case recommendations
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        subtype = try container.decodeIfPresent(String.self, forKey: .subtype)
        user_document = try container.decodeIfPresent(MendeleyUserDocument.self, forKey: .user_document)
        recommendations = try container.decodeIfPresent([MendeleyRecommendedDocument].self, forKey: .recommendations)
        try super.init(from: decoder)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(subtype, forKey: .subtype)
        try container.encodeIfPresent(user_document, forKey: .user_document)
        try container.encodeIfPresent(recommendations, forKey: .recommendations)
    }
}

open class MendeleyEmploymentUpdateJsonNode : MendeleyCountableJsonNode {
    public var institution: String?
    public var position: String?
    
    private enum CodingKeys: String, CodingKey {
        case institution
        case position
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        institution = try container.decodeIfPresent(String.self, forKey: .institution)
        position = try container.decodeIfPresent(String.self, forKey: .position)
        try super.init(from: decoder)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(institution, forKey: .institution)
        try container.encodeIfPresent(position, forKey: .position)
    }
}

open class MendeleyEducationUpdateJsonNode : MendeleyCountableJsonNode {
    public var institution: String?
    public var degree: String?
    
    private enum CodingKeys: String, CodingKey {
        case institution
        case degree
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        institution = try container.decodeIfPresent(String.self, forKey: .institution)
        degree = try container.decodeIfPresent(String.self, forKey: .degree)
        try super.init(from: decoder)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(institution, forKey: .institution)
        try container.encodeIfPresent(degree, forKey: .degree)
    }
}

open class MendeleyGroupDocAddedJsonNode : MendeleyCountableJsonNode {
    public var group: MendeleyFeedGroup?
    public var documents: [MendeleyAddedDocument]?
    
    private enum CodingKeys: String, CodingKey {
        case group
        case documents
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        group = try container.decodeIfPresent(MendeleyFeedGroup.self, forKey: .group)
        documents = try container.decodeIfPresent([MendeleyAddedDocument].self, forKey: .documents)
        try super.init(from: decoder)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(group, forKey: .group)
        try container.encodeIfPresent(documents, forKey: .documents)
    }
}

open class MendeleyFeedGroup : MendeleySwiftObject {
    public var link: String?
    public var access_level: String?
    public var name: String?
    
    private enum CodingKeys: String, CodingKey {
        case link
        case access_level
        case name
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        link = try container.decodeIfPresent(String.self, forKey: .link)
        access_level = try container.decodeIfPresent(String.self, forKey: .access_level)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        try super.init(from: decoder)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(link, forKey: .link)
        try container.encodeIfPresent(access_level, forKey: .access_level)
        try container.encodeIfPresent(name, forKey: .name)
    }
}

open class MendeleyNewFollowerJsonNode : MendeleyCountableJsonNode {
    public var followings: [MendeleyFollowerProfile]?
    
    private enum CodingKeys: String, CodingKey {
        case followings
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        followings = try container.decodeIfPresent([MendeleyFollowerProfile].self, forKey: .followings)
        try super.init(from: decoder)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(followings, forKey: .followings)
    }
}

open class MendeleyNewPublicationJsonNode : MendeleyCountableJsonNode {
    public var documents: [MendeleyPublishedDocument]?
    public var co_authors: [MendeleyFeedAuthor]?
    
    private enum CodingKeys: String, CodingKey {
        case documents
        case co_authors
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        documents = try container.decodeIfPresent([MendeleyPublishedDocument].self, forKey: .documents)
        co_authors = try container.decodeIfPresent([MendeleyFeedAuthor].self, forKey: .co_authors)
        try super.init(from: decoder)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(documents, forKey: .documents)
        try container.encodeIfPresent(co_authors, forKey: .co_authors)
    }
}

open class MendeleyNewStatusJsonNode : MendeleyJsonNode {
    public var post: MendeleyPost?
    
    private enum CodingKeys: String, CodingKey {
        case post
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        post = try container.decodeIfPresent(MendeleyPost.self, forKey: .post)
        try super.init(from: decoder)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(post, forKey: .post)
    }
}

open class MendeleyGroupStatusJsonNode: MendeleyJsonNode {
    public var group: MendeleyGroup?
    public var post: MendeleyGroupPost?
    
    private enum CodingKeys: String, CodingKey {
        case group
        case post
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        group = try container.decodeIfPresent(MendeleyGroup.self, forKey: .group)
        post = try container.decodeIfPresent(MendeleyGroupPost.self, forKey: .post)
        try super.init(from: decoder)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(group, forKey: .group)
        try container.encodeIfPresent(post, forKey: .post)
    }
}

open class MendeleyPostedCataloguePublicationJsonNode : MendeleyCountableJsonNode {
    public var documents: [MendeleyCataloguePubDocument]?
    
    private enum CodingKeys: String, CodingKey {
        case documents
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        documents = try container.decodeIfPresent([MendeleyCataloguePubDocument].self, forKey: .documents)
        try super.init(from: decoder)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(documents, forKey: .documents)
    }
}

open class MendeleyPostedPublicationJsonNode : MendeleyCountableJsonNode {
    public var documents: [MendeleyCataloguePubDocument]?
    
    private enum CodingKeys: String, CodingKey {
        case documents
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        documents = try container.decodeIfPresent([MendeleyCataloguePubDocument].self, forKey: .documents)
        try super.init(from: decoder)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(documents, forKey: .documents)
    }
}

open class MendeleyRSSJsonNode : MendeleyJsonNode {
    public var title: String?
    public var summary: String?
    public var link: String?
    public var publish_date: String?
    public var image_url: String?
    
    private enum CodingKeys: String, CodingKey {
        case title
        case summary
        case link
        case publish_date
        case image_url
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        summary = try container.decodeIfPresent(String.self, forKey: .summary)
        link = try container.decodeIfPresent(String.self, forKey: .link)
        publish_date = try container.decodeIfPresent(String.self, forKey: .publish_date)
        image_url = try container.decodeIfPresent(String.self, forKey: .image_url)
        try super.init(from: decoder)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(title, forKey: .title)
        try container.encodeIfPresent(summary, forKey: .summary)
        try container.encodeIfPresent(link, forKey: .link)
        try container.encodeIfPresent(publish_date, forKey: .publish_date)
        try container.encodeIfPresent(image_url, forKey: .image_url)
    }
}

open class MendeleyShare : MendeleySwiftSecureObject, Codable {
    public var total_count: Int?
    public var shared_by_me: Bool?
    public var originating_sharer_profile: MendeleySocialProfile?
    public var most_recent_sharer_profiles: [MendeleySocialProfile]?

    private enum CodingKeys: String, CodingKey {
        case total_count
        case shared_by_me
        case originating_sharer_profile
        case most_recent_sharer_profiles
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        total_count = try container.decodeIfPresent(Int.self, forKey: .total_count)
        shared_by_me = try container.decodeIfPresent(Bool.self, forKey: .shared_by_me)
        originating_sharer_profile = try container.decodeIfPresent(MendeleySocialProfile.self, forKey: .originating_sharer_profile)
        most_recent_sharer_profiles = try container.decodeIfPresent([MendeleySocialProfile].self, forKey: .most_recent_sharer_profiles)
        super.init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(total_count, forKey: .total_count)
        try container.encodeIfPresent(shared_by_me, forKey: .shared_by_me)
        try container.encodeIfPresent(originating_sharer_profile, forKey: .originating_sharer_profile)
        try container.encodeIfPresent(most_recent_sharer_profiles, forKey: .most_recent_sharer_profiles)
    }
}

open class MendeleyLike : MendeleySwiftSecureObject, Codable {
    public var total_count: Int?
    public var liked_by_me: Bool?
    
    private enum CodingKeys: String, CodingKey {
        case total_count
        case liked_by_me
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        total_count = try container.decodeIfPresent(Int.self, forKey: .total_count)
        liked_by_me = try container.decodeIfPresent(Bool.self, forKey: .liked_by_me)
        super.init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(total_count, forKey: .total_count)
        try container.encodeIfPresent(liked_by_me, forKey: .liked_by_me)
    }
}

open class MendeleyExpandedComments : MendeleySwiftSecureObject, Codable {
    public var total_count: Int?
    public var latest: [MendeleyExpandedComment]?
    
    private enum CodingKeys: String, CodingKey {
        case total_count
        case latest
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        total_count = try container.decodeIfPresent(Int.self, forKey: .total_count)
        latest = try container.decodeIfPresent([MendeleyExpandedComment].self, forKey: .latest)
        super.init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(total_count, forKey: .total_count)
        try container.encodeIfPresent(latest, forKey: .latest)
    }
}

open class MendeleyPost : MendeleySwiftObject {
    public var text: String?
    public var document: MendeleyFeedDocument?
    public var documents: [MendeleyFeedDocument]?
    public var tagged_users: [MendeleySocialProfile]?
    
    private enum CodingKeys: String, CodingKey {
        case text
        case document
        case documents
        case tagged_users
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        text = try container.decodeIfPresent(String.self, forKey: .text)
        document = try container.decodeIfPresent(MendeleyFeedDocument.self, forKey: .document)
        documents = try container.decodeIfPresent([MendeleyFeedDocument].self, forKey: .documents)
        tagged_users = try container.decodeIfPresent([MendeleySocialProfile].self, forKey: .tagged_users)
        try super.init(from: decoder)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(text, forKey: .text)
        try container.encodeIfPresent(document, forKey: .document)
        try container.encodeIfPresent(documents, forKey: .documents)
        try container.encodeIfPresent(tagged_users, forKey: .tagged_users)
    }
}

open class MendeleyGroupPost : MendeleyPost {
    public var group_id: String?
    public var visibility: String?
    public var poster_id: String?
    public var created_date_time: String?
    public var hide_link_snippet: Bool?
    
    private enum CodingKeys: String, CodingKey {
        case group_id
        case visibility
        case poster_id
        case created_date_time
        case hide_link_snippet
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        group_id = try container.decodeIfPresent(String.self, forKey: .group_id)
        visibility = try container.decodeIfPresent(String.self, forKey: .visibility)
        poster_id = try container.decodeIfPresent(String.self, forKey: .poster_id)
        created_date_time = try container.decodeIfPresent(String.self, forKey: .created_date_time)
        hide_link_snippet = try container.decodeIfPresent(Bool.self, forKey: .hide_link_snippet)
        try super.init(from: decoder)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(group_id, forKey: .group_id)
        try container.encodeIfPresent(visibility, forKey: .visibility)
        try container.encodeIfPresent(poster_id, forKey: .poster_id)
        try container.encodeIfPresent(created_date_time, forKey: .created_date_time)
        try container.encodeIfPresent(hide_link_snippet, forKey: .hide_link_snippet)
    }
}

open class MendeleyFeedDocument : MendeleySwiftObject {
    public var title: String?
    public var year: Int?
    public var link: String?
    public var type: String?
    public var authors: [MendeleyFeedAuthor]?
    public var doi: String?
    
    private enum CodingKeys: String, CodingKey {
        case title
        case year
        case link
        case type
        case authors
        case doi
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        year = try container.decodeIfPresent(Int.self, forKey: .year)
        link = try container.decodeIfPresent(String.self, forKey: .link)
        type = try container.decodeIfPresent(String.self, forKey: .type)
        authors = try container.decodeIfPresent([MendeleyFeedAuthor].self, forKey: .authors)
        doi = try container.decodeIfPresent(String.self, forKey: .doi)
        try super.init(from: decoder)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(title, forKey: .title)
        try container.encodeIfPresent(year, forKey: .year)
        try container.encodeIfPresent(link, forKey: .link)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(authors, forKey: .authors)
        try container.encodeIfPresent(doi, forKey: .doi)
    }
}

open class MendeleyAddedDocument : MendeleySwiftObject {
    public var title: String?
    public var year: Int?
    public var link: String?
    public var type: String?
    public var authors: [MendeleySimpleAuthor]?
    
    private enum CodingKeys: String, CodingKey {
        case title
        case year
        case link
        case type
        case authors
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        year = try container.decodeIfPresent(Int.self, forKey: .year)
        link = try container.decodeIfPresent(String.self, forKey: .link)
        type = try container.decodeIfPresent(String.self, forKey: .type)
        authors = try container.decodeIfPresent([MendeleyFeedAuthor].self, forKey: .authors)
        try super.init(from: decoder)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(title, forKey: .title)
        try container.encodeIfPresent(year, forKey: .year)
        try container.encodeIfPresent(link, forKey: .link)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(authors, forKey: .authors)
    }
}

open class MendeleyPublishedDocument : MendeleyAddedDocument {
    public var source: String?
    
    private enum CodingKeys: String, CodingKey {
        case source
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        source = try container.decodeIfPresent(String.self, forKey: .source)
        try super.init(from: decoder)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(source, forKey: .source)
    }
}

open class MendeleyRecommendedDocument : MendeleyPublishedDocument {
    public var doi: String?
    public var trace: String?
    public var reader_count: Int?
    public var abstract: String?
    
    private enum CodingKeys: String, CodingKey {
        case doi
        case trace
        case reader_count
        case abstract
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        doi = try container.decodeIfPresent(String.self, forKey: .doi)
        trace = try container.decodeIfPresent(String.self, forKey: .trace)
        reader_count = try container.decodeIfPresent(Int.self, forKey: .reader_count)
        abstract = try container.decodeIfPresent(String.self, forKey: .abstract)
        try super.init(from: decoder)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(source, forKey: .doi)
        try container.encodeIfPresent(trace, forKey: .trace)
        try container.encodeIfPresent(reader_count, forKey: .reader_count)
        try container.encodeIfPresent(abstract, forKey: .abstract)
    }
}

open class MendeleyCataloguePubDocument : MendeleyPublishedDocument {
    public var doi: String?
    
    private enum CodingKeys: String, CodingKey {
        case doi
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        doi = try container.decodeIfPresent(String.self, forKey: .doi)
        try super.init(from: decoder)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(doi, forKey: .doi)
    }
}

open class MendeleyUserDocument : MendeleySwiftSecureObject, Codable {
    public var title: String?
    public var type: String?
    public var year: Int?
    public var source: String?
    public var authors: [MendeleySimpleAuthor]?
    public var identifiers: [NSDictionary]?
    
    private enum CodingKeys: String, CodingKey {
        case title
        case type
        case year
        case source
        case authors
        case identifiers
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        type = try container.decodeIfPresent(String.self, forKey: .type)
        year = try container.decodeIfPresent(Int.self, forKey: .year)
        source = try container.decodeIfPresent(String.self, forKey: .source)
        authors = try container.decodeIfPresent([MendeleySimpleAuthor].self, forKey: .authors)
        identifiers = try container.decodeIfPresent([NSDictionary].self, forKey: .identifiers)
        super.init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(title, forKey: .title)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(year, forKey: .year)
        try container.encodeIfPresent(source, forKey: .source)
        try container.encodeIfPresent(authors, forKey: .authors)
        try container.encodeIfPresent(identifiers, forKey: .identifiers)
    }
}

open class MendeleySimpleAuthor : MendeleySwiftSecureObject, Codable {
    public var first_name: String?
    public var last_name: String?

    private enum CodingKeys: String, CodingKey {
        case first_name
        case last_name
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        first_name = try container.decodeIfPresent(String.self, forKey: .first_name)
        last_name = try container.decodeIfPresent(String.self, forKey: .last_name)
        super.init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(first_name, forKey: .first_name)
        try container.encodeIfPresent(last_name, forKey: .last_name)
    }
}

open class MendeleyFeedAuthor : MendeleySimpleAuthor {
    public var scopus_author_id: String?
    
    private enum CodingKeys: String, CodingKey {
        case scopus_author_id
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        scopus_author_id = try container.decodeIfPresent(String.self, forKey: .scopus_author_id)
        try super.init(from: decoder)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(scopus_author_id, forKey: .scopus_author_id)
    }
}

open class MendeleySocialProfile : MendeleySwiftObject {
    public var first_name: String?
    public var last_name: String?
    public var link: String?
    public var photos: [MendeleySocialProfilePhoto]?
    
    private enum CodingKeys: String, CodingKey {
        case first_name
        case last_name
        case link
        case photos
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        first_name = try container.decodeIfPresent(String.self, forKey: .first_name)
        last_name = try container.decodeIfPresent(String.self, forKey: .last_name)
        link = try container.decodeIfPresent(String.self, forKey: .link)
        photos = try container.decodeIfPresent([MendeleySocialProfilePhoto].self, forKey: .photos)
        try super.init(from: decoder)
    }
    
    required public init?(coder aDecoder: NSCoder) {
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

open class MendeleyFollowerProfile : MendeleySocialProfile {
    public var profile_id: String?
    public var institution: String?
    
    private enum CodingKeys: String, CodingKey {
        case profile_id
        case institution
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        profile_id = try container.decodeIfPresent(String.self, forKey: .profile_id)
        institution = try container.decodeIfPresent(String.self, forKey: .institution)
        try super.init(from: decoder)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(profile_id, forKey: .profile_id)
        try container.encodeIfPresent(institution, forKey: .institution)
    }
}

open class MendeleySocialProfilePhoto : MendeleySwiftSecureObject, Codable {
    public var width: Float?
    public var height: Float?
    public var url: String?
    public var original: Bool?
    
    private enum CodingKeys: String, CodingKey {
        case width
        case height
        case url
        case original
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        width = try container.decodeIfPresent(Float.self, forKey: .width)
        height = try container.decodeIfPresent(Float.self, forKey: .height)
        url = try container.decodeIfPresent(String.self, forKey: .url)
        original = try container.decodeIfPresent(Bool.self, forKey: .original)
        super.init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(width, forKey: .width)
        try container.encodeIfPresent(height, forKey: .height)
        try container.encodeIfPresent(url, forKey: .url)
        try container.encodeIfPresent(original, forKey: .original)
    }
}
