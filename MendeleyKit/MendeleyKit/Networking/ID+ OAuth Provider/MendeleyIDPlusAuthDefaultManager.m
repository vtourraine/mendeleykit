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
    NSString *redirectUri = parameters[@"redirectUri"];
    if (redirectUri != nil && [redirectUri isKindOfClass:[NSString class]]) {
        self.redirectUri = redirectUri;
    }
    NSString *responseType = parameters[@"responseType"];
    if (responseType != nil && [responseType isKindOfClass:[NSString class]]) {
        self.responseType = responseType;
    }
    NSString *clientId = parameters[@"clientId"];
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
    NSURLQueryItem *clientIdParam = [NSURLQueryItem queryItemWithName:@"client_id" value:self.clientId];
    
    components.queryItems = @[scopeParam, stateParam, authTypeParam, platSiteParam, promptParam, redirectUriParam, responseTypeParam, clientIdParam];
    
    NSURL *url = components.URL;
    
    return [NSURLRequest requestWithURL:url];
}

- (void)obtainAccessTokensWithAuthorizationCode:(NSString *)code
                                completionBlock:(MendeleyOAuthCompletionBlock)completionBlock
{
    
}

- (void)obtainIDPlusAccessTokensWithAuthorizationCode:(NSString *)code
                                      completionBlock:(MendeleyIDPlusCompletionBlock)completionBlock
{
    
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
