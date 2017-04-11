//
//  MendeleyCommentsAPI.h
//  MendeleyKit
//
//  Created by Tunney, Aaron (ELS) on 29/03/2017.
//  Copyright © 2017 Mendeley. All rights reserved.
//

#import "MendeleyObjectAPI.h"

@interface MendeleyCommentsAPI : MendeleyObjectAPI

/**
 Get expanded (i.e. with profile information) comments.
 @param newsItemID
 @param task
 @param completionBlock
 */

- (void)expandedCommentsWithNewsItemID:(NSString *)newsItemID
                                  task:(MendeleyTask *)task
                       completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

/**
 Get single comment.
 @param commentID
 @param task
 @param completionBlock
 */

- (void)commentWithCommentID:(NSString *)commentID
                        task:(MendeleyTask *)task
             completionBlock:(MendeleyObjectCompletionBlock)completionBlock;

/**
 Create new comment.
 @param comment
 @param task
 @param completionBlock
 */

- (void)createComment:(MendeleyComment *)comment
                 task:(MendeleyTask *)task
      completionBlock:(MendeleyObjectCompletionBlock)completionBlock;

/**
 Edit existing comment.
 @param commentID
 @param update
 @param task
 @param completionBlock
 */

- (void)updateCommentWithCommentID:(NSString *)commentID
                            update:(MendeleyCommentUpdate *)update
                              task:(MendeleyTask *)task
                   completionBlock:(MendeleyObjectCompletionBlock)completionBlock;

/**
 Delete comment.
 @param commentID
 @param task
 @param completionBlock
 */

- (void)deleteCommentWithCommentID:(NSString *)commentID
                              task:(MendeleyTask *)task
                   completionBlock:(MendeleyCompletionBlock)completionBlock;

@end
