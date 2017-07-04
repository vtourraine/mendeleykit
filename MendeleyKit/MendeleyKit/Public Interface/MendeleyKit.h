/**
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
#import "MendeleyGlobals.h"

@class MendeleySyncInfo, MendeleyDocumentParameters, MendeleyFileParameters, MendeleyFolderParameters, MendeleyAnnotationParameters, MendeleyDocument, MendeleyFile, MendeleyFolder, MendeleyDocumentId, MendeleyAnnotation, MendeleyMetadataParameters, MendeleyGroupParameters, MendeleyTask, MendeleyCatalogParameters, MendeleyGroup, MendeleyProfile, MendeleyAmendmentProfile, MendeleyNewProfile, MendeleyRecentlyReadParameters, MendeleyRecentlyRead, MendeleyFollowersParameters, MendeleyDatasetParameters, MendeleyRecommendationsParameters, MendeleyFeedsParameters, MendeleySharesParameters, MendeleyShareDocumentParameters, MendeleyComment,
    MendeleyCommentUpdate, MendeleyNewUserPost;

@protocol MendeleyNetworkProvider;

@interface MendeleyKit : NSObject
@property (nonatomic, assign, readonly) BOOL isAuthenticated;
/**
   @name General methods
 */

/**
   singleton for MendeleyKit. Do we actually need a singleton here?
 */
+ (MendeleyKit *)sharedInstance;

/**
   changes the default network provider
   @param networkProviderClassName the name of the class used as network provider
 */
- (void)changeNetworkProviderWithClassName:(NSString *)networkProviderClassName;

/**
   Clears out any stored authentication.
   After calling this users will need to log in again.
 */
- (void)clearAuthentication;

/**
   update the configurations used in the SDK
 */
- (void)updateConfiguration;


/**
   this method checks the validity of access and refresh token.
   E.g. if user changes password on another client, the refresh_token will expire
   In this case this method will return success == NO and error != nil in the completion block
   @param completionBlock
   @return a MendeleyTask object used for cancelling the operation
 */
- (MendeleyTask *)checkAuthorisationStatusWithCompletionBlock:(MendeleyCompletionBlock)completionBlock;


#pragma mark - General

/**
   This is a generic paging method for objects. The server returns a fully formed URL
   independent of whether the paging is performed on documents, folders or any other API
   that supports paging

   @param linkURL the full HTTP link to the document listings page
   @param expectedModel the name of the expected model class to return in the array
   @param completionBlock returning array of objects, syncinfo and error
   @return a MendeleyTask object used for cancelling the operation
 */
- (MendeleyTask *)pagedListOfObjectsWithLinkedURL:(NSURL *)linkURL
                                    expectedModel:(NSString *)expectedModel
                                  completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

#pragma mark - Academic Statuses (deprecated)
/**
   This method gets all registered Mendeley academic statuses. This method is deprecated
   use 'userRolesWithCompletionBlock' instead
   @param completionBlock will return an array of MendeleyAcademicStatus objects
   @return a cancellable task
 */
- (MendeleyTask *)academicStatusesWithCompletionBlock:(MendeleyArrayCompletionBlock)completionBlock __attribute__((deprecated));

#pragma mark - Disciplines (deprecated)
/**
   This method is deprecated. Use 'subjectAreasWithCompletionBlock' instead.
   This method gets all registered Mendeley disciplines (and their subdisciplines)
   @param completionBlock will return an array of MendeleyDiscipline objects
   @return a cancellable task
 */
- (MendeleyTask *)disciplinesWithCompletionBlock:(MendeleyArrayCompletionBlock)completionBlock __attribute__((deprecated));

#pragma mark - Subject Areas and User Roles
/**
 This method gets all registered Elsevier user roles (formerly called Mendeley academic statuses).
 This method replaces 'academicStatusesWithCompletionBlock'
 @param completionBlock will return an array of MendeleyAcademicStatus objects
 @return a cancellable task
 */
- (MendeleyTask *)userRolesWithCompletionBlock:(MendeleyArrayCompletionBlock)completionBlock;

/**
 This method gets all registered Elsevier subject areas (formerly called Mendeley disciplines).
 This method replaces 'disciplinesWithCompletionBlock'
 @param completionBlock will return an array of MendeleyDiscipline objects
 @return a cancellable task
 */
- (MendeleyTask *)subjectAreasWithCompletionBlock:(MendeleyArrayCompletionBlock)completionBlock;


#pragma mark - Profiles
/**
   @name Profile API methods
 */
/**
   The completionBlock returns an instance of MendeleyUserProfile
   @param completionBlock returning the profile object if found
   @return a MendeleyTask object used for cancelling the operation
 */
- (MendeleyTask *)pullMyProfile:(MendeleyObjectCompletionBlock)completionBlock;

/**
   The completionBlock returns an instance of MendeleyProfile
   @param profileID the user profile ID
   @param completionBlock returning the profile object if found
   @return a MendeleyTask object used for cancelling the operation
 */
- (MendeleyTask *)pullProfile:(NSString *)profileID
              completionBlock:(MendeleyObjectCompletionBlock)completionBlock;

/**
   A convenience method to obtain the profile icon for a given MendeleyProfile object
   @param profile
   @param iconType
   @param completionBlock returning the image data as NSData
   @return a MendeleyTask object used for cancelling the operation
 */

- (MendeleyTask *)profileIconForProfile:(MendeleyProfile *)profile
                               iconType:(MendeleyIconType)iconType
                        completionBlock:(MendeleyBinaryDataCompletionBlock)completionBlock;


