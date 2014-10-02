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

#import "MendeleyGroupsAPI.h"

@implementation MendeleyGroupsAPI

- (NSDictionary *)defaultServiceRequestHeaders
{
    return @{ kMendeleyRESTRequestAccept: kMendeleyRESTRequestJSONGroupType };
}

- (NSDictionary *)membersRequestHeaders
{
    return @{ kMendeleyRESTRequestAccept: kMendeleyRESTRequestJSONUserRoleType };
}

- (NSDictionary *)defaultQueryParameters
{
    return [[MendeleyGroupParameters new] valueStringDictionary];
}

- (void)groupListWithQueryParameters:(MendeleyGroupParameters *)queryParameters
                            iconType:(MendeleyGroupIconType)iconType
                     completionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    NSDictionary *query = [queryParameters valueStringDictionary];
    NSDictionary *mergedQuery = [NSDictionary dictionaryByMerging:query with:[self defaultQueryParameters]];

    [self.provider invokeGET:self.baseURL api:kMendeleyRESTAPIGroups additionalHeaders:[self defaultServiceRequestHeaders] queryParameters:mergedQuery authenticationRequired:YES completionBlock:^(MendeleyResponse *response, NSError *error) {
         MendeleyBlockExecutor *blockExec = [[MendeleyBlockExecutor alloc] initWithArrayCompletionBlock:completionBlock];
         if (![self.helper isSuccessForResponse:response error:&error])
         {
             [blockExec executeWithArray:nil syncInfo:nil error:error];
         }
         else
         {
             MendeleyModeller *jsonModeller = [MendeleyModeller sharedInstance];
             [jsonModeller parseJSONData:response.responseBody expectedType:kMendeleyModelGroup completionBlock: ^(NSArray *groups, NSError *parseError) {
                  MendeleySyncInfo *syncInfo = (nil != parseError) ? nil : response.syncHeader;
                  if (nil != groups)
                  {
                      NSUInteger firstIndex = 0;
                      [self groupIconsForGroupArray:groups groupIndex:firstIndex iconType:iconType previousError:nil completionBlock:^(BOOL success, NSError *error) {
                           [blockExec executeWithArray:groups syncInfo:syncInfo error:parseError];
                       }];
                  }
                  else
                  {
                      [blockExec executeWithArray:nil syncInfo:nil error:parseError];
                  }
              }];
         }
     }];
}




- (void)groupListWithLinkedURL:(NSURL *)linkURL
                      iconType:(MendeleyGroupIconType)iconType
               completionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    [NSError assertArgumentNotNil:linkURL argumentName:@"linkURL"];
    [NSError assertArgumentNotNil:completionBlock argumentName:@"completionBlock"];

    [self.provider invokeGET:linkURL api:nil additionalHeaders:[self defaultServiceRequestHeaders] queryParameters:nil authenticationRequired:YES completionBlock: ^(MendeleyResponse *response, NSError *error) {
         MendeleyBlockExecutor *blockExec = [[MendeleyBlockExecutor alloc] initWithArrayCompletionBlock:completionBlock];
         if (![self.helper isSuccessForResponse:response error:&error])
         {
             [blockExec executeWithArray:nil syncInfo:nil error:error];
         }
         else
         {
             MendeleyModeller *jsonModeller = [MendeleyModeller sharedInstance];
             [jsonModeller parseJSONData:response.responseBody expectedType:kMendeleyModelGroup completionBlock: ^(NSArray *groups, NSError *parseError) {
                  MendeleySyncInfo *syncInfo = (nil != parseError) ? nil : response.syncHeader;
                  if (nil != groups)
                  {
                      NSUInteger firstIndex = 0;
                      [self groupIconsForGroupArray:groups groupIndex:firstIndex iconType:iconType previousError:nil completionBlock:^(BOOL success, NSError *error) {
                           [blockExec executeWithArray:groups syncInfo:syncInfo error:parseError];
                       }];
                  }
                  else
                  {
                      [blockExec executeWithArray:nil syncInfo:nil error:parseError];
                  }
              }];
         }
     }];
}

- (void)groupWithGroupID:(NSString *)groupID
                iconType:(MendeleyGroupIconType)iconType
         completionBlock:(MendeleyObjectCompletionBlock)completionBlock
{
    [NSError assertStringArgumentNotNilOrEmpty:groupID argumentName:@"groupID "];
    NSString *apiEndPoint = [NSString stringWithFormat:kMendeleyRESTAPIGroupWithID, groupID];

    [self.provider invokeGET:self.baseURL api:apiEndPoint additionalHeaders:[self defaultServiceRequestHeaders] queryParameters:nil authenticationRequired:YES completionBlock:^(MendeleyResponse *response, NSError *error) {
         MendeleyBlockExecutor *blockExec = [[MendeleyBlockExecutor alloc] initWithObjectCompletionBlock:completionBlock];
         MendeleyModeller *jsonModeller = [MendeleyModeller sharedInstance];
         [jsonModeller parseJSONData:response.responseBody expectedType:kMendeleyModelGroup completionBlock: ^(id mendeleyObject, NSError *parseError) {
              MendeleySyncInfo *syncInfo = (nil != parseError) ? nil : response.syncHeader;

              if (nil != mendeleyObject)
              {
                  MendeleyGroup *group = (MendeleyGroup *) mendeleyObject;
                  [self groupIconForGroup:group iconType:iconType completionBlock:^(BOOL success, NSError *error) {
                       [blockExec executeWithMendeleyObject:mendeleyObject syncInfo:syncInfo error:parseError];
                   }];
              }
              else
              {
                  [blockExec executeWithMendeleyObject:nil syncInfo:nil error:parseError];
              }
          }];

     }];

    [self.helper mendeleyObjectOfType:kMendeleyModelGroup
                           parameters:nil
                                  api:apiEndPoint
                    additionalHeaders:[self defaultServiceRequestHeaders]
                      completionBlock:completionBlock];
}

