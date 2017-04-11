//
//  MendeleyUserPostsAPI.h
//  MendeleyKit
//
//  Created by Tunney, Aaron (ELS) on 22/02/2017.
//  Copyright © 2017 Mendeley. All rights reserved.
//

#import "MendeleyObjectAPI.h"

@interface MendeleyUserPostsAPI : MendeleyObjectAPI

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
