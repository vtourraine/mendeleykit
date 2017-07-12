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
#import "MendeleyAcademicStatusesAPI.h"
#import "MendeleyAnnotationsAPI.h"
#import "MendeleyDocumentsAPI.h"
#import "MendeleyFilesAPI.h"
#import "MendeleyFoldersAPI.h"
#import "MendeleyGroupsAPI.h"
#import "MendeleyMetadataAPI.h"
#import "MendeleyDatasetsAPI.h"
#import "NSError+MendeleyError.h"
#import "MendeleyProfilesAPI.h"
#import "MendeleyDisciplinesAPI.h"
#import "MendeleyFollowersAPI.h"
#import "MendeleyApplicationFeaturesAPI.h"
#import "MendeleyErrorManager.h"
#import "MendeleyPhotosMeAPI.h"
#import "MendeleyRecommendationsAPI.h"
#import "MendeleyFeedsAPI.h"
#import "MendeleySharesAPI.h"
#import "MendeleyUserPostsAPI.h"
#import "MendeleyCommentsAPI.h"


@interface MendeleyKit ()

@property (nonatomic, assign, readwrite) BOOL loggedIn;
@property (nonatomic, strong, nonnull) MendeleyKitConfiguration *configuration;
@property (nonatomic, strong, nonnull) id <MendeleyNetworkProvider> networkProvider;
@property (nonatomic, strong, nonnull) MendeleyAnnotationsAPI *annotationsAPI;
@property (nonatomic, strong, nonnull) MendeleyDocumentsAPI *documentsAPI;
@property (nonatomic, strong, nonnull) MendeleyFilesAPI *filesAPI;
@property (nonatomic, strong, nonnull) MendeleyFoldersAPI *foldersAPI;
@property (nonatomic, strong, nonnull) MendeleyGroupsAPI *groupsAPI;
@property (nonatomic, strong, nonnull) MendeleyMetadataAPI *metedataAPI;
@property (nonatomic, strong, nonnull) MendeleyProfilesAPI *profilesAPI;
@property (nonatomic, strong, nonnull) MendeleyDisciplinesAPI *disciplinesAPI;
@property (nonatomic, strong, nonnull) MendeleyAcademicStatusesAPI *academicStatusesAPI;
@property (nonatomic, strong, nonnull) MendeleyFollowersAPI *followersAPI;
@property (nonatomic, strong, nonnull) MendeleyDatasetsAPI *datasetsAPI;
@property (nonatomic, strong, nonnull) MendeleyApplicationFeaturesAPI *featuresAPI;
@property (nonatomic, strong, nonnull) MendeleyPhotosMeAPI *photosAPI;
@property (nonatomic, strong, nonnull) MendeleyRecommendationsAPI *recommendationsAPI;
@property (nonatomic, strong, nonnull) MendeleyFeedsAPI *feedsAPI;
@property (nonatomic, strong, nonnull) MendeleySharesAPI *sharesAPI;
@property (nonatomic, strong, nonnull) MendeleyUserPostsAPI *userPostsAPI;
@property (nonatomic, strong, nonnull) MendeleyCommentsAPI *commentsAPI;

@end

@implementation MendeleyKit


#pragma mark - SDK configuration

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

    self.documentsAPI = [[MendeleyDocumentsAPI alloc]
                         initWithNetworkProvider:self.networkProvider
                                         baseURL:baseURL];

    self.filesAPI = [[MendeleyFilesAPI alloc]
                     initWithNetworkProvider:self.networkProvider
                                     baseURL:baseURL];

    self.foldersAPI = [[MendeleyFoldersAPI alloc]
                       initWithNetworkProvider:self.networkProvider
                                       baseURL:baseURL];

    self.groupsAPI = [[MendeleyGroupsAPI alloc]
                      initWithNetworkProvider:self.networkProvider
                                      baseURL:baseURL];

    self.annotationsAPI = [[MendeleyAnnotationsAPI alloc]
                           initWithNetworkProvider:self.networkProvider
                                           baseURL:baseURL];

    self.metedataAPI = [[MendeleyMetadataAPI alloc]
                        initWithNetworkProvider:self.networkProvider
                                        baseURL:baseURL];

    self.profilesAPI = [[MendeleyProfilesAPI alloc]
                        initWithNetworkProvider:self.networkProvider
                                        baseURL:baseURL];

    self.disciplinesAPI = [[MendeleyDisciplinesAPI alloc]
                           initWithNetworkProvider:self.networkProvider
                                           baseURL:baseURL];

    self.academicStatusesAPI = [[MendeleyAcademicStatusesAPI alloc]
                                initWithNetworkProvider:self.networkProvider
                                                baseURL:baseURL];

    self.followersAPI = [[MendeleyFollowersAPI alloc]
                         initWithNetworkProvider:self.networkProvider
                                         baseURL:baseURL];

    self.datasetsAPI = [[MendeleyDatasetsAPI alloc]
                         initWithNetworkProvider:self.networkProvider
                         baseURL:baseURL];

    self.featuresAPI = [[MendeleyApplicationFeaturesAPI alloc]
                        initWithNetworkProvider:self.networkProvider
                        baseURL:baseURL];
    
    self.photosAPI = [[MendeleyPhotosMeAPI alloc]
                      initWithNetworkProvider: self.networkProvider
                      baseURL: baseURL];
    
    self.recommendationsAPI = [[MendeleyRecommendationsAPI alloc]
                               initWithNetworkProvider:self.networkProvider
                               baseURL:baseURL];
    
    self.feedsAPI = [[MendeleyFeedsAPI alloc] initWithNetworkProvider:self.networkProvider
                                                              baseURL:baseURL];
    
    self.sharesAPI = [[MendeleySharesAPI alloc] initWithNetworkProvider:self.networkProvider
                                                              baseURL:baseURL];
    
    self.userPostsAPI = [[MendeleyUserPostsAPI alloc] initWithNetworkProvider:self.networkProvider
                                                                      baseURL:baseURL];
    
    self.commentsAPI = [[MendeleyCommentsAPI alloc] initWithNetworkProvider:self.networkProvider
                                                                    baseURL:baseURL];
}

