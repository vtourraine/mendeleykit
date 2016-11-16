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

#import "MendeleyDocumentsAPI.h"
#import "MendeleyDocument.h"
#import "MendeleyKitConfiguration.h"
#import "NSDictionary+Merge.h"
#import "NSError+Exceptions.h"
#import "MendeleyErrorManager.h"

@implementation MendeleyDocumentsAPI
#pragma mark Private methods

- (NSDictionary *)defaultServiceRequestHeaders
{
    return @{ kMendeleyRESTRequestAccept: kMendeleyRESTRequestJSONDocumentType };
}

- (NSDictionary *)defaultUploadRequestHeaders
{
    return @{ kMendeleyRESTRequestAccept: kMendeleyRESTRequestJSONDocumentType,
              kMendeleyRESTRequestContentType : kMendeleyRESTRequestJSONDocumentType };
}

- (NSDictionary *)defaultQueryParameters
{
    return [[MendeleyDocumentParameters new] valueStringDictionary];
}

- (NSDictionary *)defaultQueryParametersWithoutViewParameter
{
    MendeleyDocumentParameters *params = [MendeleyDocumentParameters new];

    params.view = nil;
    return [params valueStringDictionary];
}

- (NSDictionary *)defaultViewQueryParameters
{
    MendeleyDocumentParameters *params = [MendeleyDocumentParameters new];

    if (nil != params.view)
    {
        return @{ @"view" : params.view };
    }
    return nil;
}

- (NSDictionary *)defaultCatalogViewQueryParameters
{
    MendeleyCatalogParameters *params = [MendeleyCatalogParameters new];

    if (nil != params.view)
    {
        return @{ @"view" : params.view };
    }
    return nil;
}

#pragma mark -

- (void)documentListWithLinkedURL:(NSURL *)linkURL
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
             MendeleyModeller *jsonModeller = [MendeleyModeller sharedInstance];
             [jsonModeller parseJSONData:response.responseBody
                            expectedType:kMendeleyModelDocument
                         completionBlock: ^(NSArray *documents, NSError *parseError) {
                  if (nil != parseError)
                  {
                      [blockExec executeWithArray:nil
                                         syncInfo:nil
                                            error:parseError];
                  }
                  else
                  {
                      [blockExec executeWithArray:documents
                                         syncInfo:response.syncHeader
                                            error:nil];
                  }
              }];
         }
     }];
}

- (void)documentListWithQueryParameters:(MendeleyDocumentParameters *)queryParameters
                                   task:(MendeleyTask *)task
                        completionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    NSDictionary *query = [queryParameters valueStringDictionary];

    [self.helper mendeleyObjectListOfType:kMendeleyModelDocument
                                      api:kMendeleyRESTAPIDocuments
                               parameters:[NSDictionary dictionaryByMerging:query with:[self defaultQueryParameters]]
                        additionalHeaders:[self defaultServiceRequestHeaders]
                                     task:task
                          completionBlock:completionBlock];
}

- (void)authoredDocumentListForUserWithProfileID:(NSString *)profileID
                                 queryParameters:(MendeleyDocumentParameters *)queryParameters
                                            task:(MendeleyTask *)task
                                 completionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    queryParameters.profile_id = profileID;
    queryParameters.authored = @"true";
    NSDictionary *query = [queryParameters valueStringDictionary];

    [self.helper mendeleyObjectListOfType:kMendeleyModelDocument
                                      api:kMendeleyRESTAPIDocuments
                               parameters:[NSDictionary dictionaryByMerging:query with:[self defaultQueryParameters]]
                        additionalHeaders:[self defaultServiceRequestHeaders]
                                     task:task
                          completionBlock:completionBlock];
}

- (void)documentWithDocumentID:(NSString *)documentID
                          task:(MendeleyTask *)task
               completionBlock:(MendeleyObjectCompletionBlock)completionBlock
{
    [NSError assertArgumentNotNil:documentID argumentName:@"documentID"];
    NSString *apiEndpoint = [NSString stringWithFormat:kMendeleyRESTAPIDocumentWithID, documentID];
    [self.helper mendeleyObjectOfType:kMendeleyModelDocument
                           parameters:[self defaultViewQueryParameters]
                                  api:apiEndpoint
                    additionalHeaders:[self defaultServiceRequestHeaders]
                                 task:task
                      completionBlock:completionBlock];
}