/**
   Obtains a profile icon based on the given link URL string
   The URL string for a given icon is supplied with the MendeleyProfile metadata (see MendeleyPhoto property)
   @param iconURLString
   @param completionBlock returning the image data as NSData
   @return a MendeleyTask object used for cancelling the operation
 */
- (MendeleyTask *)profileIconForIconURLString:(NSString *)iconURLString
                              completionBlock:(MendeleyBinaryDataCompletionBlock)completionBlock;

/**
   Creates a new profile based on the MendeleyNewProfile argument passed in. The following properties MUST be
   provided to be able to create a new profile
   first_name, last_name, email, password, main discipline, academic status, marketing
   Note: the email MUST be unique
   Note: marketing is a boolean flag - e.g. set to false
   Note: discipline must be a valid, existing registered discipline in Mendeley (otherwise an error will be returned)
   @param profile - containing at least the 6 mandatory properties given above
   @param completionBlock - the completionHandler.
   @return a cancellable MendeleyTask object
 */
- (MendeleyTask *)createProfile:(MendeleyNewProfile *)profile
                completionBlock:(MendeleyObjectCompletionBlock)completionBlock;

/**
   Updates an existing user's profile based on the MendeleyAmendmentProfile argument passed in.
   If the user wants to update his password the following properties must be provided
   - password (i.e. the new password)
   - old_password (i.e the previous password to be replaced)
   @param profile - the profile containing the updated parameters.
   @param completionBlock - the completionHandler.
   @return a cancellable MendeleyTask object
 */
- (MendeleyTask *)updateMyProfile:(MendeleyAmendmentProfile *)myProfile
                  completionBlock:(MendeleyObjectCompletionBlock)completionBlock;

#pragma mark - Photos

/**
 Upload a new original photo asset for my profile.
 @param fileURL
 @param contentType
 @param contentLenght
 @param progressBlock
 @param completionBlock
 */
- (MendeleyTask *)uploadPhotoWithFile:(NSURL *)fileURL
                contentType:(NSString *)contentType
              contentLength:(NSInteger)contentLength
              progressBlock:(MendeleyResponseProgressBlock)progressBlock
            completionBlock:(MendeleyCompletionBlock)completionBlock;

#pragma mark - Documents
/**
   @name documents, trash and catalog API methods
 */

/**
   This method is only used when paging through a list of documents on the server.
   All required parameters are provided in the linkURL, which should not be modified

   @param linkURL the full HTTP link to the document listings page
   @param completionBlock returning array of documents
   @return a MendeleyTask object used for cancelling the operation
 */
- (MendeleyTask *)documentListWithLinkedURL:(NSURL *)linkURL
                            completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

/**
   obtains a list of documents for the first page.
   @param queryParameters the parameter set to be used in the request
   @param completionBlock returning array of documents
   @return a MendeleyTask object used for cancelling the operation
 */
- (MendeleyTask *)documentListWithQueryParameters:(MendeleyDocumentParameters *)queryParameters
                                  completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

/**
   obtains the first page of authored documents for another user.
   @param profileID profile ID of the user
   @param parameters the parameter set to be used in the request
   @param completionBlock returning array of documents
   @return a MendeleyTask object used for cancelling the operation
 */
- (MendeleyTask *)authoredDocumentListForUserWithProfileID:(NSString *)profileID
                                           queryParameters:(MendeleyDocumentParameters *)queryParameters
                                           completionBlock:(MendeleyArrayCompletionBlock)completionBlock;
/**
   obtains a document for given ID from the library
   @param documentID the UUID of the document
   @param completionBlock returning the document
   @return a MendeleyTask object used for cancelling the operation
 */
- (MendeleyTask *)documentWithDocumentID:(NSString *)documentID
                         completionBlock:(MendeleyObjectCompletionBlock)completionBlock;

/**
   This method returns a catalog document for a given catalog ID
   @param catalogID the catalog UUID
   @param completionBlock returning the catalog document
   @return a MendeleyTask object used for cancelling the operation
 */
- (MendeleyTask *)catalogDocumentWithCatalogID:(NSString *)catalogID
                               completionBlock:(MendeleyObjectCompletionBlock)completionBlock;

/**
   This method obtains a list of documents based on a filter. The filter should not be nil or empty
   @param queryParameters query parameters for the URL request
   @param completionBlock returning the list of found catalog documents
   @return a MendeleyTask object used for cancelling the operation
 */
- (MendeleyTask *)catalogDocumentWithParameters:(MendeleyCatalogParameters *)queryParameters
                                completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

/**
   this creates a document based on the mendeley object model provided in the argument.
   The server will respond with the JSON data structure for the new object
   @param mendeleyDocument the document to be created
   @param completionBlock returns the document created on the server with the UUID
   @return a MendeleyTask object used for cancelling the operation
 */
- (MendeleyTask *)createDocument:(MendeleyDocument *)mendeleyDocument
                 completionBlock:(MendeleyObjectCompletionBlock)completionBlock;

/**
   modify/update a document with ID. The server will return a JSON object with the updated data
   @param updatedDocument the document to be updated
   @param completionBlock returns the updated document from the server
   @return a MendeleyTask object used for cancelling the operation
 */
- (MendeleyTask *)updateDocument:(MendeleyDocument *)updatedDocument
                 completionBlock:(MendeleyObjectCompletionBlock)completionBlock;


