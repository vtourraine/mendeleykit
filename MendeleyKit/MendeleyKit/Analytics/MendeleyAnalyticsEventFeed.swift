//
//  MendeleyAnalyticsEventFeed.swift
//  MendeleyKit
//
//  Created by Tunney, Aaron (ELS) on 12/04/2017.
//  Copyright © 2017 Mendeley. All rights reserved.
//

import UIKit

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
    open var itemType: String!
    
    public init(itemType: String) {
        super.init(name: kMendeleyAnalyticsEventFeedItemViewed)
        self.itemType = itemType
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

open class MendeleyAnalyticsEventFeedItemViewed: MendeleyAnalyticsEventFeed {
    open var index: Int!
    
    public init(itemType: String, index: Int) {
        super.init(itemType: itemType)
        self.index = index
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

open class MendeleyAnalyticsEventFeedItemClicked: MendeleyAnalyticsEventFeed {
    open var pageLoadId = "false"
    open var section: String!
    open var itemId: String!
    open var coauthor = "false"
    
    public init(itemType: String, itemId: String, section: String) {
        super.init(itemType: itemType)
        self.name = kMendeleyAnalyticsEventFeedItemClicked
        self.itemId = itemId
        self.section = section
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

open class MendeleyAnalyticsEventFeedComment: MendeleyAnalyticsEventFeed {
    open var itemId: String!
    open var pageLoadId: String!
}

open class MendeleyAnalyticsEventFeedCommentAdded: MendeleyAnalyticsEventFeedComment {}

open class MendeleyAnalyticsEventFeedCommendDeleted: MendeleyAnalyticsEventFeedComment {
    open var commentIndex: Int!
}
