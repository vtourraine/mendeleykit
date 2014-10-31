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

#import "MendeleyKit.h"
#import "MendeleyModels.h"
#import "MendeleyOAuthStore.h"
#import "MendeleyOAuthCredentials.h"
#import "MendeleyDefaultNetworkProvider.h"
#import "MendeleyDefaultOAuthProvider.h"
#import "MendeleyOAuthTokenHelper.h"
#import "MendeleyKitConfiguration.h"
#import "MendeleySyncInfo.h"
#import "MendeleyQueryRequestParameters.h"
#import "MendeleyBlockExecutor.h"
#import "MendeleyAnnotationsAPI.h"
#import "MendeleyDocumentsAPI.h"
#import "MendeleyFilesAPI.h"
#import "MendeleyFoldersAPI.h"
#import "MendeleyGroupsAPI.h"
#import "MendeleyMetadataAPI.h"
#import "NSError+MendeleyError.h"
#import "MendeleyProfilesAPI.h"


@interface MendeleyKit ()

@property (nonatomic, assign, readwrite) BOOL loggedIn;
@property (nonatomic, strong) MendeleyKitConfiguration *configuration;
@property (nonatomic, strong) id <MendeleyNetworkProvider> networkProvider;
@property (nonatomic, strong) MendeleyAnnotationsAPI *annotationsAPI;
@property (nonatomic, strong) MendeleyDocumentsAPI *documentsAPI;
@property (nonatomic, strong) MendeleyFilesAPI *filesAPI;
@property (nonatomic, strong) MendeleyFoldersAPI *foldersAPI;
@property (nonatomic, strong) MendeleyGroupsAPI *groupsAPI;
@property (nonatomic, strong) MendeleyMetadataAPI *metedataAPI;
@property (nonatomic, strong) MendeleyProfilesAPI *profilesAPI;

@end

@implementation MendeleyKit


#pragma mark -
#pragma mark SDK configuration

+ (MendeleyKit *)sharedInstance
{
    static MendeleyKit *sharedInstance = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
                      sharedInstance = [[MendeleyKit alloc] init];
                  });
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (nil != self)
    {
        _configuration = [MendeleyKitConfiguration sharedInstance];
        _networkProvider =  [MendeleyKitConfiguration sharedInstance].networkProvider;
        [self updateConfiguration];
        [self initialLoginStatus];
    }
    return self;
}

- (void)changeNetworkProviderWithClassName:(NSString *)networkProviderClassName
{
    NSDictionary *providerDict = @{ kMendeleyNetworkProviderKey : networkProviderClassName };

    [self.configuration changeConfigurationWithParameters:providerDict];
    self.networkProvider = self.configuration.networkProvider;
    [self updateConfiguration];
}

- (void)updateConfiguration
{
    NSURL *baseURL = self.configuration.baseAPIURL;

    self.documentsAPI = [[MendeleyDocumentsAPI alloc] initWithNetworkProvider:self.networkProvider
                                                                      baseURL:baseURL];

    self.filesAPI = [[MendeleyFilesAPI alloc] initWithNetworkProvider:self.networkProvider
                                                              baseURL:baseURL];

    self.foldersAPI = [[MendeleyFoldersAPI alloc] initWithNetworkProvider:self.networkProvider
                                                                  baseURL:baseURL];

    self.groupsAPI = [[MendeleyGroupsAPI alloc] initWithNetworkProvider:self.networkProvider
                                                                baseURL:baseURL];

    self.annotationsAPI = [[MendeleyAnnotationsAPI alloc] initWithNetworkProvider:self.networkProvider
                                                                          baseURL:baseURL];

    self.metedataAPI = [[MendeleyMetadataAPI alloc] initWithNetworkProvider:self.networkProvider baseURL:baseURL];

    self.profilesAPI = [[MendeleyProfilesAPI alloc] initWithNetworkProvider:self.networkProvider baseURL:baseURL];
}

- (BOOL)isAuthenticated
{
    MendeleyOAuthStore *store = [[MendeleyOAuthStore alloc] init];
    MendeleyOAuthCredentials *credentials = [store retrieveOAuthCredentials];

    _loggedIn = (nil != credentials);
    return _loggedIn;
}

- (void)initialLoginStatus
{
    MendeleyOAuthStore *store = [[MendeleyOAuthStore alloc] init];
    MendeleyOAuthCredentials *credentials = [store retrieveOAuthCredentials];

    if (nil != credentials)
    {
        self.loggedIn = YES;
    }
    else
    {
        self.loggedIn = NO;
    }
}

- (void)clearAuthentication
{
    MendeleyOAuthStore *store = [[MendeleyOAuthStore alloc] init];

    [store removeOAuthCredentials];
}