/**
   this method will remove a document with given ID permanently. The document data cannot be retrieved.
   However, the user will be able to get a list of permanently removed IDs
   @param documentID the document UUID
   @param completionBlock returns bool/error
   @return a MendeleyTask object used for cancelling the operation
 */
- (MendeleyTask *)deleteDocumentWithID:(NSString *)documentID
                       completionBlock:(MendeleyCompletionBlock)completionBlock;

/**
   This method will move a document of given ID into the trash on the server. Data in trash can be restored
   (as opposed to using the deleteDocumentWithID:completionBlock: method which permanently removes them)
   @param documentID the document UUID
   @param completionBlock the success block upon completion
   @return a MendeleyTask object used for cancelling the operation
 */
- (MendeleyTask *)trashDocumentWithID:(NSString *)documentID
                      completionBlock:(MendeleyCompletionBlock)completionBlock;

/**
   This method returns a list of document IDs that were permanently deleted in the user Library. The list of deleted IDs will be kept on
   the server for a limited period of time.
   @param deletedSince passed to the server to get list of documents that were deleted since that date
   @param completionBlock a list of document UUIDs if found
   @return a MendeleyTask object used for cancelling the operation
 */
- (MendeleyTask *)deletedDocumentsSince:(NSDate *)deletedSince
                        completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

/**
   This method returns a list of document IDs that were permanently deleted in a group. The list of deleted IDs will be kept on
   the server for a limited period of time.
   @param deletedSince passed to the server to get list of documents that were deleted since that date
   @param completionBlock a list of document UUIDs if found
   @param groupID the group UUID
   @return a MendeleyTask object used for cancelling the operation
 */
- (MendeleyTask *)deletedDocumentsSince:(NSDate *)deletedSince
                                groupID:(NSString *)groupID
                        completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

/**
   This method obtains a list for a given page link of 'trashed' documents
   based on a list of query parameters.
   All required parameters are provided in the linkURL, which should not be modified

   @param linkURL the full HTTP link to the document listings page
   @param completionBlock returns a list of trashed documents if found
   @return a MendeleyTask object used for cancelling the operation
 */
- (MendeleyTask *)trashedDocumentListWithLinkedURL:(NSURL *)linkURL
                                   completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

/**
   This method obtains a list for the 'first' page of 'trashed' documents
   based on a list of query parameters.
   @param queryParameters the parameter set to be used in the request
   @param completionBlock the list of trashed documents
   @return a MendeleyTask object used for cancelling the operation
 */
- (MendeleyTask *)trashedDocumentListWithQueryParameters:(MendeleyDocumentParameters *)queryParameters
                                         completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

/**
   this method will remove a trashed document with given ID permanently.
   The document data cannot be retrieved.
   However, the user will be able to get a list of permanently removed IDs
   @param documentID the UUID of the trashed document
   @param completionBlock a success block for the operation
   @return a MendeleyTask object used for cancelling the operation
 */
- (MendeleyTask *)deleteTrashedDocumentWithID:(NSString *)documentID
                              completionBlock:(MendeleyCompletionBlock)completionBlock;

/**
   this method will restore a trashed document.
   In essence this means the document must be retrieved using the /documents API
   @param documentID the UUID of the document to be restored from trash
   @param completionBlock the success block
   @return a MendeleyTask object used for cancelling the operation
 */
- (MendeleyTask *)restoreTrashedDocumentWithID:(NSString *)documentID
                               completionBlock:(MendeleyCompletionBlock)completionBlock;


/**
   obtains a document for given ID from the library
   @param documentID the UUID of the trashed document
   @param completionBlock returns the found trashed document
   @return a MendeleyTask object used for cancelling the operation
 */
- (MendeleyTask *)trashedDocumentWithDocumentID:(NSString *)documentID
                                completionBlock:(MendeleyObjectCompletionBlock)completionBlock;

/**
   uploads a file from a location and returns a Mendeley Document in the completion handler
   @param fileURL the location of the file
   @param mimeType e.g. application/pdf
   @param completionBlock
   @return a MendeleyTask object used for cancelling the operation
 */
- (MendeleyTask *)documentFromFileWithURL:(NSURL *)fileURL mimeType:(NSString *)mimeType completionBlock:(MendeleyObjectCompletionBlock)completionBlock;

#pragma mark - Metadata
/**
   @name Metadata API
 */

/**
   obtains metadata lookup based on specified search parameters
   @param queryParameters the search parameters to be used in the request
   @param completionBlock the metadata lookup containing the catalog id and score - if found
   @return a MendeleyTask object used for cancelling the operation
 */
- (MendeleyTask *)metadataLookupWithQueryParameters:(MendeleyMetadataParameters *)queryParameters
                                    completionBlock:(MendeleyObjectCompletionBlock)completionBlock;


/**
 Method clones document metadata to a new group/lib. The returned metadata contain the user document metadata including the document ID for the cloned document
 @param documentID the ID of the document to be cloned
 @param groupID the target group ID. Use nil if you want to clone to the users' library. In this case the profile ID must be provided
 @param folderID the target folder ID.
 @param profileID must be provided if the groupID is nil (this means clone to user library). Otherwise values are ignored
 @param completionBlock
 */
- (MendeleyTask *)cloneDocumentWithID:(NSString *)documentID
                              groupID:(NSString *)groupID
                             folderID:(NSString *)folderID
                            profileID:(NSString *)profileID
                      completionBlock:(MendeleyObjectCompletionBlock)completionBlock;

/**
 Method clones files associated with a document from source to target.
 The target document must exist - otherwise the completionBlock will return an error
 @param sourceDocumentID the source document with files
 @param targetDocumentID the target document ID
 @param completionBlock
 */
