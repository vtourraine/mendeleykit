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

#import "MendeleyObjectAPI.h"

@class MendeleyDocumentId;
@class MendeleyFolderParameters;
@class MendeleyFolder;

@interface MendeleyFoldersAPI : MendeleyObjectAPI
/**
   @name MendeleyFoldersAPI
   This class provides access methods to the REST folders API
   All of the methods are accessed via MendeleyKit.
   Developers should use the methods provided in MendeleyKit rather
   than the methods listed here.
 */


/**
   Obtain a list of documents belonging to a specific folder.
   @param folderID
   @param parameters
   @param completionBlock - the array contained in the completionBlock will be an array of strings
 */
- (void)documentListFromFolderWithID:(NSString *)folderID
                          parameters:(MendeleyFolderParameters *)parameters
                     completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

/**
   this is getting the list of document IDs in a paged form
   @param linkURL
   @param completionBlock - the array contained in the completionBlock will be an array of strings
 */
- (void)documentListInFolderWithLinkedURL:(NSURL *)linkURL
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

@end