- (BOOL)isAuthenticated
{
    MendeleyOAuthCredentials *credentials = [MendeleyKitConfiguration.sharedInstance.storeProvider retrieveOAuthCredentials];

    _loggedIn = (nil != credentials);
    return _loggedIn;
}

- (void)initialLoginStatus
{
    MendeleyOAuthCredentials *credentials = [MendeleyKitConfiguration.sharedInstance.storeProvider retrieveOAuthCredentials];

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
    [MendeleyKitConfiguration.sharedInstance.storeProvider removeOAuthCredentials];
}

- (MendeleyTask *)checkAuthorisationStatusWithCompletionBlock:(MendeleyCompletionBlock)completionBlock
{
    if (!self.isAuthenticated)
    {
        if (completionBlock)
        {
            NSError *error = [[MendeleyErrorManager sharedInstance] errorWithDomain:kMendeleyErrorDomain code:kMendeleyUnauthorizedErrorCode];
            completionBlock(NO, error);
        }
        return nil;
    }
    MendeleyTask *task = [MendeleyTask new];
    MendeleyOAuthCredentials *credentials = [MendeleyKitConfiguration.sharedInstance.storeProvider retrieveOAuthCredentials];
    MendeleyKitConfiguration *configuration = [MendeleyKitConfiguration sharedInstance];
    [configuration.oauthProvider refreshTokenWithOAuthCredentials:credentials task:task completionBlock:^(MendeleyOAuthCredentials *updatedCredentials, NSError *error) {
         BOOL success = NO;
         if (nil != updatedCredentials)
         {
             [MendeleyKitConfiguration.sharedInstance.storeProvider storeOAuthCredentials:updatedCredentials];
             success = YES;
         }
         if (nil != completionBlock)
         {
             completionBlock(success, error);
         }
     }];
    return task;
}



- (MendeleyTask *)pagedListOfObjectsWithLinkedURL:(NSURL *)linkURL
                                    expectedModel:(NSString *)expectedModel
                                  completionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    if ([expectedModel isEqualToString:NSStringFromClass([MendeleyDocument class])])
    {
        return [self documentListWithLinkedURL:linkURL
                               completionBlock:completionBlock];
    }
    else if ([expectedModel isEqualToString:NSStringFromClass([MendeleyFolder class])])
    {
        return [self folderListWithLinkedURL:linkURL
                             completionBlock:completionBlock];
    }
    else if ([expectedModel isEqualToString:NSStringFromClass([MendeleyGroup class])])
    {
        return [self groupListWithLinkedURL:linkURL
                            completionBlock:completionBlock];
    }
    else if ([expectedModel isEqualToString:NSStringFromClass([MendeleyFile class])])
    {
        return [self fileListWithLinkedURL:linkURL
                           completionBlock:completionBlock];
    }
    else if ([expectedModel isEqualToString:kMendeleyModelDocumentId])
    {
        return [self documentListInFolderWithLinkedURL:linkURL
                                       completionBlock:completionBlock];
    }
    else if ([expectedModel isEqualToString:NSStringFromClass([MendeleyAnnotation class])])
    {
        return [self annotationListWithLinkedURL:linkURL
                                 completionBlock:completionBlock];
    }
    else
    {
        NSError *error = [[MendeleyErrorManager sharedInstance] errorWithDomain:kMendeleyErrorDomain
                                                                           code:kMendeleyPagingNotProvidedForThisType];
        completionBlock(nil, nil, error);
        return nil;
    }
}

#pragma mark - Academic Status (deprecated)
- (MendeleyTask *)academicStatusesWithCompletionBlock:(MendeleyArrayCompletionBlock)completionBlock __attribute__((deprecated))
{
    MendeleyTask *task = [MendeleyTask new];

    [self.academicStatusesAPI academicStatusesWithTask:task
                                       completionBlock:completionBlock];

    return task;
}


#pragma mark - Disciplines (deprecated)
- (MendeleyTask *)disciplinesWithCompletionBlock:(MendeleyArrayCompletionBlock)completionBlock __attribute__((deprecated))
{
    MendeleyTask *task = [MendeleyTask new];

    [self.disciplinesAPI disciplinesWithTask:task
                             completionBlock:completionBlock];
    return task;

}

#pragma mark - Subject areas and User roles
- (MendeleyTask *)userRolesWithCompletionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];
    [self.academicStatusesAPI userRolesWithTask:task completionBlock:completionBlock];
    return task;
}

- (MendeleyTask *)subjectAreasWithCompletionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];
    [self.disciplinesAPI subjectAreasWithTask:task completionBlock:completionBlock];
    return task;
}


#pragma mark - Authentication helper

