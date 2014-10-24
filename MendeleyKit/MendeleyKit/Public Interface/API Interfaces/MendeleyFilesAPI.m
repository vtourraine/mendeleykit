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

#import "MendeleyFilesAPI.h"
#import "MendeleyModels.h"

@implementation MendeleyFilesAPI

#pragma mark Private methods

- (NSDictionary *)defaultServiceRequestHeaders
{
    return @{ kMendeleyRESTRequestAccept: kMendeleyRESTRequestJSONFileType };
}

- (NSDictionary *)uploadFileHeadersWithLinkRel:(NSString *)linkRel
{
    return @{ kMendeleyRESTRequestContentDisposition: kMendeleyRESTRequestValueAttachment,
              kMendeleyRESTRequestContentType: kMendeleyRESTRequestValuePDF,
              kMendeleyRESTRequestLink: linkRel,
              kMendeleyRESTRequestAccept: kMendeleyRESTRequestJSONFileType };
}

- (NSDictionary *)defaultQueryParameters
{
    return [[MendeleyFileParameters new] valueStringDictionary];
}

#pragma mark -

- (void)fileListWithQueryParameters:(MendeleyFileParameters *)queryParameters
                    completionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    NSDictionary *query = [queryParameters valueStringDictionary];

    [self.helper mendeleyObjectListOfType:kMendeleyModelFile
                                      api:kMendeleyRESTAPIFiles
                               parameters:[NSDictionary dictionaryByMerging:query with:[self defaultQueryParameters]]
                        additionalHeaders:[self defaultServiceRequestHeaders]
                          completionBlock:completionBlock];
}

- (MendeleyTask *)fileWithFileID:(NSString *)fileID
                       saveToURL:(NSURL *)fileURL
                   progressBlock:(MendeleyResponseProgressBlock)progressBlock
                 completionBlock:(MendeleyCompletionBlock)completionBlock
{
    [NSError assertArgumentNotNil:fileID argumentName:@"fileID"];
    NSString *apiEndpoint = [NSString stringWithFormat:kMendeleyRESTAPIFileWithID, fileID];
    MendeleyTask *task = [self.helper downloadFileWithAPI:apiEndpoint saveToURL:fileURL progressBlock:progressBlock completionBlock:completionBlock];
    return task;
}

- (void)           createFile:(NSURL *)fileURL
    relativeToDocumentURLPath:(NSString *)documentURLPath
                progressBlock:(MendeleyResponseProgressBlock)progressBlock
              completionBlock:(MendeleyObjectCompletionBlock)completionBlock
{
    [NSError assertURLArgumentNotNilOrMissing:fileURL argumentName:@"fileURL"];
    [NSError assertStringArgumentNotNilOrEmpty:documentURLPath argumentName:@"documentURLPath"];
    [NSError assertArgumentNotNil:completionBlock argumentName:@"completionBlock"];
    MendeleyModeller *modeller = [MendeleyModeller sharedInstance];
    NSString *linkRel = [NSString stringWithFormat:@"<%@>; rel=" "document" "", documentURLPath];
    [self.provider invokeUploadForFileURL:fileURL baseURL:self.baseURL api:kMendeleyRESTAPIFiles additionalHeaders:[self uploadFileHeadersWithLinkRel:linkRel] authenticationRequired:YES progressBlock:progressBlock completionBlock: ^(MendeleyResponse *response, NSError *error) {
         MendeleyBlockExecutor *blockExec = [[MendeleyBlockExecutor alloc] initWithObjectCompletionBlock:completionBlock];
         if (![self.helper isSuccessForResponse:response error:&error])
         {
             [blockExec executeWithMendeleyObject:nil syncInfo:nil error:error];
         }
         else
         {
             [modeller parseJSONData:response.responseBody expectedType:kMendeleyModelFile completionBlock: ^(MendeleyFile *file, NSError *parseError) {
                  if (nil != parseError)
                  {
                      [blockExec executeWithMendeleyObject:nil syncInfo:nil error:parseError];
                  }
                  else
                  {
                      [blockExec executeWithMendeleyObject:file syncInfo:response.syncHeader error:nil];
                  }
              }];
         }
     }];
}

- (void)deleteFileWithID:(NSString *)fileID
         completionBlock:(MendeleyCompletionBlock)completionBlock
{
    [NSError assertArgumentNotNil:fileID argumentName:@"fileID"];
    NSString *apiEndpoint = [NSString stringWithFormat:kMendeleyRESTAPIFileWithID, fileID];
    [self.helper deleteMendeleyObjectWithAPI:apiEndpoint completionBlock:completionBlock];
}

- (void)fileListWithLinkedURL:(NSURL *)linkURL
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
             [jsonModeller parseJSONData:response.responseBody expectedType:kMendeleyModelFile completionBlock: ^(NSArray *documents, NSError *parseError) {
                  if (nil != parseError)
                  {
                      [blockExec executeWithArray:nil syncInfo:nil error:parseError];
                  }
                  else
                  {
                      [blockExec executeWithArray:documents syncInfo:response.syncHeader error:nil];
                  }
              }];
         }
     }];
}

- (void)deletedFilesSince:(NSDate *)deletedSince
          completionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    [NSError assertArgumentNotNil:deletedSince argumentName:@"deletedSince"];
    [NSError assertArgumentNotNil:completionBlock argumentName:@"completionBlock"];
    NSString *deletedSinceString = [[MendeleyObjectHelper jsonDateFormatter] stringFromDate:deletedSince];
    NSDictionary *query = @{ kMendeleyRESTAPIQueryDeletedSince : deletedSinceString };
    [self.provider invokeGET:self.baseURL
                         api:kMendeleyRESTAPIFiles
           additionalHeaders:[self defaultServiceRequestHeaders]
             queryParameters:[NSDictionary dictionaryByMerging:query with:[self defaultQueryParameters]]
      authenticationRequired:YES
             completionBlock: ^(MendeleyResponse *response, NSError *error) {
         MendeleyBlockExecutor *blockExec = [[MendeleyBlockExecutor alloc] initWithArrayCompletionBlock:completionBlock];
         if (![self.helper isSuccessForResponse:response error:&error])
         {
             [blockExec executeWithArray:nil syncInfo:nil error:error];
         }
         else
         {
             MendeleyModeller *jsonModeller = [MendeleyModeller sharedInstance];
             id jsonData = response.responseBody;
             if ([jsonData isKindOfClass:[NSArray class]])
             {
                 NSArray *jsonArray = (NSArray *) jsonData;
                 [jsonModeller parseJSONArrayOfIDDictionaries:jsonArray completionBlock: ^(NSArray *arrayOfStrings, NSError *parseError) {
                      if (nil != parseError)
                      {
                          [blockExec executeWithArray:nil syncInfo:nil error:parseError];
                      }
                      else
                      {
                          [blockExec executeWithArray:arrayOfStrings syncInfo:response.syncHeader error:nil];
                      }
                  }];
             }
         }
     }];
}

@end
