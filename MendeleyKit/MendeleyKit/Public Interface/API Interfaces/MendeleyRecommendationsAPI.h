//
//  MendeleyRecommendationsAPI.h
//  MendeleyKit
//
//  Created by Tunney, Aaron (ELS) on 15/08/2016.
//  Copyright © 2016 Mendeley. All rights reserved.
//

#import "MendeleyObjectAPI.h"

@interface MendeleyRecommendationsAPI : MendeleyObjectAPI

// GET /recommendations/based_on_library_articles
- (MendeleyTask *)recommendationsBasedOnLibraryArticlesWithParameters:(MendeleyRecommendationsParameters *)queryParameters
                                                                 task:(MendeleyTask *)task
                                                      completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

// POST /recommendations/action/feedback
- (MendeleyTask *)feedbackOnRecommendation:(NSString *)trace
                                userAction:(NSString *)userAction
                                      task:(MendeleyTask *)task
                           completionBlock:(MendeleyCompletionBlock)completionBlock;

@end
