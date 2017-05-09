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

#import "MendeleyObject.h"

@interface MendeleyNewUserPost : MendeleySecureObject

@property (nonatomic, strong, nullable) NSString *text;
@property (nonatomic, strong, nullable) NSArray<NSString *> *document_ids;
@property (nonatomic, strong, nullable) NSArray<NSString *> *tagged_users;
@property (nonatomic, strong, nullable) NSNumber *hide_link_snippet;

@end

@class MendeleyProfileLink;
@class MendeleySocialDocument;
@class MendeleyUserPostImage;

@interface MendeleyUserPost : MendeleyObject

@property (nonatomic, strong, nonnull) NSString *text;
@property (nonatomic, strong, nonnull) NSString *post_id;
@property (nonatomic, strong, nullable) NSArray<MendeleyProfileLink *> *tagged_users;
@property (nonatomic, strong, nonnull) NSString *created_date_time;
@property (nonatomic, strong, nullable) MendeleySocialDocument *document;
@property (nonatomic, strong, nullable) NSArray<MendeleySocialDocument *> *documents;
@property (nonatomic, strong, nonnull) NSArray<MendeleyUserPostImage *> *images;
@property (nonatomic, strong, nullable) NSString *last_modified_date_time;
@property (nonatomic, strong, nullable) NSNumber *hide_link_snippet;

@end

@class MendeleyImage;

@interface MendeleyProfileLink : MendeleyObject

@property (nonatomic, strong, nullable) NSString *first_name;
@property (nonatomic, strong, nullable) NSString *last_name;
@property (nonatomic, strong, nullable) NSString *link;
@property (nonatomic, strong, nullable) NSArray<MendeleyImage *> *photos;

@end

@class MendeleyFeedAuthor;
@class MendeleyFileSummary;

@interface MendeleySocialDocument : MendeleyObject

@property (nonatomic, strong, nullable) NSString *title;
@property (nonatomic, strong, nullable) NSNumber *year;
@property (nonatomic, strong, nullable) NSString *link;
@property (nonatomic, strong, nullable) NSString *type;
@property (nonatomic, strong, nullable) NSString *source;
@property (nonatomic, strong, nullable) NSArray<MendeleyFeedAuthor *> *authors;
@property (nonatomic, strong, nullable) NSString *doi;
@property (nonatomic, strong, nullable) NSString *trace;
@property (nonatomic, strong, nullable) NSNumber *reader_count;
@property (nonatomic, strong, nullable) MendeleyFileSummary *file_summary;
@property (nonatomic, strong, nullable) NSString *abstract;

@end

@interface MendeleySocialAuthor : MendeleyObject

@property (nonatomic, strong, nullable) NSString *first_name;
@property (nonatomic, strong, nullable) NSString *last_name;
@property (nonatomic, strong, nullable) NSString *scopus_author_id;

@end

@interface MendeleyUserPostImage : MendeleyObject

@end

@class MendeleyFileSummary;

@interface MendeleyFilesSummary : MendeleyObject

@property (nonatomic, strong, nullable) NSArray<MendeleyFileSummary *> *first_files;
@property (nonatomic, strong, nullable) NSNumber *file_count;

@end

@interface MendeleyFileSummary : MendeleyObject

@end
