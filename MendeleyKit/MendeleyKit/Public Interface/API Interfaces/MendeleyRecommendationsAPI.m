//
//  MendeleyRecommendationsAPI.m
//  MendeleyKit
//
//  Created by Tunney, Aaron (ELS) on 15/08/2016.
//  Copyright © 2016 Mendeley. All rights reserved.
//

#import "MendeleyRecommendationsAPI.h"
#import "NSError+Exceptions.h"

@implementation MendeleyRecommendationsAPI

#pragma mark Private methods

- (NSDictionary *)defaultServiceRequestHeaders
{
    return @{ kMendeleyRESTRequestContentType: kMendeleyRESTRequestJSONRecommendationsType };
}

#pragma mark -

// GET /recommendations/based_on_library_articles
- (MendeleyTask *)recommendationsBasedOnLibraryArticlesWithParameters:(MendeleyRecommendationsParameters *)queryParameters
                                                                 task:(MendeleyTask *)task
                                                      completionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    [NSError assertArgumentNotNil:completionBlock argumentName:@"completionBlock"];
    
    [self.provider invokeGET:self.baseURL
                         api:kMendeleyRESTAPIRecommendationsBasedOnLibrary
           additionalHeaders:[self defaultServiceRequestHeaders]
             queryParameters:[queryParameters valueStringDictionary]
      authenticationRequired:YES
                        task:task
             completionBlock:^(MendeleyResponse * _Nullable response, NSError * _Nullable error) {
                 MendeleyBlockExecutor *blockExec = [[MendeleyBlockExecutor alloc] initWithArrayCompletionBlock:completionBlock];
                 if (![self.helper isSuccessForResponse:response error:&error])
                 {
                     [blockExec executeWithArray:nil
                                        syncInfo:nil
                                           error:error];
                 }
                 else
                 {
                     MendeleyModeller *jsonModeller = [MendeleyModeller sharedInstance];
                     [jsonModeller parseJSONData:response.responseBody expectedType:kMendeleyModelRecommendations completionBlock: ^(NSArray *recommendationsList, NSError *parseError) {
                         if (nil != parseError)
                         {
                             [blockExec executeWithArray:nil
                                                syncInfo:nil
                                                   error:parseError];
                         }
                         else
                         {
                             [blockExec executeWithArray:recommendationsList
                                                syncInfo:response.syncHeader
                                                   error:nil];
                         }
                     }];
                 }

             }];
    
    return nil;
}

// POST /recommendations/action/feedback
- (void)feedbackOnRecommendation:(NSString *)feedback
                            task:(MendeleyTask *)task
                           completionBlock:(MendeleyCompletionBlock)completionBlock
{
    
}

@end
