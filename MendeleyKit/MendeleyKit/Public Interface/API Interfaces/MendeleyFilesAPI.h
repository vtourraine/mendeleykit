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

@class MendeleyFileParameters;

@interface MendeleyFilesAPI : MendeleyObjectAPI
/**
   @name MendeleyFilesAPI
   This class provides access methods to the REST file API
   All of the methods are accessed via MendeleyKit.
   Developers should use the methods provided in MendeleyKit rather
   than the methods listed here.
 */

/**
   obtains a list of files for the first page.
   @param parameters the parameter set to be used in the request
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
   @param documentID
   @param completionBlock
 */
- (void)deleteFileWithID:(NSString *)fileID
         completionBlock:(MendeleyCompletionBlock)completionBlock;

/**
   @param linkURL
   @param completionBlock
 */
- (void)fileListWithLinkedURL:(NSURL *)linkURL
              completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

/**
   This method returns a list of files IDs that were permanently deleted. The list of deleted IDs will be kept on
   the server for a limited period of time.
   @param deletedSince the parameter set to be used in the request
   @param completionBlock
 */
- (void)deletedFilesSince:(NSDate *)deletedSince
          completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

@end
