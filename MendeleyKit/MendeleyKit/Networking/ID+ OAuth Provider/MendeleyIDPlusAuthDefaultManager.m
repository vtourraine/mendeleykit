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

#import "MendeleyIDPlusAuthDefaultManager.h"
#import "MendeleyKitConfiguration.h"
#import "NSError+Exceptions.h"
#import "MendeleyOAuthConstants.h"
#import "MendeleyBlockExecutor.h"
#import "MendeleyKitHelper.h"
#import "MendeleyModeller.h"
#import "MendeleyProfilesAPI.h"

NSString *const kMendeleyOAuth2StateKey = @"state";
NSString *const kMendeleyOAuth2AuthTypeKey = @"authType";
NSString *const kMendeleyOAuth2PlatSiteKey = @"platSite";
NSString *const kMendeleyOAuth2PromptKey = @"prompt";
NSString *const kMendeleyIDPlusBaseURL = @"https://loadcp-id.elsevier.com";
NSString *const kMendeleyIDPlusAuthorizationEndpoint = @"as/authorization.oauth2";
NSString *const kMendeleyIDPlusTokenEndpoint = @"as/token.oauth2";
NSString *const kMendeleyIDPlusRevokeEndpoint = @"as/revoke_token.oauth2";

@interface MendeleyIDPlusAuthDefaultManager()

@property (nonatomic, strong) NSString *idPlusScope;
@property (nonatomic, strong) NSString *idPlusState;
@property (nonatomic, strong) NSString *idPlusAuthType;
@property (nonatomic, strong) NSString *idPlusPlatSite;
@property (nonatomic, strong) NSString *idPlusPrompt;
@property (nonatomic, strong) NSString *idPlusRedirectUri;
@property (nonatomic, strong) NSString *idPlusResponseType;
@property (nonatomic, strong) NSString *idPlusClientId;

@property (nonatomic, strong) NSString *oAuthClientId;
@property (nonatomic, strong) NSString *oAuthClientSecret;
@property (nonatomic, strong) NSString *oAuthRedirectUri;

@end

@implementation MendeleyIDPlusAuthDefaultManager

+ (MendeleyIDPlusAuthDefaultManager *)sharedInstance
{
    static MendeleyIDPlusAuthDefaultManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[MendeleyIDPlusAuthDefaultManager alloc] init];
        
    });
    return sharedInstance;
    
}

- (void)configureWithParameters:(NSDictionary *)parameters
{
    [NSError assertArgumentNotNil:parameters argumentName:@"parameters"];
    
    NSString *scope = parameters[kIDPlusScope];
    if (scope != nil && [scope isKindOfClass:[NSString class]]) {
        self.idPlusScope = scope;
    }
    NSString *state = parameters[kIDPlusState];
    if (state != nil && [state isKindOfClass:[NSString class]]) {
        self.idPlusState = state;
    }
    NSString *authType = parameters[kIDPlusAuthType];
    if (authType != nil && [authType isKindOfClass:[NSString class]]) {
        self.idPlusAuthType = authType;
    }
    NSString *platSite = parameters[kIDPlusPlatSite];
    if (platSite != nil && [platSite isKindOfClass:[NSString class]]) {
        self.idPlusPlatSite = platSite;
    }
    NSString *prompt = parameters[kIDPlusPrompt];
    if (prompt != nil && [prompt isKindOfClass:[NSString class]]) {
        self.idPlusPrompt = prompt;
    }
    NSString *idPlusRedirectUri = parameters[kIDPlusRedirectUri];
    if (idPlusRedirectUri != nil && [idPlusRedirectUri isKindOfClass:[NSString class]]) {
        self.idPlusRedirectUri = idPlusRedirectUri;
    }
    NSString *responseType = parameters[kIDPlusResponseType];
    if (responseType != nil && [responseType isKindOfClass:[NSString class]]) {
        self.idPlusResponseType = responseType;
    }
    NSString *idPlusClientId = parameters[kIDPlusClientId];
    if (idPlusClientId != nil && [idPlusClientId isKindOfClass:[NSString class]]) {
        self.idPlusClientId = idPlusClientId;
    }
    
    NSString *clientId = parameters[kMendeleyOAuth2ClientIDKey];
    if (clientId != nil && [clientId isKindOfClass:[NSString class]]) {
        self.oAuthClientId = clientId;
    }
    NSString *clientSecret = parameters[kMendeleyOAuth2ClientSecretKey];
    if (clientSecret != nil && [clientSecret isKindOfClass:[NSString class]]) {
        self.oAuthClientSecret = clientSecret;
    }
    NSString *redirectUri = parameters[kMendeleyOAuth2RedirectURLKey];
    if (redirectUri != nil && [redirectUri isKindOfClass:[NSString class]]) {
        self.oAuthRedirectUri = redirectUri;
    }
}

