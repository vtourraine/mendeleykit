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

@property (nonatomic, strong, nullable) NSNumber *likeable;
@property (nonatomic, strong, nullable) NSNumber* commentable;
@property (nonatomic, strong, nullable) NSNumber* sharable;
@property (nonatomic, strong, nullable) MendeleyNewsFeedSource *source;
@property (nonatomic, strong, nullable) MendeleyJsonNode *content;
@property (nonatomic, strong, nullable) NSString *created;
@property (nonatomic, strong, nullable) MendeleyShare *share;
@property (nonatomic, strong, nullable) MendeleyLike *like;
@property (nonatomic, strong, nullable) MendeleyExpandedComments *comments;

@end

@interface MendeleyNewsFeedSource : MendeleySecureObject

@property (nonatomic, strong, nullable) NSString *type;

@end

@class MendeleySocialProfile;

@interface MendeleyNewsFeedProfileSource : MendeleyNewsFeedSource

@property (nonatomic, strong, nullable) MendeleySocialProfile *profile;

@end

@class MendeleyFeedRSSFeed;

@interface MendeleyNewsFeedRSSSource : MendeleyNewsFeedSource

@property (nonatomic, strong, nullable) MendeleyFeedRSSFeed *rss_feed;

@end

@interface MendeleyFeedRSSFeed : MendeleySecureObject

@property (nonatomic, strong, nullable) NSString *name;
@property (nonatomic, strong, nullable) NSString *link;

@end

@interface MendeleyJsonNode : MendeleySecureObject

@property (nonatomic, strong, nullable) NSString *type;

@end

@interface MendeleyCountableJsonNode : MendeleyJsonNode

@property (nonatomic, strong, nullable) NSNumber* total_count;

@end

@class MendeleyRecommendedDocument;
@class MendeleyUserDocument;

@interface MendeleyDocumentRecommendationJsonNode : MendeleyCountableJsonNode

@property (nonatomic, strong, nullable) NSString *subtype;
@property (nonatomic, strong, nullable) MendeleyUserDocument *user_document; // in the JSON it is user-documents
@property (nonatomic, strong, nullable) NSArray<MendeleyRecommendedDocument *> *recommendations;

@end

@interface MendeleyEmploymentUpdateJsonNode : MendeleyCountableJsonNode

@property (nonatomic, strong, nullable) NSString *institution;
@property (nonatomic, strong, nullable) NSString *position;

@end

@interface MendeleyEducationUpdateJsonNode : MendeleyCountableJsonNode

@property (nonatomic, strong, nullable) NSString *institution;
@property (nonatomic, strong, nullable) NSString *degree;

@end

@class MendeleyAddedDocument;
@class MendeleyFeedGroup;

@interface MendeleyGroupDocAddedJsonNode : MendeleyCountableJsonNode

@property (nonatomic, strong, nullable) MendeleyFeedGroup *group;
@property (nonatomic, strong, nullable) NSArray<MendeleyAddedDocument *> *documents;

@end

@interface MendeleyFeedGroup : MendeleyObject

@property (nonatomic, strong, nullable) NSString *link;
@property (nonatomic, strong, nullable) NSString *access_level;
@property (nonatomic, strong, nullable) NSString *name;

@end

@class MendeleyFollowerProfile;

@interface MendeleyNewFollowerJsonNode : MendeleyCountableJsonNode

@property (nonatomic, strong, nullable) NSArray<MendeleyFollowerProfile *> *followings;

@end

@class MendeleyFeedAuthor;
@class MendeleyPublishedDocument;

@interface MendeleyNewPublicationJsonNode : MendeleyCountableJsonNode

@property (nonatomic, strong, nullable) NSArray<MendeleyPublishedDocument *> *documents;
@property (nonatomic, strong, nullable) NSArray<MendeleyFeedAuthor *> *co_authors;

@end

@class MendeleyPost;

@interface MendeleyNewStatusJsonNode : MendeleyJsonNode

@property (nonatomic, strong, nullable) MendeleyPost *post;

@end

@class MendeleyGroupPost;
@class MendeleyGroup;

@interface MendeleyGroupStatusJsonNode: MendeleyJsonNode

@property (nonatomic, strong, nullable) MendeleyGroup *group;
@property (nonatomic, strong, nullable) MendeleyGroupPost *post;

@end

@class MendeleyCataloguePubDocument;

@interface MendeleyPostedCataloguePublicationJsonNode : MendeleyCountableJsonNode

@property (nonatomic, strong, nullable) NSArray<MendeleyCataloguePubDocument *> *documents;

@end

@class MendeleyCataloguePubDocument;

@interface MendeleyPostedPublicationJsonNode : MendeleyCountableJsonNode

@property (nonatomic, strong, nullable) NSArray<MendeleyCataloguePubDocument *> *documents;

@end

@interface MendeleyRSSJsonNode : MendeleyJsonNode

@property (nonatomic, strong, nullable) NSString *title;
@property (nonatomic, strong, nullable) NSString *summary;
@property (nonatomic, strong, nullable) NSString *link;
@property (nonatomic, strong, nullable) NSString *publish_date;
@property (nonatomic, strong, nullable) NSString *image_url;

