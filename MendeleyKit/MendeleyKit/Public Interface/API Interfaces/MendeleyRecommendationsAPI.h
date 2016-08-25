//
//  MendeleyRecommendationsAPI.h
//  MendeleyKit
//
//  Created by Tunney, Aaron (ELS) on 15/08/2016.
//  Copyright © 2016 Mendeley. All rights reserved.
//

#import "MendeleyObjectAPI.h"

@interface MendeleyRecommendationsAPI : MendeleyObjectAPI

- (MendeleyTask *)recommendationsBasedOnLibraryArticlesWithParameters:(MendeleyRecommendationsParameters *)queryParameters
                                                                 task:(MendeleyTask *)task
                                                      completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

- (MendeleyTask *)feedbackOnRecommendation:(NSString *)trace
                                  position:(NSNumber *)position
                                userAction:(NSString *)userAction
                                  carousel:(NSNumber *)carousel
                                      task:(MendeleyTask *)task
                           completionBlock:(MendeleyCompletionBlock)completionBlock;

@end
