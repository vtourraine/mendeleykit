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

@interface MendeleyUserPostsAPI : MendeleyObjectAPI

/**
 Creates a new user post.
 @param newPost
 @param task
 @param completionBlock
 */

- (void)createUserPost:(MendeleyNewUserPost *)newPost
                  task:(MendeleyTask *)task
       completionBlock:(MendeleyObjectCompletionBlock)completionBlock;

/**
 Deletes a user post.
 @param postID
 @param task
 @param completionBlock
 */

- (void)deleteUserPostWithPostID:(NSString *)postID
                            task:(MendeleyTask *)task
                 completionBlock:(MendeleyCompletionBlock)completionBlock;

@end