- (void)catalogDocumentWithCatalogID:(NSString *)catalogID
                                task:(MendeleyTask *)task
                     completionBlock:(MendeleyObjectCompletionBlock)completionBlock
{
    [NSError assertArgumentNotNil:catalogID argumentName:@"catalogID"];
    NSString *apiEndpoint = [NSString stringWithFormat:kMendeleyRESTAPICatalogWithID, catalogID];
    [self.helper mendeleyObjectOfType:kMendeleyModelCatalogDocument
                           parameters:[self defaultCatalogViewQueryParameters]
                                  api:apiEndpoint
                    additionalHeaders:[self defaultServiceRequestHeaders]
                                 task:task
                      completionBlock:completionBlock];
}

- (void)catalogDocumentWithParameters:(MendeleyCatalogParameters *)queryParameters
                                 task:(MendeleyTask *)task
                      completionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    NSDictionary *query = [queryParameters valueStringDictionary];

    [self.helper mendeleyObjectListOfType:kMendeleyModelCatalogDocument
                                      api:kMendeleyRESTAPICatalog
                               parameters:query
                        additionalHeaders:[self defaultServiceRequestHeaders]
                                     task:task
                          completionBlock:completionBlock];
}

- (void)createDocument:(MendeleyDocument *)mendeleyDocument
                  task:(MendeleyTask *)task
       completionBlock:(MendeleyObjectCompletionBlock)completionBlock
{
    [self.helper createMendeleyObject:mendeleyDocument
                                  api:kMendeleyRESTAPIDocuments
                    additionalHeaders:[self defaultUploadRequestHeaders]
                         expectedType:kMendeleyModelDocument
                                 task:task
                      completionBlock:completionBlock];
}

- (void)updateDocument:(MendeleyDocument *)updatedMendeleyDocument
                  task:(MendeleyTask *)task
       completionBlock:(MendeleyObjectCompletionBlock)completionBlock
{
    [NSError assertArgumentNotNil:updatedMendeleyDocument argumentName:@"updatedMendeleyDocument"];
    NSString *apiEndpoint = [NSString stringWithFormat:kMendeleyRESTAPIDocumentWithID, updatedMendeleyDocument.object_ID];
    [self.helper updateMendeleyObject:updatedMendeleyDocument
                                  api:apiEndpoint
                    additionalHeaders:[self defaultUploadRequestHeaders]
                         expectedType:kMendeleyModelDocument
                                 task:task
                      completionBlock:completionBlock];
}

- (void)deleteDocumentWithID:(NSString *)documentID
                        task:(MendeleyTask *)task
             completionBlock:(MendeleyCompletionBlock)completionBlock
{
    [NSError assertArgumentNotNil:documentID argumentName:@"documentID"];
    NSString *apiEndpoint = [NSString stringWithFormat:kMendeleyRESTAPIDocumentWithID, documentID];
    [self.helper deleteMendeleyObjectWithAPI:apiEndpoint
                                        task:task
                             completionBlock:completionBlock];
}

- (void)trashDocumentWithID:(NSString *)documentID
                       task:(MendeleyTask *)task
            completionBlock:(MendeleyCompletionBlock)completionBlock
{
    [NSError assertArgumentNotNil:documentID argumentName:@"documentID"];
    [NSError assertArgumentNotNil:completionBlock argumentName:@"completionBlock"];
    NSString *apiEndpoint = [NSString stringWithFormat:kMendeleyRESTAPIDocumentWithIDToTrash, documentID];
    [self.provider invokePOST:self.baseURL
                          api:apiEndpoint
            additionalHeaders:[self defaultServiceRequestHeaders]
               bodyParameters:nil
                       isJSON:NO
       authenticationRequired:YES
                         task:task
              completionBlock: ^(MendeleyResponse *response, NSError *error) {
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
}

- (void)deletedDocumentsSince:(NSDate *)deletedSince
                      groupID:(NSString *)groupID
                         task:(MendeleyTask *)task
              completionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    [NSError assertArgumentNotNil:deletedSince argumentName:@"deletedSince"];
    [NSError assertArgumentNotNil:completionBlock argumentName:@"completionBlock"];
    NSString *deletedSinceString = [[MendeleyObjectHelper jsonDateFormatter] stringFromDate:deletedSince];
    NSMutableDictionary *query = [NSMutableDictionary dictionaryWithDictionary:@{ kMendeleyRESTAPIQueryDeletedSince : deletedSinceString }];
    if (groupID)
    {
        [query addEntriesFromDictionary:@{ kMendeleyRESTAPIQueryGroupID:groupID }];
    }
    [self.provider invokeGET:self.baseURL
                         api:kMendeleyRESTAPIDocuments
           additionalHeaders:[self defaultServiceRequestHeaders]
             queryParameters:[NSDictionary dictionaryByMerging:query with:[self defaultQueryParametersWithoutViewParameter]]
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
             id jsonData = response.responseBody;
             if ([jsonData isKindOfClass:[NSArray class]])
             {
                 NSArray *jsonArray = (NSArray *) jsonData;
                 [jsonModeller parseJSONArrayOfIDDictionaries:jsonArray completionBlock: ^(NSArray *arrayOfStrings, NSError *parseError) {
                      if (nil != parseError)
                      {
                          [blockExec executeWithArray:nil
                                             syncInfo:nil
                                                error:parseError];
                      }
                      else
                      {
                          [blockExec executeWithArray:arrayOfStrings
                                             syncInfo:response.syncHeader
                                                error:nil];
                      }
                  }];
             }
         }
     }];
}

