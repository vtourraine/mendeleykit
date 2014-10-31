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

@class MendeleySyncInfo, MendeleyDocumentParameters, MendeleyFileParameters, MendeleyFolderParameters, MendeleyAnnotationParameters, MendeleyDocument, MendeleyFile, MendeleyFolder, MendeleyDocumentId, MendeleyAnnotation, MendeleyMetadataParameters, MendeleyGroupParameters, MendeleyTask, MendeleyCatalogParameters, MendeleyGroup;

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

#pragma mark -
#pragma mark General

/**
   This is a generic paging method for objects. The server returns a fully formed URL
   independent of whether the paging is performed on documents, folders or any other API
   that supports paging

   @param linkURL the full HTTP link to the document listings page
   @param expectedModel the name of the expected model class to return in the array
   @param completionBlock returning array of objects, syncinfo and error
 */
- (void)pagedListOfObjectsWithLinkedURL:(NSURL *)linkURL
                          expectedModel:(NSString *)expectedModel
                        completionBlock:(MendeleyArrayCompletionBlock)completionBlock;


#pragma mark -
#pragma mark Profiles
/**
   @name Profile API methods
 */
/**
   The completionBlock returns an instance of MendeleyUserProfile
   @param completionBlock returning the profile object if found
 */
- (void)pullMyProfile:(MendeleyObjectCompletionBlock)completionBlock;

/**
   The completionBlock returns an instance of MendeleyProfile
   @param profileID the user profile ID
   @param completionBlock returning the profile object if found
 */
- (void)pullProfile:(NSString *)profileID
    completionBlock:(MendeleyObjectCompletionBlock)completionBlock;


#pragma mark -
#pragma mark Documents
/**
   @name documents, trash and catalog API methods
 */

/**
   This method is only used when paging through a list of documents on the server.
   All required parameters are provided in the linkURL, which should not be modified

   @param linkURL the full HTTP link to the document listings page
   @param completionBlock returning array of documents
 */
- (void)documentListWithLinkedURL:(NSURL *)linkURL
                  completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

/**
   obtains a list of documents for the first page.
   @param queryParameters the parameter set to be used in the request
   @param completionBlock returning array of documents
 */
- (void)documentListWithQueryParameters:(MendeleyDocumentParameters *)queryParameters
                        completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

/**
   obtains a document for given ID from the library
   @param documentID the UUID of the document
   @param completionBlock returning the document
 */
- (void)documentWithDocumentID:(NSString *)documentID
               completionBlock:(MendeleyObjectCompletionBlock)completionBlock;

/**
   This method returns a catalog document for a given catalog ID
   @param catalogID the catalog UUID
   @param completionBlock returning the catalog document
 */
- (void)catalogDocumentWithCatalogID:(NSString *)catalogID
                     completionBlock:(MendeleyObjectCompletionBlock)completionBlock;

/**
   This method obtains a list of documents based on a filter. The filter should not be nil or empty
   @param queryParameters query parameters for the URL request
   @param completionBlock returning the list of found catalog documents
 */
- (void)catalogDocumentWithParameters:(MendeleyCatalogParameters *)queryParameters
                      completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

/**
   this creates a document based on the mendeley object model provided in the argument.
   The server will respond with the JSON data structure for the new object
   @param mendeleyDocument the document to be created
   @param completionBlock returns the document created on the server with the UUID
 */
- (void)createDocument:(MendeleyDocument *)mendeleyDocument
       completionBlock:(MendeleyObjectCompletionBlock)completionBlock;

/**
   modify/update a document with ID. The server will return a JSON object with the updated data
   @param updatedDocument the document to be updated
   @param completionBlock returns the updated document from the server
 */
- (void)updateDocument:(MendeleyDocument *)updatedDocument
       completionBlock:(MendeleyObjectCompletionBlock)completionBlock;


/**
   this method will remove a document with given ID permanently. The document data cannot be retrieved.
   However, the user will be able to get a list of permanently removed IDs
   @param documentID the document UUID
   @param completionBlock returns bool/error
 */
- (void)deleteDocumentWithID:(NSString *)documentID
             completionBlock:(MendeleyCompletionBlock)completionBlock;

/**
   This method will move a document of given ID into the trash on the server. Data in trash can be restored
   (as opposed to using the deleteDocumentWithID:completionBlock: method which permanently removes them)
   @param documentID the document UUID
   @param completionBlock the success block upon completion
 */
- (void)trashDocumentWithID:(NSString *)documentID
            completionBlock:(MendeleyCompletionBlock)completionBlock;

