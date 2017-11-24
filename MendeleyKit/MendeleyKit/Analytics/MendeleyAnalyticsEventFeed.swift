//
//  MendeleyAnalyticsEventFeed.swift
//  MendeleyKit
//
//  Created by Tunney, Aaron (ELS) on 12/04/2017.
//  Copyright © 2017 Mendeley. All rights reserved.
//

public enum FeedItemSection: String {
    case showMore = "see_more"
    case profileNameInRecommender = "profile_name_%ld"
    case profilePhotoInRecommender = "profile_photo_%ld"
    case profileNameInCards = "source_name"
    case groupName = "group_name"
    case attachDocument = "attach_document"
    case removeDocument = "detach_document"
    case attachImage = "attach_image"
    case removeImage = "detach_image"
    case postStatusTextArea = "textarea"
    case followersIconNextToPostButton = "change_visibility"
    case postButton = "post_button"
    case deleteStatusTextButton = "delete_status"
    case like = "like"
    case unlike = "unlike"
    case share = "share_to_followers"
    case likeCounter = "like_count"
    case shareCounter = "share_count"
    case publicationTitle = "title_%ld"
    case saveReference = "save_reference_%ld"
    case getFullTextAtJournal = "open_doi_%ld"
    case etAlOnAuthorNamesList = "authors_et_al"
    case followOrUnfollow = "follow_toggle_%ld"
    case seePreviousComments = "view_more_comments"
    case snippetImage = "snippet_image"
    case snippetTitle = "snippet_title"
    case snippetURL = "snippet_url"
    case removeSnippetPreview = "dismiss_snippet"
}

open class MendeleyAnalyticsEventFeed: MendeleyAnalyticsEvent {
    public var itemType: String {
        get {
            return properties[kMendeleyAnalyticsJSONItemType] as? String ?? ""
        }
        set {
            properties[kMendeleyAnalyticsJSONItemType] = newValue
        }
    }
    
    public init(itemType: String) {
        super.init(name: kMendeleyAnalyticsEventFeedItemViewed)
        self.itemType = itemType
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

open class MendeleyAnalyticsEventFeedItemViewed: MendeleyAnalyticsEventFeed {
    public var index: Int {
        get {
            return properties[kMendeleyAnalyticsJSONIndex] as? Int ?? -1
        }
        set {
            properties[kMendeleyAnalyticsJSONIndex] = newValue
        }
    }
    
    public init(itemType: String, index: Int) {
        super.init(itemType: itemType)
        self.index = index
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

open class MendeleyAnalyticsEventFeedItemClicked: MendeleyAnalyticsEventFeed {
    public var section: String {
        get {
            return properties[kMendeleyAnalyticsJSONSection] as? String ?? ""
        }
        set {
            properties[kMendeleyAnalyticsJSONSection] = newValue
        }
    }
    
    public var itemId: String {
        get {
            return properties[kMendeleyAnalyticsJSONItemId] as? String ?? ""
        }
        set {
            properties[kMendeleyAnalyticsJSONItemId] = newValue
        }
    }
    
    public init(itemType: String, itemId: String, section: String) {
        super.init(itemType: itemType)
        self.name = kMendeleyAnalyticsEventFeedItemClicked
        self.itemId = itemId
        self.section = section
        
        self.properties[kMendeleyAnalyticsJSONPageLoadId] = "false"
        self.properties[kMendeleyAnalyticsJSONCoautor] = "false"
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

open class MendeleyAnalyticsEventFeedComment: MendeleyAnalyticsEventFeed {
    public var itemId: String {
        get {
            return properties[kMendeleyAnalyticsJSONItemId] as? String ?? ""
        }
        set {
            properties[kMendeleyAnalyticsJSONItemId] = newValue
        }
    }
    
    public var pageLoadId: String {
        get {
            return properties[kMendeleyAnalyticsJSONPageLoadId] as? String ?? ""
        }
        set {
            properties[kMendeleyAnalyticsJSONPageLoadId] = newValue
        }
    }
    
    public init(itemType: String, itemId: String, pageLoadId: String) {
        super.init(itemType: itemType)
        self.itemId = itemId
        self.pageLoadId = pageLoadId
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

open class MendeleyAnalyticsEventFeedCommentAdded: MendeleyAnalyticsEventFeedComment {
    
    override public init(itemType: String, itemId: String, pageLoadId: String) {
        super.init(itemType: itemType, itemId: itemId, pageLoadId: pageLoadId)
        self.name = kMendeleyAnalyticsEventFeedCommentAdded
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

open class MendeleyAnalyticsEventFeedCommendDeleted: MendeleyAnalyticsEventFeedComment {
    open var commentIndex: Int {
        get {
            return properties[kMendeleyAnalyticsJSONCommentIndex] as? Int ?? -1
        }
        set {
            properties[kMendeleyAnalyticsJSONCommentIndex] = newValue
        }
    }
    
    public init(itemType: String, itemId: String, pageLoadId: String, commentIndex: Int) {
        super.init(itemType: itemType, itemId: itemId, pageLoadId: pageLoadId)
        self.commentIndex = commentIndex
        self.name = kMendeleyAnalyticsEventFeedCommentDeleted
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
