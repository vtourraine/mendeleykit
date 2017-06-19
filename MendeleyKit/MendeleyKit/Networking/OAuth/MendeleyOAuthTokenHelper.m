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

#import "MendeleyOAuthTokenHelper.h"
#import "MendeleyOAuthStore.h"
#import "MendeleyOAuthProvider.h"
#import "MendeleyKitConfiguration.h"
#import "NSError+MendeleyError.h"

@implementation MendeleyOAuthTokenHelper

+ (void)refreshTokenWithRefreshBlock:(MendeleyCompletionBlock)refreshBlock
{
    if (refreshBlock)
    {
        refreshBlock(YES, nil);
    }
    return;
    
    // @TODO: Re-enable code once ID+ complete
    MendeleyOAuthCredentials *credentials = [MendeleyKitConfiguration.sharedInstance.storeProvider retrieveOAuthCredentials];

    if (nil == credentials)
    {
        NSError *error = [NSError errorWithCode:kMendeleyUnauthorizedErrorCode];
        if (refreshBlock)
        {
            refreshBlock(NO, error);
        }
    }

    else if (credentials.oauthCredentialIsExpired)
    {
        id<MendeleyIDPlusAuthProvider>idPlusProvider = [[MendeleyKitConfiguration sharedInstance]
                                                  idPlusProvider];
        [idPlusProvider refreshTokenWithOAuthCredentials:credentials
                                        completionBlock:^(MendeleyOAuthCredentials *credentials, NSError *error) {
             if (refreshBlock)
             {
                 if (nil != credentials)
                 {
                     BOOL success = [MendeleyKitConfiguration.sharedInstance.storeProvider storeOAuthCredentials:credentials];
                     refreshBlock(success, nil);
                 }
                 else
                 {
                     refreshBlock(NO, error);
                 }
             }
         }];
    }
    else
    {
        if (refreshBlock)
        {
            refreshBlock(YES, nil);
        }
    }
}

@end
