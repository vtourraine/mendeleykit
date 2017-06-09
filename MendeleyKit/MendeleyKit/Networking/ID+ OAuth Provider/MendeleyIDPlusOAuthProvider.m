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

#import "MendeleyIDPlusOAuthProvider.h"
#import "NSError+Exceptions.h"
#import "MendeleyOAuthConstants.h"
#import "MendeleyURLBuilder.h"
#import "MendeleyKitConfiguration.h"
#import "MendeleyBlockExecutor.h"
#import "MendeleyKitHelper.h"
#import "MendeleyModeller.h"
#import "MendeleyTask.h"


NSString *const kMendeleyIDPlusResponseType = @"code";
NSString *const kMendeleyIDPlusScope = @"openid email profile";
NSString *const kMendeleyIDPlusAuthType = @"SINGLE_SIGN_IN";
NSString *const kMendeleyIDPlusPlatSite = @"MDY/mendeley";
NSString *const kMendeleyIDPlusPrompt = @"login";

NSString *const kMendeleyIDPlusClientIdValue = @"Mendeley";
NSString *const kMendeleyIDPlusClientSecretValue = @"jCppRnFrDxLHlF9vCzaX6b5doOsLGrNCseyOMg7pst8lfZOEflanH7bIFzozZKVl";

NSString *const kMendeleyOAuth2StateKeyDeprecated = @"state";
NSString *const kMendeleyOAuth2AuthTypeKey = @"authType";
NSString *const kMendeleyOAuth2PlatSiteKey = @"platSite";
NSString *const kMendeleyOAuth2PromptKey = @"prompt";

NSString *const kMendeleyIDPlusBaseURLDeprecated = @"https://loadcp-id.elsevier.com";
NSString *const kMendeleyIDPlusAuthorizationEndpointDeprecated = @"as/authorization.oauth2";
NSString *const kMendeleyIDPlusTokenEndpointDeprecated = @"as/token.oauth2";


@interface MendeleyIDPlusOAuthProvider ()

@property (nonatomic, assign, readwrite) BOOL isTrustedSSLServer;
@property (nonatomic, strong) NSString *idPlusClientID;
@property (nonatomic, strong) NSString *idPlusClientSecret;
@property (nonatomic, strong) NSString *clientID;
@property (nonatomic, strong) NSString *clientSecret;
@property (nonatomic, strong) NSString *redirectURI;

@property (nonatomic, strong) NSURL *baseURL;
@property (nonatomic, strong) NSURL *idPlusBaseURL;

// response_type
// scope
// client_id
// state
// authType
// platSite
// prompt
// redirect_uri

@end


@implementation MendeleyIDPlusOAuthProvider

+ (MendeleyIDPlusOAuthProvider *)sharedInstance
{
    static MendeleyIDPlusOAuthProvider *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[MendeleyIDPlusOAuthProvider alloc] init];
    });
    return sharedInstance;
}

#pragma mark - MendeleyOAuthProvider protocol methods

- (void)configureOAuthWithParameters:(NSDictionary *)parameters
{
    [NSError assertArgumentNotNil:parameters argumentName:@"parameters"];
    NSString *idObject = [parameters objectForKey:kMendeleyOAuth2ClientIDKey];

    if (nil != idObject && [idObject isKindOfClass:[NSString class]])
    {
        self.clientID = (NSString *) idObject;
    }
    
    id secretObj = [parameters objectForKey:kMendeleyOAuth2ClientSecretKey];
    if (nil != secretObj && [secretObj isKindOfClass:[NSString class]])
    {
        self.clientSecret = (NSString *) secretObj;
    }
    
    self.idPlusClientID = kMendeleyIDPlusClientIdValue;
    self.idPlusClientSecret = kMendeleyIDPlusClientSecretValue;
    
    id redirectURI = [parameters objectForKey:kMendeleyOAuth2RedirectURLKey];
    if (nil != redirectURI && [redirectURI isKindOfClass:[NSString class]])
    {
        self.redirectURI = redirectURI;
    }
    
    self.idPlusBaseURL = [NSURL URLWithString:kMendeleyIDPlusBaseURLDeprecated];
//    self.baseURL = [MendeleyKitConfiguration sharedInstance].baseAPIURL;
}


- (BOOL)urlStringIsRedirectURI:(NSString *)urlString
{
    return [urlString hasPrefix:self.redirectURI];
}


