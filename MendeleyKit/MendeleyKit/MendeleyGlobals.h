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

#ifndef MendeleyKit_MendeleyGlobals_h
#define MendeleyKit_MendeleyGlobals_h

@import Foundation;

@class MendeleyResponse, MendeleyOAuthCredentials, MendeleySyncInfo, MendeleyDocument, MendeleyObject, MendeleySecureObject, MendeleyIDPlusCredentials;

/***********************************************
 @name Enums definitions
 ***********************************************/
typedef NS_ENUM(int, MendeleyHTTPRequestType)
{
    HTTP_GET = 0,
    HTTP_DELETE,
    HTTP_POST,
    HTTP_PUT,
    HTTP_PATCH,
    HTTP_HEAD
};

typedef NS_ENUM(int, MendeleyResponseBodyContentType)
{
    JSONBody = 0,
    PDFBody,
    JPGBody,
    PNGBody,
    BinaryBody,
    UnknownBody
};

typedef NS_ENUM(int, MendeleyIconType)
{
    OriginalIcon = 0,
    SquareIcon,
    StandardIcon
};

/***********************************************
 @name Block definitions
 ***********************************************/
typedef void (^ __nullable MendeleyOAuthCompletionBlock)(MendeleyOAuthCredentials * __nullable credentials, NSError * __nullable error);
typedef void (^ __nullable MendeleyIDPlusCompletionBlock) (MendeleyIDPlusCredentials * __nullable credentials, NSError * __nullable error);
typedef void (^ __nullable MendeleyResponseCompletionBlock)(MendeleyResponse * __nullable response, NSError * __nullable error);
typedef void (^ __nullable MendeleyResponseProgressBlock)(NSNumber * __nonnull progress);
typedef void (^ __nullable MendeleyCompletionBlock)(BOOL success, NSError * __nullable error);
typedef void (^ __nullable MendeleyArrayCompletionBlock)(NSArray * __nullable array, MendeleySyncInfo * __nullable syncInfo, NSError * __nullable error);
typedef void (^ __nullable MendeleyObjectCompletionBlock)(MendeleyObject * __nullable mendeleyObject, MendeleySyncInfo * __nullable syncInfo, NSError * __nullable error);
typedef void (^ __nullable MendeleyObjectAndStateCompletionBlock)(MendeleySecureObject * __nullable mendeleyObject, NSInteger state, NSError * __nullable error);
typedef void (^ __nullable MendeleySecureObjectCompletionBlock)(MendeleySecureObject * __nullable mendeleyObject, MendeleySyncInfo * __nullable syncInfo, NSError * __nullable error);
typedef void (^ __nullable MendeleyDictionaryResponseBlock)(NSDictionary * __nullable dictionary, NSError * __nullable error);
typedef void (^ __nullable MendeleyDeserializedResponseObject)(id __nullable deserializedResponseObject, NSError * __nullable deserializeError);
typedef void (^ __nullable MendeleyBinaryDataCompletionBlock)(NSData * __nullable binaryData, NSError * __nullable dataError);
typedef void (^ __nullable MendeleyStringArrayCompletionBlock)(NSArray * __nullable arrayOfStrings, NSError * __nullable error);

/***********************************************
   @name Mendeley Server URLs as strings
***********************************************/
#define kMendeleyKitURL                       @"https://api.mendeley.com"

/***********************************************
   @name Mendeley Server setting keys
***********************************************/
#define kMendeleyBaseAPIURLKey                @"BaseAPIURLKey"
#define kMendeleyTrustedSSLServerKey          @"TrustedSSLServerKey"
#define kMendeleyDocumentViewType             @"DefaultDocumentViewType"

/***********************************************
   @name Mendeley Server Document View Type
***********************************************/
#define kMendeleyDocumentViewTypeDefault      @""
#define kMendeleyDocumentViewTypeBibliography @"bib"
#define kMendeleyDocumentViewTypeClient       @"client"
#define kMendeleyDocumentViewTypeTags         @"tags"
#define kMendeleyDocumentViewTypeAll          @"all"

/***********************************************
   @name Mendeley SDK Provider keys
***********************************************/
#define kMendeleyOAuthProviderKey             @"MendeleyKitOAuthProvider"
#define kMendeleyIDPlusAuthProviderKey        @"MendeleyKitIDPlusAuthProvider"
#define kMendeleyNetworkProviderKey           @"MendeleyKitNetworkProvider"
#define kMendeleyOAuth2RedirectURLKey         @"redirect_uri"
#define kMendeleyOAuth2ClientSecretKey        @"client_secret"
#define kMendeleyOAuth2ClientIDKey            @"client_id"
#define kMendeleyOAuthStoreProviderKey        @"MendeleyKitOAuthStoreProvider"


