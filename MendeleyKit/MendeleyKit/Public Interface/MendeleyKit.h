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

@class MendeleySyncInfo, MendeleyDocumentParameters, MendeleyFileParameters, MendeleyFolderParameters, MendeleyAnnotationParameters, MendeleyDocument, MendeleyFile, MendeleyFolder, MendeleyDocumentId, MendeleyAnnotation, MendeleyMetadataParameters, MendeleyGroupParameters, MendeleyTask, MendeleyCatalogParameters;

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
   @param networkProviderClassName
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
   @param completionBlock
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
   @param completionBlock
 */
- (void)pullMyProfile:(MendeleyObjectCompletionBlock)completionBlock;

/**
   The completionBlock returns an instance of MendeleyProfile
   @param profileID
   @param completionBlock
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
   @param completionBlock
 */
- (void)documentListWithLinkedURL:(NSURL *)linkURL
                  completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

/**
   obtains a list of documents for the first page.
   @param queryParameters the parameter set to be used in the request
   @param completionBlock
 */
- (void)documentListWithQueryParameters:(MendeleyDocumentParameters *)queryParameters
                        completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

/**
   obtains a document for given ID from the library
   @param documentID
   @param completionBlock
 */
- (void)documentWithDocumentID:(NSString *)documentID
               completionBlock:(MendeleyObjectCompletionBlock)completionBlock;

/**
   This method returns a catalog document for a given catalog ID
   @param catalogID
   @param completionBlock
 */
- (void)catalogDocumentWithCatalogID:(NSString *)catalogID
                     completionBlock:(MendeleyObjectCompletionBlock)completionBlock;

/**
   This method obtains a list of documents based on a filter. The filter should not be nil or empty
   @param queryParameters
   @param completionBlock
 */
- (void)catalogDocumentWithParameters:(MendeleyCatalogParameters *)queryParameters
                      completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

/**
   this creates a document based on the mendeley object model provided in the argument.
   The server will respond with the JSON data structure for the new object
   @param mendeleyDocument
   @param completionBlock
 */
- (void)createDocument:(MendeleyDocument *)mendeleyDocument
       completionBlock:(MendeleyObjectCompletionBlock)completionBlock;

/**
   modify/update a document with ID. The server will return a JSON object with the updated data
   @param updatedDocument
   @param completionBlock
 */
- (void)updateDocument:(MendeleyDocument *)updatedDocument
       completionBlock:(MendeleyObjectCompletionBlock)completionBlock;


/**
   this method will remove a document with given ID permanently. The document data cannot be retrieved.
   However, the user will be able to get a list of permanently removed IDs
   @param documentID
   @param completionBlock
 */
- (void)deleteDocumentWithID:(NSString *)documentID
             completionBlock:(MendeleyCompletionBlock)completionBlock;

/**
   This method will move a document of given ID into the trash on the server. Data in trash can be restored
   (as opposed to using the deleteDocumentWithID:completionBlock: method which permanently removes them)
   @param documentID
   @param completionBlock
 */
- (void)trashDocumentWithID:(NSString *)documentID
            completionBlock:(MendeleyCompletionBlock)completionBlock;

/**
   This method returns a list of document IDs that were permanently deleted. The list of deleted IDs will be kept on
   the server for a limited period of time.
   @param deletedSince
   @param completionBlock
 */
- (void)deletedDocumentsSince:(NSDate *)deletedSince
              completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

/**
   This method obtains a list for a given page link of 'trashed' documents
   based on a list of query parameters.
   All required parameters are provided in the linkURL, which should not be modified

   @param linkURL the full HTTP link to the document listings page
   @param completionBlock
 */
- (void)trashedDocumentListWithLinkedURL:(NSURL *)linkURL
                         completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

/**
   This method obtains a list for the 'first' page of 'trashed' documents
   based on a list of query parameters.
   @param queryParameters the parameter set to be used in the request
   @param completionBlock
 */
- (void)trashedDocumentListWithQueryParameters:(MendeleyDocumentParameters *)queryParameters
                               completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

/**
   this method will remove a trashed document with given ID permanently.
   The document data cannot be retrieved.
   However, the user will be able to get a list of permanently removed IDs
   @param documentID
   @param completionBlock
 */