- (NSURLRequest *)getAuthURLRequestWithIDPlusClientID:(NSString *)clientID
{
    NSString *urlString = [kMendeleyIDPlusBaseURL stringByAppendingPathComponent:kMendeleyIDPlusAuthorizationEndpoint];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:urlString];
    NSURLQueryItem *scopeParam = [NSURLQueryItem queryItemWithName:kMendeleyOAuth2ScopeKey value:self.idPlusScope];
    NSURLQueryItem *stateParam = [NSURLQueryItem queryItemWithName:kMendeleyOAuth2StateKey value:self.idPlusState];
    NSURLQueryItem *authTypeParam = [NSURLQueryItem queryItemWithName:kMendeleyOAuth2AuthTypeKey value:self.idPlusAuthType];
    NSURLQueryItem *platSiteParam = [NSURLQueryItem queryItemWithName:kMendeleyOAuth2PlatSiteKey value:self.idPlusPlatSite];
    NSURLQueryItem *promptParam = [NSURLQueryItem queryItemWithName:kMendeleyOAuth2PromptKey value:self.idPlusPrompt];
    NSURLQueryItem *redirectUriParam = [NSURLQueryItem queryItemWithName:kMendeleyOAuth2RedirectURLKey value:self.idPlusRedirectUri];
    NSURLQueryItem *responseTypeParam = [NSURLQueryItem queryItemWithName:kMendeleyOAuth2ResponseTypeKey value:self.idPlusResponseType];
    NSURLQueryItem *clientIdParam = [NSURLQueryItem queryItemWithName:kMendeleyOAuth2ClientIDKey value:clientID];
    
    components.queryItems = @[scopeParam, stateParam, authTypeParam, platSiteParam, promptParam, redirectUriParam, responseTypeParam, clientIdParam];
    
    NSURL *url = components.URL;
    
    return [NSURLRequest requestWithURL:url];
}

- (MendeleyAuthToken *) getAuthCodeAndStateFrom:(NSURL *)requestUrl
{
    MendeleyAuthToken *authToken = [MendeleyAuthToken new];
    
    if (requestUrl.query.length)
    {
        NSArray<NSString *> *components = [requestUrl.query componentsSeparatedByString:@"&"];
        
        for (NSString *component in components)
        {
            NSArray<NSString *> *parameterPair = [component componentsSeparatedByString:@"="];
            
            if (parameterPair.count == 2)
            {
                NSString *key = parameterPair.firstObject;
                NSString *value = parameterPair.lastObject;
                
                if ([kMendeleyOAuth2ResponseType isEqualToString:key])
                {
                    authToken.code = value;
                }
                else if ([kMendeleyOAuth2StateKey isEqualToString:key])
                {
                    authToken.state = value;
                }
            }
        }
    }
    
    return [authToken.state isEqualToString:self.idPlusState] ? authToken : nil;
}

