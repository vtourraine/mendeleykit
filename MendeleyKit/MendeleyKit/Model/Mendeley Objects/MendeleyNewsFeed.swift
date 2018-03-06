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

@objc open class MendeleyNewsFeed : MendeleyObject {
    @objc public var likeable: NSNumber?
    @objc public var commentable: NSNumber?
    @objc public var sharable: NSNumber?
    @objc public var source: MendeleyNewsFeedSource?
    @objc public var content: MendeleyJsonNode?
    @objc public var created: String?
    @objc public var share: MendeleyShare?
    @objc public var like: MendeleyLike?
    @objc public var comments: MendeleyExpandedComments?
    
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
        if let likeableBool = try container.decodeIfPresent(Bool.self, forKey: .likeable) {
            likeable = NSNumber(value: likeableBool)
        }
        if let commentableBool = try container.decodeIfPresent(Bool.self, forKey: .commentable) {
            commentable = NSNumber(value: commentableBool)
        }
        if let sharableBool = try container.decodeIfPresent(Bool.self, forKey: .sharable) {
            sharable = NSNumber(value: sharableBool)
        }
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
        try container.encodeIfPresent(likeable?.boolValue, forKey: .likeable)
        try container.encodeIfPresent(commentable?.boolValue, forKey: .commentable)
        try container.encodeIfPresent(sharable?.boolValue, forKey: .sharable)
        try container.encodeIfPresent(source, forKey: .source)
        try container.encodeIfPresent(content, forKey: .content)
        try container.encodeIfPresent(created, forKey: .created)
        try container.encodeIfPresent(share, forKey: .share)
        try container.encodeIfPresent(like, forKey: .like)
        try container.encodeIfPresent(comments, forKey: .comments)
    }
}

@objc open class MendeleyNewsFeedSource : MendeleySecureObject, Codable {
    @objc public var type: String?
    
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

@objc open class MendeleyNewsFeedProfileSource : MendeleyNewsFeedSource {
    @objc public var profile: MendeleySocialProfile?
    
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

@objc open class MendeleyNewsFeedRSSSource : MendeleyNewsFeedSource {
    @objc public var rss_feed: MendeleyFeedRSSFeed?
    
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

@objc open class MendeleyFeedRSSFeed : MendeleySecureObject, Codable {
    @objc public var name: String?
    @objc public var link: String?
    
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

@objc open class MendeleyJsonNode : MendeleySecureObject, Codable {
    @objc public var type: String?
    
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

@objc open class MendeleyCountableJsonNode : MendeleyJsonNode {
    @objc public var total_count: NSNumber?
    
    private enum CodingKeys: String, CodingKey {
        case total_count
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let total_countInt = try container.decodeIfPresent(Int.self, forKey: .total_count) {
            total_count = NSNumber(value: total_countInt)
        }
        try super.init(from: decoder)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(total_count?.boolValue, forKey: .total_count)
    }
}

@objc open class MendeleyDocumentRecommendationJsonNode : MendeleyCountableJsonNode {
    @objc public var subtype: String?
    @objc public var user_document: MendeleyUserDocument?
    @objc public var recommendations: [MendeleyRecommendedDocument]?
    
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

@objc open class MendeleyEmploymentUpdateJsonNode : MendeleyCountableJsonNode {
    @objc public var institution: String?
    @objc public var position: String?
    
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

@objc open class MendeleyEducationUpdateJsonNode : MendeleyCountableJsonNode {
    @objc public var institution: String?
    @objc public var degree: String?
    
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

@objc open class MendeleyGroupDocAddedJsonNode : MendeleyCountableJsonNode {
    @objc public var group: MendeleyFeedGroup?
    @objc public var documents: [MendeleyAddedDocument]?
    
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

@objc open class MendeleyFeedGroup : MendeleyObject {
    @objc public var link: String?
    @objc public var access_level: String?
    @objc public var name: String?
    
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

@objc open class MendeleyNewFollowerJsonNode : MendeleyCountableJsonNode {
    @objc public var followings: [MendeleyFollowerProfile]?
    
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

@objc open class MendeleyNewPublicationJsonNode : MendeleyCountableJsonNode {
    @objc public var documents: [MendeleyPublishedDocument]?
    @objc public var co_authors: [MendeleyFeedAuthor]?
    
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

@objc open class MendeleyNewStatusJsonNode : MendeleyJsonNode {
    @objc public var post: MendeleyPost?
    
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

@objc open class MendeleyGroupStatusJsonNode: MendeleyJsonNode {
    @objc public var group: MendeleyGroup?
    @objc public var post: MendeleyGroupPost?
    
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

@objc open class MendeleyPostedCataloguePublicationJsonNode : MendeleyCountableJsonNode {
    @objc public var documents: [MendeleyCataloguePubDocument]?
    
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

@objc open class MendeleyPostedPublicationJsonNode : MendeleyCountableJsonNode {
    @objc public var documents: [MendeleyCataloguePubDocument]?
    
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

@objc open class MendeleyRSSJsonNode : MendeleyJsonNode {
    @objc public var title: String?
    @objc public var summary: String?
    @objc public var link: String?
    @objc public var publish_date: String?
    @objc public var image_url: String?
    
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

@objc open class MendeleyShare : MendeleySecureObject, Codable {
    @objc public var total_count: NSNumber?
    @objc public var shared_by_me: NSNumber?
    @objc public var originating_sharer_profile: MendeleySocialProfile?
    @objc public var most_recent_sharer_profiles: [MendeleySocialProfile]?

