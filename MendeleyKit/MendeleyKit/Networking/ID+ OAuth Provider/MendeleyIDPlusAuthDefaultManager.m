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

@property (nonatomic, strong) NSString *scope;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *authType;
@property (nonatomic, strong) NSString *platSite;
@property (nonatomic, strong) NSString *prompt;
@property (nonatomic, strong) NSString *redirectUri;
@property (nonatomic, strong) NSString *responseType;
@property (nonatomic, strong) NSString *clientId;

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
    
    NSString *scope = parameters[@"scope"];
    if (scope != nil && [scope isKindOfClass:[NSString class]]) {
        self.scope = scope;
    }
    NSString *state = parameters[@"state"];
    if (state != nil && [state isKindOfClass:[NSString class]]) {
        self.state = state;
    }
    NSString *authType = parameters[@"authType"];
    if (authType != nil && [authType isKindOfClass:[NSString class]]) {
        self.authType = authType;
    }
    NSString *platSite = parameters[@"platSite"];
    if (platSite != nil && [platSite isKindOfClass:[NSString class]]) {
        self.platSite = platSite;
    }
    NSString *prompt = parameters[@"prompt"];
    if (prompt != nil && [prompt isKindOfClass:[NSString class]]) {
        self.prompt = prompt;
    }
    NSString *redirectUri = parameters[@"redirect_uri"];
    if (redirectUri != nil && [redirectUri isKindOfClass:[NSString class]]) {
        self.redirectUri = redirectUri;
    }
    NSString *responseType = parameters[@"response_type"];
    if (responseType != nil && [responseType isKindOfClass:[NSString class]]) {
        self.responseType = responseType;
    }
    NSString *clientId = parameters[@"client_id"];
    if (clientId != nil && [clientId isKindOfClass:[NSString class]]) {
        self.clientId = clientId;
    }
}

- (NSURLRequest *)getAuthURLRequestWithClientID:(NSString *)clientID
{
    NSURLComponents *components = [NSURLComponents componentsWithString:@"https://loadcp-id.elsevier.com/as/authorization.oauth2"];
    NSURLQueryItem *scopeParam = [NSURLQueryItem queryItemWithName:@"scope" value:self.scope];
    NSURLQueryItem *stateParam = [NSURLQueryItem queryItemWithName:@"state" value:self.state];
    NSURLQueryItem *authTypeParam = [NSURLQueryItem queryItemWithName:@"authType" value:self.authType];
    NSURLQueryItem *platSiteParam = [NSURLQueryItem queryItemWithName:@"platSite" value:self.platSite];
    NSURLQueryItem *promptParam = [NSURLQueryItem queryItemWithName:@"prompt" value:self.prompt];
    NSURLQueryItem *redirectUriParam = [NSURLQueryItem queryItemWithName:@"redirect_uri" value:self.redirectUri];
    NSURLQueryItem *responseTypeParam = [NSURLQueryItem queryItemWithName:@"response_type" value:self.responseType];
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
    
}

- (void)obtainIDPlusAccessTokensWithAuthorizationCode:(NSString *)code
                                      completionBlock:(MendeleyIDPlusCompletionBlock)completionBlock
{
    [NSError assertArgumentNotNil:code argumentName:@"authenticationCode"];
    [NSError assertArgumentNotNil:completionBlock argumentName:@"completionBlock"];
    
    NSDictionary *requestBody = @{ kMendeleyOAuthAuthorizationCodeKey : kMendeleyOAuthAuthorizationCode,
                                   kMendeleyOAuth2RedirectURLKey : self.redirectUri,
                                   kMendeleyOAuth2ResponseType : code
                                   };
    NSString *contactString = [NSString stringWithFormat:@"%@:%@", MendeleyKitConfiguration.sharedInstance.idPlusClientId, MendeleyKitConfiguration.sharedInstance.idPlusClientSecret];
    NSString *base64IDCredentials = [[contactString dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
    NSString *authorizationString = [NSString stringWithFormat:@"Basic %@", base64IDCredentials];
    
    NSDictionary *requestHeader = @{ kMendeleyRESTRequestContentType : kMendeleyRESTRequestURLType,
                                     kMendeleyRESTRequestAccept : kMendeleyRESTRequestJSONType,
                                     kMendeleyRESTRequestAuthorization : authorizationString};
    
    MendeleyTask *task = [MendeleyTask new];
    [self executeAuthenticationRequestWithRequestHeader:requestHeader
                                            requestBody:requestBody
                                                   task:task
                                        completionBlock:completionBlock];
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

- (void)executeAuthenticationRequestWithRequestHeader:(NSDictionary *)requestHeader
                                          requestBody:(NSDictionary *)requestBody
                                                 task:(MendeleyTask *)task
                                      completionBlock:(MendeleyIDPlusCompletionBlock)completionBlock
{
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
                        [blockExec executeWithCredentials:nil error:error];
                    }
                    else
                    {
                        MendeleyModeller *modeller = [MendeleyModeller sharedInstance];
                        [modeller parseJSONData:response.responseBody expectedType:kMendeleyModelIDPlusCredentials completionBlock:^(MendeleyIDPlusCredentials *credentials, NSError *parseError) {
                            
                            [blockExec executeWithCredentials:credentials error:parseError];
                        }];
                        
                    }
                    
                }];
}


@end