/***********************************************
   @name default URL session settings
***********************************************/
#define kMendeleyDefaultCachePolicy                       NSURLRequestReloadIgnoringLocalCacheData
#define kMendeleyDefaultTimeOut                           60.0

/***********************************************
   @name Request keys
***********************************************/
#define kMendeleyRESTRequestAccept                              @"Accept"
#define kMendeleyRESTRequestContentDisposition                  @"Content-Disposition"
#define kMendeleyRESTRequestContentType                         @"Content-Type"
#define kMendeleyRESTRequestContentLength                       @"Content-Length"
#define kMendeleyRESTRequestAuthorization                       @"Authorization"
#define kMendeleyRESTRequestJPEGType                            @"image/jpeg"
#define kMendeleyRESTRequestPNGType                             @"image/png"
#define kMendeleyRESTRequestBinaryType                          @"application/octet-stream"
#define kMendeleyRESTRequestJSONType                            @"application/json"
#define kMendeleyRESTRequestURLType                             @"application/x-www-form-urlencoded"
#define kMendeleyRESTRequestJSONAnnotationType                  @"application/vnd.mendeley-annotation.1+json"
#define kMendeleyRESTRequestJSONDocumentType                    @"application/vnd.mendeley-document.1+json"
#define kMendeleyRESTRequestJSONDocumentCloneType               @"application/vnd.mendeley-document-clone.1+json"
#define kMendeleyRESTRequestJSONMetadataLookupType              @"application/vnd.mendeley-document-lookup.1+json"
#define kMendeleyRESTRequestJSONFileType                        @"application/vnd.mendeley-file.1+json"
#define kMendeleyRESTRequestJSONFolderType                      @"application/vnd.mendeley-folder.1+json"
#define kMendeleyRESTRequestJSONFolderDocumentIDsType           @"application/vnd.mendeley-folder-documentids.1+json"
#define kMendeleyRESTRequestJSONGroupType                       @"application/vnd.mendeley-group.1+json"
#define kMendeleyRESTRequestJSONUserRoleType                    @"application/vnd.mendeley-membership.1+json"
#define kMendeleyRESTRequestJSONLookup                          @"application/vnd.mendeley-lookup.1+json"
#define kMendeleyRESTRequestJSONProfilesType                    @"application/vnd.mendeley-profiles.1+json"
#define kMendeleyRESTRequestJSONNewProfilesType                 @"application/vnd.mendeley-new-profile.1+json"
#define kMendeleyRESTRequestJSONProfilesVerificationType        @"application/vnd.mendeley-profile-verification.1+json"
#define kMendeleyRESTRequestJSONProfileUpdateType               @"application/vnd.mendeley-profile-amendment.1+json"
#define kMendeleyRESTRequestJSONDisciplineType                  @"application/vnd.mendeley-discipline.1+json"
#define kMendeleyRESTRequestJSONAcademicStatuses                @"application/vnd.mendeley-academic-status.1+json"
#define kMendeleyRESTRequestJSONUserRole                        @"application/vnd.mendeley-user-role.1+json"
#define kMendeleyRESTRequestJSONSubjectArea                     @"application/vnd.mendeley-subject-area.1+json"
#define kMendeleyRESTRequestJSONRecentlyRead                    @"application/vnd.mendeley-recently-read.1+json"
#define kMendeleyRESTRequestJSONFollowType                      @"application/vnd.mendeley-follow.1+json"
#define kMendeleyRESTRequestJSONFollowRequestType               @"application/vnd.mendeley-follow-request.1+json"
#define kMendeleyRESTRequestJSONFollowAcceptancesRequestType    @"application/vnd.mendeley-follow-acceptance.1+json"
#define kMendeleyRESTRequestJSONDatasetType                     @"application/vnd.mendeley-public-dataset.1+json"
#define kMendeleyRESTRequestJSONLicenceInfoType                 @"application/vnd.mendeley-licence-info.1+json"
#define kMendeleyRESTRequestJSONApplicationFeaturesType         @"application/vnd.mendeley-features.1+json"
#define kMendeleyRESTRequestJSONRecommendationsType             @"application/vnd.mendeley-article-rec.1+json"
#define kMendeleyRESTRequestJSONRecommendationFeedbackType      @"application/vnd.mendeley-rec-feedback.1+json"
#define kMendeleyRESTRequestJSONNewsItemListType                @"application/vnd.mendeley-news-item-list+json"
#define kMendeleyRESTRequestJSONNewsItemType                    @"application/vnd.mendeley-news-item+json"
#define kMendeleyRESTRequestJSONNewsItemsShareType              @"application/vnd.mendeley-news-items-share+json"
#define kMendeleyRESTRequestJSONDocumentShareType               @"application/vnd.mendeley-news-items-share-document+json"
#define kMendeleyRESTRequestJSONNewsItemSharerListType          @"application/vnd.mendeley-expanded-news-sharer-list+json"
#define kMendeleyRESTRequestJSONNewsItemLikerListType           @"application/vnd.mendeley-expanded-like-list+json"
#define kMendeleyRESTRequestJSONCommentType                     @"application/vnd.mendeley-comment+json"
#define kMendeleyRESTRequestJSONExpandedCommentsType            @"application/vnd.mendeley-expanded-comment-list+json"
#define kMendeleyRESTRequestJSONCommentUpdateType               @"application/vnd.mendeley-comment-update+json"
#define kMendeleyRESTRequestJSONNewUserPostType                 @"application/vnd.mendeley-new-user-post+json"
#define kMendeleyRESTRequestJSONUserPostType                    @"application/vnd.mendeley-user-post+json"
#define kMendeleyRESTRequestJSONNewGroupPostType                @"application/vnd.mendeley-new-group-user-post+json"
#define kMendeleyRESTRequestJSONGroupPostType                   @"application/vnd.mendeley-group-user-post+json"
#define kMendeleyRESTRequestJSONIDPlusProfileType               @"application/vnd.elsevier-idplus-identity+jwt"
#define kMendeleyRESTRequestJSONProfilePrivacySettingsType      @"application/vnd.mendeley-profile-privacy-settings.1+json"
#define kMendeleyRESTRequestJSONIDPlusProfileAcceptType         @"application/vnd.idplus-sync-response+json"
#define kMendeleyOAuth2ClientVersionKey                         @"Client-Version"
#define kMendeleyOAuth2UserAgentKey                             @"User-Agent"
#define kMendeleyOAuth2AcceptLanguageKey                        @"Accept-Language"
#define kMendeleyRESTRequestDate                                @"Date"
#define kMendeleyRESTRequestLink                                @"Link"
#define kMendeleyRESTHTTPLinkNext                               @"next"
#define kMendeleyRESTHTTPLinkPrevious                           @"previous"
#define kMendeleyRESTHTTPLinkFirst                              @"first"
#define kMendeleyRESTHTTPLinkLast                               @"last"
#define kMendeleyRESTHTTPTotalCount                             @"Mendeley-Count"