- (void)pagedListOfObjectsWithLinkedURL:(NSURL *)linkURL
                          expectedModel:(NSString *)expectedModel
                        completionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    if ([expectedModel isEqualToString:NSStringFromClass([MendeleyDocument class])])
    {
        [self documentListWithLinkedURL:linkURL completionBlock:completionBlock];
    }
    else if ([expectedModel isEqualToString:NSStringFromClass([MendeleyFolder class])])
    {
        [self folderListWithLinkedURL:linkURL completionBlock:completionBlock];
    }
    else if ([expectedModel isEqualToString:NSStringFromClass([MendeleyGroup class])])
    {
        [self groupListWithLinkedURL:linkURL completionBlock:completionBlock];
    }
    else if ([expectedModel isEqualToString:NSStringFromClass([MendeleyFile class])])
    {
        [self fileListWithLinkedURL:linkURL completionBlock:completionBlock];
    }
    else if ([expectedModel isEqualToString:kMendeleyModelDocumentId])
    {
        [self documentListInFolderWithLinkedURL:linkURL completionBlock:completionBlock];
    }
    else if ([expectedModel isEqualToString:NSStringFromClass([MendeleyAnnotation class])])
    {
        [self annotationListWithLinkedURL:linkURL completionBlock:completionBlock];
    }
    else
    {
        NSError *error = [[MendeleyErrorManager sharedInstance] errorWithDomain:kMendeleyErrorDomain code:kMendeleyPagingNotProvidedForThisType];
        completionBlock(nil, nil, error);
    }
}

#pragma mark -
#pragma mark Profiles

- (void)pullMyProfile:(MendeleyObjectCompletionBlock)completionBlock
{
    if (self.isAuthenticated)
    {
        [MendeleyOAuthTokenHelper refreshTokenWithRefreshBlock:^(BOOL success, NSError *error) {
             if (success)
             {
                 [self.profilesAPI pullMyProfile:completionBlock];
             }
             else
             {
                 completionBlock(nil, nil, error);
             }
         }];
    }
    else
    {
        NSError *unauthorisedError = [NSError errorWithCode:kMendeleyUnauthorizedErrorCode];
        completionBlock(nil, nil, unauthorisedError);
    }

}

- (void)pullProfile:(NSString *)profileID
    completionBlock:(MendeleyObjectCompletionBlock)completionBlock
{
    if (self.isAuthenticated)
    {
        [MendeleyOAuthTokenHelper refreshTokenWithRefreshBlock:^(BOOL success, NSError *error) {
             if (success)
             {
                 [self.profilesAPI pullProfile:profileID completionBlock:completionBlock];
             }
             else
             {
                 completionBlock(nil, nil, error);
             }
         }];
    }
    else
    {
        NSError *unauthorisedError = [NSError errorWithCode:kMendeleyUnauthorizedErrorCode];
        completionBlock(nil, nil, unauthorisedError);
    }

}



#pragma mark -
#pragma mark Documents

- (void)documentListWithLinkedURL:(NSURL *)linkURL
                  completionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    if (self.isAuthenticated)
    {
        [MendeleyOAuthTokenHelper refreshTokenWithRefreshBlock: ^(BOOL success, NSError *error) {
             if (success)
             {
                 [self.documentsAPI documentListWithLinkedURL:linkURL completionBlock:completionBlock];
             }
             else
             {
                 completionBlock(nil, nil, error);
             }
         }];
    }
    else
    {
        NSError *unauthorisedError = [NSError errorWithCode:kMendeleyUnauthorizedErrorCode];
        completionBlock(nil, nil, unauthorisedError);
    }
}

- (void)documentListWithQueryParameters:(MendeleyDocumentParameters *)queryParameters
                        completionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    if (self.isAuthenticated)
    {
        [MendeleyOAuthTokenHelper refreshTokenWithRefreshBlock: ^(BOOL success, NSError *error) {
             if (success)
             {
                 [self.documentsAPI documentListWithQueryParameters:queryParameters completionBlock:completionBlock];
             }
             else
             {
                 completionBlock(nil, nil, error);
             }
         }];
    }
    else
    {
        NSError *unauthorisedError = [NSError errorWithCode:kMendeleyUnauthorizedErrorCode];
        completionBlock(nil, nil, unauthorisedError);
    }
}

- (void)documentWithDocumentID:(NSString *)documentID
               completionBlock:(MendeleyObjectCompletionBlock)completionBlock
{
    if (self.isAuthenticated)
    {
        [MendeleyOAuthTokenHelper refreshTokenWithRefreshBlock: ^(BOOL success, NSError *error) {
             if (success)
             {
                 [self.documentsAPI documentWithDocumentID:documentID
                                           completionBlock:completionBlock];
             }
             else
             {
                 completionBlock(nil, nil, error);
             }
         }];
    }
    else
    {
        NSError *unauthorisedError = [NSError errorWithCode:kMendeleyUnauthorizedErrorCode];
        completionBlock(nil, nil, unauthorisedError);
    }
}


- (void)catalogDocumentWithCatalogID:(NSString *)catalogID
                     completionBlock:(MendeleyObjectCompletionBlock)completionBlock
{
    if (self.isAuthenticated)
    {
        [MendeleyOAuthTokenHelper refreshTokenWithRefreshBlock:^(BOOL success, NSError *error) {
             if (success)
             {
                 [self.documentsAPI catalogDocumentWithCatalogID:catalogID
                                                 completionBlock:completionBlock];
             }
             else
             {
                 completionBlock(nil, nil, error);
             }
         }];
    }
    else
    {
        NSError *unauthorisedError = [NSError errorWithCode:kMendeleyUnauthorizedErrorCode];
        completionBlock(nil, nil, unauthorisedError);
    }
}

