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
 @param queryParameters
 @param task
 @param completionBlock
 */

- (void)shareDocumentWithQueryParameters:(MendeleyShareDocumentParameters *)queryParameters
                                    task:(MendeleyTask *)task
                         completionBlock:(MendeleyCompletionBlock)completionBlock;

@end