- (MendeleyTask *)cloneDocumentFiles:(NSString *)sourceDocumentID
                    targetDocumentID:(NSString *)targetDocumentID
                     completionBlock:(MendeleyCompletionBlock)completionBlock;


/**
 Method clones document metadata to a new group/lib. It also clones any associated files from source to target document
 The returned metadata contain the user document metadata including the document ID for the cloned document
 @param documentID the ID of the document to be cloned
 @param groupID the target group ID. Use nil if you want to clone to the users' library. In this case the profile ID must be provided
 @param folderID the target folder ID.
 @param profileID must be provided if the groupID is nil (this means clone to user library). Otherwise values are ignored
 @param completionBlock
 */
- (MendeleyTask *)cloneDocumentAndFiles:(NSString *)documentID
                                groupID:(NSString *)groupID
                               folderID:(NSString *)folderID
                              profileID:(NSString *)profileID
                        completionBlock:(MendeleyObjectCompletionBlock)completionBlock;



#pragma mark - Document and Identifier Types
/**
   @name documentTypes and identifierTypes APIs methods
 */

/**
   obtains the list of document types (e.g. journal, book etc) currently available
   @param completionBlock returns the list of document types
   @return a MendeleyTask object used for cancelling the operation
 */
- (MendeleyTask *)documentTypesWithCompletionBlock:(MendeleyArrayCompletionBlock)completionBlock;

/**
   obtains the list of identifier types (e.g. arxiv, doi, pmid) currently available
   @param completionBlock returns the list of identifier types
   @return a MendeleyTask object used for cancelling the operation
 */
- (MendeleyTask *)identifierTypesWithCompletionBlock:(MendeleyArrayCompletionBlock)completionBlock;

#pragma mark - Files
/**
   @name files API methods
 */

/**
   obtains a list of files for the first page.
   @param queryParameters the parameter set to be used in the request
   @param completionBlock returns the list of files if found
   @return a MendeleyTask object used for cancelling the operation
 */
- (MendeleyTask *)fileListWithQueryParameters:(MendeleyFileParameters *)queryParameters
                              completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

/**
   obtains a file for given ID from the library
   @param fileID the file UUID
   @param fileURL the location of the file to be saved into
   @param progressBlock a callback block to capture progress
   @param completionBlock the final completion block indicating success/failure
   @return a MendeleyTask object used for cancelling the operation
 */
- (MendeleyTask *)fileWithFileID:(NSString *)fileID
                       saveToURL:(NSURL *)fileURL
                   progressBlock:(MendeleyResponseProgressBlock)progressBlock
                 completionBlock:(MendeleyCompletionBlock)completionBlock;

/**
   This creates a file on the server by uploading it. This method will assume the content type of the file
   to be PDF. The /files API also requires a filename to be specified. This method will set the filename to be
   example.pdf

   @param fileURL the location of the file to be created
   @param documentURLPath the relative URL path of the associated document
   @param progressBlock a callback block to capture progress
   @param completionBlock the success/failure block
   @return a MendeleyTask object used for cancelling the operation
 */
- (MendeleyTask *) createFile:(NSURL *)fileURL
    relativeToDocumentURLPath:(NSString *)documentURLPath
                progressBlock:(MendeleyResponseProgressBlock)progressBlock
              completionBlock:(MendeleyObjectCompletionBlock)completionBlock;

/**
   this creates a file based on the mendeley object model provided in the argument.
   The server will respond with the JSON data structure for the new object
   @param fileURL the location of the file to be created
   @param filename the name of the file (optional). If nil, the name from fileURL will be taken
   @param contentType the type e.g. application/pdf (optional). If nil, PDF will be assumed
   @param documentURLPath the relative URL path of the associated document
   @param progressBlock a callback block to capture progress
   @param completionBlock the success/failure block
   @return a MendeleyTask object used for cancelling the operation
 */
- (MendeleyTask *) createFile:(NSURL *)fileURL
                     filename:(NSString *)filename
                  contentType:(NSString *)contentType
    relativeToDocumentURLPath:(NSString *)documentURLPath
                progressBlock:(MendeleyResponseProgressBlock)progressBlock
              completionBlock:(MendeleyObjectCompletionBlock)completionBlock;

/**
   this method will remove a file with given ID permanently. The file data cannot be retrieved.
   However, the user will be able to get a list of permanently removed IDs
   @param fileID the file UUID
   @param completionBlock the success/failure block
   @return a MendeleyTask object used for cancelling the operation
 */
- (MendeleyTask *)deleteFileWithID:(NSString *)fileID
                   completionBlock:(MendeleyCompletionBlock)completionBlock;

/**
   This method returns a list of files IDs that were permanently deleted in the user Library. The list of deleted IDs will be kept on
   the server for a limited period of time.
   @param deletedSince passed to the server to get list of files that were deleted since that date
   @param completionBlock a list of document UUIDs if found
   @return a MendeleyTask object used for cancelling the operation
 */
- (MendeleyTask *)deletedFilesSince:(NSDate *)deletedSince
                    completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

/**
   This method returns a list of files IDs that were permanently deleted in a group. The list of deleted IDs will be kept on
   the server for a limited period of time.
   @param deletedSince passed to the server to get list of files that were deleted since that date
   @param completionBlock a list of document UUIDs if found
   @param groupID the group UUID
   @return a MendeleyTask object used for cancelling the operation
 */
- (MendeleyTask *)deletedFilesSince:(NSDate *)deletedSince
                            groupID:(NSString *)groupID
                    completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