- (void)catalogDocumentWithParameters:(MendeleyCatalogParameters *)queryParameters
                      completionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    if (self.isAuthenticated)
    {
        [MendeleyOAuthTokenHelper refreshTokenWithRefreshBlock:^(BOOL success, NSError *error) {
             if (success)
             {
                 [self.documentsAPI catalogDocumentWithParameters:queryParameters
                                                  completionBlock:completionBlock];
             }
             else
             {
                 completionBlock(nil, nil, error);
             }
         }];
    }
    else
    {
        NSError *unauthorisedError = [NSError errorWithCode:kMendeleyUnauthorizedErrorCode];
        completionBlock(nil, nil, unauthorisedError);
    }

}

- (void)createDocument:(MendeleyDocument *)mendeleyDocument
       completionBlock:(MendeleyObjectCompletionBlock)completionBlock
{
    if (self.isAuthenticated)
    {
        [MendeleyOAuthTokenHelper refreshTokenWithRefreshBlock: ^(BOOL success, NSError *error) {
             if (success)
             {
                 [self.documentsAPI createDocument:mendeleyDocument completionBlock:completionBlock];
             }
             else
             {
                 completionBlock(nil, nil, error);
             }
         }];
    }
    else
    {
        NSError *unauthorisedError = [NSError errorWithCode:kMendeleyUnauthorizedErrorCode];
        completionBlock(nil, nil, unauthorisedError);
    }
}

- (void)updateDocument:(MendeleyDocument *)updatedDocument
       completionBlock:(MendeleyObjectCompletionBlock)completionBlock
{
    if (self.isAuthenticated)
    {
        [MendeleyOAuthTokenHelper refreshTokenWithRefreshBlock:^(BOOL success, NSError *error) {
             if (success)
             {
                 [self.documentsAPI updateDocument:updatedDocument completionBlock:completionBlock];
             }
             else
             {
                 completionBlock(nil, nil, error);
             }
         }];
    }
    else
    {
        NSError *unauthorisedError = [NSError errorWithCode:kMendeleyUnauthorizedErrorCode];
        completionBlock(nil, nil, unauthorisedError);
    }
}


- (void)deleteDocumentWithID:(NSString *)documentID
             completionBlock:(MendeleyCompletionBlock)completionBlock
{
    if (self.isAuthenticated)
    {
        [MendeleyOAuthTokenHelper refreshTokenWithRefreshBlock: ^(BOOL success, NSError *error) {
             if (success)
             {
                 [self.documentsAPI deleteDocumentWithID:documentID completionBlock:completionBlock];
             }
             else
             {
                 completionBlock(NO, error);
             }
         }];
    }
    else
    {
        NSError *unauthorisedError = [NSError errorWithCode:kMendeleyUnauthorizedErrorCode];
        completionBlock(NO, unauthorisedError);
    }
}

- (void)trashDocumentWithID:(NSString *)documentID
            completionBlock:(MendeleyCompletionBlock)completionBlock
{
    if (self.isAuthenticated)
    {
        [MendeleyOAuthTokenHelper refreshTokenWithRefreshBlock: ^(BOOL success, NSError *error) {
             if (success)
             {
                 [self.documentsAPI trashDocumentWithID:documentID completionBlock:completionBlock];
             }
             else
             {
                 completionBlock(NO, error);
             }
         }];
    }
    else
    {
        NSError *unauthorisedError = [NSError errorWithCode:kMendeleyUnauthorizedErrorCode];
        completionBlock(NO, unauthorisedError);
    }
}

- (void)deletedDocumentsSince:(NSDate *)deletedSince
              completionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    if (self.isAuthenticated)
    {
        [MendeleyOAuthTokenHelper refreshTokenWithRefreshBlock: ^(BOOL success, NSError *error) {
             if (success)
             {
                 [self.documentsAPI deletedDocumentsSince:deletedSince completionBlock:completionBlock];
             }
             else
             {
                 completionBlock(nil, nil, error);
             }
         }];
    }
    else
    {
        NSError *unauthorisedError = [NSError errorWithCode:kMendeleyUnauthorizedErrorCode];
        completionBlock(nil, nil, unauthorisedError);
    }
}

- (void)trashedDocumentListWithLinkedURL:(NSURL *)linkURL
                         completionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    if (self.isAuthenticated)
    {
        [MendeleyOAuthTokenHelper refreshTokenWithRefreshBlock: ^(BOOL success, NSError *error) {
             if (success)
             {
                 [self.documentsAPI trashedDocumentListWithLinkedURL:linkURL completionBlock:completionBlock];
             }
             else
             {
                 completionBlock(nil, nil, error);
             }
         }];
    }
    else
    {
        NSError *unauthorisedError = [NSError errorWithCode:kMendeleyUnauthorizedErrorCode];
        completionBlock(nil, nil, unauthorisedError);
    }
}

- (void)trashedDocumentListWithQueryParameters:(MendeleyDocumentParameters *)queryParameters
                               completionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    if (self.isAuthenticated)
    {
        [MendeleyOAuthTokenHelper refreshTokenWithRefreshBlock: ^(BOOL success, NSError *error) {
             if (success)
             {
                 [self.documentsAPI trashedDocumentListWithQueryParameters:queryParameters completionBlock:completionBlock];
             }
             else
             {
                 completionBlock(nil, nil, error);
             }
         }];
    }
    else
    {
        NSError *unauthorisedError = [NSError errorWithCode:kMendeleyUnauthorizedErrorCode];
        completionBlock(nil, nil, unauthorisedError);
    }
}