/***********************************************
   @name Request values
***********************************************/
#define kMendeleyRESTRequestValueAttachment               @"attachment"
#define kMendeleyRESTRequestValuePDF                      @"application/pdf"

/***********************************************
   @name REST API endpoints
***********************************************/
#define kMendeleyRESTAPIDocuments                         @"documents"
#define kMendeleyRESTAPIDocumentWithID                    @"documents/%@"
#define kMendeleyRESTAPIDocumentWithIDToTrash             @"documents/%@/trash"
#define kMendeleyRESTAPIDocumentCloneTo                   @"documents/%@/actions/cloneTo"
#define kMendeleyRESTAPIDocumentCloneFilesTo              @"documents/%@/actions/cloneFilesTo"
#define kMendeleyRESTAPICatalog                           @"catalog"
#define kMendeleyRESTAPICatalogWithID                     @"catalog/%@"
#define kMendeleyRESTAPIMetadata                          @"metadata"
#define kMendeleyRESTAPITrashedDocuments                  @"trash"
#define kMendeleyRESTAPITrashedDocumentWithID             @"trash/%@"
#define kMendeleyRESTAPIRestoreTrashedDocumentWithID      @"trash/%@/restore"
#define kMendeleyRESTAPIDocumentTypes                     @"document_types"
#define kMendeleyRESTAPIIdentifierTypes                   @"identifier_types"
#define kMendeleyRESTAPIFeeds                             @"news_items/v2"
#define kMendeleyRESTAPILikeFeed                          @"news_items/v1/%@/likers"
#define kMendeleyRESTAPIUnlikeFeed                        @"news_items/v1/%@/likers/me"
#define kMendeleyRESTAPISharersFeed                       @"news_items/v1/%@/sharers"
#define kMendeleyRESTAPIShareFeed                         @"news_items/v1/actions/share"
#define kMendeleyRESTAPICreateUserPost                    @"user_posts/v2"
#define kMendeleyRESTAPIDeleteUserPost                    @"user_posts/v1/%@"
#define kMendeleyRESTAPICreateGroupPost                   @"group_user_posts/v2"
#define kMendeleyRESTAPIDeleteGroupPost                   @"group_user_posts/v1/%@"
#define kMendeleyRESTAPIFiles                             @"files"
#define kMendeleyRESTAPIFileWithID                        @"files/%@"
#define kMendeleyRESTAPIFolders                           @"folders"
#define kMendeleyRESTAPIFolderWithID                      @"folders/%@"
#define kMendeleyRESTAPIDocumentWithIDInFolderWithID      @"folders/%@/documents/%@"
#define kMendeleyRESTAPIDocumentsInFolderWithID           @"folders/%@/documents"
#define kMendeleyRESTAPIGroups                            @"groups"
#define kMendeleyRESTAPIGroupWithID                       @"groups/%@"
#define kMendeleyRESTAPIMembersInGroupWithID              @"groups/%@/members"
#define kMendeleyRESTAPIAnnotations                       @"annotations"
#define kMendeleyRESTAPIAnnotationWithID                  @"annotations/%@"
#define kMendeleyRESTAPIAnnotationsSync                   @"documents/%@/annotations_sync"
#define kMendeleyRESTAPIAnnotationsSyncWithID             @"documents/%@/annotations_sync/%@"
#define kMendeleyRESTAPIProfilesMe                        @"profiles/me"
#define kMendeleyRESTAPIProfilesWithID                    @"profiles/%@"
#define kMendeleyRESTAPIProfiles                          @"profiles"
#define kMendeleyRESTAPICheckProfiles                     @"profiles/v1"
#define kMendeleyRESTAPIDisciplines                       @"disciplines"
#define kMendeleyRESTAPISubjectAreas                      @"subject_areas"
#define kMendeleyRESTAPIAcademicStatuses                  @"academic_statuses"
#define kMendeleyRESTAPIUserRoles                         @"user_roles"
#define kMendeleyRESTAPIRecentlyRead                      @"recently_read"
#define kMendeleyRESTAPIFollowers                         @"followers"
#define kMendeleyRESTAPIFollowersWithID                   @"followers/%@"
#define kMendeleyRESTAPIDatasets                          @"datasets"
#define kMendeleyRESTAPIDatasetWithID                     @"datasets/%@"
#define kMendeleyRESTAPIDatasetsLicences                  @"datasets/licences"
#define kMendeleyRESTAPIApplicationFeatures               @"application_features"
#define kMendeleyRESTAPIPhotosMe                          @"photos/me"
#define kMendeleyRESTAPIRecommendationsBasedOnLibrary     @"recommendations/based_on_library_articles"
#define kMendeleyRESTAPIRecommendationFeedback            @"recommendations/action/feedback"
#define kMendeleyRESTAPIComments                          @"comments/v1"
#define kMendeleyRESTAPICommentsWithCommentID             @"comments/v1/%@"
#define kMendeleyRESTAPIProfileUpdatePrivacySettings      @"profiles/me/privacy_settings"