/**
   BETA - This method returns a list of recently showed files on any device running a version
   of Mendeley (or a third part app) that support this feature.
   The objects are sorted by date with the most recent first.
   By default 20 items are returned.
   The number of records saved on the server is limited.
   @param queryParameters the parameter set to be used in the request
   @param completionBlock
 */
- (MendeleyTask *)recentlyReadWithParameters:(MendeleyRecentlyReadParameters *)queryParameters
                             completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

/**
   BETA - This method create/replace an entry of recently read for a file.
   Any existing entry with a matching id if present is removed, and a new one is created.
   The new one is inserted into the list at a position determined by the
   current server time or at the time provided by the client if specified.
   @param recentlyRead the recently read object to create
   @param completionBlock
 */
- (MendeleyTask *)addRecentlyRead:(MendeleyRecentlyRead *)recentlyRead
                  completionBlock:(MendeleyObjectCompletionBlock)completionBlock;

/**
   Note: this service is not yet available!
   This method update the entry of recently read for a file.
   If an entry with the given id exists in the history for this user,
   its position (page and vertical_position values) are updated.
   It is not brought to the top of the history.
   If there is no entry with matching id in the recent history, it returns an error.
   @param recentlyRead the recently read object to update
   @param completionBlock
   - (MendeleyTask *)updateRecentlyRead:(MendeleyRecentlyRead *)recentlyRead
                     completionBlock:(MendeleyObjectCompletionBlock)completionBlock;
 */

#pragma mark - Folders

/**
   @name folders API methods
 */
/**
   Obtain a list of documents belonging to a specific folder
   @param folderID the folder UUID
   @param queryParameters the query parameters used in the API request
   @param completionBlock the list of folders returned if found
   @return a MendeleyTask object used for cancelling the operation
 */
- (MendeleyTask *)documentListFromFolderWithID:(NSString *)folderID
                                    parameters:(MendeleyFolderParameters *)queryParameters
                               completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

/**
   Add a previously created document in a specific folder
   @param mendeleyDocumentId the UUID of the folder document
   @param folderID the folder UUID
   @param completionBlock the success/failure block
   @return a MendeleyTask object used for cancelling the operation
 */
- (MendeleyTask *)addDocument:(NSString *)mendeleyDocumentId
                     folderID:(NSString *)folderID
              completionBlock:(MendeleyCompletionBlock)completionBlock;

/**
   Create a folder
   @param mendeleyFolder the folder to be created
   @param completionBlock returns the folder as created on the server with UUID
   @return a MendeleyTask object used for cancelling the operation
 */
- (MendeleyTask *)createFolder:(MendeleyFolder *)mendeleyFolder
               completionBlock:(MendeleyObjectCompletionBlock)completionBlock;

/**
   This method is only used when paging through a list of folders on the server.
   All required parameters are provided in the linkURL, which should not be modified

   @param linkURL the full HTTP link to the document listings page
   @param completionBlock the list of folders if any
   @return a MendeleyTask object used for cancelling the operation
 */
- (MendeleyTask *)folderListWithLinkedURL:(NSURL *)linkURL
                          completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

/**
   Obtain a list of folders for the logged-in user
   @param queryParameters the query parameters to be used in the REST API request
   @param completionBlock the list of folders returned if any
   @return a MendeleyTask object used for cancelling the operation
 */
- (MendeleyTask *)folderListWithQueryParameters:(MendeleyFolderParameters *)queryParameters
                                completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

/**
   Obtain a folder identified by the given folderID
   @param folderID the folder UUID
   @param completionBlock the returned folder for given ID if found
   @return a MendeleyTask object used for cancelling the operation
 */
- (MendeleyTask *)folderWithFolderID:(NSString *)folderID
                     completionBlock:(MendeleyObjectCompletionBlock)completionBlock;

/**
   Delete a folder identified by the given folderID
   @param folderID the folder UUID
   @param completionBlock the success/failure block for the operation
   @return a MendeleyTask object used for cancelling the operation
 */
- (MendeleyTask *)deleteFolderWithID:(NSString *)folderID
                     completionBlock:(MendeleyCompletionBlock)completionBlock;

/**
   Update a folder's name, or move it to a new parent
   @param updatedFolder the folder to be updated
   @param completionBlock the success/failure block
   @return a MendeleyTask object used for cancelling the operation
 */
- (MendeleyTask *)updateFolder:(MendeleyFolder *)updatedFolder
               completionBlock:(MendeleyCompletionBlock)completionBlock;

/**
   Delete a document identified by the given documentID and belonging to a folder identified by the given folderID
   @param documentID the document UUID to be deleted in folder
   @param folderID the folder UUID
   @param completionBlock the success/failure block
   @return a MendeleyTask object used for cancelling the operation
 */
- (MendeleyTask *)deleteDocumentWithID:(NSString *)documentID
                      fromFolderWithID:(NSString *)folderID
                       completionBlock:(MendeleyCompletionBlock)completionBlock;

#pragma mark - Groups
/**
   @name groups API methods
 */
/**
   Obtain a list of groups where the logged in user is a member.
   This method also downloads the group icons for each group in the same call
   @param queryParameters the parameters to be used in the API request
   @param iconType (original, square or standard)
   @param completionBlock the list of groups if found
   @return a MendeleyTask object used for cancelling the operation
 */
- (MendeleyTask *)groupListWithQueryParameters:(MendeleyGroupParameters *)queryParameters
                                      iconType:(MendeleyIconType)iconType
                               completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