- (void)deleteTrashedDocumentWithID:(NSString *)documentID
                    completionBlock:(MendeleyCompletionBlock)completionBlock;

/**
   this method will restore a trashed document.
   In essence this means the document must be retrieved using the /documents API
   @param documentID
   @param completionBlock
 */
- (void)restoreTrashedDocumentWithID:(NSString *)documentID
                     completionBlock:(MendeleyCompletionBlock)completionBlock;


/**
   obtains a document for given ID from the library
   @param documentID
   @param completionBlock
 */
- (void)trashedDocumentWithDocumentID:(NSString *)documentID
                      completionBlock:(MendeleyObjectCompletionBlock)completionBlock;

#pragma mark -
#pragma mark Metadata
/**
   @name Metadata API
 */

/**
   obtains metadata
   @param queryParameters
   @param completionBlock
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
   @param completionBlock
 */
- (void)documentTypesWithCompletionBlock:(MendeleyArrayCompletionBlock)completionBlock;

/**
   obtains the list of identifier types (e.g. arxiv, doi, pmid) currently available
   @param completionBlock
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
   @param completionBlock
 */
- (void)fileListWithQueryParameters:(MendeleyFileParameters *)queryParameters
                    completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

/**
   obtains a file for given ID from the library
   @param fileID
   @param fileURL
   @param progressBlock
   @param completionBlock
 */
- (MendeleyTask *)fileWithFileID:(NSString *)fileID
                       saveToURL:(NSURL *)fileURL
                   progressBlock:(MendeleyResponseProgressBlock)progressBlock
                 completionBlock:(MendeleyCompletionBlock)completionBlock;

/**
   this creates a file based on the mendeley object model provided in the argument.
   The server will respond with the JSON data structure for the new object
   @param fileURL
   @param documentURLPath
   @param progressBlock
   @param completionBlock
 */
- (void)           createFile:(NSURL *)fileURL
    relativeToDocumentURLPath:(NSString *)documentURLPath
                progressBlock:(MendeleyResponseProgressBlock)progressBlock
              completionBlock:(MendeleyObjectCompletionBlock)completionBlock;

/**
   this method will remove a file with given ID permanently. The file data cannot be retrieved.
   However, the user will be able to get a list of permanently removed IDs
   @param fileID
   @param completionBlock
 */
- (void)deleteFileWithID:(NSString *)fileID
         completionBlock:(MendeleyCompletionBlock)completionBlock;

#pragma mark -
#pragma mark Folders

/**
   @name folders API methods
 */
/**
   Obtain a list of documents belonging to a specific folder
   @param folderID
   @param queryParameters
   @param completionBlock
 */
- (void)documentListFromFolderWithID:(NSString *)folderID
                          parameters:(MendeleyFolderParameters *)queryParameters
                     completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

/**
   Add a previously created document in a specific folder
   @param mendeleyDocumentId
   @param folderID
   @param completionBlock
 */
- (void)addDocument:(NSString *)mendeleyDocumentId
           folderID:(NSString *)folderID
    completionBlock:(MendeleyCompletionBlock)completionBlock;

/**
   Create a folder
   @param mendeleyFolder
   @param completionBlock
 */
- (void)createFolder:(MendeleyFolder *)mendeleyFolder
     completionBlock:(MendeleyObjectCompletionBlock)completionBlock;

/**
   This method is only used when paging through a list of folders on the server.
   All required parameters are provided in the linkURL, which should not be modified

   @param linkURL the full HTTP link to the document listings page
   @param completionBlock
 */
- (void)folderListWithLinkedURL:(NSURL *)linkURL
                completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

/**
   Obtain a list of folders for the logged-in user
   @param queryParameters
   @param completionBlock
 */
- (void)folderListWithQueryParameters:(MendeleyFolderParameters *)queryParameters
                      completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

/**
   Obtain a folder identified by the given folderID
   @param folderID
   @param completionBlock
 */
- (void)folderWithFolderID:(NSString *)folderID
           completionBlock:(MendeleyObjectCompletionBlock)completionBlock;

/**
   Delete a folder identified by the given folderID
   @param folderID
   @param completionBlock
 */
- (void)deleteFolderWithID:(NSString *)folderID
           completionBlock:(MendeleyCompletionBlock)completionBlock;

/**
   Update a folder's name, or move it to a new parent
   @param updatedFolder
   @param completionBlock
 */