- (void)checkAuthenticationThenRefreshTokenThenPerform:(void(^)())operationBlock completionBlock:(MendeleyCompletionBlock)completionBlock
{
    if (self.isAuthenticated)
    {
        [MendeleyOAuthTokenHelper refreshTokenWithRefreshBlock: ^(BOOL success, NSError *error) {
            if (success)
            {
                operationBlock();
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

- (void)checkAuthenticationThenRefreshTokenThenPerform:(void(^)())operationBlock objectCompletionBlock:(MendeleyObjectCompletionBlock)completionBlock
{
    if (self.isAuthenticated)
    {
        [MendeleyOAuthTokenHelper refreshTokenWithRefreshBlock:^(BOOL success, NSError *error) {
            if (success)
            {
                operationBlock();
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

- (void)checkAuthenticationThenRefreshTokenThenPerform:(void(^)())operationBlock arrayCompletionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    if (self.isAuthenticated)
    {
        [MendeleyOAuthTokenHelper refreshTokenWithRefreshBlock:^(BOOL success, NSError *error) {
            if (success)
            {
                operationBlock();
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


#pragma mark - Profiles

- (MendeleyTask *)pullMyProfile:(MendeleyObjectCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];

    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.profilesAPI pullMyProfileWithTask:task
                                completionBlock:completionBlock];
    } objectCompletionBlock:completionBlock];

    return task;
}

- (MendeleyTask *)pullProfile:(NSString *)profileID
              completionBlock:(MendeleyObjectCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];

    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.profilesAPI pullProfile:profileID
                                 task:task
                      completionBlock:completionBlock];
    } objectCompletionBlock:completionBlock];

    return task;
}
- (MendeleyTask *)profileIconForProfile:(MendeleyProfile *)profile
                               iconType:(MendeleyIconType)iconType
                        completionBlock:(MendeleyBinaryDataCompletionBlock)completionBlock
{
    /*
       Note: this call doesn't require an authentication header
     */
    MendeleyTask *task = [MendeleyTask new];

    [self.profilesAPI profileIconForProfile:profile iconType:iconType
                                       task:task
                            completionBlock:completionBlock];
    return task;
}

- (MendeleyTask *)profileIconForIconURLString:(NSString *)iconURLString
                              completionBlock:(MendeleyBinaryDataCompletionBlock)completionBlock
{
    /*
       Note: this call doesn't require an authentication header
     */
    MendeleyTask *task = [MendeleyTask new];

    [self.profilesAPI profileIconForIconURLString:iconURLString
                                             task:task
                                  completionBlock:completionBlock];
    return task;

}

- (MendeleyTask *)createProfile:(MendeleyNewProfile *)profile
                completionBlock:(MendeleyObjectCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];

    [self.profilesAPI createProfile:profile
                               task:task
                    completionBlock:completionBlock];
    return task;
}

- (MendeleyTask *)updateMyProfile:(MendeleyAmendmentProfile *)myProfile
                  completionBlock:(MendeleyObjectCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];

    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.profilesAPI updateMyProfile:myProfile
                                     task:task
                          completionBlock:completionBlock];
    } objectCompletionBlock:completionBlock];

    return task;

}

#pragma mark - Photos

- (MendeleyTask *)uploadPhotoWithFile:(NSURL *)fileURL
                contentType:(NSString *)contentType
              contentLength:(NSInteger)contentLength
              progressBlock:(MendeleyResponseProgressBlock)progressBlock
            completionBlock:(MendeleyCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];
    [self.photosAPI uploadPhotoWithFile:fileURL
                            contentType:contentType
                          contentLength:contentLength
                                   task:task
                          progressBlock:progressBlock
                        completionBlock:completionBlock];
    return task;
}


#pragma mark - Documents

- (MendeleyTask *)documentListWithLinkedURL:(NSURL *)linkURL
                            completionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];

    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.documentsAPI documentListWithLinkedURL:linkURL
                                                task:task
                                     completionBlock:completionBlock];
    } arrayCompletionBlock:completionBlock];

    return task;
}

- (MendeleyTask *)documentListWithQueryParameters:(MendeleyDocumentParameters *)queryParameters
                                  completionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];

    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.documentsAPI documentListWithQueryParameters:queryParameters
                                                      task:task
                                           completionBlock:completionBlock];
    } arrayCompletionBlock:completionBlock];

    return task;
}

- (MendeleyTask *)authoredDocumentListForUserWithProfileID:(NSString *)profileID
                                           queryParameters:(MendeleyDocumentParameters *)queryParameters
                                           completionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];

    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.documentsAPI authoredDocumentListForUserWithProfileID:profileID
                                                    queryParameters:queryParameters
                                                               task:task
                                                    completionBlock:completionBlock];
    } arrayCompletionBlock:completionBlock];

    return task;
}

- (MendeleyTask *)documentWithDocumentID:(NSString *)documentID
                         completionBlock:(MendeleyObjectCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];

    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.documentsAPI documentWithDocumentID:documentID
                                             task:task
                                  completionBlock:completionBlock];
    } objectCompletionBlock:completionBlock];

    return task;
}


- (MendeleyTask *)catalogDocumentWithCatalogID:(NSString *)catalogID
                               completionBlock:(MendeleyObjectCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];

    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.documentsAPI catalogDocumentWithCatalogID:catalogID
                                                   task:task
                                        completionBlock:completionBlock];
    } objectCompletionBlock:completionBlock];

    return task;
}

- (MendeleyTask *)catalogDocumentWithParameters:(MendeleyCatalogParameters *)queryParameters
                                completionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];

    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.documentsAPI catalogDocumentWithParameters:queryParameters
                                                    task:task
                                         completionBlock:completionBlock];
    } arrayCompletionBlock:completionBlock];

    return task;

}

- (MendeleyTask *)createDocument:(MendeleyDocument *)mendeleyDocument
                 completionBlock:(MendeleyObjectCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];

    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.documentsAPI createDocument:mendeleyDocument
                                     task:task
                          completionBlock:completionBlock];
    } objectCompletionBlock:completionBlock];

    return task;
}

- (MendeleyTask *)updateDocument:(MendeleyDocument *)updatedDocument
                 completionBlock:(MendeleyObjectCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];

    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.documentsAPI updateDocument:updatedDocument
                                     task:task
                          completionBlock:completionBlock];
    } objectCompletionBlock:completionBlock];

    return task;
}


- (MendeleyTask *)deleteDocumentWithID:(NSString *)documentID
                       completionBlock:(MendeleyCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];

    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.documentsAPI deleteDocumentWithID:documentID
                                           task:task
                                completionBlock:completionBlock];
    } completionBlock:completionBlock];

    return task;
}

- (MendeleyTask *)trashDocumentWithID:(NSString *)documentID
                      completionBlock:(MendeleyCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];

    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.documentsAPI trashDocumentWithID:documentID
                                          task:task
                               completionBlock:completionBlock];
    } completionBlock:completionBlock];

    return task;
}

- (MendeleyTask *)deletedDocumentsSince:(NSDate *)deletedSince
                        completionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    return [self deletedDocumentsSince:deletedSince
                               groupID:nil
                       completionBlock:completionBlock];
}