/***********************************************
   @name REST API Query Parameters
***********************************************/
#define kMendeleyRESTAPIQueryLimit                        @"limit"
#define kMendeleyRESTAPIQueryModifiedSince                @"modified_since"
#define kMendeleyRESTAPIQueryDeletedSince                 @"deleted_since"
#define kMendeleyRESTAPIQueryAddedSince                   @"added_since"
#define kMendeleyRESTAPIQuerySort                         @"sort"
#define kMendeleyRESTAPIQueryOrder                        @"order"
#define kMendeleyRESTAPIQueryReverse                      @"reverse"
#define kMendeleyRESTAPIQueryIncludeTrashed               @"include_trashed"
#define kMendeleyRESTAPIQueryGroupID                      @"group_id"
#define kMendeleyRESTAPIQueryProfileID                    @"profile_id"
#define kMendeleyRESTAPIQueryDocumentID                   @"document_id"
#define kMendeleyRESTAPIQuerySortAsc                      @"asc"
#define kMendeleyRESTAPIQuerySortDesc                     @"desc"
#define kMendeleyRESTAPIQueryOrderByTitle                 @"title"
#define kMendeleyRESTAPIQueryOrderByCreated               @"created"
#define kMendeleyRESTAPIQueryOrderByModified              @"last_modified"
#define kMendeleyRESTAPIQueryDelimiter                    @"&"
#define kMendeleyRESTAPIQueryMarker                       @"?"
#define kMendeleyRESTAPIQueryAssigner                     @"="
#define kMendeleyRESTAPIQueryViewType                     @"view"
#define kMendeleyRESTAPIQueryFilehash                     @"filehash"
#define kMendeleyRESTAPIQueryScopus                       @"scopus"
#define kMendeleyRESTAPIDefaultPageSize                   50
#define kMendeleyRESTAPIMaxPageSize                       200
#define kMendeleyRESTAPIQueryFollowersTypeFollowing       @"following"
#define kMendeleyRESTAPIQueryFollowersTypePending         @"pending"
#define kMendeleyRESTAPIPageLoadID                        @"page_load_id"
#define kMendeleyRESTAPIRef                               @"ref"