- (void)obtainAccessTokensWithAuthorizationCode:(NSString *)code
                                completionBlock:(MendeleyOAuthCompletionBlock)completionBlock
{
    [NSError assertArgumentNotNil:code argumentName:@"authenticationCode"];
    [NSError assertArgumentNotNil:completionBlock argumentName:@"completionBlock"];
    NSDictionary *requestBody = @{ kMendeleyOAuth2ClientIDKey : self.oAuthClientId,
                                   kMendeleyOAuth2ClientSecretKey : self.oAuthClientSecret,
                                   kMendeleyOAuthAuthorizationCodeKey : kMendeleyOAuthClientCredentials,
                                   kMendeleyOAuth2ScopeKey : kMendeleyOAuth2Scope };
    
    NSDictionary *requestHeader = @{ kMendeleyRESTRequestContentType : kMendeleyRESTRequestURLType,
                                     kMendeleyRESTRequestAccept : kMendeleyRESTRequestJSONType };
    
    MendeleyTask *task = [MendeleyTask new];
    id<MendeleyNetworkProvider>networkProvider = MendeleyKitConfiguration.sharedInstance.networkProvider;
    [networkProvider invokePOST:MendeleyKitConfiguration.sharedInstance.baseAPIURL
                            api:kMendeleyOAuthPathOAuth2Token
              additionalHeaders:requestHeader
                 bodyParameters:requestBody
                         isJSON:NO
         authenticationRequired:NO
                           task:task
                completionBlock:^(MendeleyResponse *response, NSError *error) {
                    MendeleyBlockExecutor *blockExec = [[MendeleyBlockExecutor alloc] initWithOAuthCompletionBlock:completionBlock];
                    MendeleyKitHelper *helper = [MendeleyKitHelper new];
                    
                    if (![helper isSuccessForResponse:response error:&error])
                    {
                        [blockExec executeWithCredentials:nil error:error];
                    }
                    else
                    {
                        MendeleyModeller *modeller = [MendeleyModeller sharedInstance];
                        [modeller parseJSONData:response.responseBody expectedType:kMendeleyModelOpenIDCredentials completionBlock:^(MendeleyOAuthCredentials *credentials, NSError *parseError) {
                            
                            [blockExec executeWithCredentials:credentials error:parseError];
                        }];
                        
                    }
                    
                }];
}

- (void)obtainIDPlusAccessTokensWithAuthorizationCode:(NSString *)code
                                      completionBlock:(MendeleyIDPlusCompletionBlock)completionBlock
{
    [NSError assertArgumentNotNil:code argumentName:@"authenticationCode"];
    [NSError assertArgumentNotNil:completionBlock argumentName:@"completionBlock"];
    
    NSDictionary *requestBody = @{ kMendeleyOAuthAuthorizationCodeKey : kMendeleyOAuthAuthorizationCode,
                                   kMendeleyOAuth2RedirectURLKey : self.idPlusRedirectUri,
                                   kMendeleyOAuth2ResponseType : code
                                   };
    NSDictionary *requestHeader = @{ kMendeleyRESTRequestContentType : kMendeleyRESTRequestURLType,
                                     kMendeleyRESTRequestAccept : kMendeleyRESTRequestJSONType,
                                     kMendeleyRESTRequestAuthorization : [self base64StringWithClientId:kIDPlusClientID
                                                                                           clientSecret:kIDPlusSecret]
                                     };
    
    MendeleyTask *task = [MendeleyTask new];
    id<MendeleyNetworkProvider>networkProvider = [MendeleyKitConfiguration sharedInstance].networkProvider;
    [networkProvider invokePOST:[NSURL URLWithString:kMendeleyIDPlusBaseURL]
                            api:kMendeleyIDPlusTokenEndpoint
              additionalHeaders:requestHeader
                 bodyParameters:requestBody
                         isJSON:NO
         authenticationRequired:NO
                           task:task
                completionBlock:^(MendeleyResponse *response, NSError *error) {
                    MendeleyBlockExecutor *blockExec = [[MendeleyBlockExecutor alloc] initWithIdPlusCompletionBlock:completionBlock];
                    MendeleyKitHelper *helper = [MendeleyKitHelper new];
                    
                    if (![helper isSuccessForResponse:response error:&error])
                    {
                        [blockExec executeWithIDPlusCredentials:nil error:error];
                    }
                    else
                    {
                        MendeleyModeller *modeller = [MendeleyModeller sharedInstance];
                        [modeller parseJSONData:response.responseBody expectedType:kMendeleyModelIDPlusCredentials completionBlock:^(MendeleyIDPlusCredentials *credentials, NSError *parseError) {
                            
                            [blockExec executeWithIDPlusCredentials:credentials error:parseError];
                        }];
                        
                    }
                    
                }];
}