/**
   This method returns a list of document IDs that were permanently deleted. The list of deleted IDs will be kept on
   the server for a limited period of time.
   @param deletedSince passed to the server to get list of documents that were deleted since that date
   @param completionBlock a list of document UUIDs if found
 */
- (void)deletedDocumentsSince:(NSDate *)deletedSince
              completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

/**
   This method obtains a list for a given page link of 'trashed' documents
   based on a list of query parameters.
   All required parameters are provided in the linkURL, which should not be modified

   @param linkURL the full HTTP link to the document listings page
   @param completionBlock returns a list of trashed documents if found
 */
- (void)trashedDocumentListWithLinkedURL:(NSURL *)linkURL
                         completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

/**
   This method obtains a list for the 'first' page of 'trashed' documents
   based on a list of query parameters.
   @param queryParameters the parameter set to be used in the request
   @param completionBlock the list of trashed documents
 */
- (void)trashedDocumentListWithQueryParameters:(MendeleyDocumentParameters *)queryParameters
                               completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

/**
   this method will remove a trashed document with given ID permanently.
   The document data cannot be retrieved.
   However, the user will be able to get a list of permanently removed IDs
   @param documentID the UUID of the trashed document
   @param completionBlock a success block for the operation
 */
- (void)deleteTrashedDocumentWithID:(NSString *)documentID
                    completionBlock:(MendeleyCompletionBlock)completionBlock;

/**
   this method will restore a trashed document.
   In essence this means the document must be retrieved using the /documents API
   @param documentID the UUID of the document to be restored from trash
   @param completionBlock the success block
 */
- (void)restoreTrashedDocumentWithID:(NSString *)documentID
                     completionBlock:(MendeleyCompletionBlock)completionBlock;


/**
   obtains a document for given ID from the library
   @param documentID the UUID of the trashed document
   @param completionBlock returns the found trashed document
 */
- (void)trashedDocumentWithDocumentID:(NSString *)documentID
                      completionBlock:(MendeleyObjectCompletionBlock)completionBlock;

/**
 uploads a file from a location and returns a Mendeley Document in the completion handler
 @param fileURL the location of the file
 @param mimeType e.g. application/pdf
 @param completionBlock
 */
- (MendeleyTask *)documentFromFileWithURL:(NSURL *)fileURL mimeType:(NSString *)mimeType completionBlock:(MendeleyObjectCompletionBlock)completionBlock;

#pragma mark -
#pragma mark Metadata
/**
   @name Metadata API
 */

/**
   obtains metadata lookup based on specified search parameters
   @param queryParameters the search parameters to be used in the request
   @param completionBlock the metadata lookup containing the catalog id and score - if found
 */
- (void)metadataLookupWithQueryParameters:(MendeleyMetadataParameters *)queryParameters
                          completionBlock:(MendeleyObjectCompletionBlock)completionBlock;

#pragma mark -
#pragma mark Document and Identifier Types
/**
   @name documentTypes and identifierTypes APIs methods
 */

/**
   obtains the list of document types (e.g. journal, book etc) currently available
   @param completionBlock returns the list of document types
 */
- (void)documentTypesWithCompletionBlock:(MendeleyArrayCompletionBlock)completionBlock;

/**
   obtains the list of identifier types (e.g. arxiv, doi, pmid) currently available
   @param completionBlock returns the list of identifier types
 */
- (void)identifierTypesWithCompletionBlock:(MendeleyArrayCompletionBlock)completionBlock;

#pragma mark -
#pragma mark Files
/**
   @name files API methods
 */

/**
   obtains a list of files for the first page.
   @param queryParameters the parameter set to be used in the request
   @param completionBlock returns the list of files if found
 */
- (void)fileListWithQueryParameters:(MendeleyFileParameters *)queryParameters
                    completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

/**
   obtains a file for given ID from the library
   @param fileID the file UUID
   @param fileURL the location of the file to be saved into
   @param progressBlock a callback block to capture progress
   @param completionBlock the final completion block indicating success/failure
 */
- (MendeleyTask *)fileWithFileID:(NSString *)fileID
                       saveToURL:(NSURL *)fileURL
                   progressBlock:(MendeleyResponseProgressBlock)progressBlock
                 completionBlock:(MendeleyCompletionBlock)completionBlock;

/**
   this creates a file based on the mendeley object model provided in the argument.
   The server will respond with the JSON data structure for the new object
   @param fileURL the location of the file to be created
   @param documentURLPath the relative URL path of the associated document
   @param progressBlock a callback block to capture progress
   @param completionBlock the success/failure block
 */
