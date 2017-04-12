//
//  MendeleyAnalyticsEventFeed.swift
//  MendeleyKit
//
//  Created by Tunney, Aaron (ELS) on 12/04/2017.
//  Copyright © 2017 Mendeley. All rights reserved.
//

import UIKit

enum FeedItemType: String {
    case documentRecommendation = "document-recommendation"
    case documentsRecommendations = "documents-recommendat..." // ?
    case educationUpdate = "education-update"
    case employmentUpdate = "employment-update"
    case followed = "followed"
    case groupDocAdded = "group-doc-added"
    case groupStatusPosted = "group-status-posted"
    case newFollower = "new-follower"
    case newPub = "new-pub"
    case newStatus = "new-status"
    case newScientist = "newscientist"
    case onboarding = "onboarding"
    case peopleRecommendation = "people-recommendation"
    case peopleRecommendationSomething = "people-recommendation-..." // ?
    case postAStatus = "post-a-status"
    case postedCataloguePub = "posted-catalogue-pub"
    case postedPub = "posted-pub"
    case rssItem = "rss-item"
    case thirdParty = "thirdParty"
    case thirdPartyMendeleyData = "third-party-mendeley-data"
    case thirdPartyUndefined = "third-party-undefined"
    case unfollowed = "unfollowed"
}


class MendeleyAnalyticsEventFeed: MendeleyAnalyticsEvent {
    open var itemType: String!
}

class MendeleyAnalyticsEventFeedItemViewed: MendeleyAnalyticsEventFeed {
    open var index: Int!
}

class MendeleyAnalyticsEventFeedItemClicked: MendeleyAnalyticsEventFeed {
    open var pageLoadId = "false"
    open var section: String!
    open var itemId: String!
    open var coauthor = "false"
}