- (void)deleteTrashedDocumentWithID:(NSString *)documentID
                    completionBlock:(MendeleyCompletionBlock)completionBlock
{
    if (self.isAuthenticated)
    {
        [MendeleyOAuthTokenHelper refreshTokenWithRefreshBlock: ^(BOOL success, NSError *error) {
             if (success)
             {
                 [self.documentsAPI deleteTrashedDocumentWithID:documentID completionBlock:completionBlock];
             }
             else
             {
                 completionBlock(NO, error);
             }
         }];
    }
    else
    {
        NSError *unauthorisedError = [NSError errorWithCode:kMendeleyUnauthorizedErrorCode];
        completionBlock(NO, unauthorisedError);
    }
}

- (void)restoreTrashedDocumentWithID:(NSString *)documentID
                     completionBlock:(MendeleyCompletionBlock)completionBlock
{
    if (self.isAuthenticated)
    {
        [MendeleyOAuthTokenHelper refreshTokenWithRefreshBlock: ^(BOOL success, NSError *error) {
             if (success)
             {
                 [self.documentsAPI restoreTrashedDocumentWithID:documentID completionBlock:completionBlock];
             }
             else
             {
                 completionBlock(NO, error);
             }
         }];
    }
    else
    {
        NSError *unauthorisedError = [NSError errorWithCode:kMendeleyUnauthorizedErrorCode];
        completionBlock(NO, unauthorisedError);
    }
}

- (void)trashedDocumentWithDocumentID:(NSString *)documentID
                      completionBlock:(MendeleyObjectCompletionBlock)completionBlock
{
    if (self.isAuthenticated)
    {
        [MendeleyOAuthTokenHelper refreshTokenWithRefreshBlock: ^(BOOL success, NSError *error) {
             if (success)
             {
                 [self.documentsAPI trashedDocumentWithDocumentID:documentID completionBlock:completionBlock];
             }
             else
             {
                 completionBlock(nil, nil, error);
             }
         }];
    }
    else
    {
        NSError *unauthorisedError = [NSError errorWithCode:kMendeleyUnauthorizedErrorCode];
        completionBlock(nil, nil, unauthorisedError);
    }
}

- (MendeleyTask *)documentFromFileWithURL:(NSURL *)fileURL mimeType:(NSString *)mimeType completionBlock:(MendeleyObjectCompletionBlock)completionBlock
{
    __block MendeleyTask *task;
    
    if (self.isAuthenticated)
    {
        [MendeleyOAuthTokenHelper refreshTokenWithRefreshBlock: ^(BOOL success, NSError *error) {
            if (success)
            {
                task = [self.documentsAPI documentFromFileWithURL:fileURL mimeType:mimeType completionBlock:completionBlock];
            }
            else
            {
                task = nil;
                completionBlock(nil, nil, error);
            }
        }];
    }
    else
    {
        task = nil;
        NSError *unauthorisedError = [NSError errorWithCode:kMendeleyUnauthorizedErrorCode];
        completionBlock(nil, nil, unauthorisedError);
    }
    return task;
}


#pragma mark -
#pragma mark Metadata

- (void)metadataLookupWithQueryParameters:(MendeleyMetadataParameters *)queryParameters completionBlock:(MendeleyObjectCompletionBlock)completionBlock
{
    if (self.isAuthenticated)
    {
        [MendeleyOAuthTokenHelper refreshTokenWithRefreshBlock: ^(BOOL success, NSError *error) {
             if (success)
             {
                 [self.metedataAPI metadataLookupWithQueryParameters:queryParameters
                                                     completionBlock:completionBlock];
             }
             else
             {
                 completionBlock(nil, nil, error);
             }
         }];
    }
    else
    {
        NSError *unauthorisedError = [NSError errorWithCode:kMendeleyUnauthorizedErrorCode];
        completionBlock(nil, nil, unauthorisedError);
    }
}

#pragma mark -
#pragma mark Document Types

- (void)documentTypesWithCompletionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    if (self.isAuthenticated)
    {
        [MendeleyOAuthTokenHelper refreshTokenWithRefreshBlock: ^(BOOL success, NSError *error) {
             if (success)
             {
                 [self.documentsAPI documentTypesWithCompletionBlock:completionBlock];
             }
             else
             {
                 completionBlock(nil, nil, error);
             }
         }];
    }
    else
    {
        NSError *unauthorisedError = [NSError errorWithCode:kMendeleyUnauthorizedErrorCode];
        completionBlock(nil, nil, unauthorisedError);
    }
}

#pragma mark -
#pragma mark Document Identifiers

- (void)identifierTypesWithCompletionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    if (self.isAuthenticated)
    {
        [MendeleyOAuthTokenHelper refreshTokenWithRefreshBlock: ^(BOOL success, NSError *error) {
             if (success)
             {
                 [self.documentsAPI identifierTypesWithCompletionBlock:completionBlock];
             }
             else
             {
                 completionBlock(nil, nil, error);
             }
         }];
    }
    else
    {
        NSError *unauthorisedError = [NSError errorWithCode:kMendeleyUnauthorizedErrorCode];
        completionBlock(nil, nil, unauthorisedError);
    }
}

#pragma mark -
#pragma mark Files