/***********************************************
   @name Data models
***********************************************/
#define kMendeleyModelDocumentType                        @"MendeleyDocumentType"
#define kMendeleyModelMetadataLookup                      @"MendeleyMetadataLookup"
#define kMendeleyModelIdentifierType                      @"MendeleyIdentifierType"
#define kMendeleyModelDocument                            @"MendeleyDocument"
#define kMendeleyModelDocumentId                          @"MendeleyDocumentId"
#define kMendeleyModelCatalogDocument                     @"MendeleyCatalogDocument"
#define kMendeleyModelPerson                              @"MendeleyPerson"
#define kMendeleyModelFolder                              @"MendeleyFolder"
#define kMendeleyModelFile                                @"MendeleyFile"
#define kMendeleyModelOAuthCredentials                    @"MendeleyOAuthCredentials"
#define kMendeleyModelOpenIDCredentials                   @"MendeleyOpenIDCredentials"
#define kMendeleyModelIDPlusCredentials                   @"MendeleyIDPlusCredentials"
#define kMendeleyModelGroup                               @"MendeleyGroup"
#define kMendeleyModelAnnotation                          @"MendeleyAnnotation"
#define kMendeleyModelUserRole                            @"MendeleyUserRole"
#define kMendeleyModelProfile                             @"MendeleyProfile"
#define kMendeleyModelProfileVerificationStatus           @"MendeleyProfileVerificationStatus"
#define kMendeleyModelUserProfile                         @"MendeleyUserProfile"
#define kMendeleyModelSocialProfile                       @"MendeleySocialProfile"
#define kMendeleyModelEmployment                          @"MendeleyEmployment"
#define kMendeleyModelEducation                           @"MendeleyEducation"
#define kMendeleyModelRecentlyRead                        @"MendeleyRecentlyRead"
#define kMendeleyModelFollow                              @"MendeleyFollow"
#define kMendeleyModelDataset                             @"MendeleyDataset"
#define kMendeleyModelLicenceInfo                         @"MendeleyLicenceInfo"
#define kMendeleyModelApplicationFeature                  @"MendeleyFeature"
#define kMendeleyModelWebsites                            @"NSArray"
#define kMendeleyModelTags                                @"NSArray"
#define kMendeleyModelKeywords                            @"NSArray"
#define kMendeleyModelDiscipline                          @"MendeleyDiscipline"
#define kMendeleyModelAcademicStatus                      @"MendeleyAcademicStatus"
#define kMendeleyModelDisciplines                         @"NSArray"
#define kMendeleyModelSubdisciplines                      @"NSArray"
#define kMendeleyModelPhotos                              @"NSArray"
#define kMendeleyModelReaderCountByCountry                @"NSDictionary"
#define kMendeleyModelReaderCountByDiscipline             @"NSDictionary"
#define kMendeleyModelReaderCountByAcademicStatus         @"NSDictionary"
#define kMendeleyModelRecommendations                     @"MendeleyRecommendedArticle"
#define kMendeleyModelNewsFeed                            @"MendeleyNewsFeed"
#define kMendeleyModelComment                             @"MendeleyComment"
#define kMendeleyModelExpandedComment                     @"MendeleyExpandedComment"
#define kMendeleyModelCommentUpdate                       @"MendeleyCommentUpdate"
#define kMendeleyModelUserPost                            @"MendeleyUserPost"
#define kMendeleyModelGroupPost                           @"MendeleyGroupPost"

