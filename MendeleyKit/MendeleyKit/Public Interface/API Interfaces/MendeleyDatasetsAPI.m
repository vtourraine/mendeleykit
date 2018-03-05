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

//#import "MendeleyDatasetsAPI.h"
//#import "NSError+Exceptions.h"
//#import "MendeleyErrorManager.h"
//
//@implementation MendeleyDatasetsAPI
//
//#pragma mark - Default configurations
//
//- (NSDictionary *)defaultServiceRequestHeaders
//{
//    return @{ kMendeleyRESTRequestAccept: kMendeleyRESTRequestJSONDatasetType };
//}
//
//- (NSDictionary *)licencesServiceRequestHeaders
//{
//    return @{ kMendeleyRESTRequestAccept: kMendeleyRESTRequestJSONLicenceInfoType };
//}
//
//- (NSDictionary *)defaultQueryParameters
//{
//    return [[MendeleyDatasetParameters new] valueStringDictionary];
//}
//
//- (NSDictionary *)defaultViewQueryParameters
//{
//    return nil;
//}
//
//#pragma mark - Methods
//
//- (void)datasetListWithQueryParameters:(MendeleyDatasetParameters *)queryParameters
//                                  task:(MendeleyTask *)task
//                       completionBlock:(MendeleyArrayCompletionBlock)completionBlock
//{
//    NSDictionary *query = [queryParameters valueStringDictionary];
//
//    [self.helper mendeleyObjectListOfType:kMendeleyModelDataset
//                                      api:kMendeleyRESTAPIDatasets
//                               parameters:[NSDictionary dictionaryByMerging:query with:[self defaultQueryParameters]]
//                        additionalHeaders:[self defaultServiceRequestHeaders]
//                                     task:task
//                          completionBlock:completionBlock];
//}
//
//- (void)datasetListWithLinkedURL:(NSURL *)linkURL
//                            task:(MendeleyTask *)task
//                 completionBlock:(MendeleyArrayCompletionBlock)completionBlock
//{
//    [NSError assertArgumentNotNil:linkURL argumentName:@"linkURL"];
//    [NSError assertArgumentNotNil:completionBlock argumentName:@"completionBlock"];
//
//    [self.provider invokeGET:linkURL
//                         api:nil
//           additionalHeaders:[self defaultServiceRequestHeaders]
//             queryParameters:nil
//      authenticationRequired:YES
//                        task:task
//             completionBlock: ^(MendeleyResponse *response, NSError *error) {
//                 MendeleyBlockExecutor *blockExec = [[MendeleyBlockExecutor alloc] initWithArrayCompletionBlock:completionBlock];
//                 if (![self.helper isSuccessForResponse:response error:&error])
//                 {
//                     [blockExec executeWithArray:nil
//                                        syncInfo:nil
//                                           error:error];
//                 }
//                 else
//                 {
//                     MendeleyModeller *jsonModeller = [MendeleyModeller sharedInstance];
//                     [jsonModeller parseJSONData:response.responseBody expectedType:kMendeleyModelDataset completionBlock: ^(NSArray *datasets, NSError *parseError) {
//                         MendeleySyncInfo *syncInfo = (nil != parseError) ? nil : response.syncHeader;
//                         [blockExec executeWithArray:datasets
//                                            syncInfo:syncInfo
//                                               error:parseError];
//                     }];
//                 }
//             }];
//}
//
//- (void)datasetWithDatasetID:(NSString *)datasetID
//                        task:(MendeleyTask *)task
//             completionBlock:(MendeleyObjectCompletionBlock)completionBlock
//{
//    [NSError assertArgumentNotNil:datasetID argumentName:@"datasetID"];
//
//    NSString *apiEndpoint = [NSString stringWithFormat:kMendeleyRESTAPIDatasetWithID, datasetID];
//    [self.helper mendeleyObjectOfType:kMendeleyModelDataset
//                           parameters:[self defaultViewQueryParameters]
//                                  api:apiEndpoint
//                    additionalHeaders:[self defaultServiceRequestHeaders]
//                                 task:task
//                      completionBlock:completionBlock];
//}
//
//- (void)createDataset:(MendeleyDataset *)mendeleyDataset
//                 task:(MendeleyTask *)task
//      completionBlock:(MendeleyObjectCompletionBlock)completionBlock
//{
//    [self.helper createMendeleyObject:mendeleyDataset
//                                  api:kMendeleyRESTAPIDatasetsDrafts
//                    additionalHeaders:@{kMendeleyRESTRequestContentType: kMendeleyRESTRequestJSONDatasetCreationRequestType}
//                         expectedType:kMendeleyModelDataset
//                                 task:task
//                      completionBlock:completionBlock];
//}
//
//- (void)createDatasetFile:(NSURL *)fileURL
//                 filename:(NSString *)filename
//              contentType:(NSString *)contentType
//                     task:(MendeleyTask *)task
//            progressBlock:(MendeleyResponseProgressBlock)progressBlock
//          completionBlock:(MendeleyObjectCompletionBlock)completionBlock
//{
//    NSMutableDictionary *additionalHeaders = [NSMutableDictionary dictionary];
//
//    if (filename) {
//        NSString *fileAttachment = [NSString stringWithFormat:@"; filename=\"%@\"", filename];
//        NSString *contentDisposition = [kMendeleyRESTRequestValueAttachment stringByAppendingString:fileAttachment];
//        additionalHeaders[kMendeleyRESTRequestContentDisposition] = contentDisposition;
//    }
//
//    if (contentType) {
//        additionalHeaders[kMendeleyRESTRequestContentType] = contentType;
//    }
//
//    [self.provider invokeUploadForFileURL:fileURL
//                                  baseURL:self.baseURL
//                                      api:kMendeleyRESTAPIFileContents
//                        additionalHeaders:additionalHeaders
//                   authenticationRequired:YES
//                                     task:task
//                            progressBlock:progressBlock
//                          completionBlock:^(MendeleyResponse *response, NSError *error) {
//                              MendeleyBlockExecutor *blockExec = [[MendeleyBlockExecutor alloc] initWithObjectCompletionBlock:completionBlock];
//                              if (![self.helper isSuccessForResponse:response error:&error])
//                              {
//                                  [blockExec executeWithMendeleyObject:nil
//                                                              syncInfo:nil
//                                                                 error:error];
//                              }
//                              else
//                              {
//                                  MendeleyModeller *modeller = [MendeleyModeller sharedInstance];
//                                  [modeller parseJSONData:response.responseBody expectedType:kMendeleyModelContentTicket completionBlock: ^(MendeleyContentTicket *ticket, NSError *parseError) {
//                                      if (nil != parseError)
//                                      {
//                                          [blockExec executeWithMendeleyObject:nil
//                                                                      syncInfo:nil
//                                                                         error:parseError];
//                                      }
//                                      else
//                                      {
//                                          MendeleyFileData *fileData = [[MendeleyFileData alloc] init];
//                                          fileData.object_ID = ticket.object_ID;
//
//                                          MendeleyFileMetadata *fileMetadata = [[MendeleyFileMetadata alloc] init];
//                                          fileMetadata.filename = filename;
//                                          fileMetadata.content_details = fileData;
//
//                                          [blockExec executeWithMendeleyObject:fileMetadata
//                                                                      syncInfo:response.syncHeader
//                                                                         error:nil];
//                                      }
//                                  }];
//                              }
//                          }];
//}
//
//#pragma mark - Licences
//
//- (void)datasetLicencesListWithTask:(MendeleyTask *)task
//                    completionBlock:(MendeleyArrayCompletionBlock)completionBlock
//{
//    [self.helper mendeleyObjectListOfType:kMendeleyModelLicenceInfo
//                                      api:kMendeleyRESTAPIDatasetsLicences
//                               parameters:nil
//                        additionalHeaders:[self licencesServiceRequestHeaders]
//                                     task:task
//                          completionBlock:completionBlock];
//}
//
//@end