- (void)trashedDocumentListWithLinkedURL:(NSURL *)linkURL
                                    task:(MendeleyTask *)task
                         completionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    [NSError assertArgumentNotNil:linkURL argumentName:@"linkURL"];
    [NSError assertArgumentNotNil:completionBlock argumentName:@"completionBlock"];
    [self.provider invokeGET:linkURL
                         api:nil
           additionalHeaders:[self defaultServiceRequestHeaders]
             queryParameters:[self defaultQueryParameters]
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
             [jsonModeller parseJSONData:response.responseBody expectedType:kMendeleyModelDocument completionBlock: ^(NSArray *documents, NSError *parseError) {
                  if (nil != parseError)
                  {
                      [blockExec executeWithArray:nil
                                         syncInfo:nil
                                            error:parseError];
                  }
                  else
                  {
                      [blockExec executeWithArray:documents
                                         syncInfo:response.syncHeader
                                            error:nil];
                  }
              }];
         }
     }];
}

- (void)trashedDocumentListWithQueryParameters:(MendeleyDocumentParameters *)queryParameters
                                          task:(MendeleyTask *)task
                               completionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    NSDictionary *query = [queryParameters valueStringDictionary];

    [self.helper mendeleyObjectListOfType:kMendeleyModelDocument
                                      api:kMendeleyRESTAPITrashedDocuments
                               parameters:[NSDictionary dictionaryByMerging:query with:[self defaultQueryParameters]]
                        additionalHeaders:[self defaultServiceRequestHeaders]
                                     task:task
                          completionBlock:completionBlock];
}

- (void)deleteTrashedDocumentWithID:(NSString *)documentID
                               task:(MendeleyTask *)task
                    completionBlock:(MendeleyCompletionBlock)completionBlock
{
    [NSError assertArgumentNotNil:documentID argumentName:@"documentID"];
    NSString *apiEndpoint = [NSString stringWithFormat:kMendeleyRESTAPITrashedDocumentWithID, documentID];
    [self.helper deleteMendeleyObjectWithAPI:apiEndpoint
                                        task:task
                             completionBlock:completionBlock];
}

- (void)restoreTrashedDocumentWithID:(NSString *)documentID
                                task:(MendeleyTask *)task
                     completionBlock:(MendeleyCompletionBlock)completionBlock
{
    [NSError assertArgumentNotNil:documentID argumentName:@"documentID"];
    [NSError assertArgumentNotNil:completionBlock argumentName:@"completionBlock"];
    NSString *apiEndpoint = [NSString stringWithFormat:kMendeleyRESTAPIRestoreTrashedDocumentWithID, documentID];
    [self.provider invokePOST:self.baseURL
                          api:apiEndpoint
            additionalHeaders:nil
               bodyParameters:nil
                       isJSON:NO
       authenticationRequired:YES
                         task:task
              completionBlock: ^(MendeleyResponse *response, NSError *error) {
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
}

- (void)trashedDocumentWithDocumentID:(NSString *)documentID
                                 task:(MendeleyTask *)task
                      completionBlock:(MendeleyObjectCompletionBlock)completionBlock
{
    [NSError assertArgumentNotNil:documentID argumentName:@"documentID"];
    NSString *apiEndpoint = [NSString stringWithFormat:kMendeleyRESTAPITrashedDocumentWithID, documentID];
    [self.helper mendeleyObjectOfType:kMendeleyModelDocument
                           parameters:[self defaultViewQueryParameters]
                                  api:apiEndpoint
                    additionalHeaders:[self defaultServiceRequestHeaders]
                                 task:task
                      completionBlock:completionBlock];
}

- (void)documentTypesWithTask:(MendeleyTask *)task
              completionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    [self.helper mendeleyObjectListOfType:kMendeleyModelDocumentType
                                      api:kMendeleyRESTAPIDocumentTypes
                               parameters:nil
                        additionalHeaders:nil
                                     task:task
                          completionBlock:completionBlock];
}

- (void)identifierTypesWithTask:(MendeleyTask *)task
                completionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    [self.helper mendeleyObjectListOfType:kMendeleyModelIdentifierType
                                      api:kMendeleyRESTAPIIdentifierTypes
                               parameters:nil
                        additionalHeaders:nil
                                     task:task
                          completionBlock:completionBlock];
}