- (void)           createFile:(NSURL *)fileURL
    relativeToDocumentURLPath:(NSString *)documentURLPath
                progressBlock:(MendeleyResponseProgressBlock)progressBlock
              completionBlock:(MendeleyObjectCompletionBlock)completionBlock;

/**
   this method will remove a file with given ID permanently. The file data cannot be retrieved.
   However, the user will be able to get a list of permanently removed IDs
   @param fileID the file UUID
   @param completionBlock the success/failure block
 */
- (void)deleteFileWithID:(NSString *)fileID
         completionBlock:(MendeleyCompletionBlock)completionBlock;

/**
   This method returns a list of files IDs that were permanently deleted. The list of deleted IDs will be kept on
   the server for a limited period of time.
   @param deletedSince passed to the server to get list of files that were deleted since that date
   @param completionBlock a list of document UUIDs if found
 */
- (void)deletedFilesSince:(NSDate *)deletedSince
          completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

#pragma mark -
#pragma mark Folders

/**
   @name folders API methods
 */
/**
   Obtain a list of documents belonging to a specific folder
   @param folderID the folder UUID
   @param queryParameters the query parameters used in the API request
   @param completionBlock the list of folders returned if found
 */
- (void)documentListFromFolderWithID:(NSString *)folderID
                          parameters:(MendeleyFolderParameters *)queryParameters
                     completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

/**
   Add a previously created document in a specific folder
   @param mendeleyDocumentId the UUID of the folder document
   @param folderID the folder UUID
   @param completionBlock the success/failure block
 */
- (void)addDocument:(NSString *)mendeleyDocumentId
           folderID:(NSString *)folderID
    completionBlock:(MendeleyCompletionBlock)completionBlock;

/**
   Create a folder
   @param mendeleyFolder the folder to be created
   @param completionBlock returns the folder as created on the server with UUID
 */
- (void)createFolder:(MendeleyFolder *)mendeleyFolder
     completionBlock:(MendeleyObjectCompletionBlock)completionBlock;

/**
   This method is only used when paging through a list of folders on the server.
   All required parameters are provided in the linkURL, which should not be modified

   @param linkURL the full HTTP link to the document listings page
   @param completionBlock the list of folders if any
 */
- (void)folderListWithLinkedURL:(NSURL *)linkURL
                completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

/**
   Obtain a list of folders for the logged-in user
   @param queryParameters the query parameters to be used in the REST API request
   @param completionBlock the list of folders returned if any
 */
- (void)folderListWithQueryParameters:(MendeleyFolderParameters *)queryParameters
                      completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

/**
   Obtain a folder identified by the given folderID
   @param folderID the folder UUID
   @param completionBlock the returned folder for given ID if found
 */
- (void)folderWithFolderID:(NSString *)folderID
           completionBlock:(MendeleyObjectCompletionBlock)completionBlock;

/**
   Delete a folder identified by the given folderID
   @param folderID the folder UUID
   @param completionBlock the success/failure block for the operation
 */
- (void)deleteFolderWithID:(NSString *)folderID
           completionBlock:(MendeleyCompletionBlock)completionBlock;

/**
   Update a folder's name, or move it to a new parent
   @param updatedFolder the folder to be updated
   @param completionBlock the success/failure block
 */
- (void)updateFolder:(MendeleyFolder *)updatedFolder
     completionBlock:(MendeleyCompletionBlock)completionBlock;

/**
   Delete a document identified by the given documentID and belonging to a folder identified by the given folderID
   @param documentID the document UUID to be deleted in folder
   @param folderID the folder UUID
   @param completionBlock the success/failure block
 */
- (void)deleteDocumentWithID:(NSString *)documentID
            fromFolderWithID:(NSString *)folderID
             completionBlock:(MendeleyCompletionBlock)completionBlock;

#pragma mark -
#pragma mark Groups
/**
   @name groups API methods
 */
/**
   Obtain a list of groups where the logged in user is a member.
   This method also downloads the group icons for each group in the same call
   @param queryParameters the parameters to be used in the API request
   @param iconType (original, square or standard)
   @param completionBlock the list of groups if found
 */
- (void)groupListWithQueryParameters:(MendeleyGroupParameters *)queryParameters
                            iconType:(MendeleyGroupIconType)iconType
                     completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

/**
   This method is only used when paging through a list of groups on the server.
   All required parameters are provided in the linkURL, which should not be modified
   This method also downloads the group icons for each group in the same call

   @param linkURL the full HTTP link to the document listings page
   @param iconType (original, square or standard)
   @param completionBlock the list of groups if found
 */
- (void)groupListWithLinkedURL:(NSURL *)linkURL
                      iconType:(MendeleyGroupIconType)iconType
               completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

