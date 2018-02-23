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

#import "MendeleyCommentsAPI.h"
#import "MendeleyComment.h"
#import "NSError+Exceptions.h"

//@implementation MendeleyCommentsAPI
//
//- (NSDictionary *)defaultCommentRequestHeaders
//{
//    return @{ kMendeleyRESTRequestAccept: kMendeleyRESTRequestJSONCommentType };
//}
//
//- (NSDictionary *)expandedCommentsListRequestHeaders
//{
//    return @{ kMendeleyRESTRequestAccept: kMendeleyRESTRequestJSONExpandedCommentsType };
//}
//
//- (NSDictionary *)postCommentRequestHeaders
//{
//    return @{ kMendeleyRESTRequestAccept: kMendeleyRESTRequestJSONCommentType,
//              kMendeleyRESTRequestContentType: kMendeleyRESTRequestJSONCommentType };
//}
//
//- (NSDictionary *)updateCommentRequestHeaders
//{
//    return @{ kMendeleyRESTRequestAccept: kMendeleyRESTRequestJSONCommentUpdateType,
//              kMendeleyRESTRequestContentType: kMendeleyRESTRequestJSONCommentUpdateType };
//}
//
//- (void)expandedCommentsWithNewsItemID:(NSString *)newsItemID
//                                  task:(MendeleyTask *)task
//                       completionBlock:(MendeleyArrayCompletionBlock)completionBlock
//{
//    [NSError assertStringArgumentNotNilOrEmpty:newsItemID argumentName:@"newsItemID"];
//    [NSError assertArgumentNotNil:completionBlock argumentName:@"completionBlock"];
//
//    MendeleyExpandedCommentsParameters *queryParameters = [MendeleyExpandedCommentsParameters new];
//    queryParameters.news_item_id = newsItemID;
//
//    [self.helper mendeleyObjectListOfType:kMendeleyModelExpandedComment
//                                      api:kMendeleyRESTAPIComments
//                               parameters:[queryParameters valueStringDictionary]
//                        additionalHeaders:[self expandedCommentsListRequestHeaders]
//                                     task:task
//                          completionBlock:completionBlock];
//}
//
//- (void)commentWithCommentID:(NSString *)commentID
//                        task:(MendeleyTask *)task
//             completionBlock:(MendeleyObjectCompletionBlock)completionBlock
//{
//    [NSError assertStringArgumentNotNilOrEmpty:commentID argumentName:@"commentID"];
//    [NSError assertArgumentNotNil:completionBlock argumentName:@"completionBlock"];
//
//    [self.helper mendeleyObjectOfType:kMendeleyModelComment
//                           parameters:nil
//                                  api:[NSString stringWithFormat:kMendeleyRESTAPICommentsWithCommentID, commentID]
//                    additionalHeaders:[self defaultCommentRequestHeaders]
//                                 task:task
//                      completionBlock:completionBlock];
//}
//
//- (void)createComment:(MendeleyComment *)comment
//                 task:(MendeleyTask *)task
//      completionBlock:(MendeleyObjectCompletionBlock)completionBlock
//{
//    [self.helper createMendeleyObject:comment
//                                  api:kMendeleyRESTAPIComments
//                    additionalHeaders:[self postCommentRequestHeaders]
//                         expectedType:kMendeleyModelComment
//                                 task:task
//                      completionBlock:completionBlock];
//}
//
//- (void)updateCommentWithCommentID:(NSString *)commentID
//                            update:(MendeleyCommentUpdate *)update
//                              task:(MendeleyTask *)task
//                   completionBlock:(MendeleyObjectCompletionBlock)completionBlock
//{
//    [self.helper updateMendeleyObject:update
//                                  api:[NSString stringWithFormat:kMendeleyRESTAPICommentsWithCommentID, commentID]
//                    additionalHeaders:[self updateCommentRequestHeaders]
//                         expectedType:kMendeleyModelComment
//                                 task:task
//                      completionBlock:completionBlock];
//}
//
//- (void)deleteCommentWithCommentID:(NSString *)commentID
//                              task:(MendeleyTask *)task
//                   completionBlock:(MendeleyCompletionBlock)completionBlock
//{
//    [self.helper deleteMendeleyObjectWithAPI:[NSString stringWithFormat:kMendeleyRESTAPICommentsWithCommentID, commentID]
//                                        task:task
//                             completionBlock:completionBlock];
//}
//
//@end