/***********************************************
   @name JSON keys General
***********************************************/
#define kMendeleyJSONID                                   @"id"
#define kMendeleyJSONDescription                          @"description"
#define kMendeleyJSONVersion                              @"version"
#define kMendeleyJSONDateTimeFormat                       @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
#define kMendeleyShortJSONDateTimeFormat                  @"yyyy-MM-dd"
#define kMendeleyHTTPHeaderDateFormat                     @"EEE', 'dd' 'MMM' 'yyyy' 'HH':'mm':'ss' GMT"
#define kMendeleyObjectID                                 @"object_ID"
#define kMendeleyObjectDescription                        @"objectDescription"
#define kMendeleyObjectVersion                            @"object_version"


/***********************************************
   @name JSON keys Document
***********************************************/
#define kMendeleyJSONType                                 @"type"
#define kMendeleyJSONMonth                                @"month"
#define kMendeleyJSONYear                                 @"year"
#define kMendeleyJSONLastModified                         @"last_modified"
#define kMendeleyJSONDay                                  @"day"
#define kMendeleyJSONGroupID                              @"group_id"
#define kMendeleyJSONSource                               @"source"
#define kMendeleyJSONTitle                                @"title"
#define kMendeleyJSONRevision                             @"revision"
#define kMendeleyJSONAbstract                             @"abstract"
#define kMendeleyJSONIdentifiers                          @"identifiers"
#define kMendeleyJSONProfileID                            @"profile_id"
#define kMendeleyJSONAuthors                              @"authors"
#define kMendeleyJSONTranslators                          @"translators"
#define kMendeleyJSONCreated                              @"created"
#define kMendeleyJSONTrashed                              @"trashed"
#define kMendeleyJSONPages                                @"pages"
#define kMendeleyJSONVolume                               @"volume"
#define kMendeleyJSONIssue                                @"issue"
#define kMendeleyJSONWebsites                             @"websites"
#define kMendeleyJSONPublisher                            @"publisher"
#define kMendeleyJSONCity                                 @"city"
#define kMendeleyJSONEdition                              @"edition"
#define kMendeleyJSONInstitution                          @"institution"
#define kMendeleyJSONSeries                               @"series"
#define kMendeleyJSONChapter                              @"chapter"
#define kMendeleyJSONEditors                              @"editors"
#define kMendeleyJSONRead                                 @"read"
#define kMendeleyJSONStarred                              @"starred"
#define kMendeleyJSONAuthored                             @"authored"
#define kMendeleyJSONConfirmed                            @"confirmed"
#define kMendeleyJSONHidden                               @"hidden"
#define kMendeleyJSONPositions                            @"positions"
#define kMendeleyJSONErrorMessage                         @"message"
#define kMendeleyJSONFileAttached                         @"file_attached"
#define kMendeleyJSONTags                                 @"tags"
#define kMendeleyJSONKeywords                             @"keywords"
#define kMendeleyJSONDisciplines                          @"disciplines"
#define kMendeleyJSONReaderCountByCountry                 @"reader_count_by_country"
#define kMendeleyJSONReaderCountByDiscipline              @"reader_count_by_subdiscipline"
#define kMendeleyJSONReaderCountByAcademicStatus          @"reader_count_by_academic_status"

#define kMendeleyJSONCitationKey                          @"citation_key"
#define kMendeleyJSONSourceType                           @"source_type"
#define kMendeleyJSONLanguage                             @"language"
#define kMendeleyJSONShortTitle                           @"short_title"
#define kMendeleyJSONReprintEdition                       @"reprint_edition"
#define kMendeleyJSONGenre                                @"genre"
#define kMendeleyJSONCountry                              @"country"
#define kMendeleyJSONSeriesEditor                         @"series_editor"
#define kMendeleyJSONCode                                 @"code"
#define kMendeleyJSONMedium                               @"medium"
#define kMendeleyJSONUserContext                          @"user_context"
#define kMendeleyJSONDepartment                           @"department"
#define kMendeleyJSONPatentOwner                          @"patent_owner"
#define kMendeleyJSONPatentApplicationNumber              @"patent_application_number"
#define kMendeleyJSONPatentLegalStatus                    @"patent_legal_status"
#define kMendeleyJSONNotes                                @"notes"
#define kMendeleyJSONAccessed                             @"accessed"
#define kMendeleyJSONFolderID                             @"folder_id"
#define kMendeleyJSONUserID                               @"user_id"



/***********************************************
   @name JSON keys File
***********************************************/
#define kMendeleyJSONFileFileName                         @"file_name"
#define kMendeleyJSONFileMimeType                         @"mime_type"
#define kMendeleyJSONFileFileHash                         @"filehash"
#define kMendeleyJSONFileDocumentID                       @"document_id"
#define kMendeleyJSONFileCatalogID                        @"catalog_id"
#define kMendeleyJSONFileSize                             @"size"

