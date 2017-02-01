//
//  MendeleySharesAPI.h
//  MendeleyKit
//
//  Created by Trevisi, Luigi (ELS) on 25/01/2017.
//  Copyright © 2017 Mendeley. All rights reserved.
//

#import "MendeleyObjectAPI.h"

@interface MendeleySharesAPI : MendeleyObjectAPI

/**
 shares a feed item.
 @param queryParameters
 @param task
 @param completionBlock
 */

- (void)shareFeedWithQueryParameters:(MendeleySharesParameters *)queryParameters
                                task:(MendeleyTask *)task
                     completionBlock:(MendeleyCompletionBlock)completionBlock;

/**
 Shares a document.
 @param documentID
 @param task
 @param completionBlock
 */

- (void)shareDocumentWithDocumentID:(NSString *)documentID
                               task:(MendeleyTask *)task
                    completionBlock:(MendeleyCompletionBlock)completionBlock;
/**
 Shares a document.
 @param doi
 @param task
 @param completionBlock
 */

- (void)shareDocumentWithDOI:(NSString *)doi
                        task:(MendeleyTask *)task
             completionBlock:(MendeleyCompletionBlock)completionBlock;

/**
 Shares a document.
 @param scopus
 @param task
 @param completionBlock
 */

- (void)shareDocumentWithScopus:(NSString *)scopus
                           task:(MendeleyTask *)task
                completionBlock:(MendeleyCompletionBlock)completionBlock;

@end