/**
   This method is only used when paging through a list of groups on the server.
   All required parameters are provided in the linkURL, which should not be modified
   This method also downloads the group icons for each group in the same call

   @param linkURL the full HTTP link to the document listings page
   @param iconType (original, square or standard)
   @param completionBlock the list of groups if found
   @return a MendeleyTask object used for cancelling the operation
 */
- (MendeleyTask *)groupListWithLinkedURL:(NSURL *)linkURL
                                iconType:(MendeleyIconType)iconType
                         completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

/**
   Obtain details for the group identified by the given groupID. It also downloads the group icon.
   @param groupID the group UUID
   @param iconType (original, square or standard)
   @param completionBlock returns the group
   @return a MendeleyTask object used for cancelling the operation
 */
- (MendeleyTask *)groupWithGroupID:(NSString *)groupID
                          iconType:(MendeleyIconType)iconType
                   completionBlock:(MendeleyObjectCompletionBlock)completionBlock;

/**
   Obtain a list of groups where the logged in user is a member
   Note: this method only obtains the group metadata (including any MendeleyPhoto properties)
   It does not download the group icons.
   @param queryParameters the parameters to be used in the API request
   @param completionBlock the list of groups if found
   @return a MendeleyTask object used for cancelling the operation
 */
- (MendeleyTask *)groupListWithQueryParameters:(MendeleyGroupParameters *)queryParameters
                               completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

/**
   This method is only used when paging through a list of groups on the server.
   All required parameters are provided in the linkURL, which should not be modified
   Note: this method only obtains the group metadata (including any MendeleyPhoto properties)
   It does not download the group icons.

   @param linkURL the full HTTP link to the document listings page
   @param completionBlock the list of groups if found
   @return a MendeleyTask object used for cancelling the operation
 */
- (MendeleyTask *)groupListWithLinkedURL:(NSURL *)linkURL
                         completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

/**
   Obtain metadata for the group identified by the given groupID.
   Note: this method only obtains the metadata for a group with ID (including any MendeleyPhoto properties)
   It does not download its group icon.
   @param groupID the group UUID
   @param completionBlock the group
   @return a MendeleyTask object used for cancelling the operation
 */
- (MendeleyTask *)groupWithGroupID:(NSString *)groupID
                   completionBlock:(MendeleyObjectCompletionBlock)completionBlock;

/**
   A convenience method to obtain the group icon for a given MendeleyGroup object
   @param group
   @param iconType
   @param completionBlock returning the image data as NSData
   @return a MendeleyTask object used for cancelling the operation
 */
- (MendeleyTask *)groupIconForGroup:(MendeleyGroup *)group
                           iconType:(MendeleyIconType)iconType
                    completionBlock:(MendeleyBinaryDataCompletionBlock)completionBlock;


/**
   Obtains a group icon based on the given link URL string
   The URL string for a given icon is supplied with the MendeleyGroup metadata (see MendeleyPhoto property)
   @param iconURLString
   @param completionBlock returning the image data as NSData
   @return a MendeleyTask object used for cancelling the operation
 */
- (MendeleyTask *)groupIconForIconURLString:(NSString *)iconURLString
                            completionBlock:(MendeleyBinaryDataCompletionBlock)completionBlock;

#pragma mark - Annotations

/**
   @name annotations API methods
 */
/**
   Obtain details for the annotation identified by the given annotationID
   @param annotationID the annotation UUID
   @param completionBlock the found annotation object
   @return a MendeleyTask object used for cancelling the operation
 */
- (MendeleyTask *)annotationWithAnnotationID:(NSString *)annotationID
                             completionBlock:(MendeleyObjectCompletionBlock)completionBlock;

/**
   Delete the annotation identified by the given annotationID
   @param annotationID the annotation UUID
   @param completionBlock the success/failure block
   @return a MendeleyTask object used for cancelling the operation
 */
- (MendeleyTask *)deleteAnnotationWithID:(NSString *)annotationID
                         completionBlock:(MendeleyCompletionBlock)completionBlock;

/**
   Update the annotation identified by the given annotationID with the given updateMendeleyAnnotation
   @param updatedMendeleyAnnotation the updated annotation object
   @param completionBlock the updated annotation object from the server
   @return a MendeleyTask object used for cancelling the operation
 */
- (MendeleyTask *)updateAnnotation:(MendeleyAnnotation *)updatedMendeleyAnnotation
                   completionBlock:(MendeleyObjectCompletionBlock)completionBlock;
/**
   Create an annotation composed by the parameters of the given mendeletAnnotation
   @param mendeleyAnnotation the annotation to be created on the server
   @param completionBlock returns the created annotation with UUID
   @return a MendeleyTask object used for cancelling the operation
 */
- (MendeleyTask *)createAnnotation:(MendeleyAnnotation *)mendeleyAnnotation
                   completionBlock:(MendeleyObjectCompletionBlock)completionBlock;

/**
   a speficic page/download link for getting annotations.
   @param linkURL the link to be used for obtaining annotations in a paged manner
   @param completionBlock the list of annotations
   @return a MendeleyTask object used for cancelling the operation
 */
- (MendeleyTask *)annotationListWithLinkedURL:(NSURL *)linkURL
                              completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

/**
   Obtain a list of annotations. This is for the first call to getting a list of annotations.
   The queryParameters should contain the limit of the page size
   @param queryParameters the parameters to be used in the request
   @param completionBlock the list of annotations
   @return a MendeleyTask object used for cancelling the operation
 */