@end

@interface MendeleyShare : MendeleySecureObject

@property (nonatomic, strong, nullable) NSNumber *total_count;
@property (nonatomic, strong, nullable) NSNumber* shared_by_me;
@property (nonatomic, strong, nullable) MendeleySocialProfile *originating_sharer_profile;
@property (nonatomic, strong, nullable) NSArray<MendeleySocialProfile *> *most_recent_sharer_profiles;

@end

@interface MendeleyLike : MendeleySecureObject

@property (nonatomic, strong, nullable) NSNumber* total_count;
@property (nonatomic, strong, nullable) NSNumber* liked_by_me;

@end

@class MendeleyExpandedComment;

@interface MendeleyExpandedComments : MendeleySecureObject

@property (nonatomic, strong, nullable) NSNumber* total_count;
@property (nonatomic, strong, nullable) NSArray<MendeleyExpandedComment *> *latest;

@end

@class MendeleyFeedDocument;

@interface MendeleyPost : MendeleyObject

@property (nonatomic, strong, nullable) NSString *text;
@property (nonatomic, strong, nullable) MendeleyFeedDocument *document;
@property (nonatomic, strong, nullable) NSArray<MendeleyFeedDocument *> *documents;
@property (nonatomic, strong, nullable) NSArray<MendeleySocialProfile *> *tagged_users;

@end

@interface MendeleyGroupPost : MendeleyPost

@property (nonatomic, strong, nullable) NSString *group_id;
@property (nonatomic, strong, nullable) NSString *visibility;
@property (nonatomic, strong, nullable) NSString *poster_id;
@property (nonatomic, strong, nullable) NSString *created_date_time;
@property (nonatomic, strong, nullable) NSNumber *hide_link_snippet;

@end

@interface MendeleyFeedDocument : MendeleyObject

@property (nonatomic, strong, nullable) NSString *title;
@property (nonatomic, strong, nullable) NSNumber* year;
@property (nonatomic, strong, nullable) NSString *link;
@property (nonatomic, strong, nullable) NSString *type;
@property (nonatomic, strong, nullable) NSArray<MendeleyFeedAuthor *> *authors;
@property (nonatomic, strong, nullable) NSString *doi;

@end

@class MendeleySimpleAuthor;

@interface MendeleyAddedDocument : MendeleyObject

@property (nonatomic, strong, nullable) NSString *title;
@property (nonatomic, strong, nullable) NSNumber *year;
@property (nonatomic, strong, nullable) NSString *link;
@property (nonatomic, strong, nullable) NSString *type;
@property (nonatomic, strong, nullable) NSArray<MendeleySimpleAuthor *> *authors;

@end

@class MendeleyAddedDocument;

@interface MendeleyPublishedDocument : MendeleyAddedDocument

@property (nonatomic, strong, nullable) NSString *source;

@end

@interface MendeleyRecommendedDocument : MendeleyPublishedDocument

@property (nonatomic, strong, nullable) NSString *doi;
@property (nonatomic, strong, nullable) NSString *trace;
@property (nonatomic, strong, nullable) NSNumber *reader_count;
@property (nonatomic, strong, nullable) NSString *abstract;

@end

@interface MendeleyCataloguePubDocument : MendeleyPublishedDocument

@property (nonatomic, strong, nullable) NSString *doi;

@end

@class MendeleySimpleAuthor;

@interface MendeleyUserDocument : MendeleySecureObject

@property (nonatomic, strong, nullable) NSString *title;
@property (nonatomic, strong, nullable) NSString *type;
@property (nonatomic, strong, nullable) NSNumber *year;
@property (nonatomic, strong, nullable) NSString *source;
@property (nonatomic, strong, nullable) NSArray<MendeleySimpleAuthor *> *authors;
@property (nonatomic, strong, nullable) NSArray<NSDictionary *> *identifiers;

@end

@interface MendeleySimpleAuthor : MendeleySecureObject

@property (nonatomic, strong, nullable) NSString *first_name;
@property (nonatomic, strong, nullable) NSString *last_name;

@end

@class MendeleySimpleAuthor;

@interface MendeleyFeedAuthor : MendeleySimpleAuthor

@property (nonatomic, strong, nullable) NSString *scopus_author_id;

@end

@class MendeleySocialProfilePhoto;

@interface MendeleySocialProfile : MendeleyObject

@property (nonatomic, strong, nullable) NSString *first_name;
@property (nonatomic, strong, nullable) NSString *last_name;
@property (nonatomic, strong, nullable) NSString *link;
@property (nonatomic, strong, nullable) NSArray<MendeleySocialProfilePhoto *> *photos;

@end

@class MendeleySocialProfile;

@interface MendeleyFollowerProfile : MendeleySocialProfile

@property (nonatomic, strong, nullable) NSString *profile_id;
@property (nonatomic, strong, nullable) NSString *institution;

@end

@interface MendeleySocialProfilePhoto : MendeleySecureObject

@property (nonatomic, strong, nullable) NSNumber* width;
@property (nonatomic, strong, nullable) NSNumber* height;
@property (nonatomic, strong, nullable) NSString *url;
@property (nonatomic, strong, nullable) NSNumber* original;

@end


