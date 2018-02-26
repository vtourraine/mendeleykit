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

//#import "MendeleySharesAPI.h"
//
//@implementation MendeleySharesAPI
//
//- (NSDictionary *)defaultServiceRequestHeaders
//{
//    return @{
//             kMendeleyRESTRequestContentType: kMendeleyRESTRequestJSONNewsItemsShareType
//             };
//}
//
//- (NSDictionary *)shareDocumentServiceRequestHeaders
//{
//    return @{
//             kMendeleyRESTRequestContentType: kMendeleyRESTRequestJSONDocumentShareType
//             };
//}
//
//- (void)shareFeedWithQueryParameters:(MendeleySharesParameters *)queryParameters
//                                task:(MendeleyTask *)task
//                     completionBlock:(MendeleyCompletionBlock)completionBlock
//{
//    [self.provider invokePOST:self.baseURL
//                          api:kMendeleyRESTAPIShareFeed
//            additionalHeaders:[self defaultServiceRequestHeaders]
//               bodyParameters:[queryParameters valueStringDictionary]
//                       isJSON:YES
//       authenticationRequired:YES
//                         task:task
//              completionBlock:^(MendeleyResponse * _Nullable response, NSError * _Nullable error) {
//        MendeleyBlockExecutor *blockExec = [[MendeleyBlockExecutor alloc] initWithCompletionBlock:completionBlock];
//        BOOL success = [self.helper isSuccessForResponse:response error:&error];
//        [blockExec executeWithBool:success error:error];
//              }];
//}
//
//- (void)shareDocumentWithDocumentID:(NSString *)documentID
//                               task:(MendeleyTask *)task
//                    completionBlock:(MendeleyCompletionBlock)completionBlock
//{
//    MendeleyShareDocumentParameters *parameters = [MendeleyShareDocumentParameters new];
//    parameters.document_id = documentID;
//    [self shareDocumentWithQueryParameters:parameters
//                                      task:task
//                           completionBlock:completionBlock];
//}
//
//- (void)shareDocumentWithDOI:(NSString *)doi
//                        task:(MendeleyTask *)task
//             completionBlock:(MendeleyCompletionBlock)completionBlock
//{
//    MendeleyShareDocumentParameters *parameters = [MendeleyShareDocumentParameters new];
//    parameters.doi = doi;
//    [self shareDocumentWithQueryParameters:parameters
//                                      task:task
//                           completionBlock:completionBlock];
//}
//
//- (void)shareDocumentWithScopus:(NSString *)scopus
//                           task:(MendeleyTask *)task
//                completionBlock:(MendeleyCompletionBlock)completionBlock
//{
//    MendeleyShareDocumentParameters *parameters = [MendeleyShareDocumentParameters new];
//    parameters.scopus = scopus;
//    [self shareDocumentWithQueryParameters:parameters
//                                      task:task
//                           completionBlock:completionBlock];
//}
//
//- (void)shareDocumentWithQueryParameters:(MendeleyShareDocumentParameters *)queryParameters
//                                    task:(MendeleyTask *)task
//                         completionBlock:(MendeleyCompletionBlock)completionBlock
//{
//    [self.provider invokePOST:self.baseURL
//                          api:kMendeleyRESTAPIShareFeed
//            additionalHeaders:[self shareDocumentServiceRequestHeaders]
//               bodyParameters:[queryParameters valueStringDictionary]
//                       isJSON:YES
//       authenticationRequired:YES
//                         task:task
//              completionBlock:^(MendeleyResponse * _Nullable response, NSError * _Nullable error) {
//                  MendeleyBlockExecutor *blockExec = [[MendeleyBlockExecutor alloc] initWithCompletionBlock:completionBlock];
//                  BOOL success = [self.helper isSuccessForResponse:response error:&error];
//                  [blockExec executeWithBool:success error:error];
//              }];
//}
//
//@end

