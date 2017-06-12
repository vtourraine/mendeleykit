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
#import "MendeleyIDPlusOAuthProvider.h"
#import "MendeleyKitConfiguration.h"
#import "NSError+Exceptions.h"
#import "MendeleyOAuthConstants.h"
#import "MendeleyBlockExecutor.h"
#import "MendeleyKitHelper.h"
#import "MendeleyModeller.h"

NSString *const kMendeleyOAuth2StateKey = @"state";
NSString *const kMendeleyIDPlusBaseURL = @"https://loadcp-id.elsevier.com";
NSString *const kMendeleyIDPlusAuthorizationEndpoint = @"as/authorization.oauth2";
NSString *const kMendeleyIDPlusTokenEndpoint = @"as/token.oauth2";

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
    NSURLComponents *components = [NSURLComponents componentsWithString:@"https://loadcp-id.elsevier.com/as/authorization.oauth2"];
    NSURLQueryItem *scopeParam = [NSURLQueryItem queryItemWithName:@"scope" value:self.idPlusScope];
    NSURLQueryItem *stateParam = [NSURLQueryItem queryItemWithName:@"state" value:self.idPlusState];
    NSURLQueryItem *authTypeParam = [NSURLQueryItem queryItemWithName:@"authType" value:self.idPlusAuthType];
    NSURLQueryItem *platSiteParam = [NSURLQueryItem queryItemWithName:@"platSite" value:self.idPlusPlatSite];
    NSURLQueryItem *promptParam = [NSURLQueryItem queryItemWithName:@"prompt" value:self.idPlusPrompt];
    NSURLQueryItem *redirectUriParam = [NSURLQueryItem queryItemWithName:@"redirect_uri" value:self.idPlusRedirectUri];
    NSURLQueryItem *responseTypeParam = [NSURLQueryItem queryItemWithName:@"response_type" value:self.idPlusResponseType];
    NSURLQueryItem *clientIdParam = [NSURLQueryItem queryItemWithName:@"client_id" value:clientID];
    
    components.queryItems = @[scopeParam, stateParam, authTypeParam, platSiteParam, promptParam, redirectUriParam, responseTypeParam, clientIdParam];
    
    NSURL *url = components.URL;
    
    return [NSURLRequest requestWithURL:url];
}

//TODO: compare the return state string to the one sent with the initial request 
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
    
    return authToken;
}

- (void)obtainAccessTokensWithAuthorizationCode:(NSString *)code
                                completionBlock:(MendeleyOAuthCompletionBlock)completionBlock
{
    [NSError assertArgumentNotNil:code argumentName:@"authenticationCode"];
    [NSError assertArgumentNotNil:completionBlock argumentName:@"completionBlock"];
    NSDictionary *requestBody = @{ kMendeleyOAuthAuthorizationCodeKey : kMendeleyOAuthAuthorizationCode,
                                   kMendeleyOAuth2RedirectURLKey : self.oAuthRedirectUri,
                                   kMendeleyOAuth2ResponseType : code,
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
                        [modeller parseJSONData:response.responseBody expectedType:kMendeleyModelIDPlusCredentials completionBlock:^(MendeleyOAuthCredentials *credentials, NSError *parseError) {
                            
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
    NSString *contactString = [NSString stringWithFormat:@"%@:%@", MendeleyKitConfiguration.sharedInstance.idPlusClientId, MendeleyKitConfiguration.sharedInstance.idPlusClientSecret];
    NSString *base64IDCredentials = [[contactString dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
    NSString *authorizationString = [NSString stringWithFormat:@"Basic %@", base64IDCredentials];
    
    NSDictionary *requestHeader = @{ kMendeleyRESTRequestContentType : kMendeleyRESTRequestURLType,
                                     kMendeleyRESTRequestAccept : kMendeleyRESTRequestJSONType,
                                     kMendeleyRESTRequestAuthorization : authorizationString};
    
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

- (void)postProfileWithMendeleyCredentials:(MendeleyOAuthCredentials *)credentials
                           completionBlock:(MendeleyCompletionBlock)completionBlock
{
    
}

- (void)obtainMendeleyAPIAccessTokensWithMendeleyCredentials:(MendeleyOAuthCredentials *)mendeleyCredentials
                                           idPlusCredentials:(MendeleyIDPlusCredentials *)idPlusCredentials
                                             completionBlock:(MendeleyOAuthCompletionBlock)completionBlock
{
    
}


@end