- (void)groupMemberListWithGroupID:(NSString *)groupID
                        parameters:(MendeleyGroupParameters *)queryParameters
                   completionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    NSDictionary *query = [queryParameters valueStringDictionary];

    [NSError assertStringArgumentNotNilOrEmpty:groupID argumentName:@"groupID"];
    NSString *apiEndPoint = [NSString stringWithFormat:kMendeleyRESTAPIMembersInGroupWithID, groupID];
    [self.helper mendeleyObjectListOfType:kMendeleyModelUserRole api:apiEndPoint parameters:[NSDictionary dictionaryByMerging:query with:[self defaultQueryParameters]] additionalHeaders:[self membersRequestHeaders] completionBlock:completionBlock];
}

- (void)groupIconsForGroupArray:(NSArray *)groups
                     groupIndex:(NSUInteger)groupIndex
                       iconType:(MendeleyGroupIconType)iconType
                  previousError:(NSError *)previousError
                completionBlock:(MendeleyCompletionBlock)completionBlock
{
    [NSError assertArgumentNotNil:groups argumentName:@"groups"];
    if (groups.count <= groupIndex)
    {
        if (completionBlock)
        {
            completionBlock(nil == previousError, previousError);
        }
        return;
    }
    MendeleyGroup *group = [groups objectAtIndex:groupIndex];
    [self groupIconForGroup:group iconType:iconType completionBlock:^(BOOL success, NSError *error) {
         NSError *nextError = nil;
         NSUInteger nextIndex = groupIndex + 1;
         if (nil == previousError)
         {
             nextError = error;
         }
         else
         {
             nextError = previousError;
         }
         [self groupIconsForGroupArray:groups
                            groupIndex:nextIndex
                              iconType:iconType
                         previousError:nextError
                       completionBlock:completionBlock];
     }];

}

- (void)groupIconForGroup:(MendeleyGroup *)group
                 iconType:(MendeleyGroupIconType)iconType
          completionBlock:(MendeleyCompletionBlock)completionBlock
{
    [NSError assertArgumentNotNil:group argumentName:@"group"];
    NSError *error = nil;
    NSString *linkURLString = [self linkFromPhoto:group.photo iconType:iconType error:&error];
    if (nil == linkURLString)
    {
        error = [NSError errorWithDomain:@"com.mendeleykit" code:100 userInfo:nil];
        completionBlock(NO, error);
        return;
    }
    NSURL *url = [NSURL URLWithString:linkURLString];
    NSDictionary *requestHeader = [self requestHeaderForImageLink:linkURLString];
    [self.provider invokeGET:url api:nil additionalHeaders:requestHeader queryParameters:nil authenticationRequired:NO completionBlock:^(MendeleyResponse *response, NSError *error) {
         if (![self.helper isSuccessForResponse:response error:&error])
         {
             completionBlock(NO, error);
         }
         else
         {
             id bodyData = response.responseBody;
             if ([bodyData isKindOfClass:[NSData class]])
             {
                 switch (iconType)
                 {
                     case OriginalIcon:
                         group.photo.originalImageData = bodyData;
                         break;
                     case SquareIcon:
                         group.photo.squareImageData = bodyData;
                         break;
                     case StandardIcon:
                         group.photo.standardImageData = bodyData;
                         break;
                 }
             }
             completionBlock(YES, nil);
         }
     }];


}


- (NSString *)linkFromPhoto:(MendeleyPhoto *)photo
                   iconType:(MendeleyGroupIconType)iconType
                      error:(NSError **)error
{
    if (nil == photo)
    {
        if (NULL != *error)
        {
            *error = [NSError errorWithDomain:@"com.MendeleyKit" code:100 userInfo:nil];
        }
        return nil;
    }

    NSString *link = nil;
    switch (iconType)
    {
        case OriginalIcon:
            link = photo.original;
            break;
        case SquareIcon:
            link = photo.square;
            break;
        case StandardIcon:
            link = photo.standard;
            break;
    }
    if (nil == link)
    {
        if (NULL != *error)
        {
            *error = [NSError errorWithDomain:@"com.mendeleykit" code:100 userInfo:nil];
            return nil;
        }
    }
    return link;
}

- (NSDictionary *)requestHeaderForImageLink:(NSString *)link
{
    if ([link hasSuffix:@".jpg"])
    {
        return @{ kMendeleyRESTRequestAccept : kMendeleyRESTRequestJPEGType };
    }
    else if ([link hasSuffix:@".png"])
    {
        return @{ kMendeleyRESTRequestAccept : kMendeleyRESTRequestPNGType };
    }
    return @{ kMendeleyRESTRequestAccept : kMendeleyRESTRequestBinaryType };
}

@end
