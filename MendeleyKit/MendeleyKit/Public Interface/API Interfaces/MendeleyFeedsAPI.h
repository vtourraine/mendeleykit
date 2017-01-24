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

@interface MendeleyFeedsAPI : MendeleyObjectAPI

/**
 This method is only used when paging through a list of documents on the server.
 All required parameters are provided in the linkURL, which should not be modified
 
 @param linkURL the full HTTP link to the document listings page
 @param task
 @param completionBlock
 */
- (void)feedListWithLinkedURL:(NSURL *)linkURL
                             task:(MendeleyTask *)task
                  completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

/**
 obtains a list of feeds for the first page.
 @param parameters the parameter set to be used in the request
 @param task
 @param completionBlock
 */
- (void)feedListWithQueryParameters:(MendeleyFeedsParameters *)queryParameters
                                   task:(MendeleyTask *)task
                        completionBlock:(MendeleyArrayCompletionBlock)completionBlock;


/**
 likes a feed item.
 @param feedID
 @param task
 @param completionBlock
 */
- (void)likeFeedWithID:(NSString *)feedID
                  task:(MendeleyTask *)task
       completionBlock:(MendeleyCompletionBlock)completionBlock;

/**
 likes a feed item.
 @param feedID
 @param task
 @param completionBlock
 */
- (void)unlikeFeedWithID:(NSString *)feedID
                    task:(MendeleyTask *)task
         completionBlock:(MendeleyCompletionBlock)completionBlock;

@end