- (MendeleyTask *)deletedDocumentsSince:(NSDate *)deletedSince
                                groupID:(NSString *)groupID
                        completionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];

    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.documentsAPI deletedDocumentsSince:deletedSince
                                         groupID:groupID
                                            task:task
                                 completionBlock:completionBlock];
    } arrayCompletionBlock:completionBlock];

    return task;
}

- (MendeleyTask *)trashedDocumentListWithLinkedURL:(NSURL *)linkURL
                                   completionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];

    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.documentsAPI trashedDocumentListWithLinkedURL:linkURL
                                                       task:task
                                            completionBlock:completionBlock];
    } arrayCompletionBlock:completionBlock];

    return task;
}

- (MendeleyTask *)trashedDocumentListWithQueryParameters:(MendeleyDocumentParameters *)queryParameters
                                         completionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];

    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.documentsAPI trashedDocumentListWithQueryParameters:queryParameters
                                                             task:task
                                                  completionBlock:completionBlock];
    } arrayCompletionBlock:completionBlock];

    return task;
}

- (MendeleyTask *)deleteTrashedDocumentWithID:(NSString *)documentID
                              completionBlock:(MendeleyCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];

    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.documentsAPI deleteTrashedDocumentWithID:documentID
                                                  task:task
                                       completionBlock:completionBlock];
    } completionBlock:completionBlock];

    return task;
}

- (MendeleyTask *)restoreTrashedDocumentWithID:(NSString *)documentID
                               completionBlock:(MendeleyCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];

    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.documentsAPI restoreTrashedDocumentWithID:documentID
                                                   task:task
                                        completionBlock:completionBlock];
    } completionBlock:completionBlock];

    return task;
}

- (MendeleyTask *)trashedDocumentWithDocumentID:(NSString *)documentID
                                completionBlock:(MendeleyObjectCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];

    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.documentsAPI trashedDocumentWithDocumentID:documentID
                                                    task:task
                                         completionBlock:completionBlock];
    } objectCompletionBlock:completionBlock];

    return task;
}

- (MendeleyTask *)documentFromFileWithURL:(NSURL *)fileURL
                                 mimeType:(NSString *)mimeType
                          completionBlock:(MendeleyObjectCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];

    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.documentsAPI documentFromFileWithURL:fileURL
                                          mimeType:mimeType
                                              task:task
                                   completionBlock:completionBlock];
    } objectCompletionBlock:completionBlock];

    return task;
}

- (MendeleyTask *)cloneDocumentWithID:(NSString *)documentID
                              groupID:(NSString *)groupID
                             folderID:(NSString *)folderID
                            profileID:(NSString *)profileID
                      completionBlock:(MendeleyObjectCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];
    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.documentsAPI cloneDocumentWithID:documentID groupID:groupID folderID:folderID profileID:profileID task:task completionBlock:completionBlock];
    } objectCompletionBlock:completionBlock];
    return task;
}

- (MendeleyTask *)cloneDocumentFiles:(NSString *)sourceDocumentID
                    targetDocumentID:(NSString *)targetDocumentID
                     completionBlock:(MendeleyCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];
    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.documentsAPI cloneDocumentFiles:sourceDocumentID targetDocumentID:targetDocumentID task:task completionBlock:completionBlock];
    } completionBlock:completionBlock];
    return task;
}


- (MendeleyTask *)cloneDocumentAndFiles:(NSString *)documentID
                                groupID:(NSString *)groupID
                               folderID:(NSString *)folderID
                              profileID:(NSString *)profileID
                        completionBlock:(MendeleyObjectCompletionBlock)completionBlock;
{
    MendeleyTask *task = [MendeleyTask new];
    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.documentsAPI cloneDocumentAndFiles:documentID groupID:groupID folderID:folderID profileID:profileID task:task completionBlock:completionBlock];
    } objectCompletionBlock:completionBlock];
    return task;
}




#pragma mark - Metadata

- (MendeleyTask *)metadataLookupWithQueryParameters:(MendeleyMetadataParameters *)queryParameters
                                    completionBlock:(MendeleyObjectCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];

    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.metedataAPI metadataLookupWithQueryParameters:queryParameters
                                                       task:task
                                            completionBlock:completionBlock];
    } objectCompletionBlock:completionBlock];

    return task;
}

#pragma mark - Document Types

- (MendeleyTask *)documentTypesWithCompletionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];

    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.documentsAPI documentTypesWithTask:task
                                 completionBlock:completionBlock];
    } arrayCompletionBlock:completionBlock];

    return task;
}

#pragma mark - Document Identifiers

- (MendeleyTask *)identifierTypesWithCompletionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];

    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.documentsAPI identifierTypesWithTask:task
                                   completionBlock:completionBlock];
    } arrayCompletionBlock:completionBlock];

    return task;
}

#pragma mark - Files

- (MendeleyTask *)fileListWithQueryParameters:(MendeleyFileParameters *)queryParameters
                              completionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];

    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.filesAPI fileListWithQueryParameters:queryParameters
                                              task:task
                                   completionBlock:completionBlock];
    } arrayCompletionBlock:completionBlock];

    return task;
}

- (MendeleyTask *)fileWithFileID:(NSString *)fileID
                       saveToURL:(NSURL *)fileURL
                   progressBlock:(MendeleyResponseProgressBlock)progressBlock
                 completionBlock:(MendeleyCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];

    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.filesAPI fileWithFileID:fileID saveToURL:fileURL
                                 task:task
                        progressBlock:progressBlock
                      completionBlock:completionBlock];
    } completionBlock:completionBlock];

    return task;
}

- (MendeleyTask *) createFile:(NSURL *)fileURL
    relativeToDocumentURLPath:(NSString *)documentURLPath
                progressBlock:(MendeleyResponseProgressBlock)progressBlock
              completionBlock:(MendeleyObjectCompletionBlock)completionBlock
{
    MendeleyTask *task = [self createFile:fileURL
                                 filename:nil
                              contentType:nil
                relativeToDocumentURLPath:documentURLPath
                            progressBlock:progressBlock
                          completionBlock:completionBlock];

    return task;
}

