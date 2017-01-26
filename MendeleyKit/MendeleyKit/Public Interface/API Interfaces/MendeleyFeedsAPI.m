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

#import "MendeleyFeedsAPI.h"
#import "MendeleyModels.h"
#import "NSError+Exceptions.h"

static NSArray *itemTypes;
static NSArray *itemClassStrings;

@implementation MendeleyFeedsAPI

- (NSDictionary *)defaultServiceRequestHeaders
{
    return @{ kMendeleyRESTRequestAccept: kMendeleyRESTRequestJSONNewsItemListType };
}

- (void)feedListWithLinkedURL:(NSURL *)linkURL
                         task:(MendeleyTask *)task
              completionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    [NSError assertArgumentNotNil:linkURL argumentName:@"linkURL"];
    [NSError assertArgumentNotNil:completionBlock argumentName:@"completionBlock"];
    
    [self.provider invokeGET:linkURL
                         api:nil
           additionalHeaders:[self defaultServiceRequestHeaders]
             queryParameters:nil
      authenticationRequired:YES
                        task:task
             completionBlock: ^(MendeleyResponse *response, NSError *error) {
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
                     [jsonModeller parseJSONData:response.responseBody expectedType:kMendeleyModelNewsFeed completionBlock: ^(NSArray *feeds, NSError *parseError) {
                         MendeleySyncInfo *syncInfo = (nil != parseError) ? nil : response.syncHeader;
                         [blockExec executeWithArray:feeds
                                            syncInfo:syncInfo
                                               error:parseError];
                     }];
                 }
             }];
}

- (void)feedListWithQueryParameters:(MendeleyFeedsParameters *)queryParameters
                               task:(MendeleyTask *)task
                    completionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    NSDictionary *query = [queryParameters valueStringDictionary];
    //    NSDictionary *mergedQuery = [NSDictionary dictionaryByMerging:query with:[self defaultQueryParameters]];
    
    [self.provider invokeGET:self.baseURL
                         api:kMendeleyRESTAPIFeeds
           additionalHeaders:[self defaultServiceRequestHeaders]
     //             queryParameters:mergedQuery
             queryParameters:query
      authenticationRequired:YES
                        task:task
             completionBlock:^(MendeleyResponse *response, NSError *error) {
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
                     [jsonModeller parseJSONData:response.responseBody expectedType:kMendeleyModelNewsFeed completionBlock: ^(NSArray *feeds, NSError *parseError) {
                         MendeleySyncInfo *syncInfo = (nil != parseError) ? nil : response.syncHeader;
                         [blockExec executeWithArray:feeds
                                            syncInfo:syncInfo
                                               error:parseError];
                     }];
                 }
             }];
}

- (void)likeFeedWithID:(NSString *)feedID
                  task:(MendeleyTask *)task
       completionBlock:(MendeleyCompletionBlock)completionBlock
{
    NSString *apiString = [NSString stringWithFormat:kMendeleyRESTAPILikeFeed, feedID];
    [self.provider invokePOST:self.baseURL
                          api:apiString
            additionalHeaders:nil
               bodyParameters:nil
                       isJSON:NO
       authenticationRequired:YES
                         task:task
              completionBlock:^(MendeleyResponse * _Nullable response, NSError * _Nullable error) {
                  MendeleyBlockExecutor *blockExec = [[MendeleyBlockExecutor alloc] initWithCompletionBlock:completionBlock];
                  BOOL success = [self.helper isSuccessForResponse:response error:&error];
                  [blockExec executeWithBool:success error:error];
              }];
}

- (void)unlikeFeedWithID:(NSString *)feedID
                    task:(MendeleyTask *)task
         completionBlock:(MendeleyCompletionBlock)completionBlock
{
    NSString *apiString = [NSString stringWithFormat:kMendeleyRESTAPIUnlikeFeed, feedID];
    [self.provider invokeDELETE:self.baseURL
                            api:apiString
              additionalHeaders:nil
                 bodyParameters:nil
         authenticationRequired:YES
                           task:task
                completionBlock:^(MendeleyResponse * _Nullable response, NSError * _Nullable error) {
                    MendeleyBlockExecutor *blockExec = [[MendeleyBlockExecutor alloc] initWithCompletionBlock:completionBlock];
                    BOOL success = [self.helper isSuccessForResponse:response error:&error];
                    [blockExec executeWithBool:success error:error];
                }];
}

@end