- (void)documentFromFileWithURL:(NSURL *)fileURL
                       mimeType:(NSString *)mimeType
                           task:(MendeleyTask *)task
                completionBlock:(MendeleyObjectCompletionBlock)completionBlock
{
    [NSError assertArgumentNotNil:fileURL argumentName:@"fileURL"];
    if (nil == mimeType)
    {
        mimeType = kMendeleyRESTRequestValuePDF;
    }

    NSString *filename = [fileURL lastPathComponent];
    NSString *contentDisposition = [NSString stringWithFormat:@"%@; filename=\"%@\"", kMendeleyRESTRequestValueAttachment, filename];

    NSDictionary *header = @{ kMendeleyRESTRequestContentDisposition: contentDisposition,
                              kMendeleyRESTRequestContentType: mimeType,
                              kMendeleyRESTRequestAccept: kMendeleyRESTRequestJSONDocumentType };

    [self.provider invokeUploadForFileURL:fileURL
                                  baseURL:self.baseURL
                                      api:kMendeleyRESTAPIDocuments
                        additionalHeaders:header
                   authenticationRequired:YES
                                     task:task
                            progressBlock:^(NSNumber *progress) {
     } completionBlock:^(MendeleyResponse *response, NSError *error) {
         MendeleyBlockExecutor *blockExec = [[MendeleyBlockExecutor alloc]
                                             initWithObjectCompletionBlock:completionBlock];
         if (![self.helper isSuccessForResponse:response error:&error])
         {
             [blockExec executeWithMendeleyObject:nil syncInfo:nil error:error];
         }
         else
         {
             MendeleyModeller *jsonModeller = [MendeleyModeller sharedInstance];
             [jsonModeller parseJSONData:response.responseBody
                            expectedType:kMendeleyModelDocument
                         completionBlock:^(id parsedObject, NSError *parseError) {
                  if (nil != parseError)
                  {
                      [blockExec executeWithMendeleyObject:nil
                                                  syncInfo:nil
                                                     error:parseError];
                  }
                  else
                  {
                      [blockExec executeWithMendeleyObject:parsedObject
                                                  syncInfo:response.syncHeader
                                                     error:nil];
                  }
              }];
         }
     }];
}

- (void)cloneDocumentWithID:(NSString *)documentID
                    groupID:(NSString *)groupID
                   folderID:(NSString *)folderID
                  profileID:(NSString *)profileID
                       task:(MendeleyTask *)task
            completionBlock:(MendeleyObjectCompletionBlock)completionBlock
{
    [NSError assertArgumentNotNil:documentID argumentName:@"documentID"];
    [NSError assertArgumentNotNil:completionBlock argumentName:@"completionBlock"];
    MendeleyBlockExecutor *blockExec = [[MendeleyBlockExecutor alloc] initWithObjectCompletionBlock:completionBlock];
    MendeleyModeller *modeller = [MendeleyModeller sharedInstance];
    NSMutableDictionary *arguments = [NSMutableDictionary new];
    if (nil == groupID && nil == profileID)
    {
        NSError *argumentError = [[MendeleyErrorManager sharedInstance] errorWithDomain:kMendeleyErrorDomain code:kMendeleyDataNotAvailableErrorCode];
        completionBlock(nil, nil, argumentError);
        return;
    }
    else if (nil != groupID)
    {
        [arguments setObject:groupID forKey:kMendeleyJSONGroupID];
        profileID = nil;
    }
    else if (nil != profileID)
    {
        [arguments setObject:profileID forKey:kMendeleyJSONUserID];
        groupID = nil;
    }
    else if (nil != folderID)
    {
        [arguments setObject:folderID forKey:kMendeleyJSONFolderID];
    }
    
    if (0 == arguments.count)
    {
        NSError *argumentError = [[MendeleyErrorManager sharedInstance] errorWithDomain:kMendeleyErrorDomain code:kMendeleyDataNotAvailableErrorCode];
        completionBlock(nil, nil, argumentError);
        return;
    }
    
    NSError *serialiseError = nil;
    NSData *jsonData = [modeller jsonObjectFromModelOrModels:arguments error:&serialiseError];
    if (nil == jsonData)
    {
        [blockExec executeWithMendeleyObject:nil
                                    syncInfo:nil
                                       error:serialiseError];
        return;
    }
    id <MendeleyNetworkProvider> networkProvider = [self provider];
    NSString *api = [NSString stringWithFormat:kMendeleyRESTAPIDocumentCloneTo, documentID];
    [networkProvider invokePOST:self.baseURL
                            api:api
              additionalHeaders:[self defaultServiceRequestHeaders]
                       jsonData:jsonData
         authenticationRequired:YES
                           task:task
                completionBlock:^(MendeleyResponse * _Nullable response, NSError * _Nullable error) {
                    if (![self.helper isSuccessForResponse:response error:&error])
                    {
                        [blockExec executeWithMendeleyObject:nil syncInfo:nil error:error];
                    }
                    else
                    {
                        [modeller parseJSONData:response.responseBody
                                       expectedType:kMendeleyModelDocument
                                    completionBlock:^(id parsedObject, NSError *parseError) {
                                        if (nil != parseError)
                                        {
                                            [blockExec executeWithMendeleyObject:nil
                                                                        syncInfo:nil
                                                                           error:parseError];
                                        }
                                        else
                                        {
                                            [blockExec executeWithMendeleyObject:parsedObject
                                                                        syncInfo:response.syncHeader
                                                                           error:nil];
                                        }
                                    }];
                        
                    }
    }];
}