- (void)fileListWithQueryParameters:(MendeleyFileParameters *)queryParameters
                    completionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    if (self.isAuthenticated)
    {
        [MendeleyOAuthTokenHelper refreshTokenWithRefreshBlock: ^(BOOL success, NSError *error) {
             if (success)
             {
                 [self.filesAPI fileListWithQueryParameters:queryParameters completionBlock:completionBlock];
             }
             else
             {
                 completionBlock(nil, nil, error);
             }
         }];
    }
    else
    {
        NSError *unauthorisedError = [NSError errorWithCode:kMendeleyUnauthorizedErrorCode];
        completionBlock(nil, nil, unauthorisedError);
    }
}

- (MendeleyTask *)fileWithFileID:(NSString *)fileID
                       saveToURL:(NSURL *)fileURL
                   progressBlock:(MendeleyResponseProgressBlock)progressBlock
                 completionBlock:(MendeleyCompletionBlock)completionBlock
{
    __block MendeleyTask *task;

    if (self.isAuthenticated)
    {
        [MendeleyOAuthTokenHelper refreshTokenWithRefreshBlock: ^(BOOL success, NSError *error) {
             if (success)
             {
                 task = [self.filesAPI fileWithFileID:fileID saveToURL:fileURL progressBlock:progressBlock completionBlock:completionBlock];
             }
             else
             {
                 task = nil;
                 completionBlock(NO, error);
             }
         }];
    }
    else
    {
        task = nil;
        NSError *unauthorisedError = [NSError errorWithCode:kMendeleyUnauthorizedErrorCode];
        completionBlock(NO, unauthorisedError);
    }
    return task;
}

- (void)           createFile:(NSURL *)fileURL
    relativeToDocumentURLPath:(NSString *)documentURLPath
                progressBlock:(MendeleyResponseProgressBlock)progressBlock
              completionBlock:(MendeleyObjectCompletionBlock)completionBlock
{
    if (self.isAuthenticated)
    {
        [MendeleyOAuthTokenHelper refreshTokenWithRefreshBlock: ^(BOOL success, NSError *error) {
             if (success)
             {
                 [self.filesAPI createFile:fileURL relativeToDocumentURLPath:documentURLPath progressBlock:progressBlock completionBlock:completionBlock];
             }
             else
             {
                 completionBlock(nil, nil, error);
             }
         }];
    }
    else
    {
        NSError *unauthorisedError = [NSError errorWithCode:kMendeleyUnauthorizedErrorCode];
        completionBlock(nil, nil, unauthorisedError);
    }
}

- (void)deleteFileWithID:(NSString *)fileID
         completionBlock:(MendeleyCompletionBlock)completionBlock
{
    if (self.isAuthenticated)
    {
        [MendeleyOAuthTokenHelper refreshTokenWithRefreshBlock: ^(BOOL success, NSError *error) {
             if (success)
             {
                 [self.filesAPI deleteFileWithID:fileID completionBlock:completionBlock];
             }
             else
             {
                 completionBlock(NO, error);
             }
         }];
    }
    else
    {
        NSError *unauthorisedError = [NSError errorWithCode:kMendeleyUnauthorizedErrorCode];
        completionBlock(NO, unauthorisedError);
    }
}

- (void)fileListWithLinkedURL:(NSURL *)linkURL
              completionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    if (self.isAuthenticated)
    {
        [MendeleyOAuthTokenHelper refreshTokenWithRefreshBlock: ^(BOOL success, NSError *error) {
             if (success)
             {
                 [self.filesAPI fileListWithLinkedURL:linkURL completionBlock:completionBlock];
             }
             else
             {
                 completionBlock(nil, nil, error);
             }
         }];
    }
    else
    {
        NSError *unauthorisedError = [NSError errorWithCode:kMendeleyUnauthorizedErrorCode];
        completionBlock(nil, nil, unauthorisedError);
    }
}

- (void)deletedFilesSince:(NSDate *)deletedSince
          completionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    if (self.isAuthenticated)
    {
        [MendeleyOAuthTokenHelper refreshTokenWithRefreshBlock: ^(BOOL success, NSError *error) {
             if (success)
             {
                 [self.filesAPI deletedFilesSince:deletedSince completionBlock:completionBlock];
             }
             else
             {
                 completionBlock(nil, nil, error);
             }
         }];
    }
    else
    {
        NSError *unauthorisedError = [NSError errorWithCode:kMendeleyUnauthorizedErrorCode];
        completionBlock(nil, nil, unauthorisedError);
    }
}


#pragma mark -
#pragma mark Folder

- (void)documentListFromFolderWithID:(NSString *)folderID
                          parameters:(MendeleyFolderParameters *)queryParameters
                     completionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    if (self.isAuthenticated)
    {
        [MendeleyOAuthTokenHelper refreshTokenWithRefreshBlock: ^(BOOL success, NSError *error) {
             if (success)
             {
                 [self.foldersAPI documentListFromFolderWithID:folderID parameters:queryParameters completionBlock:completionBlock];
             }
             else
             {
                 completionBlock(nil, nil, error);
             }
         }];
    }
    else
    {
        NSError *unauthorisedError = [NSError errorWithCode:kMendeleyUnauthorizedErrorCode];
        completionBlock(nil, nil, unauthorisedError);
    }
}