- (MendeleyTask *) createFile:(NSURL *)fileURL
                     filename:(NSString *)filename
                  contentType:(NSString *)contentType
    relativeToDocumentURLPath:(NSString *)documentURLPath
                progressBlock:(MendeleyResponseProgressBlock)progressBlock
              completionBlock:(MendeleyObjectCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];

    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.filesAPI createFile:fileURL
                         filename:filename
                      contentType:contentType
        relativeToDocumentURLPath:documentURLPath
                             task:task
                    progressBlock:progressBlock
                  completionBlock:completionBlock];
    } objectCompletionBlock:completionBlock];

    return task;
}


- (MendeleyTask *)deleteFileWithID:(NSString *)fileID
                   completionBlock:(MendeleyCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];

    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.filesAPI deleteFileWithID:fileID
                                   task:task
                        completionBlock:completionBlock];
    } completionBlock:completionBlock];

    return task;
}

- (MendeleyTask *)fileListWithLinkedURL:(NSURL *)linkURL
                        completionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];

    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.filesAPI fileListWithLinkedURL:linkURL
                                        task:task
                             completionBlock:completionBlock];
    } arrayCompletionBlock:completionBlock];

    return task;
}

- (MendeleyTask *)deletedFilesSince:(NSDate *)deletedSince
                    completionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    return [self deletedFilesSince:deletedSince
                           groupID:nil
                   completionBlock:completionBlock];
}

- (MendeleyTask *)deletedFilesSince:(NSDate *)deletedSince
                            groupID:(NSString *)groupID
                    completionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];

    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.filesAPI deletedFilesSince:deletedSince
                                 groupID:groupID
                                    task:task
                         completionBlock:completionBlock];
    } arrayCompletionBlock:completionBlock];

    return task;
}

- (MendeleyTask *)recentlyReadWithParameters:(MendeleyRecentlyReadParameters *)queryParameters
                             completionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];

    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.filesAPI recentlyReadWithParameters:queryParameters
                                             task:task
                                  completionBlock:completionBlock];
    } arrayCompletionBlock:completionBlock];

    return task;
}

- (MendeleyTask *)addRecentlyRead:(MendeleyRecentlyRead *)recentlyRead
                  completionBlock:(MendeleyObjectCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];

    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.filesAPI addRecentlyRead:recentlyRead
                                  task:task
                       completionBlock:completionBlock];
    } objectCompletionBlock:completionBlock];

    return task;

}

/**
   Note: this service is not yet available
   - (MendeleyTask *)updateRecentlyRead:(MendeleyRecentlyRead *)recentlyRead
                     completionBlock:(MendeleyObjectCompletionBlock)completionBlock
   {
    MendeleyTask *task = [MendeleyTask new];

    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.filesAPI updateRecentlyRead:recentlyRead
                                     task:task
                          completionBlock:completionBlock];
    } objectCompletionBlock:completionBlock];

    return task;
   }
 */

#pragma mark - Folder

- (MendeleyTask *)documentListFromFolderWithID:(NSString *)folderID
                                    parameters:(MendeleyFolderParameters *)queryParameters
                               completionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];

    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.foldersAPI documentListFromFolderWithID:folderID
                                           parameters:queryParameters
                                                 task:task
                                      completionBlock:completionBlock];
    } arrayCompletionBlock:completionBlock];

    return task;
}

- (MendeleyTask *)addDocument:(NSString *)mendeleyDocumentId
                     folderID:(NSString *)folderID
              completionBlock:(MendeleyCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];

    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.foldersAPI addDocument:mendeleyDocumentId
                            folderID:folderID
                                task:task
                     completionBlock:completionBlock];
    } completionBlock:completionBlock];

    return task;
}

- (MendeleyTask *)createFolder:(MendeleyFolder *)mendeleyFolder
               completionBlock:(MendeleyObjectCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];

    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.foldersAPI createFolder:mendeleyFolder
                                 task:task
                      completionBlock:completionBlock];
    } objectCompletionBlock:completionBlock];

    return task;
}

- (MendeleyTask *)folderListWithLinkedURL:(NSURL *)linkURL
                          completionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];

    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.foldersAPI folderListWithLinkedURL:linkURL
                                            task:task
                                 completionBlock:completionBlock];
    } arrayCompletionBlock:completionBlock];

    return task;
}

- (MendeleyTask *)documentListInFolderWithLinkedURL:(NSURL *)linkURL
                                    completionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];

    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.foldersAPI documentListInFolderWithLinkedURL:linkURL
                                                      task:task
                                           completionBlock:completionBlock];
    } arrayCompletionBlock:completionBlock];

    return task;
}

- (MendeleyTask *)folderListWithQueryParameters:(MendeleyFolderParameters *)queryParameters
                                completionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];

    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.foldersAPI folderListWithQueryParameters:queryParameters
                                                  task:task
                                       completionBlock:completionBlock];
    } arrayCompletionBlock:completionBlock];

    return task;
}

- (MendeleyTask *)folderWithFolderID:(NSString *)folderID
                     completionBlock:(MendeleyObjectCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];

    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.foldersAPI folderWithFolderID:folderID
                                       task:task
                            completionBlock:completionBlock];
    } objectCompletionBlock:completionBlock];

    return task;
}

- (MendeleyTask *)deleteFolderWithID:(NSString *)folderID
                     completionBlock:(MendeleyCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];

    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.foldersAPI deleteFolderWithID:folderID
                                       task:task
                            completionBlock:completionBlock];
    } completionBlock:completionBlock];

    return task;
}

- (MendeleyTask *)updateFolder:(MendeleyFolder *)updatedFolder
               completionBlock:(MendeleyCompletionBlock)completionBlock;
{
    MendeleyTask *task = [MendeleyTask new];

    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.foldersAPI updateFolder:updatedFolder
                                 task:task
                      completionBlock:completionBlock];
    } completionBlock:completionBlock];

    return task;
}

