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
#import "MendeleyGroup.h"

@interface MendeleyGroupsAPI : MendeleyObjectAPI

/**
   @param queryParameters
   @param iconType
   @param completionBlock
 */
- (void)groupListWithQueryParameters:(MendeleyGroupParameters *)queryParameters
                            iconType:(MendeleyGroupIconType)iconType
                     completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

/**
   This method is only used when paging through a list of groups on the server.
   All required parameters are provided in the linkURL, which should not be modified

   @param linkURL the full HTTP link to the document listings page
   @param iconType
   @param completionBlock
 */
- (void)groupListWithLinkedURL:(NSURL *)linkURL
                      iconType:(MendeleyGroupIconType)iconType
               completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

/**
   @param groupID
   @param iconType
   @param completionBlock
 */
- (void)groupWithGroupID:(NSString *)groupID
                iconType:(MendeleyGroupIconType)iconType
         completionBlock:(MendeleyObjectCompletionBlock)completionBlock;

/**
   @param groupID
   @param queryParameters
   @param completionBlock
 */
- (void)groupMemberListWithGroupID:(NSString *)groupID
                        parameters:(MendeleyGroupParameters *)queryParameters
                   completionBlock:(MendeleyArrayCompletionBlock)completionBlock;


/**
   This obtains the binary image data for a given group and its icon type.
   @param group
   @param iconType
   @param completionBlock
 */
- (void)groupIconForGroup:(MendeleyGroup *)group
                 iconType:(MendeleyGroupIconType)iconType
          completionBlock:(MendeleyCompletionBlock)completionBlock;

@end
