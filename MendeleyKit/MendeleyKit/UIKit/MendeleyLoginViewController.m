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

#import "MendeleyLoginViewController.h"
#import "MendeleyURLBuilder.h"
#import "MendeleyKitConfiguration.h"
#import "MendeleyOAuthConstants.h"
#import "MendeleyOAuthStore.h"
#import "NSError+MendeleyError.h"
#import "MendeleyGlobals.h"
#import <MendeleyKitiOS/MendeleyKitiOS-Swift.h>

@interface MendeleyLoginViewController ()
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSURL *oauthServer;
@property (nonatomic, strong) NSString *clientID;
@property (nonatomic, strong) NSString *redirectURI;
@property (nonatomic, copy) MendeleyStateCompletionBlock completionBlock;
@property (nonatomic, strong) MendeleyOAuthCompletionBlock oAuthCompletionBlock;
@property (nonatomic, strong) id<MendeleyOAuthProvider> oauthProvider;
@property (nonatomic, strong) id<MendeleyIDPlusAuthProvider> idPlusProvider;
@property (nonatomic, strong, nonnull) MendeleyLoginWebKitHandler *oAuthLoginHandler;
@property (nonatomic, strong, nonnull) MendeleyIDPlusLoginWebKitHandler *idPlusLoginHandler;
@property (nonatomic, assign) BOOL isHandlingOAuth;
@end

@implementation MendeleyLoginViewController

- (id)initWithClientKey:(NSString *)clientKey
           clientSecret:(NSString *)clientSecret
            redirectURI:(NSString *)redirectURI
        completionBlock:(MendeleyStateCompletionBlock)completionBlock
{
    return [self initWithClientKey:clientKey
                      clientSecret:clientSecret
                       redirectURI:redirectURI
                   completionBlock:completionBlock
               customOAuthProvider:nil];

}


- (id)initWithClientKey:(NSString *)clientKey
           clientSecret:(NSString *)clientSecret
            redirectURI:(NSString *)redirectURI
        completionBlock:(MendeleyStateCompletionBlock)completionBlock
    customOAuthProvider:(id<MendeleyOAuthProvider>)customOAuthProvider
{
    self = [super init];
    if (nil != self)
    {
        if (nil == customOAuthProvider)
        {
            _oauthProvider = [[MendeleyKitConfiguration sharedInstance] oauthProvider];
        }
        else
        {
            _oauthProvider = customOAuthProvider;
        }
        NSDictionary *oauthParameters = @{ kMendeleyOAuth2ClientSecretKey : clientSecret,
                                           kMendeleyOAuth2ClientIDKey : clientKey,
                                           kMendeleyOAuth2RedirectURLKey : redirectURI };
        [[MendeleyKitConfiguration sharedInstance] configureOAuthWithParameters:oauthParameters];
        _completionBlock = completionBlock;
        _clientID = clientKey;
        _redirectURI = redirectURI;
    }
    return self;

}

- (id)initWithClientKey:(NSString *)clientKey
           clientSecret:(NSString *)clientSecret
            redirectURI:(NSString *)redirectURI
        idPlusClientKey:(NSString *)idPlusClientKey
           idPlusSecret:(NSString *)idPlusSecret
      idPlusRedirectURI:(NSString *)idPlusRedirectURI
        completionBlock:(MendeleyStateCompletionBlock)completionBlock
{
    return [self initWithClientKey:clientKey
                      clientSecret:clientSecret
                       redirectURI:redirectURI
                   idPlusClientKey:idPlusClientKey
                      idPlusSecret:idPlusSecret
                 idPlusRedirectURI:idPlusRedirectURI
                   completionBlock:completionBlock
              customIDPlusProvider:nil];
}


- (id)initWithClientKey:(NSString *)clientKey
           clientSecret:(NSString *)clientSecret
            redirectURI:(NSString *)redirectURI
        idPlusClientKey:(NSString *)idPlusClientKey
           idPlusSecret:(NSString *)idPlusSecret
      idPlusRedirectURI:(NSString *)idPlusRedirectURI
        completionBlock:(MendeleyStateCompletionBlock)completionBlock
   customIDPlusProvider:(id<MendeleyIDPlusAuthProvider>)customIDPlusProvider
{
    self = [super init];
    if (nil != self)
    {
        if (nil == customIDPlusProvider)
        {
            _idPlusProvider = [[MendeleyKitConfiguration sharedInstance] idPlusProvider];
        }
        else
        {
            _idPlusProvider = customIDPlusProvider;
        }
        NSDictionary *authenticationParameters = @{ kMendeleyOAuth2ClientSecretKey : clientSecret,
                                                    kMendeleyOAuth2ClientIDKey : clientKey,
                                                    kMendeleyOAuth2RedirectURLKey : redirectURI,
                                                    kMendeleyIDPlusClientIdKey : idPlusClientKey,
                                                    kMendeleyIDPlusSecretKey : idPlusSecret,
                                                    kMendeleyIDPlusRedirectUriKey : idPlusRedirectURI,
                                                    kMendeleyIDPlusScopeKey : kIDPlusScopeDefault,
                                                    kMendeleyIDPlusStateKey : [[NSUUID UUID] UUIDString],
                                                    kMendeleyIDPlusAuthTypeKey : kIDPlusAuthTypeDefault,
                                                    kMendeleyIDPlusPlatSiteKey : kIDPlusPlatSiteDefault,
                                                    kMendeleyIDPlusPromptKey : kIDPlusPromptDefault,
                                                    kMendeleyIDPlusResponseTypeKey :  kIDPlusResponseTypeDefault };
        
        [[MendeleyKitConfiguration sharedInstance] configureAuthenticationWithParameters:authenticationParameters];
        _completionBlock = completionBlock;
        _clientID = clientKey;
        _redirectURI = redirectURI;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.view.autoresizesSubviews = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    __strong MendeleyOAuthCompletionBlock oAuthCompletionBlock = ^void (MendeleyOAuthCredentials *credentials, NSError *error) {
        if (nil != credentials)
        {
            BOOL success = [MendeleyKitConfiguration.sharedInstance.storeProvider storeOAuthCredentials:credentials];
            
            if (nil != self.completionBlock && _idPlusProvider == nil)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.completionBlock(success, nil);
                });
            }
        }
        else if (nil != self.completionBlock && _idPlusProvider == nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.completionBlock(NO, error);
            });
        }
    };
    
    if (MendeleyKitConfiguration.sharedInstance.authenticationProvider == self.idPlusProvider)
    {
        self.idPlusLoginHandler = [[MendeleyIDPlusLoginWebKitHandler alloc] initWithController:self];
        
        [self.idPlusLoginHandler startLoginProcess:self.clientID
                                       redirectURI:self.redirectURI
                                 completionHandler:self.completionBlock
                                      oauthHandler:oAuthCompletionBlock];
    }
    else
    {
        self.oAuthLoginHandler = [[MendeleyLoginWebKitHandler alloc] initWithController:self];
        
        [self.oAuthLoginHandler startLoginProcess:self.clientID
                                       redirectURI:self.redirectURI
                                 completionHandler:self.completionBlock
                                      oauthHandler:oAuthCompletionBlock];
    }
}

#pragma mark Handle device rotations
- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}
@end