- (MendeleyTask *)deleteDocumentWithID:(NSString *)documentID fromFolderWithID:(NSString *)folderID completionBlock:(MendeleyCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];

    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.foldersAPI deleteDocumentWithID:documentID
                             fromFolderWithID:folderID
                                         task:task
                              completionBlock:completionBlock];
    } completionBlock:completionBlock];

    return task;
}

#pragma mark - Groups
- (MendeleyTask *)groupListWithQueryParameters:(MendeleyGroupParameters *)queryParameters
                                      iconType:(MendeleyIconType)iconType
                               completionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];

    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.groupsAPI groupListWithQueryParameters:queryParameters
                                            iconType:iconType
                                                task:task
                                     completionBlock:completionBlock];
    } arrayCompletionBlock:completionBlock];

    return task;

}

- (MendeleyTask *)groupListWithLinkedURL:(NSURL *)linkURL
                                iconType:(MendeleyIconType)iconType
                         completionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];

    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.groupsAPI groupListWithLinkedURL:linkURL
                                      iconType:iconType
                                          task:task
                               completionBlock:completionBlock];
    } arrayCompletionBlock:completionBlock];

    return task;

}

- (MendeleyTask *)groupWithGroupID:(NSString *)groupID
                          iconType:(MendeleyIconType)iconType
                   completionBlock:(MendeleyObjectCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];

    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.groupsAPI groupWithGroupID:groupID
                                iconType:iconType
                                    task:task
                         completionBlock:completionBlock];
    } objectCompletionBlock:completionBlock];

    return task;

}

- (MendeleyTask *)groupListWithQueryParameters:(MendeleyGroupParameters *)queryParameters
                               completionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];

    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.groupsAPI groupListWithQueryParameters:queryParameters
                                                task:task
                                     completionBlock:completionBlock];
    } arrayCompletionBlock:completionBlock];

    return task;
}

- (MendeleyTask *)groupListWithLinkedURL:(NSURL *)linkURL
                         completionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];

    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.groupsAPI groupListWithLinkedURL:linkURL
                                          task:task
                               completionBlock:completionBlock];
    } arrayCompletionBlock:completionBlock];

    return task;
}

- (MendeleyTask *)groupWithGroupID:(NSString *)groupID
                   completionBlock:(MendeleyObjectCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];

    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.groupsAPI groupWithGroupID:groupID
                                    task:task
                         completionBlock:completionBlock];
    } objectCompletionBlock:completionBlock];

    return task;
}

- (MendeleyTask *)groupIconForGroup:(MendeleyGroup *)group
                           iconType:(MendeleyIconType)iconType
                    completionBlock:(MendeleyBinaryDataCompletionBlock)completionBlock
{
    /*
       Note: this call doesn't require an authentication header
     */
    MendeleyTask *task = [MendeleyTask new];

    [self.groupsAPI groupIconForGroup:group iconType:iconType
                                 task:task
                      completionBlock:completionBlock];
    return task;
}


- (MendeleyTask *)groupIconForIconURLString:(NSString *)iconURLString
                            completionBlock:(MendeleyBinaryDataCompletionBlock)completionBlock
{
    /*
       Note: this call doesn't require an authentication header
     */
    MendeleyTask *task = [MendeleyTask new];

    [self.groupsAPI groupIconForIconURLString:iconURLString
                                         task:task
                              completionBlock:completionBlock];
    return task;

}


#pragma mark - Annotations

- (MendeleyTask *)annotationWithAnnotationID:(NSString *)annotationID
                             completionBlock:(MendeleyObjectCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];

    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.annotationsAPI annotationWithAnnotationID:annotationID
                                                   task:task
                                        completionBlock:completionBlock];
    } objectCompletionBlock:completionBlock];

    return task;
}

- (MendeleyTask *)deleteAnnotationWithID:(NSString *)annotationID
                         completionBlock:(MendeleyCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];

    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.annotationsAPI deleteAnnotationWithID:annotationID
                                               task:task
                                    completionBlock:completionBlock];
    } completionBlock:completionBlock];

    return task;
}

- (MendeleyTask *)updateAnnotation:(MendeleyAnnotation *)updatedMendeleyAnnotation
                   completionBlock:(MendeleyObjectCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];

    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.annotationsAPI updateAnnotation:updatedMendeleyAnnotation
                                         task:task
                              completionBlock:completionBlock];
    } objectCompletionBlock:completionBlock];

    return task;
}

- (MendeleyTask *)createAnnotation:(MendeleyAnnotation *)mendeleyAnnotation
                   completionBlock:(MendeleyObjectCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];

    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.annotationsAPI createAnnotation:mendeleyAnnotation
                                         task:task
                              completionBlock:completionBlock];
    } objectCompletionBlock:completionBlock];

    return task;
}

- (MendeleyTask *)annotationListWithLinkedURL:(NSURL *)linkURL
                              completionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];

    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.annotationsAPI annotationListWithLinkedURL:linkURL
                                                    task:task
                                         completionBlock:completionBlock];
    } arrayCompletionBlock:completionBlock];

    return task;

}


- (MendeleyTask *)annotationListWithQueryParameters:(MendeleyAnnotationParameters *)queryParameters
                                    completionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];

    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.annotationsAPI annotationListWithQueryParameters:queryParameters
                                                          task:task
                                               completionBlock:completionBlock];
    } arrayCompletionBlock:completionBlock];

    return task;
}

- (MendeleyTask *)deletedAnnotationsSince:(NSDate *)deletedSince
                          completionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    return [self deletedAnnotationsSince:deletedSince
                                 groupID:nil
                         completionBlock:completionBlock];
}

- (MendeleyTask *)deletedAnnotationsSince:(NSDate *)deletedSince
                                  groupID:(NSString *)groupID
                          completionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];

    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.annotationsAPI deletedAnnotationsSince:deletedSince
                                             groupID:groupID
                                                task:task
                                     completionBlock:completionBlock];
    } arrayCompletionBlock:completionBlock];

    return task;
}

#pragma mark - Followers