/***********************************************
   @name JSON Folder Identifier keys
***********************************************/
#define kMendeleyJSONFolderParentID                       @"parent_id"
#define kMendeleyJSONFolderName                           @"name"
#define kMendeleyJSONFolderGroupID                        @"group_id"

/***********************************************
   @name JSON Document Identifier keys
***********************************************/
#define kMendeleyJSONIdentifierArxiv                      @"arxiv"
#define kMendeleyJSONIdentifierPmid                       @"pmid"
#define kMendeleyJSONIdentifierDoi                        @"doi"
#define kMendeleyJSONIdentifierIsbn                       @"isbn"
#define kMendeleyJSONIdentifierIssn                       @"issn"

/***********************************************
   @name JSON keys Annotations
***********************************************/
#define kMendeleyJSONColor                                @"color"
#define kMendeleyJSONPositions                            @"positions"
#define kMendeleyJSONTopLeft                              @"top_left"
#define kMendeleyJSONBottomRight                          @"bottom_right"
#define kMendeleyJSONPositionX                            @"x"
#define kMendeleyJSONPositionY                            @"y"
#define kMendeleyJSONColorRed                             @"r"
#define kMendeleyJSONColorGreen                           @"g"
#define kMendeleyJSONColorBlue                            @"b"
#define kMendeleyJSONPage                                 @"page"
#define kMendeleyJSONAnnotationDocumentID                 @"document_id"

/***********************************************
   @name JSON keys Group & Photo
***********************************************/
#define kMendeleyJSONLink                                 @"link"
#define kMendeleyJSONPhoto                                @"photo"
#define kMendeleyJSONPhotos                               @"photos"
#define kMendeleyJSONName                                 @"name"
#define kMendeleyJSONOriginal                             @"original"
#define kMendeleyJSONSquare                               @"square"
#define kMendeleyJSONStandard                             @"standard"

/***********************************************
   @name JSON keys Profile
***********************************************/
#define kMendeleyJSONLocation                             @"location"
#define kMendeleyJSONDiscipline                           @"discipline"
#define kMendeleyJSONSubdisciplines                       @"subdisciplines"
#define kMendeleyJSONEmployment                           @"employment"
#define kMendeleyJSONEducation                            @"education"

/***********************************************
   @name JSON keys Person
***********************************************/
/***********************************************
**  Field Definitions: ************************
   surname (string, optional),
   forename (string, optional)
***********************************************/
#define kMendeleyJSONSurname                              @"last_name"
#define kMendeleyJSONForename                             @"first_name"

/***********************************************
 @name JSON keys Dataset
 ***********************************************/
#define kMendeleyJSONDOI                                  @"doi"
#define kMendeleyJSONDataLicence                          @"data_licence"
#define kMendeleyJSONVersions                             @"versions"
#define kMendeleyJSONFiles                                @"files"
#define kMendeleyJSONMetrics                              @"metrics"
#define kMendeleyJSONContributors                         @"contributors"
#define kMendeleyJSONArticles                             @"articles"
#define kMendeleyJSONCategories                           @"categories"
#define kMendeleyJSONInstitutions                         @"institutions"
#define kMendeleyJSONRelatedLinks                         @"related_links"

/***********************************************
 @name JSON keys File metadata
 ***********************************************/
#define kMendeleyJSONContentDetails                       @"content_details"

/***********************************************
 @name JSON keys Recommendations metadata
 ***********************************************/
#define kMendeleyJSONData                                 @"data"
#define kMendeleyJSONCatalogDocument                      @"catalogue_document"
#define kMendeleyJSONRank                                 @"rank"
#define kMendeleyJSONTrace                                @"trace"
#define kMendeleyJSONPosition                             @"position"
#define kMendeleyJSONUserAction                           @"userAction"
#define kMendeleyJSONCarousel                             @"carousel"

/***********************************************
 @name JSON keys NewsFeed
 ***********************************************/
#define kMendeleyJSONContent                       @"content"
#define kMendeleyJSONRSSFeed                       @"rss_feed"
#define kMendeleyJSONComments                      @"comments"
#define kMendeleyJSONShare                         @"share"
#define kMendeleyJSONLike                          @"like"
#define kMendeleyJSONProfile                       @"profile"
#define kMendeleyJSONFollowings                    @"followings"
#define kMendeleyJSONDocuments                     @"documents"
#define kMendeleyJSONGroup                         @"group"
#define kMendeleyJSONRecommendations               @"recommendations"
#define kMendeleyJSONUserDocument                  @"user_document"
#define kMendeleyJSONPost                          @"post"