- (void)addDocument:(NSString *)mendeleyDocumentId
           folderID:(NSString *)folderID
    completionBlock:(MendeleyCompletionBlock)completionBlock
{
    if (self.isAuthenticated)
    {
        [MendeleyOAuthTokenHelper refreshTokenWithRefreshBlock: ^(BOOL success, NSError *error) {
             if (success)
             {
                 [self.foldersAPI addDocument:mendeleyDocumentId folderID:folderID completionBlock:completionBlock];
             }
             else
             {
                 completionBlock(NO, error);
             }
         }];
    }
    else
    {
        NSError *unauthorisedError = [NSError errorWithCode:kMendeleyUnauthorizedErrorCode];
        completionBlock(NO, unauthorisedError);
    }
}

- (void)createFolder:(MendeleyFolder *)mendeleyFolder completionBlock:(MendeleyObjectCompletionBlock)completionBlock
{
    if (self.isAuthenticated)
    {
        [MendeleyOAuthTokenHelper refreshTokenWithRefreshBlock: ^(BOOL success, NSError *error) {
             if (success)
             {
                 [self.foldersAPI createFolder:mendeleyFolder completionBlock:completionBlock];
             }
             else
             {
                 completionBlock(nil, nil, error);
             }
         }];
    }
    else
    {
        NSError *unauthorisedError = [NSError errorWithCode:kMendeleyUnauthorizedErrorCode];
        completionBlock(nil, nil, unauthorisedError);
    }
}

- (void)folderListWithLinkedURL:(NSURL *)linkURL
                completionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    if (self.isAuthenticated)
    {
        [MendeleyOAuthTokenHelper refreshTokenWithRefreshBlock: ^(BOOL success, NSError *error) {
             if (success)
             {
                 [self.foldersAPI folderListWithLinkedURL:linkURL completionBlock:completionBlock];
             }
             else
             {
                 completionBlock(nil, nil, error);
             }
         }];
    }
    else
    {
        NSError *unauthorisedError = [NSError errorWithCode:kMendeleyUnauthorizedErrorCode];
        completionBlock(nil, nil, unauthorisedError);
    }
}

- (void)documentListInFolderWithLinkedURL:(NSURL *)linkURL
                          completionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    if (self.isAuthenticated)
    {
        [MendeleyOAuthTokenHelper refreshTokenWithRefreshBlock: ^(BOOL success, NSError *error) {
             if (success)
             {
                 [self.foldersAPI documentListInFolderWithLinkedURL:linkURL completionBlock:completionBlock];
             }
             else
             {
                 completionBlock(nil, nil, error);
             }
         }];
    }
    else
    {
        NSError *unauthorisedError = [NSError errorWithCode:kMendeleyUnauthorizedErrorCode];
        completionBlock(nil, nil, unauthorisedError);
    }
}

- (void)folderListWithQueryParameters:(MendeleyFolderParameters *)queryParameters completionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    if (self.isAuthenticated)
    {
        [MendeleyOAuthTokenHelper refreshTokenWithRefreshBlock: ^(BOOL success, NSError *error) {
             if (success)
             {
                 [self.foldersAPI folderListWithQueryParameters:queryParameters completionBlock:completionBlock];
             }
             else
             {
                 completionBlock(nil, nil, error);
             }
         }];
    }
    else
    {
        NSError *unauthorisedError = [NSError errorWithCode:kMendeleyUnauthorizedErrorCode];
        completionBlock(nil, nil, unauthorisedError);
    }
}

- (void)folderWithFolderID:(NSString *)folderID completionBlock:(MendeleyObjectCompletionBlock)completionBlock
{
    if (self.isAuthenticated)
    {
        [MendeleyOAuthTokenHelper refreshTokenWithRefreshBlock: ^(BOOL success, NSError *error) {
             if (success)
             {
                 [self.foldersAPI folderWithFolderID:folderID completionBlock:completionBlock];
             }
             else
             {
                 completionBlock(nil, nil, error);
             }
         }];
    }
    else
    {
        NSError *unauthorisedError = [NSError errorWithCode:kMendeleyUnauthorizedErrorCode];
        completionBlock(nil, nil, unauthorisedError);
    }
}

- (void)deleteFolderWithID:(NSString *)folderID completionBlock:(MendeleyCompletionBlock)completionBlock
{
    if (self.isAuthenticated)
    {
        [MendeleyOAuthTokenHelper refreshTokenWithRefreshBlock: ^(BOOL success, NSError *error) {
             if (success)
             {
                 [self.foldersAPI deleteFolderWithID:folderID completionBlock:completionBlock];
             }
             else
             {
                 completionBlock(NO, error);
             }
         }];
    }
    else
    {
        NSError *unauthorisedError = [NSError errorWithCode:kMendeleyUnauthorizedErrorCode];
        completionBlock(NO, unauthorisedError);
    }
}

- (void)updateFolder:(MendeleyFolder *)updatedFolder
     completionBlock:(MendeleyCompletionBlock)completionBlock;
{
    [self.foldersAPI updateFolder:updatedFolder completionBlock:completionBlock];
}

- (void)deleteDocumentWithID:(NSString *)documentID fromFolderWithID:(NSString *)folderID completionBlock:(MendeleyCompletionBlock)completionBlock
{
    if (self.isAuthenticated)
    {
        [MendeleyOAuthTokenHelper refreshTokenWithRefreshBlock: ^(BOOL success, NSError *error) {
             if (success)
             {
                 [self.foldersAPI deleteDocumentWithID:documentID fromFolderWithID:folderID completionBlock:completionBlock];
             }
             else
             {
                 completionBlock(NO, error);
             }
         }];
    }
    else
    {
        NSError *unauthorisedError = [NSError errorWithCode:kMendeleyUnauthorizedErrorCode];
        completionBlock(NO, unauthorisedError);
    }
}