    private enum CodingKeys: String, CodingKey {
        case total_count
        case shared_by_me
        case originating_sharer_profile
        case most_recent_sharer_profiles
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let total_countInt = try container.decodeIfPresent(Int.self, forKey: .total_count) {
            total_count = NSNumber(value: total_countInt)
        }
        if let shared_by_meBool = try container.decodeIfPresent(Bool.self, forKey: .shared_by_me) {
            shared_by_me = NSNumber(value: shared_by_meBool)
        }
        originating_sharer_profile = try container.decodeIfPresent(MendeleySocialProfile.self, forKey: .originating_sharer_profile)
        most_recent_sharer_profiles = try container.decodeIfPresent([MendeleySocialProfile].self, forKey: .most_recent_sharer_profiles)
        super.init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(total_count?.intValue, forKey: .total_count)
        try container.encodeIfPresent(shared_by_me?.boolValue, forKey: .shared_by_me)
        try container.encodeIfPresent(originating_sharer_profile, forKey: .originating_sharer_profile)
        try container.encodeIfPresent(most_recent_sharer_profiles, forKey: .most_recent_sharer_profiles)
    }
}

@objc open class MendeleyLike : MendeleySecureObject, Codable {
    @objc public var total_count: NSNumber?
    @objc public var liked_by_me: NSNumber?
    
    private enum CodingKeys: String, CodingKey {
        case total_count
        case liked_by_me
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let total_countInt = try container.decodeIfPresent(Int.self, forKey: .total_count) {
            total_count = NSNumber(value: total_countInt)
        }
        if let liked_by_meBool = try container.decodeIfPresent(Bool.self, forKey: .liked_by_me) {
            liked_by_me = NSNumber(value: liked_by_meBool)
        }
        super.init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(total_count?.intValue, forKey: .total_count)
        try container.encodeIfPresent(liked_by_me?.boolValue, forKey: .liked_by_me)
    }
}

@objc open class MendeleyExpandedComments : MendeleySecureObject, Codable {
    @objc public var total_count: NSNumber?
    @objc public var latest: [MendeleyExpandedComment]?
    