- (void)postProfileWithIDPlusCredentials:(MendeleyIDPlusCredentials *)credentials
                         completionBlock:(MendeleyObjectAndStateCompletionBlock)completionBlock
{
    MendeleyProfilesAPI *profilesAPI = [[MendeleyProfilesAPI alloc] initWithNetworkProvider:MendeleyKitConfiguration.sharedInstance.networkProvider
                                                                                    baseURL:MendeleyKitConfiguration.sharedInstance.baseAPIURL];
    [profilesAPI checkIDPlusProfileWithIdPlusToken:credentials.id_token
                                              task:[MendeleyTask new]
                                   completionBlock: completionBlock];
}

- (void)obtainMendeleyAPIAccessTokensWithMendeleyCredentials:(MendeleyOAuthCredentials *)mendeleyCredentials
                                           idPlusCredentials:(MendeleyIDPlusCredentials *)idPlusCredentials
                                             completionBlock:(MendeleyOAuthCompletionBlock)completionBlock
{
    [NSError assertArgumentNotNil:mendeleyCredentials argumentName:@"mendeleyCredentials"];
        [NSError assertArgumentNotNil:idPlusCredentials argumentName:@"idPlusCredentials"];
    [NSError assertArgumentNotNil:completionBlock argumentName:@"completionBlock"];
    NSDictionary *requestBody = @{ kMendeleyOAuthAuthorizationCodeKey : kMendeleyIdPlusGrantTypeValue,
                                   kMendeleyOAuth2ScopeKey : kMendeleyOAuth2Scope,
                                   kMendeleyIdPlusIdTokenKey : idPlusCredentials.id_token};

    NSDictionary *requestHeader = @{ kMendeleyRESTRequestContentType : kMendeleyRESTRequestURLType,
                                     kMendeleyRESTRequestAuthorization : [self base64StringWithClientId:self.oAuthClientId
                                                                                           clientSecret:self.oAuthClientSecret]};
    
    MendeleyTask *task = [MendeleyTask new];
    id<MendeleyNetworkProvider>networkProvider = MendeleyKitConfiguration.sharedInstance.networkProvider;
    [networkProvider invokePOST:MendeleyKitConfiguration.sharedInstance.baseAPIURL
                            api:kMendeleyOAuthPathOAuth2Token
              additionalHeaders:requestHeader
                 bodyParameters:requestBody
                         isJSON:NO
         authenticationRequired:NO
                           task:task
                completionBlock:^(MendeleyResponse *response, NSError *error) {
                    MendeleyBlockExecutor *blockExec = [[MendeleyBlockExecutor alloc] initWithOAuthCompletionBlock:completionBlock];
                    MendeleyKitHelper *helper = [MendeleyKitHelper new];
                    
                    if (![helper isSuccessForResponse:response error:&error])
                    {
                        [blockExec executeWithCredentials:nil error:error];
                    }
                    else
                    {
                        MendeleyModeller *modeller = [MendeleyModeller sharedInstance];
                        [modeller parseJSONData:response.responseBody expectedType:kMendeleyModelOpenIDCredentials completionBlock:^(MendeleyOAuthCredentials *credentials, NSError *parseError) {
                            
                            [blockExec executeWithCredentials:credentials error:parseError];
                        }];
                        
                    }
                    
                }];
}

- (void)refreshTokenWithOAuthCredentials:(MendeleyOAuthCredentials *)credentials completionBlock:(MendeleyOAuthCompletionBlock)completionBlock
{
    [self refreshTokenWithOAuthCredentials:credentials task:nil completionBlock:completionBlock];
}