#pragma mark -
#pragma mark Groups
- (void)groupListWithQueryParameters:(MendeleyGroupParameters *)queryParameters
                            iconType:(MendeleyGroupIconType)iconType
                     completionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    if (self.isAuthenticated)
    {
        [MendeleyOAuthTokenHelper refreshTokenWithRefreshBlock: ^(BOOL success, NSError *error) {
             if (success)
             {
                 [self.groupsAPI groupListWithQueryParameters:queryParameters
                                                     iconType:iconType
                                              completionBlock:completionBlock];
             }
             else
             {
                 completionBlock(nil, nil, error);
             }
         }];
    }
    else
    {
        NSError *unauthorisedError = [NSError errorWithCode:kMendeleyUnauthorizedErrorCode];
        completionBlock(nil, nil, unauthorisedError);
    }

}

- (void)groupListWithLinkedURL:(NSURL *)linkURL
                      iconType:(MendeleyGroupIconType)iconType
               completionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    if (self.isAuthenticated)
    {
        [MendeleyOAuthTokenHelper refreshTokenWithRefreshBlock: ^(BOOL success, NSError *error) {
             if (success)
             {
                 [self.groupsAPI groupListWithLinkedURL:linkURL
                                               iconType:iconType
                                        completionBlock:completionBlock];
             }
             else
             {
                 completionBlock(nil, nil, error);
             }
         }];
    }
    else
    {
        NSError *unauthorisedError = [NSError errorWithCode:kMendeleyUnauthorizedErrorCode];
        completionBlock(nil, nil, unauthorisedError);
    }

}

- (void)groupWithGroupID:(NSString *)groupID
                iconType:(MendeleyGroupIconType)iconType
         completionBlock:(MendeleyObjectCompletionBlock)completionBlock
{
    if (self.isAuthenticated)
    {
        [MendeleyOAuthTokenHelper refreshTokenWithRefreshBlock: ^(BOOL success, NSError *error) {
             if (success)
             {
                 [self.groupsAPI groupWithGroupID:groupID
                                         iconType:iconType
                                  completionBlock:completionBlock];
             }
             else
             {
                 completionBlock(nil, nil, error);
             }
         }];
    }
    else
    {
        NSError *unauthorisedError = [NSError errorWithCode:kMendeleyUnauthorizedErrorCode];
        completionBlock(nil, nil, unauthorisedError);
    }

}

- (void)groupListWithQueryParameters:(MendeleyGroupParameters *)queryParameters
                     completionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    if (self.isAuthenticated)
    {
        [MendeleyOAuthTokenHelper refreshTokenWithRefreshBlock: ^(BOOL success, NSError *error) {
             if (success)
             {
                 [self.groupsAPI groupListWithQueryParameters:queryParameters
                                              completionBlock:completionBlock];
             }
             else
             {
                 completionBlock(nil, nil, error);
             }
         }];
    }
    else
    {
        NSError *unauthorisedError = [NSError errorWithCode:kMendeleyUnauthorizedErrorCode];
        completionBlock(nil, nil, unauthorisedError);
    }
}

- (void)groupListWithLinkedURL:(NSURL *)linkURL
               completionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    if (self.isAuthenticated)
    {
        [MendeleyOAuthTokenHelper refreshTokenWithRefreshBlock: ^(BOOL success, NSError *error) {
             if (success)
             {
                 [self.groupsAPI groupListWithLinkedURL:linkURL
                                        completionBlock:completionBlock];
             }
             else
             {
                 completionBlock(nil, nil, error);
             }
         }];
    }
    else
    {
        NSError *unauthorisedError = [NSError errorWithCode:kMendeleyUnauthorizedErrorCode];
        completionBlock(nil, nil, unauthorisedError);
    }
}

- (void)groupWithGroupID:(NSString *)groupID
         completionBlock:(MendeleyObjectCompletionBlock)completionBlock
{
    if (self.isAuthenticated)
    {
        [MendeleyOAuthTokenHelper refreshTokenWithRefreshBlock: ^(BOOL success, NSError *error) {
             if (success)
             {
                 [self.groupsAPI groupWithGroupID:groupID
                                  completionBlock:completionBlock];
             }
             else
             {
                 completionBlock(nil, nil, error);
             }
         }];
    }
    else
    {
        NSError *unauthorisedError = [NSError errorWithCode:kMendeleyUnauthorizedErrorCode];
        completionBlock(nil, nil, unauthorisedError);
    }
}

- (void)groupIconForGroup:(MendeleyGroup *)group
                 iconType:(MendeleyGroupIconType)iconType
          completionBlock:(MendeleyBinaryDataCompletionBlock)completionBlock
{
    /*
       Note: this call doesn't require an authentication header
     */
    [self.groupsAPI groupIconForGroup:group iconType:iconType completionBlock:completionBlock];
}


- (void)groupIconForIconURLString:(NSString *)iconURLString
                  completionBlock:(MendeleyBinaryDataCompletionBlock)completionBlock
{
    /*
       Note: this call doesn't require an authentication header
     */
    [self.groupsAPI groupIconForIconURLString:iconURLString completionBlock:completionBlock];

}