- (MendeleyTask *)followersForUserWithID:(NSString *)profileID
                              parameters:(MendeleyFollowersParameters *)parameters
                         completionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];

    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.followersAPI followersForUserWithID:profileID
                                       parameters:parameters
                                             task:task
                                  completionBlock:completionBlock];
    } arrayCompletionBlock:completionBlock];

    return task;
}

- (MendeleyTask *)followedByUserWithID:(NSString *)profileID
                            parameters:(MendeleyFollowersParameters *)parameters
                       completionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];

    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.followersAPI followedByUserWithID:profileID
                                     parameters:parameters
                                           task:task
                                completionBlock:completionBlock];
    } arrayCompletionBlock:completionBlock];

    return task;
}

- (MendeleyTask *)pendingFollowersForUserWithID:(NSString *)profileID
                                     parameters:(MendeleyFollowersParameters *)parameters
                                completionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];

    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.followersAPI pendingFollowersForUserWithID:profileID
                                              parameters:parameters
                                                    task:task
                                         completionBlock:completionBlock];
    } arrayCompletionBlock:completionBlock];

    return task;
}

- (MendeleyTask *)pendingFollowedByUserWithID:(NSString *)profileID
                                   parameters:(MendeleyFollowersParameters *)parameters
                              completionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];

    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.followersAPI pendingFollowedByUserWithID:profileID
                                            parameters:parameters
                                                  task:task
                                       completionBlock:completionBlock];
    } arrayCompletionBlock:completionBlock];

    return task;
}

- (MendeleyTask *)followUserWithID:(NSString *)followedID
         completionBlock:(MendeleyObjectCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];

    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.followersAPI followUserWithID:followedID
                                       task:task
                            completionBlock:completionBlock];
    } objectCompletionBlock:completionBlock];

    return task;
}

- (MendeleyTask *)acceptFollowRequestWithID:(NSString *)requestID
                  completionBlock:(MendeleyCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];

    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.followersAPI acceptFollowRequestWithID:requestID
                                                task:task
                                     completionBlock:completionBlock];
    } completionBlock:completionBlock];

    return task;
}

- (MendeleyTask *)stopOrDenyRelationshipWithID:(NSString *)relationshipID
               completionBlock:(MendeleyCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];

    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.followersAPI stopOrDenyRelationshipWithID:relationshipID
                                                   task:task
                                        completionBlock:completionBlock];
    } completionBlock:completionBlock];

    return task;
}

- (MendeleyTask *)profileWithID:(NSString *)followerID
             isFollowingProfile:(NSString *)followedID
                completionBlock:(MendeleyCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];
    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.followersAPI profileWithID:followerID
                      isFollowingProfile:followedID
                                    task:task
                         completionBlock:completionBlock];
    } completionBlock:completionBlock];
    
    return task;
}

#pragma mark - Recommendations

- (MendeleyTask *)recommendationsBasedOnLibraryArticlesWithParameters:(MendeleyRecommendationsParameters *)queryParameters
                                                      completionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];
    
    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.recommendationsAPI recommendationsBasedOnLibraryArticlesWithParameters:queryParameters
                                                                                task:task
                                                                     completionBlock:completionBlock];
    } arrayCompletionBlock:completionBlock];
    
    return task;
}

- (MendeleyTask *)feedbackOnRecommendation:(NSString *)trace
                                  position:(NSNumber *)position
                                userAction:(NSString *)userAction
                                  carousel:(NSNumber *)carousel
                 completionBlock:(MendeleyCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];
    
    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.recommendationsAPI feedbackOnRecommendation:trace
                                                 position:position
                                               userAction:userAction
                                                 carousel:carousel
                                                     task:task
                                          completionBlock:completionBlock];
    } completionBlock:completionBlock];
    
    return task;
}

#pragma mark - Feeds

- (MendeleyTask *)feedListWithLinkedURL:(NSURL *)linkURL
                        completionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];
    
    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.feedsAPI feedListWithLinkedURL:linkURL
                                        task:task
                             completionBlock:completionBlock];
    } arrayCompletionBlock:completionBlock];
    
    return task;
}

- (MendeleyTask *)feedListWithQueryParameters:(MendeleyFeedsParameters *)queryParameters
                              completionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];
    
    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.feedsAPI feedListWithQueryParameters:queryParameters
                                              task:task
                                   completionBlock:completionBlock];
    } arrayCompletionBlock:completionBlock];
    
    return task;
}

- (MendeleyTask *)feedWithId:(NSString *)feedId
             completionBlock:(MendeleyObjectCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];
    
    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.feedsAPI feedWithId:feedId
                             task:task
                  completionBlock:completionBlock];
    } objectCompletionBlock:completionBlock];
    
    return task;

}

- (MendeleyTask *)likeFeedWithID:(NSString *)feedID
       completionBlock:(MendeleyCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];
    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.feedsAPI likeFeedWithID:feedID
                                 task:task
                      completionBlock:completionBlock];
    } completionBlock:completionBlock];
    
    return task;
}

- (MendeleyTask *)unlikeFeedWithID:(NSString *)feedID
                   completionBlock:(MendeleyCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];
    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.feedsAPI unlikeFeedWithID:feedID
                                 task:task
                      completionBlock:completionBlock];
    } completionBlock:completionBlock];
    
    return task;
}

- (MendeleyTask *)likersForFeedWithID:(NSString *)feedID
            completionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];
    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.feedsAPI likersForFeedWithID:feedID
                                      task:task
                           completionBlock:completionBlock];
    } arrayCompletionBlock:completionBlock];
    
    return task;
}

- (MendeleyTask *)sharersForFeedWithID:(NSString *)feedID
             completionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];
    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.feedsAPI sharersForFeedWithID:feedID
                                       task:task
                            completionBlock:completionBlock];
    } arrayCompletionBlock:completionBlock];
    
    return task;
}

#pragma mark - User Posts

- (MendeleyTask *)createUserPost:(MendeleyNewUserPost *)newPost
                 completionBlock:(MendeleyObjectCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];
    
    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.userPostsAPI createUserPost:newPost
                                     task:task
                          completionBlock:completionBlock];
    } objectCompletionBlock:completionBlock];
    
    return task;
}