- (void)cloneDocumentFiles:(NSString *)sourceDocumentID
          targetDocumentID:(NSString *)targetDocumentID
                      task:(MendeleyTask *)task
           completionBlock:(MendeleyCompletionBlock)completionBlock
{
    [NSError assertArgumentNotNil:sourceDocumentID argumentName:@"sourceDocumentID"];
    [NSError assertArgumentNotNil:targetDocumentID argumentName:@"targetDocumentID"];
    [NSError assertArgumentNotNil:completionBlock argumentName:@"completionBlock"];
    MendeleyBlockExecutor *blockExec = [[MendeleyBlockExecutor alloc] initWithCompletionBlock:completionBlock];
    MendeleyModeller *modeller = [MendeleyModeller sharedInstance];
    NSDictionary *sourceDict = @{@"id" : sourceDocumentID};
    NSError *serialiseError = nil;
    NSData *jsonData = [modeller jsonObjectFromModelOrModels:sourceDict error:&serialiseError];
    if (nil == jsonData)
    {
        [blockExec executeWithBool:NO error:serialiseError];
        return;
    }
    NSString *apiURL = [NSString stringWithFormat:kMendeleyRESTAPIDocumentCloneFilesTo,sourceDocumentID];
    id <MendeleyNetworkProvider> networkProvider = [self provider];
    [networkProvider invokePOST:self.baseURL
                            api:apiURL
              additionalHeaders:nil
                       jsonData:jsonData
         authenticationRequired:YES
                           task:task
                completionBlock:^(MendeleyResponse * _Nullable response, NSError * _Nullable error) {
                    if (![self.helper isSuccessForResponse:response error:&error])
                    {
                        [blockExec executeWithBool:NO error:error];
                    }
                    else
                    {
                        [blockExec executeWithBool:YES error:error];
                    }
    }];
}


- (void)cloneDocumentAndFiles:(NSString *)documentID
                      groupID:(NSString *)groupID
                     folderID:(NSString *)folderID
                    profileID:(NSString *)profileID
                         task:(MendeleyTask *)task
              completionBlock:(MendeleyObjectCompletionBlock)completionBlock
{
    [NSError assertArgumentNotNil:documentID argumentName:@"documentID"];
    [NSError assertArgumentNotNil:completionBlock argumentName:@"completionBlock"];
    [self cloneDocumentWithID:documentID groupID:groupID folderID:folderID profileID:profileID task:task completionBlock:^(MendeleyObject * _Nullable mendeleyObject, MendeleySyncInfo * _Nullable syncInfo, NSError * _Nullable error) {
        if (error)
        {
            completionBlock(nil, nil, error);
        }
        else
        {
            NSString *clonedDocumentID = mendeleyObject.object_ID;
            if (clonedDocumentID)
            {
                [self cloneDocumentFiles:documentID targetDocumentID:clonedDocumentID task:task completionBlock:^(BOOL success, NSError * _Nullable error) {
                    if (error)
                    {
                        completionBlock(nil, nil, error);
                    }
                    else
                    {
                        completionBlock(mendeleyObject, syncInfo, nil);
                    }
                }];
            }
            else
            {
                completionBlock(nil, nil, error);
            }
        }
    }];
}

@end