#pragma mark -
#pragma mark Annotations

- (void)annotationWithAnnotationID:(NSString *)annotationID
                   completionBlock:(MendeleyObjectCompletionBlock)completionBlock
{
    if (self.isAuthenticated)
    {
        [MendeleyOAuthTokenHelper refreshTokenWithRefreshBlock: ^(BOOL success, NSError *error) {
             if (success)
             {
                 [self.annotationsAPI annotationWithAnnotationID:annotationID completionBlock:completionBlock];
             }
             else
             {
                 completionBlock(nil, nil, error);
             }
         }];
    }
    else
    {
        NSError *unauthorisedError = [NSError errorWithCode:kMendeleyUnauthorizedErrorCode];
        completionBlock(nil, nil, unauthorisedError);
    }
}

- (void)deleteAnnotationWithID:(NSString *)annotationID
               completionBlock:(MendeleyCompletionBlock)completionBlock
{
    if (self.isAuthenticated)
    {
        [MendeleyOAuthTokenHelper refreshTokenWithRefreshBlock: ^(BOOL success, NSError *error) {
             if (success)
             {
                 [self.annotationsAPI deleteAnnotationWithID:annotationID completionBlock:completionBlock];
             }
             else
             {
                 completionBlock(NO, error);
             }
         }];
    }
    else
    {
        NSError *unauthorisedError = [NSError errorWithCode:kMendeleyUnauthorizedErrorCode];
        completionBlock(NO, unauthorisedError);
    }
}

- (void)updateAnnotation:(MendeleyAnnotation *)updatedMendeleyAnnotation
         completionBlock:(MendeleyObjectCompletionBlock)completionBlock
{
    if (self.isAuthenticated)
    {
        [MendeleyOAuthTokenHelper refreshTokenWithRefreshBlock: ^(BOOL success, NSError *error) {
             if (success)
             {
                 [self.annotationsAPI updateAnnotation:updatedMendeleyAnnotation completionBlock:completionBlock];
             }
             else
             {
                 completionBlock(nil, nil, error);
             }
         }];
    }
    else
    {
        NSError *unauthorisedError = [NSError errorWithCode:kMendeleyUnauthorizedErrorCode];
        completionBlock(nil, nil, unauthorisedError);
    }
}

- (void)createAnnotation:(MendeleyAnnotation *)mendeleyAnnotation
         completionBlock:(MendeleyObjectCompletionBlock)completionBlock
{
    if (self.isAuthenticated)
    {
        [MendeleyOAuthTokenHelper refreshTokenWithRefreshBlock: ^(BOOL success, NSError *error) {
             if (success)
             {
                 [self.annotationsAPI createAnnotation:mendeleyAnnotation completionBlock:completionBlock];
             }
             else
             {
                 completionBlock(nil, nil, error);
             }
         }];
    }
    else
    {
        NSError *unauthorisedError = [NSError errorWithCode:kMendeleyUnauthorizedErrorCode];
        completionBlock(nil, nil, unauthorisedError);
    }
}

- (void)annotationListWithLinkedURL:(NSURL *)linkURL
                    completionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    if (self.isAuthenticated)
    {
        [MendeleyOAuthTokenHelper refreshTokenWithRefreshBlock:^(BOOL success, NSError *error) {
             if (success)
             {
                 [self.annotationsAPI annotationListWithLinkedURL:linkURL completionBlock:completionBlock];
             }
             else
             {
                 completionBlock(nil, nil, error);
             }


         }];
    }
    else
    {
        NSError *unauthorisedError = [NSError errorWithCode:kMendeleyUnauthorizedErrorCode];
        completionBlock(nil, nil, unauthorisedError);
    }

}


- (void)annotationListWithQueryParameters:(MendeleyAnnotationParameters *)queryParameters
                          completionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    if (self.isAuthenticated)
    {
        [MendeleyOAuthTokenHelper refreshTokenWithRefreshBlock: ^(BOOL success, NSError *error) {
             if (success)
             {
                 [self.annotationsAPI annotationListWithQueryParameters:queryParameters completionBlock:completionBlock];
             }
             else
             {
                 completionBlock(nil, nil, error);
             }
         }];
    }
    else
    {
        NSError *unauthorisedError = [NSError errorWithCode:kMendeleyUnauthorizedErrorCode];
        completionBlock(nil, nil, unauthorisedError);
    }
}

- (void)deletedAnnotationsSince:(NSDate *)deletedSince
                completionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    if (self.isAuthenticated)
    {
        [MendeleyOAuthTokenHelper refreshTokenWithRefreshBlock: ^(BOOL success, NSError *error) {
             if (success)
             {
                 [self.annotationsAPI deletedAnnotationsSince:deletedSince completionBlock:completionBlock];
             }
             else
             {
                 completionBlock(nil, nil, error);
             }
         }];
    }
    else
    {
        NSError *unauthorisedError = [NSError errorWithCode:kMendeleyUnauthorizedErrorCode];
        completionBlock(nil, nil, unauthorisedError);
    }
}

- (void) cancelTask:(MendeleyTask *)task
    completionBlock:(MendeleyCompletionBlock)completionBlock
{
    [self.networkProvider cancelTask:task completionBlock:completionBlock];
}

- (void)cancelAllTasks:(MendeleyCompletionBlock)completionBlock
{
    [self.networkProvider cancelAllTasks:completionBlock];
}

@end
