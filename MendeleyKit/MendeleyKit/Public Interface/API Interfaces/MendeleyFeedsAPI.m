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

- (instancetype)initWithNetworkProvider:(id<MendeleyNetworkProvider>)provider baseURL:(NSURL *)baseURL
{
    self = [super initWithNetworkProvider:provider baseURL:baseURL];
    if (self)
    {
        if (itemTypes == nil || itemClassStrings == nil)
        {
            itemTypes = @[@"rss-item",
                          @"new-status",
                          @"employment-update",
                          @"new-follower",
                          @"new-pub",
                          @"document-recommendation",
                          @"posted-catalogue-pub",
                          @"posted-pub",
                          @"group-doc-added"];
            
            itemClassStrings = @[@"MendeleyRSSItemFeed",
                                 @"MendeleyNewStatusFeed",
                                 @"MendeleyEmploymentUpdateNewsFeed",
                                 @"MendeleyNewFollowerFeed",
                                 @"MendeleyNewPubFeed",
                                 @"MendeleyDocumentRecommendationFeed",
                                 @"MendeleyPostedCataloguePubFeed",
                                 @"MendeleyPostedPubFeed",
                                 @"MendeleyDocuAddedFeed"];
        }
    }
    return self;
}

- (NSDictionary *)defaultServiceRequestHeaders
{
    return @{ kMendeleyRESTRequestAccept: kMendeleyRESTRequestJSONNewsItemType };
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
             queryParameters:nil       // we don't need to specify parameters because are inehrits from the previous call
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
                     NSArray *items = response.responseBody;
                     NSMutableArray<MendeleyNewsFeed *> *feeds = [NSMutableArray new];
                     MendeleyModeller *jsonModeller = [MendeleyModeller sharedInstance];
                     
                     [items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                         NSDictionary *item = obj;
                         NSString *itemType = item[@"content"][@"type"];
                         NSUInteger index = [itemTypes indexOfObject:itemType];
                         if (index == NSNotFound)
                         {
                             // create custom error
                             NSError *mappingError;
                             [blockExec executeWithArray:nil
                                                syncInfo:nil
                                                   error:mappingError];
                         }
                         else
                         {
                             NSString *objectTypeString = itemClassStrings[index];
                             [jsonModeller parseJSONData:response.responseBody expectedType:objectTypeString completionBlock: ^(MendeleyNewsFeed *feed, NSError *parseError) {
                                 if (nil != parseError)
                                 {
                                     [blockExec executeWithArray:nil
                                                        syncInfo:nil
                                                           error:parseError];
                                 }
                                 else
                                 {
                                     [feeds addObject:feed];
                                 }
                             }];
                         }
                     }];
                     if (feeds.count == items.count)
                     {
                         [blockExec executeWithArray:feeds
                                            syncInfo:response.syncHeader
                                               error:nil];
                     }
                 }
             }];

}

- (void)feedListWithQueryParameters:(MendeleyFeedsParameters *)queryParameters
                               task:(MendeleyTask *)task
                    completionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    NSDictionary *query = [queryParameters valueStringDictionary];
    
    [self.helper mendeleyFeedListWithParameters:query
                        additionalHeaders:[self defaultServiceRequestHeaders]
                                     task:task
                                  categoryTypes:itemTypes
                             categoryClassNames:itemClassStrings
                          completionBlock:completionBlock];
}

@end