    private enum CodingKeys: String, CodingKey {
        case total_count
        case latest
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let total_countInt = try container.decodeIfPresent(Int.self, forKey: .total_count) {
            total_count = NSNumber(value: total_countInt)
        }
        latest = try container.decodeIfPresent([MendeleyExpandedComment].self, forKey: .latest)
        super.init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(total_count?.intValue, forKey: .total_count)
        try container.encodeIfPresent(latest, forKey: .latest)
    }
}

@objc open class MendeleyPost : MendeleyObject {
    @objc public var text: String?
    @objc public var document: MendeleyFeedDocument?
    @objc public var documents: [MendeleyFeedDocument]?
    @objc public var tagged_users: [MendeleySocialProfile]?
    
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

@objc open class MendeleyGroupPost : MendeleyPost {
    @objc public var group_id: String?
    @objc public var visibility: String?
    @objc public var poster_id: String?
    @objc public var created_date_time: String?
    @objc public var hide_link_snippet: NSNumber?
    
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
        if let hide_link_snippetBool = try container.decodeIfPresent(Bool.self, forKey: .hide_link_snippet) {
            hide_link_snippet = NSNumber(value: hide_link_snippetBool)
        }
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
        try container.encodeIfPresent(hide_link_snippet?.boolValue, forKey: .hide_link_snippet)
    }
}

@objc open class MendeleyFeedDocument : MendeleyObject {
    @objc public var title: String?
    @objc public var year: NSNumber?
    @objc public var link: String?
    @objc public var type: String?
    @objc public var authors: [MendeleyFeedAuthor]?
    @objc public var doi: String?
    
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
        if let yearInt = try container.decodeIfPresent(Int.self, forKey: .year) {
            year = NSNumber(value: yearInt)
        }
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
        try container.encodeIfPresent(year?.intValue, forKey: .year)
        try container.encodeIfPresent(link, forKey: .link)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(authors, forKey: .authors)
        try container.encodeIfPresent(doi, forKey: .doi)
    }
}

@objc open class MendeleyAddedDocument : MendeleyObject {
    @objc public var title: String?
    @objc public var year: NSNumber?
    @objc public var link: String?
    @objc public var type: String?
    @objc public var authors: [MendeleySimpleAuthor]?
    
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
        if let yearInt = try container.decodeIfPresent(Int.self, forKey: .year) {
            year = NSNumber(value: yearInt)
        }
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
        try container.encodeIfPresent(year?.intValue, forKey: .year)
        try container.encodeIfPresent(link, forKey: .link)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(authors, forKey: .authors)
    }
}

@objc open class MendeleyPublishedDocument : MendeleyAddedDocument {
    @objc public var source: String?
    
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

@objc open class MendeleyRecommendedDocument : MendeleyPublishedDocument {
    @objc public var doi: String?
    @objc public var trace: String?
    @objc public var reader_count: NSNumber?
    @objc public var abstract: String?
    
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
        if let reader_countInt = try container.decodeIfPresent(Int.self, forKey: .reader_count) {
            reader_count = NSNumber(value: reader_countInt)
        }
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
        try container.encodeIfPresent(reader_count?.intValue, forKey: .reader_count)
        try container.encodeIfPresent(abstract, forKey: .abstract)
    }
}

@objc open class MendeleyCataloguePubDocument : MendeleyPublishedDocument {
    @objc public var doi: String?
    
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

@objc open class MendeleyUserDocument : MendeleySecureObject, Codable {
    @objc public var title: String?
    @objc public var type: String?
    @objc public var year: NSNumber?
    @objc public var source: String?
    @objc public var authors: [MendeleySimpleAuthor]?
    @objc public var identifiers: [NSDictionary]?
    
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
        if let yearInt = try container.decodeIfPresent(Int.self, forKey: .year) {
            year = NSNumber(value: yearInt)
        }
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
        try container.encodeIfPresent(year?.intValue, forKey: .year)
        try container.encodeIfPresent(source, forKey: .source)
        try container.encodeIfPresent(authors, forKey: .authors)
        try container.encodeIfPresent(identifiers, forKey: .identifiers)
    }
}

@objc open class MendeleySimpleAuthor : MendeleySecureObject, Codable {
    @objc public var first_name: String?
    @objc public var last_name: String?

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

@objc open class MendeleyFeedAuthor : MendeleySimpleAuthor {
    @objc public var scopus_author_id: String?
    
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

@objc open class MendeleySocialProfile : MendeleyObject {
    @objc public var first_name: String?
    @objc public var last_name: String?
    @objc public var link: String?
    @objc public var photos: [MendeleySocialProfilePhoto]?
    
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

@objc open class MendeleyFollowerProfile : MendeleySocialProfile {
    @objc public var profile_id: String?
    @objc public var institution: String?
    
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

@objc open class MendeleySocialProfilePhoto : MendeleySecureObject, Codable {
    @objc public var width: NSNumber?
    @objc public var height: NSNumber?
    @objc public var url: String?
    @objc public var original: NSNumber?
    
    private enum CodingKeys: String, CodingKey {
        case width
        case height
        case url
        case original
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let widthDouble = try container.decodeIfPresent(Double.self, forKey: .width) {
            width = NSNumber(value: widthDouble)
        }
        if let heightDouble = try container.decodeIfPresent(Double.self, forKey: .height) {
            height = NSNumber(value: heightDouble)
        }
        url = try container.decodeIfPresent(String.self, forKey: .url)
        if let originalBool = try container.decodeIfPresent(Bool.self, forKey: .original) {
            original = NSNumber(value: originalBool)
        }
        super.init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(width?.doubleValue, forKey: .width)
        try container.encodeIfPresent(height?.doubleValue, forKey: .height)
        try container.encodeIfPresent(url, forKey: .url)
        try container.encodeIfPresent(original?.boolValue, forKey: .original)
    }
}