- (void)authenticateWithUserName:(NSString *)username
                        password:(NSString *)password
                 completionBlock:(MendeleyCompletionBlock)completionBlock
{
    
}


- (void)authenticateWithAuthenticationCode:(NSString *)authenticationCode
                           completionBlock:(MendeleyOAuthCompletionBlock)completionBlock
{
    
    [NSError assertArgumentNotNil:authenticationCode argumentName:@"authenticationCode"];
    [NSError assertArgumentNotNil:completionBlock argumentName:@"completionBlock"];
    NSDictionary *requestBody = @{ kMendeleyOAuthAuthorizationCodeKey : kMendeleyOAuthAuthorizationCode,
                                   kMendeleyOAuth2RedirectURLKey : self.redirectURI,
                                   kMendeleyOAuth2ResponseType : authenticationCode,
                                   kMendeleyOAuth2ClientSecretKey : self.clientSecret,
                                   kMendeleyOAuth2ClientIDKey : self.clientID };
    
    NSDictionary *requestHeader = @{ kMendeleyRESTRequestContentType : kMendeleyRESTRequestURLType,
                                     kMendeleyRESTRequestAccept : kMendeleyRESTRequestJSONType };
    
    [self executeAuthenticationRequestWithRequestHeader:requestHeader
                                            requestBody:requestBody
                                        completionBlock:completionBlock];

}

- (void)authenticateWithIdPlusAuthenticationCode:(NSString *)authenticationCode completionBlock:(MendeleyOAuthCompletionBlock)completionBlock
{
    [NSError assertArgumentNotNil:authenticationCode argumentName:@"authenticationCode"];
    [NSError assertArgumentNotNil:completionBlock argumentName:@"completionBlock"];
    
    NSDictionary *requestBody = @{ kMendeleyOAuthAuthorizationCodeKey : kMendeleyOAuthAuthorizationCode,
                                   kMendeleyOAuth2RedirectURLKey : self.redirectURI,
                                   kMendeleyOAuth2ResponseType : authenticationCode,
                                   };
    NSString *contactString = [NSString stringWithFormat:@"%@:%@", self.idPlusClientID, self.idPlusClientSecret];
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
    // Get ID+ token
    
    // Get/create profile
    
    // Exchange ID+ token for MendeleyToken
}


- (void)refreshTokenWithOAuthCredentials:(MendeleyOAuthCredentials *)credentials
                         completionBlock:(MendeleyOAuthCompletionBlock)completionBlock
{
    [self refreshTokenWithOAuthCredentials:credentials
                                      task:nil
                           completionBlock:completionBlock];
}

- (void)refreshTokenWithOAuthCredentials:(MendeleyOAuthCredentials *)credentials
                                    task:(id)task
                         completionBlock:(MendeleyOAuthCompletionBlock)completionBlock
{

}

- (void)authenticateClientWithCompletionBlock:(MendeleyOAuthCompletionBlock)completionBlock
{

}

//- (NSURLRequest *)oauthURLRequest
//{
//    NSURL *baseOAuthURL = [self.baseURL URLByAppendingPathComponent:kMendeleyIDPlusAuthorizationEndpointDeprecated];
//    NSDictionary *parameters = @{ //kMendeleyOAuthAuthorizationCodeKey: kMendeleyOAuthAuthorizationCode,
//                                  kMendeleyOAuth2RedirectURLKey: self.redirectURI,
//                                  kMendeleyOAuth2ScopeKey: kMendeleyIDPlusScope,
////                                  kMendeleyOAuth2ClientIDKey: self.clientID,
//                                  kMendeleyOAuth2ClientIDKey: self.idPlusClientID,
//                                  kMendeleyOAuth2ResponseTypeKey: kMendeleyOAuth2ResponseType,
//                                  kMendeleyOAuth2StateKeyDeprecated: self.state,
//                                  kMendeleyOAuth2AuthTypeKey: kMendeleyIDPlusAuthType,
//                                  kMendeleyOAuth2PlatSiteKey: kMendeleyIDPlusPlatSite,
//                                  kMendeleyOAuth2PromptKey: kMendeleyIDPlusPrompt
//                                  };
//    
//    baseOAuthURL = [MendeleyURLBuilder urlWithBaseURL:baseOAuthURL parameters:parameters query:YES];
//    
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:baseOAuthURL];
//    request.HTTPMethod = @"GET";
//    request.allHTTPHeaderFields = [MendeleyURLBuilder defaultHeader];
//    
//    return request;
//}