- (MendeleyTask *)deleteUserPostWithPostID:(NSString *)postID
                           completionBlock:(MendeleyCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];
    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.userPostsAPI deleteUserPostWithPostID:postID
                                               task:task
                                    completionBlock:completionBlock];
    } completionBlock:completionBlock];
    
    return task;
}

- (MendeleyTask *)createGroupPost:(MendeleyGroupPost *)groupPost
                  completionBlock:(MendeleyObjectCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];
    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.userPostsAPI createGroupPost:groupPost
                                      task:task
                           completionBlock:completionBlock];
    } objectCompletionBlock:completionBlock];
    
    return task;
}

- (MendeleyTask *)deleteGroupPostWithPostID:(NSString *)postID
                            completionBlock:(MendeleyCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];
    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.userPostsAPI deleteGroupPostWithPostID:postID
                                                task:task
                                     completionBlock:completionBlock];
    } completionBlock:completionBlock];
    
    return task;
}

#pragma mark - Shares

- (MendeleyTask *)shareFeedWithQueryParameters:(MendeleySharesParameters *)queryParameters
                     completionBlock:(MendeleyCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];
    
    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.sharesAPI shareFeedWithQueryParameters:queryParameters
                                                task:task
                                     completionBlock:completionBlock];
    } completionBlock:completionBlock];
    
    return task;
}

- (MendeleyTask *)shareDocumentWithDocumentID:(NSString *)documentID
                              completionBlock:(MendeleyCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];
    
    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.sharesAPI shareDocumentWithDocumentID:documentID
                                               task:task
                                    completionBlock:completionBlock];
    } completionBlock:completionBlock];
    
    return task;
}

- (MendeleyTask *)shareDocumentWithDOI:(NSString *)doi
                       completionBlock:(MendeleyCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];
    
    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.sharesAPI shareDocumentWithDOI:doi
                                        task:task
                             completionBlock:completionBlock];
    } completionBlock:completionBlock];
    
    return task;
}

- (MendeleyTask *)shareDocumentWithScopus:(NSString *)scopus
                          completionBlock:(MendeleyCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];
    
    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.sharesAPI shareDocumentWithScopus:scopus
                                           task:task
                                completionBlock:completionBlock];
    } completionBlock:completionBlock];
    
    return task;
}

#pragma mark - Comments

- (MendeleyTask *)expandedCommentsWithNewsItemID:(NSString *)newsItemID
                                 completionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];
    
    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.commentsAPI expandedCommentsWithNewsItemID:newsItemID
                                                    task:task
                                         completionBlock:completionBlock];
    } arrayCompletionBlock:completionBlock];
    
    return task;
}

- (MendeleyTask *)commentWithCommentID:(NSString *)commentID
                       completionBlock:(MendeleyObjectCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];
    
    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.commentsAPI commentWithCommentID:commentID
                                          task:task
                               completionBlock:completionBlock];
    } objectCompletionBlock:completionBlock];
    
    return task;
}

- (MendeleyTask *)createComment:(MendeleyComment *)comment
                completionBlock:(MendeleyObjectCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];
    
    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.commentsAPI createComment:comment
                                   task:task
                        completionBlock:completionBlock];
    } objectCompletionBlock:completionBlock];
    
    return task;
}

- (MendeleyTask *)updateCommentWithCommentID:(NSString *)commentID
                                      update:(MendeleyCommentUpdate *)update
                             completionBlock:(MendeleyObjectCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];
    
    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.commentsAPI updateCommentWithCommentID:commentID
                                              update:update
                                                task:task
                                     completionBlock:completionBlock];
    } objectCompletionBlock:completionBlock];
    
    return task;
}

- (MendeleyTask *)deleteCommentWithCommentID:(NSString *)commentID
                             completionBlock:(MendeleyCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];
    
    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.commentsAPI deleteCommentWithCommentID:commentID
                                                task:task
                                     completionBlock:completionBlock];
    } completionBlock:completionBlock];
    
    return task;
}

#pragma mark - Datasets

- (MendeleyTask *)datasetListWithQueryParameters:(MendeleyDatasetParameters *)queryParameters
                                 completionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];

    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.datasetsAPI datasetListWithQueryParameters:queryParameters
                                                    task:task
                                         completionBlock:completionBlock];
    } arrayCompletionBlock:completionBlock];

    return task;
}

- (MendeleyTask *)datasetListWithLinkedURL:(NSURL *)linkURL
                           completionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];

    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.datasetsAPI datasetListWithLinkedURL:linkURL
                                              task:task
                                   completionBlock:completionBlock];
    } arrayCompletionBlock:completionBlock];

    return task;
}

- (MendeleyTask *)datasetWithDatasetID:(NSString *)datasetID
                       completionBlock:(MendeleyObjectCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];

    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.datasetsAPI datasetWithDatasetID:datasetID
                                          task:task
                               completionBlock:completionBlock];
    } objectCompletionBlock:completionBlock];

    return task;
}

- (MendeleyTask *)datasetLicencesListWithCompletionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];

    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.datasetsAPI datasetLicencesListWithTask:task
                                      completionBlock:completionBlock];
    } arrayCompletionBlock:completionBlock];

    return task;
}

#pragma mark - Features

- (MendeleyTask *)applicationFeaturesWithCompletionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    MendeleyTask *task = [MendeleyTask new];

    [self checkAuthenticationThenRefreshTokenThenPerform:^{
        [self.featuresAPI applicationFeaturesWithTask:task
                                      completionBlock:completionBlock];
    } arrayCompletionBlock:completionBlock];

    return task;
}

#pragma mark - Cancellation

- (void) cancelTask:(MendeleyTask *)task
    completionBlock:(MendeleyCompletionBlock)completionBlock
{
    [self.networkProvider cancelTask:task
                     completionBlock:completionBlock];
}

- (void)cancelAllTasks:(MendeleyCompletionBlock)completionBlock
{
    [self.networkProvider cancelAllTasks:completionBlock];
}

@end
