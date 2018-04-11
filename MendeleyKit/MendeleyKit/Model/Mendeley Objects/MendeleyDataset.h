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

@class MendeleyDOI;
@class MendeleyPublicContributorDetails;
@class MendeleyInstitution;
@class MendeleyAlternativeName;
@class MendeleyVersionMetadata;
@class MendeleyFileMetadata;
@class MendeleyFileMetrics;
@class MendeleyFileData;
@class MendeleyEmbeddedArticleView;
@class MendeleyEmbeddedJournalView;
@class MendeleyCategory;
@class MendeleyDatasetMetrics;
@class MendeleyRelatedLink;
@class MendeleyLicenceInfo;


@interface MendeleyDataset : MendeleyObject

@property (nonatomic, strong, nullable) NSString *name;
@property (nonatomic, strong, nullable) MendeleyDOI *doi;
@property (nonatomic, strong, nullable) NSNumber *object_version;
@property (nonatomic, strong, nullable) NSArray <MendeleyPublicContributorDetails *> *contributors;
@property (nonatomic, strong, nullable) NSArray <MendeleyVersionMetadata *> *versions;
@property (nonatomic, strong, nullable) NSArray <MendeleyFileMetadata *> *files;
@property (nonatomic, strong, nullable) NSArray <MendeleyEmbeddedArticleView *> *articles;
@property (nonatomic, strong, nullable) NSArray <MendeleyCategory *> *categories;
@property (nonatomic, strong, nullable) NSArray <MendeleyInstitution *> *institutions;
@property (nonatomic, strong, nullable) MendeleyDatasetMetrics *metrics;
@property (nonatomic, strong, nullable) NSNumber *available;
@property (nonatomic, strong, nullable) NSString *method;
@property (nonatomic, strong, nullable) NSArray <MendeleyRelatedLink *> *related_links;
@property (nonatomic, strong, nullable) NSDate *publish_date;
@property (nonatomic, strong, nullable) MendeleyLicenceInfo *data_licence;
@property (nonatomic, strong, nullable) NSString *owner_id;
@property (nonatomic, strong, nullable) NSDate *embargo_date;

@end


@interface MendeleyDOI : MendeleyObject

@property (nonatomic, strong, nullable) NSString *status;

@end


@interface MendeleyPublicContributorDetails : MendeleyObject

@property (nonatomic, strong, nullable) NSString *contribution;
@property (nonatomic, strong, nullable) NSString *institution;
@property (nonatomic, strong, nullable) NSString *profile_id;
@property (nonatomic, strong, nullable) NSString *first_name;
@property (nonatomic, strong, nullable) NSString *last_name;

@end


@interface MendeleyInstitution : MendeleyObject

@property (nonatomic, strong, nullable) NSNumber *scival_id;
@property (nonatomic, strong, nullable) NSString *name;
@property (nonatomic, strong, nullable) NSString *city;
@property (nonatomic, strong, nullable) NSString *state;
@property (nonatomic, strong, nullable) NSString *country;
@property (nonatomic, strong, nullable) NSString *parent_id;
@property (nonatomic, strong, nullable) NSArray <NSString *> *urls;
@property (nonatomic, strong, nullable) NSString *profile_url;
@property (nonatomic, strong, nullable) NSArray <MendeleyAlternativeName *> *alt_names;

@end


@interface MendeleyAlternativeName : MendeleyObject

@property (nonatomic, strong, nullable) NSString *name;

@end


@interface MendeleyVersionMetadata : MendeleyObject

@property (nonatomic, strong, nullable) NSNumber *object_version;
@property (nonatomic, strong, nullable) NSNumber *available;
@property (nonatomic, strong, nullable) NSDate *publish_date;
@property (nonatomic, strong, nullable) NSDate *embargo_date;

@end


@interface MendeleyFileMetadata : MendeleyObject

@property (nonatomic, strong, nullable) NSString *filename;
@property (nonatomic, strong, nullable) MendeleyFileMetrics *metrics;
@property (nonatomic, strong, nullable) MendeleyFileData *content_details;

@end


@interface MendeleyContentTicket : MendeleyObject

@end


@interface MendeleyFileMetrics : MendeleyObject

@property (nonatomic, strong, nullable) NSNumber *downloads;
@property (nonatomic, strong, nullable) NSNumber *previews;
@property (nonatomic, strong, nullable) NSString *fileId;

@end


@interface MendeleyFileData : MendeleyObject

@property (nonatomic, strong, nullable) NSNumber *size;
@property (nonatomic, strong, nullable) NSString *content_type;
@property (nonatomic, strong, nullable) NSString *download_url;
@property (nonatomic, strong, nullable) NSString *sha256_hash;
@property (nonatomic, strong, nullable) NSString *sha1_hash;
@property (nonatomic, strong, nullable) NSString *view_url;
@property (nonatomic, strong, nullable) NSString *download_expiry_time;
@property (nonatomic, strong, nullable) NSDate *created_date;

@end


@interface MendeleyEmbeddedArticleView : MendeleyObject

@property (nonatomic, strong, nullable) MendeleyEmbeddedJournalView *journal;
@property (nonatomic, strong, nullable) NSString *title;
@property (nonatomic, strong, nullable) NSString *doi;

@end


@interface MendeleyEmbeddedJournalView : MendeleyObject

@property (nonatomic, strong, nullable) NSString *url;
@property (nonatomic, strong, nullable) NSString *issn;
@property (nonatomic, strong, nullable) NSString *name;

@end


@interface MendeleyCategory : MendeleyObject

@property (nonatomic, strong, nullable) NSString *label;

@end


@interface MendeleyDatasetMetrics : MendeleyObject

@property (nonatomic, strong, nullable) NSNumber *views;
@property (nonatomic, strong, nullable) NSNumber *file_downloads;
@property (nonatomic, strong, nullable) NSNumber *file_previews;

@end


@interface MendeleyRelatedLink : MendeleyObject

@property (nonatomic, strong, nullable) NSString *type;
@property (nonatomic, strong, nullable) NSString *rel;
@property (nonatomic, strong, nullable) NSString *href;

@end


@interface MendeleyLicenceInfo : MendeleyObject

@property (nonatomic, strong, nullable) NSString *url;
@property (nonatomic, strong, nullable) NSString *full_name;
@property (nonatomic, strong, nullable) NSString *short_name;

@end