/**
   Obtain details for the group identified by the given groupID. It also downloads the group icon.
   @param groupID the group UUID
   @param iconType (original, square or standard)
   @param completionBlock returns the group
 */
- (void)groupWithGroupID:(NSString *)groupID
                iconType:(MendeleyGroupIconType)iconType
         completionBlock:(MendeleyObjectCompletionBlock)completionBlock;

/**
   Obtain a list of groups where the logged in user is a member
   Note: this method only obtains the group metadata (including any MendeleyPhoto properties)
   It does not download the group icons.
   @param queryParameters the parameters to be used in the API request
   @param completionBlock the list of groups if found
 */
- (void)groupListWithQueryParameters:(MendeleyGroupParameters *)queryParameters
                     completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

/**
   This method is only used when paging through a list of groups on the server.
   All required parameters are provided in the linkURL, which should not be modified
   Note: this method only obtains the group metadata (including any MendeleyPhoto properties)
   It does not download the group icons.

   @param linkURL the full HTTP link to the document listings page
   @param completionBlock the list of groups if found
 */
- (void)groupListWithLinkedURL:(NSURL *)linkURL
               completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

/**
   Obtain metadata for the group identified by the given groupID.
   Note: this method only obtains the metadata for a group with ID (including any MendeleyPhoto properties)
   It does not download its group icon.
   @param groupID the group UUID
   @param completionBlock the group
 */
- (void)groupWithGroupID:(NSString *)groupID
         completionBlock:(MendeleyObjectCompletionBlock)completionBlock;

/**
   A convenience method to obtain the group icon for a given MendeleyGroup object
   @param group
   @param iconType
   @param completionBlock returning the image data as NSData
 */
- (void)groupIconForGroup:(MendeleyGroup *)group
                 iconType:(MendeleyGroupIconType)iconType
          completionBlock:(MendeleyBinaryDataCompletionBlock)completionBlock;


/**
   Obtains a group icon based on the given link URL string
   The URL string for a given icon is supplied with the MendeleyGroup metadata (see MendeleyPhoto property)
   @param iconURLString
   @param completionBlock returning the image data as NSData
 */
- (void)groupIconForIconURLString:(NSString *)iconURLString
                  completionBlock:(MendeleyBinaryDataCompletionBlock)completionBlock;

#pragma mark -
#pragma mark Annotations

/**
   @name annotations API methods
 */
/**
   Obtain details for the annotation identified by the given annotationID
   @param annotationID the annotation UUID
   @param completionBlock the found annotation object
 */
- (void)annotationWithAnnotationID:(NSString *)annotationID
                   completionBlock:(MendeleyObjectCompletionBlock)completionBlock;

/**
   Delete the annotation identified by the given annotationID
   @param annotationID the annotation UUID
   @param completionBlock the success/failure block
 */
- (void)deleteAnnotationWithID:(NSString *)annotationID
               completionBlock:(MendeleyCompletionBlock)completionBlock;

/**
   Update the annotation identified by the given annotationID with the given updateMendeleyAnnotation
   @param updatedMendeleyAnnotation the updated annotation object
   @param completionBlock the updated annotation object from the server
 */
- (void)updateAnnotation:(MendeleyAnnotation *)updatedMendeleyAnnotation
         completionBlock:(MendeleyObjectCompletionBlock)completionBlock;
/**
   Create an annotation composed by the parameters of the given mendeletAnnotation
   @param mendeleyAnnotation the annotation to be created on the server
   @param completionBlock returns the created annotation with UUID
 */
- (void)createAnnotation:(MendeleyAnnotation *)mendeleyAnnotation
         completionBlock:(MendeleyObjectCompletionBlock)completionBlock;

/**
   a speficic page/download link for getting annotations.
   @param linkURL the link to be used for obtaining annotations in a paged manner
   @param completionBlock the list of annotations
 */
- (void)annotationListWithLinkedURL:(NSURL *)linkURL
                    completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

/**
   Obtain a list of annotations. This is for the first call to getting a list of annotations.
   The queryParameters should contain the limit of the page size
   @param queryParameters the parameters to be used in the request
   @param completionBlock the list of annotations
 */
- (void)annotationListWithQueryParameters:(MendeleyAnnotationParameters *)queryParameters
                          completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

/**
   This method returns a list of annotations IDs that were permanently deleted. The list of deleted IDs will be kept on
   the server for a limited period of time.
   @param deletedSince passed to the server to get list of annotations that were deleted since that date
   @param completionBlock a list of document UUIDs if found
 */
- (void)deletedAnnotationsSince:(NSDate *)deletedSince
                completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

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
