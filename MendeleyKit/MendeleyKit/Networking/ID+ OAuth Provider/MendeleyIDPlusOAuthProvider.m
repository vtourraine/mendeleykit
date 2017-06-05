//
//  MendeleyIDPlusOAuthProvider.m
//  MendeleyKit
//
//  Created by Tunney, Aaron (ELS) on 27/04/2017.
//  Copyright © 2017 Mendeley. All rights reserved.
//

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

NSString *const kMendeleyOAuth2StateKey = @"state";
NSString *const kMendeleyOAuth2AuthTypeKey = @"authType";
NSString *const kMendeleyOAuth2PlatSiteKey = @"platSite";
NSString *const kMendeleyOAuth2PromptKey = @"prompt";

NSString *const kMendeleyIDPlusBaseURL = @"https://loadcp-idp-cluster.np.elsevier-ae.com";
NSString *const kMendeleyIDPlusAuthorizationEndpoint = @"as/authorization.oauth2";
NSString *const kMendeleyIDPlusTokenEndpoint = @"as/token.oauth2";


@interface MendeleyIDPlusOAuthProvider ()

@property (nonatomic, assign, readwrite) BOOL isTrustedSSLServer;
@property (nonatomic, strong) NSString *clientID;
@property (nonatomic, strong) NSString *clientSecret;
@property (nonatomic, strong) NSString *redirectURI;

@property (nonatomic, strong) NSURL *baseURL;

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
//    id idObject = [parameters objectForKey:kMendeleyOAuth2ClientIDKey];
    
    NSString* idObject = @"Mendeley";
    
    if (nil != idObject && [idObject isKindOfClass:[NSString class]])
    {
        self.clientID = (NSString *) idObject;
    }
    
    id secretObj = [parameters objectForKey:kMendeleyOAuth2ClientSecretKey];
    if (nil != secretObj && [secretObj isKindOfClass:[NSString class]])
    {
        self.clientSecret = (NSString *) secretObj;
    }
    
    id redirectURI = [parameters objectForKey:kMendeleyOAuth2RedirectURLKey];
    if (nil != redirectURI && [redirectURI isKindOfClass:[NSString class]])
    {
        self.redirectURI = redirectURI;
    }
    
    self.baseURL = [NSURL URLWithString:kMendeleyIDPlusBaseURL];
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
                                };
    
    NSDictionary *requestHeader = @{ kMendeleyRESTRequestContentType : kMendeleyRESTRequestURLType,
                                     kMendeleyRESTRequestAccept : kMendeleyRESTRequestJSONType };
    
    MendeleyTask *task = [MendeleyTask new];
    [self executeAuthenticationRequestWithRequestHeader:requestHeader
                                            requestBody:requestBody
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

- (NSURLRequest *)oauthURLRequest
{
    NSURL *baseOAuthURL = [self.baseURL URLByAppendingPathComponent:kMendeleyIDPlusAuthorizationEndpoint];
    NSDictionary *parameters = @{ //kMendeleyOAuthAuthorizationCodeKey: kMendeleyOAuthAuthorizationCode,
                                  kMendeleyOAuth2RedirectURLKey: self.redirectURI,
                                  kMendeleyOAuth2ScopeKey: kMendeleyIDPlusScope,
                                  kMendeleyOAuth2ClientIDKey: self.clientID,
                                  kMendeleyOAuth2ResponseTypeKey: kMendeleyOAuth2ResponseType,
                                  kMendeleyOAuth2StateKey: self.state,
                                  kMendeleyOAuth2AuthTypeKey: kMendeleyIDPlusAuthType,
                                  kMendeleyOAuth2PlatSiteKey: kMendeleyIDPlusPlatSite,
                                  kMendeleyOAuth2PromptKey: kMendeleyIDPlusPrompt
                                  };
    
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
                else if ([kMendeleyOAuth2StateKey isEqualToString:key])
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
                             completionBlock:(MendeleyOAuthCompletionBlock)completionBlock
{
    id<MendeleyNetworkProvider>networkProvider = [MendeleyKitConfiguration sharedInstance].networkProvider;
    [networkProvider invokePOST:self.baseURL
                            api:kMendeleyIDPlusTokenEndpoint
              additionalHeaders:requestHeader
                 bodyParameters:requestBody
                         isJSON:NO
         authenticationRequired:NO
                           task:[MendeleyTask new]
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
                        [modeller parseJSONData:response.responseBody expectedType:kMendeleyModelOpenIDCredentials completionBlock:^(MendeleyOpenIDCredentials *credentials, NSError *parseError) {
                            [blockExec executeWithCredentials:credentials error:parseError];
                        }];
                        
                    }
                    
                }];
}

@end
