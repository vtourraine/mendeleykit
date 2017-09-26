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

#import "MendeleyKitConfiguration.h"
#import "MendeleyDefaultNetworkProvider.h"
#import "MendeleyIDPlusAuthDefaultManager.h"
#import "MendeleyKitUserInfoManager.h"
#import "MendeleyDefaultOAuthProvider.h"
#import "MendeleyOAuthProvider.h"
#import "MendeleyOAuthStore.h"
#import "MendeleyError.h"

typedef NS_ENUM(int, MendeleyCustomClassType)
{
    NetworkProvider = 0,
    OAuthProvider,
    StoreProvider,
    IDPlusProvider
};

@interface MendeleyKitConfiguration ()
@property (nonatomic, assign, readwrite) BOOL isTrustedSSLServer;
@property (nonatomic, strong, readwrite) NSURL *baseAPIURL;
@property (nonatomic, strong, readwrite) NSURL *verifyURL;
@property (nonatomic, assign, readwrite) NSString *documentViewType;
@property (nonatomic, strong, readwrite) id<MendeleyNetworkProvider> networkProvider;
@property (nonatomic, strong, readwrite) id<MendeleyOAuthProvider> oauthProvider;
@property (nonatomic, strong, readwrite) id<MendeleyIDPlusAuthProvider> idPlusProvider;
@property (nonatomic, strong, readwrite) id<MendeleyOAuthStoreProvider> storeProvider;
@property (nonatomic, assign, readwrite) MendeleyServerType serverType;
@end

@implementation MendeleyKitConfiguration
+ (MendeleyKitConfiguration *)sharedInstance
{
    static MendeleyKitConfiguration *configuration = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
                      configuration = [[MendeleyKitConfiguration alloc] init];
                  });

    return configuration;
}

- (id)init
{
    self = [super init];
    if (nil != self)
    {
        [self resetToDefault];

        MendeleyKitUserInfoManager *sdkHelper = [MendeleyKitUserInfoManager new];
        [[MendeleyErrorManager sharedInstance] addUserInfoHelper:sdkHelper errorDomain:kMendeleyErrorDomain];
        
        self.serverType = MendeleyServerTypeProduction;
    }
    return self;
}

- (id<MendeleyAuthenticationProvider>)authenticationProvider
{
    if (self.idPlusProvider != nil) {
        return self.idPlusProvider;
    }
    return self.oauthProvider;
}

//TODO refactor method name
- (void)configureOAuthWithParameters:(NSDictionary *)oAuthParameters
{
    if (nil != self.oauthProvider &&
        [self.oauthProvider respondsToSelector:@selector(configureOAuthWithParameters:)])
    {
        [self.oauthProvider configureOAuthWithParameters:oAuthParameters];
        self.idPlusProvider = nil;
    }
}

- (void)configureAuthenticationWithParameters:(NSDictionary *)authenticationParameters
{
    if (nil != authenticationParameters[kMendeleyIDPlusClientIdKey] &&
        nil != authenticationParameters[kMendeleyIDPlusSecretKey] &&
        nil != self.idPlusProvider &&
        [self.idPlusProvider respondsToSelector:@selector(configureWithParameters:)])
    {
        [self.idPlusProvider configureWithParameters:authenticationParameters];
        self.oauthProvider = nil;
    }
    
    if (nil != self.oauthProvider &&
             [self.oauthProvider respondsToSelector:@selector(configureOAuthWithParameters:)])
    {
        [self.oauthProvider configureOAuthWithParameters:authenticationParameters];
        self.idPlusProvider = nil;
    }
}

- (void)changeConfigurationWithParameters:(NSDictionary *)configurationParameters
{
    if (nil == configurationParameters || 0 == configurationParameters.allKeys.count)
    {
        return;
    }
    NSString *baseURLCandidate = [configurationParameters objectForKey:kMendeleyBaseAPIURLKey];
    if (nil != baseURLCandidate)
    {
        self.baseAPIURL = [NSURL URLWithString:baseURLCandidate];
    }
    NSString *verifyURLCandidate = [configurationParameters objectForKey:kMendeleyVerifyURLKey];
    if (nil != verifyURLCandidate)
    {
        self.verifyURL = [NSURL URLWithString:verifyURLCandidate];
    }
    NSNumber *baseTrustedFlag = [configurationParameters objectForKey:kMendeleyTrustedSSLServerKey];
    if (nil != baseTrustedFlag)
    {
        self.isTrustedSSLServer = [baseTrustedFlag boolValue];
    }
    NSString *baseViewType = [configurationParameters objectForKey:kMendeleyDocumentViewType];
    if (nil != baseViewType)
    {
        self.documentViewType = baseViewType;
    }
    
    NSString *oauthProviderName = [configurationParameters objectForKey:kMendeleyOAuthProviderKey];
    [self createProviderForClassName:oauthProviderName classType:(OAuthProvider)];

    NSString *idPlusProviderName = [configurationParameters objectForKey:kMendeleyIDPlusAuthProviderKey];
    [self createProviderForClassName:idPlusProviderName classType:(IDPlusProvider)];

    NSString *networkProviderName = [configurationParameters objectForKey:kMendeleyNetworkProviderKey];
    [self createProviderForClassName:networkProviderName classType:(NetworkProvider)];
    
    NSString *storeProviderName = [configurationParameters objectForKey:kMendeleyOAuthStoreProviderKey];
    [self createProviderForClassName:storeProviderName classType:(StoreProvider)];
}

- (void)createProviderForClassName:(NSString *)className classType:(MendeleyCustomClassType)type
{
    Class providerClass = NSClassFromString(className);

    if (nil == providerClass)
    {
        return;
    }
    id provider = [[providerClass alloc] init];
    if (nil == provider)
    {
        return;
    }
    switch (type) {
        case NetworkProvider:
            if ([provider conformsToProtocol:@protocol(MendeleyNetworkProvider)])
            {
                self.networkProvider = provider;
            }
            break;
        case OAuthProvider:
            if ([provider conformsToProtocol:@protocol(MendeleyOAuthProvider)])
            {
                self.oauthProvider = provider;
            }
            break;
        case IDPlusProvider:
            if ([provider conformsToProtocol:@protocol(MendeleyIDPlusAuthProvider)])
            {
                self.idPlusProvider = provider;
            }
            break;
        case StoreProvider:
            if ([provider conformsToProtocol:@protocol(MendeleyOAuthStoreProvider)])
            {
                self.storeProvider = provider;
            }
            break;
    }
    
    
}

- (void)resetToDefault
{
    _networkProvider = [MendeleyDefaultNetworkProvider sharedInstance];
    _oauthProvider = [MendeleyDefaultOAuthProvider sharedInstance];
    _idPlusProvider = [MendeleyIDPlusAuthDefaultManager sharedInstance];
    _storeProvider = [MendeleyOAuthStore new];
    _isTrustedSSLServer = NO;
    _documentViewType = kMendeleyDocumentViewTypeDefault;
    NSString *urlString = self.serverType == MendeleyServerTypeProduction ? kMendeleyKitURL : kMendeleyKitStagingURL;
    _baseAPIURL =  [NSURL URLWithString:urlString];
    NSString *verifyURLString = self.serverType == MendeleyServerTypeProduction ? kMendeleyVerifyURL : kMendeleyVerifyStagingURL;
    _verifyURL = [NSURL URLWithString:verifyURLString];
}


@end