- (void)refreshTokenWithOAuthCredentials:(nonnull MendeleyOAuthCredentials *)credentials
                                    task:(nullable MendeleyTask *)task
                         completionBlock:(nullable MendeleyOAuthCompletionBlock)completionBlock
{
    [NSError assertArgumentNotNil:credentials argumentName:@"credentials"];
    [NSError assertArgumentNotNil:completionBlock argumentName:@"completionBlock"];
    NSDictionary *requestBody = @{ kMendeleyOAuthAuthorizationCodeKey: kMendeleyOAuth2RefreshToken,
                                   kMendeleyOAuth2RefreshToken : credentials.refresh_token,
                                   kMendeleyOAuth2ClientSecretKey : self.oAuthClientSecret,
                                   kMendeleyOAuth2ClientIDKey : self.oAuthClientId };
    
    NSDictionary *requestHeader = @{ kMendeleyRESTRequestContentType : kMendeleyRESTRequestURLType,
                                     kMendeleyRESTRequestAccept : kMendeleyRESTRequestJSONType };
    
    id<MendeleyNetworkProvider>networkProvider = MendeleyKitConfiguration.sharedInstance.networkProvider;
    [networkProvider invokePOST:MendeleyKitConfiguration.sharedInstance.baseAPIURL
                            api:kMendeleyOAuthPathOAuth2Token
              additionalHeaders:requestHeader
                 bodyParameters:requestBody
                         isJSON:NO
         authenticationRequired:NO
                           task:task
                completionBlock:^(MendeleyResponse *response, NSError *error) {
                    MendeleyBlockExecutor *blockExec = [[MendeleyBlockExecutor alloc] initWithOAuthCompletionBlock:completionBlock];
                    MendeleyKitHelper *helper = [MendeleyKitHelper new];
                    
                    if (![helper isSuccessForResponse:response error:&error])
                    {
                        [blockExec executeWithCredentials:nil error:error];
                    }
                    else
                    {
                        MendeleyModeller *modeller = [MendeleyModeller sharedInstance];
                        [modeller parseJSONData:response.responseBody expectedType:kMendeleyModelOpenIDCredentials completionBlock:^(MendeleyOAuthCredentials *credentials, NSError *parseError) {
                            
                            [blockExec executeWithCredentials:credentials error:parseError];
                        }];
                        
                    }
                    
                }];
}

- (void)authenticateClientWithCompletionBlock:(MendeleyOAuthCompletionBlock)completionBlock
{
    NSDictionary *requestBody = @{ kMendeleyOAuthAuthorizationCodeKey : kMendeleyOAuthClientCredentials,
                                   kMendeleyOAuth2ScopeKey : kMendeleyOAuth2Scope,
                                   kMendeleyOAuth2ClientSecretKey : self.oAuthClientSecret,
                                   kMendeleyOAuth2ClientIDKey : self.oAuthClientId };
    NSDictionary *requestHeader = @{ kMendeleyRESTRequestContentType : kMendeleyRESTRequestURLType,
                                     kMendeleyRESTRequestAccept : kMendeleyRESTRequestJSONType };
    
    MendeleyTask *task = [MendeleyTask new];
    id<MendeleyNetworkProvider>networkProvider = MendeleyKitConfiguration.sharedInstance.networkProvider;
    [networkProvider invokePOST:MendeleyKitConfiguration.sharedInstance.baseAPIURL
                            api:kMendeleyOAuthPathOAuth2Token
              additionalHeaders:requestHeader
                 bodyParameters:requestBody
                         isJSON:NO
         authenticationRequired:NO
                           task:task
                completionBlock:^(MendeleyResponse *response, NSError *error) {
                    MendeleyBlockExecutor *blockExec = [[MendeleyBlockExecutor alloc] initWithOAuthCompletionBlock:completionBlock];
                    MendeleyKitHelper *helper = [MendeleyKitHelper new];
                    
                    if (![helper isSuccessForResponse:response error:&error])
                    {
                        [blockExec executeWithCredentials:nil error:error];
                    }
                    else
                    {
                        MendeleyModeller *modeller = [MendeleyModeller sharedInstance];
                        [modeller parseJSONData:response.responseBody expectedType:kMendeleyModelOpenIDCredentials completionBlock:^(MendeleyOAuthCredentials *credentials, NSError *parseError) {
                            
                            [blockExec executeWithCredentials:credentials error:parseError];
                        }];
                        
                    }
                    
                }];
}

- (BOOL)urlStringIsRedirectURI:(NSString *)urlString
{
    return [urlString hasPrefix:self.oAuthRedirectUri];
}