- (MendeleyTask *)annotationListWithQueryParameters:(MendeleyAnnotationParameters *)queryParameters
                                    completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

/**
   This method returns a list of annotations IDs that were permanently deleted in the user Library. The list of deleted IDs will be kept on
   the server for a limited period of time.
   @param deletedSince passed to the server to get list of annotations that were deleted since that date
   @param completionBlock a list of document UUIDs if found
   @return a MendeleyTask object used for cancelling the operation
 */
- (MendeleyTask *)deletedAnnotationsSince:(NSDate *)deletedSince
                          completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

/**
   This method returns a list of annotations IDs that were permanently deleted in a group. The list of deleted IDs will be kept on
   the server for a limited period of time.
   @param deletedSince passed to the server to get list of annotations that were deleted since that date
   @param groupID the group UUID
   @param completionBlock a list of document UUIDs if found
   @return a MendeleyTask object used for cancelling the operation
 */
- (MendeleyTask *)deletedAnnotationsSince:(NSDate *)deletedSince
                                  groupID:(NSString *)groupID
                          completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

#pragma mark - Followers
/**
   BETA - Obtain a list of followers for a given user.
   @param profileID
   @param parameters
   @param task
   @param completionBlock - the array contained in the completionBlock will be an array of MendeleyFollow objects
   @return a MendeleyTask object used for cancelling the operation
 */
- (MendeleyTask *)followersForUserWithID:(NSString *)profileID
                              parameters:(MendeleyFollowersParameters *)parameters
                         completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

/**
   BETA - Obtain a list of users followed by a given user.
   @param profileID
   @param parameters
   @param task
   @param completionBlock - the array contained in the completionBlock will be an array of MendeleyFollow objects
   @return a MendeleyTask object used for cancelling the operation
 */
- (MendeleyTask *)followedByUserWithID:(NSString *)profileID
                            parameters:(MendeleyFollowersParameters *)parameters
                       completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

/**
   BETA - Obtain a list of pending followers for a given user.
   @param profileID
   @param parameters
   @param task
   @param completionBlock - the array contained in the completionBlock will be an array of MendeleyFollow objects
   @return a MendeleyTask object used for cancelling the operation
 */
- (MendeleyTask *)pendingFollowersForUserWithID:(NSString *)profileID
                                     parameters:(MendeleyFollowersParameters *)parameters
                                completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

/**
   BETA - Obtain a list of pending users followed by a given user.
   @param profileID
   @param parameters
   @param task
   @param completionBlock - the array contained in the completionBlock will be an array of MendeleyFollow objects
   @return a MendeleyTask object used for cancelling the operation
 */
- (MendeleyTask *)pendingFollowedByUserWithID:(NSString *)profileID
                                   parameters:(MendeleyFollowersParameters *)parameters
                              completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

/**
 BETA - Start following another user.
 @param followedID
 @param task
 @param completionBlock - the object contained in the completionBlock will be a MendeleyFollow object
 @return a MendeleyTask object used for cancelling the operation
 */
- (MendeleyTask *)followUserWithID:(NSString *)followedID
         completionBlock:(MendeleyObjectCompletionBlock)completionBlock;

/**
 BETA - Accept a pending follow request
 @param requestID
 @param completionBlock
 @return a MendeleyTask object used for cancelling the operation
 */
- (MendeleyTask *)acceptFollowRequestWithID:(NSString *)requestID
                  completionBlock:(MendeleyCompletionBlock)completionBlock;

/**
 BETA - Stop following a profile, cancel a follow request or reject a follow request
 @param relationshipID
 @param completionBlock
 @return a MendeleyTask object used for cancelling the operation
 */
- (MendeleyTask *)stopOrDenyRelationshipWithID:(NSString *)relationshipID
               completionBlock:(MendeleyCompletionBlock)completionBlock;

#pragma mark - Recommendations

- (MendeleyTask *)recommendationsBasedOnLibraryArticlesWithParameters:(MendeleyRecommendationsParameters *)queryParameters
                                                      completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

- (MendeleyTask *)feedbackOnRecommendation:(NSString *)trace
                                  position:(NSNumber *)position
                                userAction:(NSString *)userAction
                                  carousel:(NSNumber *)carousel
                           completionBlock:(MendeleyCompletionBlock)completionBlock;

#pragma mark - Feeds

/**
 This method is only used when paging through a list of documents on the server.
 All required parameters are provided in the linkURL, which should not be modified
 
 @param linkURL the full HTTP link to the document listings page
 @param completionBlock
 @return a MendeleyTask object used for cancelling the operation
 */
- (MendeleyTask *)feedListWithLinkedURL:(NSURL *)linkURL
              completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

/**
 obtains a list of feeds for the first page.
 @param parameters the parameter set to be used in the request
 @param completionBlock
 @return a MendeleyTask object used for cancelling the operation
 */
- (MendeleyTask *)feedListWithQueryParameters:(MendeleyFeedsParameters *)queryParameters
                    completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

/**
 obtains feed with a given identifier
 @param feedID
 @param completionBlock
 @return a MendeleyTask object used for cancelling the operation
 */
- (MendeleyTask *)feedWithId:(NSString *)feedId
   completionBlock:(MendeleyObjectCompletionBlock)completionBlock;

/**
 likes a feed item.
 @param feedID
 @param completionBlock
 @return a MendeleyTask object used for cancelling the operation
 */
- (MendeleyTask *)likeFeedWithID:(NSString *)feedID
       completionBlock:(MendeleyCompletionBlock)completionBlock;

