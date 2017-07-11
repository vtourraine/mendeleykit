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

#import "MendeleyUserPostsAPI.h"
#import "MendeleyNewUserPost.h"
#import "MendeleyModels.h"
#import "NSError+Exceptions.h"

@implementation MendeleyUserPostsAPI

- (NSDictionary *)newUserPostServiceHeaders
{
    return @{ kMendeleyRESTRequestContentType: kMendeleyRESTRequestJSONNewUserPostType,
              kMendeleyRESTRequestAccept : kMendeleyRESTRequestJSONUserPostType };
}

- (NSDictionary *)groupUserPostServiceHeaders
{
    return @{ kMendeleyRESTRequestContentType: kMendeleyRESTRequestJSONNewGroupPostType,
              kMendeleyRESTRequestAccept : kMendeleyRESTRequestJSONGroupPostType };
}

- (void)createUserPost:(MendeleyNewUserPost *)newPost
                  task:(MendeleyTask *)task
       completionBlock:(MendeleyObjectCompletionBlock)completionBlock
{
    [NSError assertArgumentNotNil:completionBlock argumentName:@"completionBlock"];
    [NSError assertArgumentNotNil:newPost argumentName:@"newPost"];
    
    MendeleyBlockExecutor *blockExec = [[MendeleyBlockExecutor alloc]
                                        initWithObjectCompletionBlock:completionBlock];
    MendeleyModeller *modeller = [MendeleyModeller sharedInstance];
    
    NSError *serialiseError = nil;
    NSData *jsonData = [modeller jsonObjectFromModelOrModels:newPost
                                                       error:&serialiseError];
    if (nil == jsonData)
    {
        [blockExec executeWithMendeleyObject:nil
                                    syncInfo:nil
                                       error:serialiseError];
        return;
    }
    
    
    [self.provider invokePOST:self.baseURL
                          api:kMendeleyRESTAPICreateUserPost
            additionalHeaders:[self newUserPostServiceHeaders]
                     jsonData:jsonData
       authenticationRequired:YES
                         task:task
              completionBlock: ^(MendeleyResponse *response, NSError *error) {
                  if (![self.helper isSuccessForResponse:response error:&error])
                  {
                      [blockExec executeWithMendeleyObject:nil syncInfo:nil error:error];
                  }
                  else
                  {
                      MendeleyModeller *jsonModeller = [MendeleyModeller sharedInstance];
                      [jsonModeller parseJSONData:response.responseBody expectedType:kMendeleyModelUserPost completionBlock: ^(MendeleyUserPost *post, NSError *parseError) {
                          if (nil != parseError)
                          {
                              [blockExec executeWithMendeleyObject:nil
                                                          syncInfo:nil
                                                             error:parseError];
                          }
                          else
                          {
                              [blockExec executeWithMendeleyObject:post
                                                          syncInfo:response.syncHeader
                                                             error:nil];
                          }
                      }];
                  }
              }];
}


- (void)deleteUserPostWithPostID:(NSString *)postID
                            task:(MendeleyTask *)task
                 completionBlock:(MendeleyCompletionBlock)completionBlock
{
    [self.provider invokeDELETE:self.baseURL
                            api:[NSString stringWithFormat:kMendeleyRESTAPIDeleteUserPost, postID]
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

- (void)createGroupPost:(MendeleyGroupPost *)groupPost
                   task:(MendeleyTask *)task
        completionBlock:(MendeleyObjectCompletionBlock)completionBlock
{
    [NSError assertArgumentNotNil:completionBlock argumentName:@"completionBlock"];
    [NSError assertArgumentNotNil:groupPost argumentName:@"groupPost"];
    
    MendeleyBlockExecutor *blockExec = [[MendeleyBlockExecutor alloc]
                                        initWithObjectCompletionBlock:completionBlock];
    MendeleyModeller *modeller = [MendeleyModeller sharedInstance];
    
    NSError *serialiseError = nil;
    NSData *jsonData = [modeller jsonObjectFromModelOrModels:groupPost
                                                       error:&serialiseError];
    if (nil == jsonData)
    {
        [blockExec executeWithMendeleyObject:nil
                                    syncInfo:nil
                                       error:serialiseError];
        return;
    }
    
    
    [self.provider invokePOST:self.baseURL
                          api:kMendeleyRESTAPICreateGroupPost
            additionalHeaders:[self groupUserPostServiceHeaders]
                     jsonData:jsonData
       authenticationRequired:YES
                         task:task
              completionBlock: ^(MendeleyResponse *response, NSError *error) {
                  if (![self.helper isSuccessForResponse:response error:&error])
                  {
                      [blockExec executeWithMendeleyObject:nil syncInfo:nil error:error];
                  }
                  else
                  {
                      MendeleyModeller *jsonModeller = [MendeleyModeller sharedInstance];
                      [jsonModeller parseJSONData:response.responseBody expectedType:kMendeleyModelGroupPost completionBlock: ^(MendeleyGroupPost *post, NSError *parseError) {
                          if (nil != parseError)
                          {
                              [blockExec executeWithMendeleyObject:nil
                                                          syncInfo:nil
                                                             error:parseError];
                          }
                          else
                          {
                              [blockExec executeWithMendeleyObject:post
                                                          syncInfo:response.syncHeader
                                                             error:nil];
                          }
                      }];
                  }
              }];

}

- (void)deleteGroupPostWithPostID:(NSString *)postID
                             task:(MendeleyTask *)task
                  completionBlock:(MendeleyCompletionBlock)completionBlock
{
    [self.provider invokeDELETE:self.baseURL
                            api:[NSString stringWithFormat:kMendeleyRESTAPIDeleteGroupPost, postID]
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