- (void)updateFolder:(MendeleyFolder *)updatedFolder
     completionBlock:(MendeleyCompletionBlock)completionBlock;

/**
   Delete a document identified by the given documentID and belonging to a folder identified by the given folderID
   @param documentID
   @param folderID
   @param completionBlock
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
   Obtain a list of groups where the logged in user is a member
   @param queryParameters
   @param iconType (original, square or standard)
   @param completionBlock
 */
- (void)groupListWithQueryParameters:(MendeleyGroupParameters *)queryParameters
                            iconType:(MendeleyGroupIconType)iconType
                     completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

/**
   This method is only used when paging through a list of groups on the server.
   All required parameters are provided in the linkURL, which should not be modified

   @param linkURL the full HTTP link to the document listings page
   @param iconType (original, square or standard)
   @param completionBlock
 */
- (void)groupListWithLinkedURL:(NSURL *)linkURL
                      iconType:(MendeleyGroupIconType)iconType
               completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

/**
   Obtain details for the group identified by the given groupID
   @param groupID
   @param iconType (original, square or standard)
   @param completionBlock
 */
- (void)groupWithGroupID:(NSString *)groupID
                iconType:(MendeleyGroupIconType)iconType
         completionBlock:(MendeleyObjectCompletionBlock)completionBlock;

/**
   Obtain a list of groups where the logged in user is a member
   If provided, it will include the square icon for the group
   @param queryParameters
   @param completionBlock
 */
- (void)groupListWithQueryParameters:(MendeleyGroupParameters *)queryParameters
                     completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

/**
   This method is only used when paging through a list of groups on the server.
   All required parameters are provided in the linkURL, which should not be modified

   @param linkURL the full HTTP link to the document listings page
   @param completionBlock
 */
- (void)groupListWithLinkedURL:(NSURL *)linkURL
               completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

/**
   Obtain details for the group identified by the given groupID
   @param groupID
   @param completionBlock
 */
- (void)groupWithGroupID:(NSString *)groupID
         completionBlock:(MendeleyObjectCompletionBlock)completionBlock;

#pragma mark -
#pragma mark Annotations

/**
   @name annotations API methods
 */
/**
   Obtain details for the annotation identified by the given annotationID
   @param annotationID
   @param completionBlock
 */
- (void)annotationWithAnnotationID:(NSString *)annotationID
                   completionBlock:(MendeleyObjectCompletionBlock)completionBlock;

/**
   Delete the annotation identified by the given annotationID
   @param annotationID
   @param completionBlock
 */
- (void)deleteAnnotationWithID:(NSString *)annotationID
               completionBlock:(MendeleyCompletionBlock)completionBlock;

/**
   Update the annotation identified by the given annotationID with the given updateMendeleyAnnotation
   @param updateMendeleyAnnotation
   @param completionBlock
 */
- (void)updateAnnotation:(MendeleyAnnotation *)updatedMendeleyAnnotation
         completionBlock:(MendeleyObjectCompletionBlock)completionBlock;
/**
   Create an annotation composed by the parameters of the given mendeletAnnotation
   @param mendeleyAnnotation
   @param completionBlock
 */
- (void)createAnnotation:(MendeleyAnnotation *)mendeleyAnnotation
         completionBlock:(MendeleyObjectCompletionBlock)completionBlock;

/**
   a speficic page/download link for getting annotations.
   @param linkURL
   @param completionBlock
 */
- (void)annotationListWithLinkedURL:(NSURL *)linkURL
                    completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

/**
   Obtain a list of annotations. This is for the first call to getting a list of annotations.
   The queryParameters should contain the limit of the page size
   @param queryParameters
   @param completionBlock
 */
- (void)annotationListWithQueryParameters:(MendeleyAnnotationParameters *)queryParameters
                          completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

#pragma mark --
#pragma mark Cancellation
/**
   @name cancellation methods
 */
/**
   cancels a specific MendeleyTask
   @param task
   @param completionBlock
 */
- (void) cancelTask:(MendeleyTask *)task
    completionBlock:(MendeleyCompletionBlock)completionBlock;

/**
   cancels ALL existing tasks
   @param completionBlock
 */
- (void)cancelAllTasks:(MendeleyCompletionBlock)completionBlock;

@end
