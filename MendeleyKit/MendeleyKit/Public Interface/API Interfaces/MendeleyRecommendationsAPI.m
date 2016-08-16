//
//  MendeleyRecommendationsAPI.m
//  MendeleyKit
//
//  Created by Tunney, Aaron (ELS) on 15/08/2016.
//  Copyright © 2016 Mendeley. All rights reserved.
//

#import "MendeleyRecommendationsAPI.h"
#import "MendeleyRecommendedArticle.h"
#import "NSError+Exceptions.h"

@implementation MendeleyRecommendationsAPI

#pragma mark Private methods

- (NSDictionary *)defaultServiceRequestHeaders
{
    return @{ kMendeleyRESTRequestContentType: kMendeleyRESTRequestJSONRecommendationsType };
}

- (NSDictionary *)feedbackServiceRequestHeaders
{
    return @{ kMendeleyRESTRequestContentType: kMendeleyRESTRequestJSONRecommendationFeedbackType };
}

- (NSDictionary *)feedbackBodyParametersWithTrace:(NSString *)trace
                                         position:(NSNumber *)position
                                       userAction:(NSString *)userAction
                                         carousel:(NSNumber *)carousel
{
    return @{ kMendeleyJSONTrace: trace,
              kMendeleyJSONPosition: position,
              kMendeleyJSONUserAction: userAction,
              kMendeleyJSONCarousel: carousel };
}

#pragma mark -

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
                     if (response.responseBody[kMendeleyJSONData] != nil)
                     {
                         [jsonModeller parseJSONData:response.responseBody[kMendeleyJSONData] expectedType:kMendeleyModelRecommendations completionBlock: ^(NSArray<MendeleyRecommendedArticle *> *recommendationsList, NSError *parseError) {
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
                 }

             }];
    
    return nil;
}

- (MendeleyTask *)feedbackOnRecommendation:(NSString *)trace
                                  position:(NSNumber *)position
                                userAction:(NSString *)userAction
                                  carousel:(NSNumber *)carousel
                                      task:(MendeleyTask *)task
                           completionBlock:(MendeleyCompletionBlock)completionBlock
{
    [NSError assertArgumentNotNil:trace argumentName:@"trace"];
    [NSError assertArgumentNotNil:position argumentName:@"position"];
    [NSError assertArgumentNotNil:userAction argumentName:@"userAction"];
    [NSError assertArgumentNotNil:carousel argumentName:@"carousel"];
    [NSError assertArgumentNotNil:completionBlock argumentName:@"completionBlock"];
    
    [self.provider invokePOST:self.baseURL
                          api:kMendeleyRESTAPIRecommendationFeedback
            additionalHeaders:[self feedbackServiceRequestHeaders]
               bodyParameters:[self feedbackBodyParametersWithTrace:trace position:position userAction:userAction carousel:carousel]
                       isJSON:YES
       authenticationRequired:YES
                         task:task
              completionBlock:^(MendeleyResponse * _Nullable response, NSError * _Nullable error) {
                  MendeleyBlockExecutor *blockExec = [[MendeleyBlockExecutor alloc] initWithCompletionBlock:completionBlock];
                  if (![self.helper isSuccessForResponse:response error:&error])
                  {
                      [blockExec executeWithBool:NO
                                           error:error];
                  }
                  else
                  {
                      [blockExec executeWithBool:YES
                                           error:nil];
                  }
              }];
    
    return nil;
}

@end
