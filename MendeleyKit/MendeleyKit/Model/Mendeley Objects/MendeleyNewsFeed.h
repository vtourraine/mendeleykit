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

#import <Foundation/Foundation.h>
#import "MendeleyObject.h"

@class MendeleyNewsFeedSource, MendeleyJsonNode, MendeleyShare, MendeleyLike, MendeleyExpandedComments;

@interface MendeleyNewsFeed : MendeleyObject

@property (nonatomic, assign) BOOL sharable;
@property (nonatomic, strong) MendeleyNewsFeedSource *source;
@property (nonatomic, strong) MendeleyJsonNode *content;
@property (nonatomic, strong) NSString *created;
@property (nonatomic, strong) MendeleyShare *share;
@property (nonatomic, strong) MendeleyLike *like;
@property (nonatomic, strong) MendeleyExpandedComments *comments;

@end

@interface MendeleyNewsFeedSource : MendeleySecureObject

@property (nonatomic, strong) NSString *type;

@end

@class MendeleyFeedProfile;

@interface MendeleyNewsFeedProfileSource : MendeleyNewsFeedSource

@property (nonatomic, strong) MendeleyFeedProfile *profile;

@end

@class MendeleyFeedRSSFeed;

@interface MendeleyNewsFeedRSSSource : MendeleyNewsFeedSource

@property (nonatomic, strong) MendeleyFeedRSSFeed *rss_feed;

@end

@interface MendeleyFeedRSSFeed : MendeleySecureObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *link;

@end

@interface MendeleyJsonNode : MendeleySecureObject

@property (nonatomic, strong) NSString *type;

@end

@interface MendeleyCountableJsonNode : MendeleyJsonNode

@property (nonatomic, assign) int total_count;

@end

@interface MendeleyDocumentRecommendationJsonNode : MendeleyCountableJsonNode

@property (nonatomic, strong) NSString *subtype;
//user-document
// recommendations

@end

@interface MendeleyEmploymentUpdateJsonNode : MendeleyCountableJsonNode

@property (nonatomic, strong) NSString *institution;
@property (nonatomic, strong) NSString *position;

@end

@interface MendeleyGroupDocAddedJsonNode : MendeleyCountableJsonNode

// group
// documents

@end

@interface MendeleyNewFollowerJsonNode : MendeleyCountableJsonNode

// followings

@end

@class MendeleyFeedAuthor;

@interface MendeleyNewPublicationJsonNode : MendeleyCountableJsonNode

// documents
@property (nonatomic, strong) NSArray<MendeleyFeedAuthor *> *co_authors;

@end

@class MendeleyPost;

@interface MendeleyNewStatusJsonNode : MendeleyJsonNode

@property (nonatomic, strong) MendeleyPost *post;

@end

@interface MendeleyPostedCataloguePublicationJsonNode : MendeleyCountableJsonNode

// documents

@end

@interface MendeleyPostedPublicationJsonNode : MendeleyCountableJsonNode

// documents

@end

@interface MendeleyRSSJsonNode : MendeleyJsonNode

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *summary;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, strong) NSString *publish_date;
@property (nonatomic, strong) NSString *image_url;

@end


@interface MendeleyShare : MendeleySecureObject

@property (nonatomic, strong) NSString *total_count;
@property (nonatomic, assign) BOOL shared_by_me;
@property (nonatomic, strong) MendeleyFeedProfile *originating_sharer_profile;
@property (nonatomic, strong) NSArray<MendeleyFeedProfile *> *most_recent_sharer_profiles;

@end

@interface MendeleyLike : MendeleySecureObject

@property (nonatomic, assign) int total_count;
@property (nonatomic, assign) BOOL liked_by_me;

@end

@interface MendeleyExpandedComments : MendeleySecureObject

@end

@class MendeleyFeedDocument;

@interface MendeleyPost : MendeleyObject

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) MendeleyFeedDocument *document;
@property (nonatomic, strong) NSArray<MendeleyFeedProfile *> *tagged_users;

@end

@interface MendeleyFeedDocument : MendeleyObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) int year;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSArray<MendeleyFeedAuthor *> *authors;
@property (nonatomic, strong) NSString *doi;

@end

@interface MendeleyFeedAuthor : MendeleySecureObject

@property (nonatomic, strong) NSString *first_name;
@property (nonatomic, strong) NSString *last_name;
@property (nonatomic, strong) NSString *scopus_author_id;

@end

@class MendeleyFeedProfilePhoto;

@interface MendeleyFeedProfile : MendeleyObject

@property (nonatomic, strong) NSString *first_name;
@property (nonatomic, strong) NSString *last_name;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, strong) NSArray<MendeleyFeedProfilePhoto *> *photos;

@end

@interface MendeleyFeedProfilePhoto : MendeleySecureObject

@property (nonatomic, assign) int width;
@property (nonatomic, assign) int height;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, assign) BOOL original;

@end