/**
 likes a feed item.
 @param feedID
 @param completionBlock
 @return a MendeleyTask object used for cancelling the operation
 */
- (MendeleyTask *)unlikeFeedWithID:(NSString *)feedID
         completionBlock:(MendeleyCompletionBlock)completionBlock;

/**
 List of users that like given item.
 @param feedID
 @param completionBlock
 */
- (MendeleyTask *)likersForFeedWithID:(NSString *)feedID
            completionBlock:(MendeleyArrayCompletionBlock)completionBlock;


/**
 List of users that have shared given item.
 @param feedID
 @param completionBlock
 */

- (MendeleyTask *)sharersForFeedWithID:(NSString *)feedID
             completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

#pragma mark - User Posts

/**
 Deletes a user post.
 @param postID
 @param completionBlock
 @return a MendeleyTask object used for cancelling the operation
 */
- (MendeleyTask *)deleteUserPostWithPostID:(NSString *)postID
                           completionBlock:(MendeleyCompletionBlock)completionBlock;

#pragma mark - Shares

- (MendeleyTask *)shareFeedWithQueryParameters:(MendeleySharesParameters *)queryParameters
                     completionBlock:(MendeleyCompletionBlock)completionBlock;

- (MendeleyTask *)shareDocumentWithDocumentID:(NSString *)documentID
                              completionBlock:(MendeleyCompletionBlock)completionBlock;

- (MendeleyTask *)shareDocumentWithDOI:(NSString *)doi
                       completionBlock:(MendeleyCompletionBlock)completionBlock;

- (MendeleyTask *)shareDocumentWithScopus:(NSString *)scopus
                          completionBlock:(MendeleyCompletionBlock)completionBlock;

#pragma mark - Comments

/**
 Get expanded (i.e. with profile information) comments.
 @param newsItemID
 @param completionBlock
 @return task
 */

- (MendeleyTask *)expandedCommentsWithNewsItemID:(NSString *)newsItemID
                       completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

/**
 Get single comment.
 @param commentID
 @param completionBlock
 @return task
 */

- (MendeleyTask *)commentWithCommentID:(NSString *)commentID
             completionBlock:(MendeleyObjectCompletionBlock)completionBlock;

/**
 Create new comment.
 @param comment
 @param completionBlock
 @return task
 */

- (MendeleyTask *)createComment:(MendeleyComment *)comment
                completionBlock:(MendeleyObjectCompletionBlock)completionBlock;

/**
 Edit existing comment.
 @param commentID
 @param update
 @param completionBlock
 @return task
 */

- (MendeleyTask *)updateCommentWithCommentID:(NSString *)commentID
                                      update:(MendeleyCommentUpdate *)update
                   completionBlock:(MendeleyObjectCompletionBlock)completionBlock;

/**
 Creates a new user post.
 @param newPost
 @param task
 @param completionBlock
 */

- (MendeleyTask *)createUserPost:(MendeleyNewUserPost *)newPost
                 completionBlock:(MendeleyObjectCompletionBlock)completionBlock;


/**
 Delete comment.
 @param commentID
 @param completionBlock
 @return task
 */

- (MendeleyTask *)deleteCommentWithCommentID:(NSString *)commentID
                   completionBlock:(MendeleyCompletionBlock)completionBlock;

#pragma mark - Datasets
/**
 @name datasets API methods
 */

/**
 obtains a list of datasets for the first page.
 @param queryParameters the parameter set to be used in the request
 @param completionBlock returns the list of datasets if found
 @return a MendeleyTask object used for cancelling the operation
 */
- (MendeleyTask *)datasetListWithQueryParameters:(MendeleyDatasetParameters *)queryParameters
                                 completionBlock:(MendeleyArrayCompletionBlock)completionBlock;
/**
 This method is only used when paging through a list of datasets on the server.
 All required parameters are provided in the linkURL, which should not be modified

 @param linkURL the full HTTP link to the dataset listings page
 @param completionBlock returning array of datasets
 @return a MendeleyTask object used for cancelling the operation
 */
- (MendeleyTask *)datasetListWithLinkedURL:(NSURL *)linkURL
                           completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

/**
 obtains a dataset for given ID from the library
 @param datasetID the UUID of the dataset
 @param completionBlock returning the document
 @return a MendeleyTask object used for cancelling the operation
 */
- (MendeleyTask *)datasetWithDatasetID:(NSString *)datasetID
                       completionBlock:(MendeleyObjectCompletionBlock)completionBlock;

/**
 obtains a list of licences that can be applied to datasets
 @param completionBlock returns the list of licences if found
 @return a MendeleyTask object used for cancelling the operation
 */
- (MendeleyTask *)datasetLicencesListWithCompletionBlock:(MendeleyArrayCompletionBlock)completionBlock;

#pragma mark - Features
/**
 obtain a list of supported features from server
 @param completionBlock returning an array of MendeleyFeature objects
 */
- (MendeleyTask *)applicationFeaturesWithCompletionBlock:(MendeleyArrayCompletionBlock)completionBlock;

#pragma mark - Cancellation
/**
   @name cancellation methods
 */
/**
   cancels a specific MendeleyTask
   @param task the mendeley network task
   @param completionBlock the success/failure block
 */
- (void) cancelTask:(MendeleyTask *)task
    completionBlock:(MendeleyCompletionBlock)completionBlock;

/**
   cancels ALL existing tasks
   @param completionBlock the success/failure block
 */
- (void)cancelAllTasks:(MendeleyCompletionBlock)completionBlock;

@end