- (NSURLRequest *)oauthURLRequest
{
    NSURL *baseOAuthURL = [[MendeleyKitConfiguration sharedInstance].baseAPIURL URLByAppendingPathComponent:kMendeleyOAuthPathAuthorize];
    NSDictionary *parameters = @{ kMendeleyOAuthAuthorizationCodeKey: kMendeleyOAuthAuthorizationCode,
                                  kMendeleyOAuth2RedirectURLKey: self.redirectURI,
                                  kMendeleyOAuth2ScopeKey: kMendeleyOAuth2Scope,
                                  kMendeleyOAuth2ClientIDKey: self.clientID,
                                  kMendeleyOAuth2ResponseTypeKey: kMendeleyOAuth2ResponseType };
    
    baseOAuthURL = [MendeleyURLBuilder urlWithBaseURL:baseOAuthURL parameters:parameters query:YES];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:baseOAuthURL];
    request.HTTPMethod = @"GET";
    request.allHTTPHeaderFields = [MendeleyURLBuilder defaultHeader];
    
    return request;
}

- (NSString *)getAuthenticationCodeFromURL:(NSURL *)redirectURL
{
    NSString *code;
    NSString *state;
    
    if (redirectURL.query.length)
    {
        NSArray<NSString *> *components = [redirectURL.query componentsSeparatedByString:@"&"];
        
        for (NSString *component in components)
        {
            NSArray<NSString *> *parameterPair = [component componentsSeparatedByString:@"="];
            
            if (parameterPair.count == 2)
            {
                NSString *key = parameterPair.firstObject;
                NSString *value = parameterPair.lastObject;
                
                if ([kMendeleyOAuth2ResponseType isEqualToString:key])
                {
                    code = value;
                }
                else if ([kMendeleyOAuth2StateKeyDeprecated isEqualToString:key])
                {
                    state = value;
                }
            }
        }
    }

    return [state isEqualToString:self.state] ? code : nil;
}

#pragma mark - Private methods

- (NSString *)state
{
    static NSString *state = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        // Generate a random string
        state = [[[NSProcessInfo processInfo] globallyUniqueString] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    });

    return state;
}

- (void)executeAuthenticationRequestWithRequestHeader:(NSDictionary *)requestHeader
                                 requestBody:(NSDictionary *)requestBody
                                                 task:(MendeleyTask *)task
                             completionBlock:(MendeleyOAuthCompletionBlock)completionBlock
{
    id<MendeleyNetworkProvider>networkProvider = [MendeleyKitConfiguration sharedInstance].networkProvider;
    [networkProvider invokePOST:self.idPlusBaseURL
                            api:kMendeleyIDPlusTokenEndpointDeprecated
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
                        [modeller parseJSONData:response.responseBody expectedType:kMendeleyModelIDPlusCredentials completionBlock:^(MendeleyIDPlusCredentials *credentials, NSError *parseError) {
              
                            [blockExec executeWithCredentials:credentials error:parseError];
                        }];
                        
                    }
                    
                }];
}

- (void)executeAuthenticationRequestWithTask:(MendeleyTask *)task
                               requestHeader:(NSDictionary *)requestHeader
                                 requestBody:(NSDictionary *)requestBody
                             completionBlock:(MendeleyOAuthCompletionBlock)completionBlock
{
    id<MendeleyNetworkProvider>networkProvider = [MendeleyKitConfiguration sharedInstance].networkProvider;
    [networkProvider invokePOST:[MendeleyKitConfiguration sharedInstance].baseAPIURL
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
                        [modeller parseJSONData:response.responseBody expectedType:kMendeleyModelOAuthCredentials completionBlock:^(MendeleyOAuthCredentials *credentials, NSError *parseError) {
                            [blockExec executeWithCredentials:credentials error:parseError];
                        }];
                        
                    }
                    
                }];
}

- (void)executeAuthenticationRequestWithRequestHeader:(NSDictionary *)requestHeader
                                          requestBody:(NSDictionary *)requestBody
                                      completionBlock:(MendeleyOAuthCompletionBlock)completionBlock
{
    [self executeAuthenticationRequestWithTask:nil requestHeader:requestHeader requestBody:requestBody completionBlock:completionBlock];
}

@end