/***********************************************
 @name JSON keys ExpandedComments
 ***********************************************/

#define kMendeleyJSONLatest                        @"latest"

/***********************************************
 @name JSON keys UserPost
 ***********************************************/

#define kMendeleyJSONTaggedUsers                   @"tagged_users"
#define kMendeleyJSONDocument                      @"document"
#define kMendeleyJSONImages                        @"images"
#define kMendeleyJSONFilesSummary                  @"files_summary"
#define kMendeleyJSONFirstFiles                    @"first_files"
#define kMendeleyJSONOriginal                      @"original"
#define kMendeleyJSONThumbnail                     @"thumbnail"

/***********************************************
   @name Paging
***********************************************/
#define kMendeleyPagingNoSizeInfo                         -1


/***********************************************
   @name Performance Tools
***********************************************/
#define kMendeleyPerformanceReportFileNamePrefix          @"Mendeley Performance Report"
#define kMendeleyPerformanceReportFileKeyTimerTitle       @"Task Name"
#define kMendeleyPerformanceReportFileKeyTimerID          @"Task ID"
#define kMendeleyPerformanceReportFileKeyTimerStartTime   @"Start Time"
#define kMendeleyPerformanceReportFileKeyTimerElapsedTime @"Elapsed Time"
#define kMendeleyPerformanceReportFileKeySessionID        @"Session ID"
#define kMendeleyPerformanceReportFileKeySessionTitle     @"Session Name"
#define kMendeleyPerformanceReportFileKeySessionTotalTime @"Total Time"
#define kMendeleyPerformanceReportFileKeySessionJobList   @"Sub Tasks"

/***********************************************
 @name Feeds
 ***********************************************/
#define kMendeleyFeedItemRSS                              @"rss-item"
#define kMendeleyFeedItemNewStatus                        @"new-status"
#define kMendeleyFeedItemGroupStatus                      @"group-status-posted"
#define kMendeleyFeedItemEmploymentUpdate                 @"employment-update"
#define kMendeleyFeedItemEducationUpdate                  @"education-update"
#define kMendeleyFeedItemNewFollower                      @"new-follower"
#define kMendeleyFeedItemNewPublication                   @"new-pub"
#define kMendeleyFeedItemDocumentRecommendation           @"document-recommendation"
#define kMendeleyFeedItemPostedCataloguePublication       @"posted-catalogue-pub"
#define kMendeleyFeedItemPostedPublication                @"posted-pub"
#define kMendeleyFeedItemGroupDocumentAdded               @"group-doc-added"

#define kMendeleyFeedSourceTypeProfile                    @"profile"
#define kMendeleyFeedSourceTypeRSS                        @"rss"

/***********************************************
 @name Generic
 ***********************************************/
#define kMendeleyPosixDefaultFormat                       @"en_US_POSIX"
#define kMendeleyTimeZoneUTC                              @"UTC"

/***********************************************
 @name Authentication
 ***********************************************/
#define kMendeleyIDPlusScopeKey                           @"idPlusScope"
#define kMendeleyIDPlusStateKey                           @"idPlusState"
#define kMendeleyIDPlusAuthTypeKey                        @"idPlusAuthType"
#define kMendeleyIDPlusPlatSiteKey                        @"idPlusPlatSite"
#define kMendeleyIDPlusPromptKey                          @"idPlusPrompt"
#define kMendeleyIDPlusRedirectUriKey                     @"idPlusRedirectUri"
#define kMendeleyIDPlusResponseTypeKey                    @"idPlusResponseType"
#define kMendeleyIDPlusClientIdKey                        @"idPlusClientId"
#define kMendeleyIDPlusSecretKey                          @"idPlusSecret"

#define kMendeleyIDPlusBaseURL                            @"https://id.elsevier.com"

#define kIDPlusScopeDefault                               @"openid email profile"
#define kIDPlusAuthTypeDefault                            @"SINGLE_SIGN_IN"
#define kIDPlusPlatSiteDefault                            @"MDY/mendeley"
#define kIDPlusPromptDefault                              @"login"
#define kIDPlusResponseTypeDefault                        @"code"


/***********************************************
 @name PrivacySettings
 ***********************************************/
#define kMendeleyJSONPrivacy                              @"privacy"

#endif /* ifndef MendeleyKit_MendeleyGlobals_h */