#pragma mark - Log out

- (void)logOutWithMendeleyCredentials:(nonnull MendeleyOAuthCredentials *)mendeleyCredentials
                       completionBlock:(nullable MendeleyCompletionBlock)completionBlock
{
    NSDictionary *requestHeader = @{ kMendeleyRESTRequestContentType : kMendeleyRESTRequestURLType,
                                     kMendeleyRESTRequestAuthorization : [self base64StringWithClientId:kIDPlusClientID
                                                                                           clientSecret:kIDPlusSecret]};

    [self revokeAccessTokenWithMendeleyCredentials:mendeleyCredentials
                                     requestHeader:requestHeader
                                   completionBlock:^(MendeleyResponse * _Nullable response, NSError * _Nullable error) {
                                       // Ignore response
                                       [self revokeRefreshTokenWithMendeleyCredentials:mendeleyCredentials
                                                                         requestHeader:requestHeader
                                                                       completionBlock:^(MendeleyResponse * _Nullable response, NSError * _Nullable error) {
                                                                           // Ignore response
                                                                           
                                                                           // Destroy all tokens
                                                                           [MendeleyKitConfiguration.sharedInstance.storeProvider removeOAuthCredentials];
                                                                           
                                                                           if (completionBlock)
                                                                           {
                                                                               completionBlock(YES, nil);
                                                                           }
                                                                       }];
                                   }];

}

- (void)revokeAccessTokenWithMendeleyCredentials:(nonnull MendeleyOAuthCredentials *)mendeleyCredentials
                                   requestHeader:(nonnull NSDictionary *)requestHeader
                             completionBlock:(nullable MendeleyResponseCompletionBlock)completionBlock
{
    NSDictionary *requestBodyAccessToken = @{ kMendeleyIdPlusTokenKey : mendeleyCredentials.access_token,
                                              kMendeleyIdPlusTokenTypeHintKey: kMendeleyIdPlusTokenTypeHintAccess};
    
    MendeleyTask *task = [MendeleyTask new];
    id<MendeleyNetworkProvider>networkProvider = MendeleyKitConfiguration.sharedInstance.networkProvider;
    [networkProvider invokePOST:[NSURL URLWithString:kMendeleyIDPlusBaseURL]
                            api:kMendeleyIDPlusRevokeEndpoint
              additionalHeaders:requestHeader
                 bodyParameters:requestBodyAccessToken
                         isJSON:NO
         authenticationRequired:NO
                           task:task
                completionBlock:completionBlock];
}

- (void)revokeRefreshTokenWithMendeleyCredentials:(nonnull MendeleyOAuthCredentials *)mendeleyCredentials
                                   requestHeader:(nonnull NSDictionary *)requestHeader
                                 completionBlock:(nullable MendeleyResponseCompletionBlock)completionBlock
{
    NSDictionary *requestBodyRefreshToken = @{ kMendeleyIdPlusTokenKey : mendeleyCredentials.refresh_token,
                                               kMendeleyIdPlusTokenTypeHintKey: kMendeleyIdPlusTokenTypeHintRefresh};
    
    MendeleyTask *task = [MendeleyTask new];
    id<MendeleyNetworkProvider>networkProvider = MendeleyKitConfiguration.sharedInstance.networkProvider;
    [networkProvider invokePOST:[NSURL URLWithString:kMendeleyIDPlusBaseURL]
                            api:kMendeleyIDPlusRevokeEndpoint
              additionalHeaders:requestHeader
                 bodyParameters:requestBodyRefreshToken
                         isJSON:NO
         authenticationRequired:NO
                           task:task
                completionBlock:completionBlock];
}
     

#pragma mark -
#pragma mark utility methods

- (NSString *)base64StringWithClientId:(NSString *)clientId
                          clientSecret:(NSString *)clientSecret
{
    NSString *contactString = [NSString stringWithFormat:@"%@:%@", clientId, clientSecret];
    NSString *base64IDCredentials = [[contactString dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
    NSString *authorizationString = [NSString stringWithFormat:@"Basic %@", base64IDCredentials];
    
    return authorizationString;
}


@end
