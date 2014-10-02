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

#import "MendeleyLoginController.h"
#import "MendeleyURLBuilder.h"
#import "MendeleyKitConfiguration.h"
#import "MendeleyOAuthConstants.h"
#import "MendeleyOAuthStore.h"
#import "MendeleyDefaultOAuthProvider.h"
#import "NSError+MendeleyError.h"

@interface MendeleyLoginController ()
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSURL *oauthServer;
@property (nonatomic, strong) NSString *clientID;
@property (nonatomic, strong) NSString *redirectURI;
@property (nonatomic, copy) MendeleyCompletionBlock completionBlock;
@property (nonatomic, strong) MendeleyOAuthCompletionBlock oAuthCompletionBlock;
@property (nonatomic, strong) id<MendeleyOAuthProvider> oauthProvider;
@end

@implementation MendeleyLoginController

- (id)initWithClientKey:(NSString *)clientKey
           clientSecret:(NSString *)clientSecret
            redirectURI:(NSString *)redirectURI
        completionBlock:(MendeleyCompletionBlock)completionBlock
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
        completionBlock:(MendeleyCompletionBlock)completionBlock
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.view.autoresizesSubviews = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self startLoginProcess];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark Handle device rotations
- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

#pragma mark UIWebview delegate methods
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([request.URL.absoluteString hasPrefix:[self.oauthServer absoluteString]])
    {
        return YES;
    }
    NSString *code = [self authenticationCodeFromURLRequest:request];
    if (nil != code)
    {
        MendeleyOAuthCompletionBlock oAuthCompletionBlock = self.oAuthCompletionBlock;
        [self.oauthProvider authenticateWithAuthenticationCode:code
                                               completionBlock:oAuthCompletionBlock];
    }
    else
    {
        ///TODO error handling
    }

    return NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSDictionary *userInfo = [error userInfo];
    NSString *failingURLString = [userInfo objectForKey:NSURLErrorFailingURLStringErrorKey];

    if (nil != failingURLString && [self.oauthProvider urlStringIsRedirectURI:failingURLString])
    {
        // ignore if redirect URI
        return;
    }

    MendeleyCompletionBlock completionBlock = self.completionBlock;

    if (completionBlock)
    {
        completionBlock(NO, error);
    }
    self.oAuthCompletionBlock = nil;
    self.completionBlock = nil;
    self.webView = nil;
}

#pragma mark private methods
- (void)startLoginProcess
{
    [self setUpCompletionBlock];
    self.oauthServer = [MendeleyKitConfiguration sharedInstance].baseAPIURL;
    [self cleanCookiesAndURLCache];

    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];

    webView.delegate = self;
    [self.view addSubview:webView];
    self.webView = webView;

    NSURLRequest *loginRequest = [self oauthURLRequest];
    [self.webView loadRequest:loginRequest];
}

- (void)setUpCompletionBlock
{
    MendeleyOAuthCompletionBlock oAuthCompletionBlock = ^void (MendeleyOAuthCredentials *credentials, NSError *error){
        if (nil != credentials)
        {
            MendeleyOAuthStore *oauthStore = [[MendeleyOAuthStore alloc] init];
            BOOL success = [oauthStore storeOAuthCredentials:credentials];
            if (nil != self.completionBlock)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                                   self.completionBlock(success, nil);
                               });
            }
        }
        else
        {
            if (nil != self.completionBlock)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                                   self.completionBlock(NO, error);
                               });
            }
        }
    };

    self.oAuthCompletionBlock = oAuthCompletionBlock;
}


- (void)cleanCookiesAndURLCache
{
    if (nil == self.oauthServer)
    {
        return;
    }

    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies])
    {

        NSString *cookieDomain = [cookie domain];
        if ([cookieDomain isEqualToString:kMendeleyKitURL])
        {

            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        }
        if ([cookieDomain isEqualToString:[self.oauthServer host]])
        {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        }
    }
}

- (NSURLRequest *)oauthURLRequest
{
    NSURL *baseOAuthURL = [self.oauthServer URLByAppendingPathComponent:kMendeleyOAuthPathAuthorize];
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

- (NSString *)authenticationCodeFromURLRequest:(NSURLRequest *)request
{
    NSArray *urlComponents = [[[request URL] query] componentsSeparatedByString:@"&"];
    __block NSString *code = nil;

    [urlComponents enumerateObjectsUsingBlock:^(NSString *param, NSUInteger index, BOOL *stop) {
         NSArray *parameterPair = [param componentsSeparatedByString:@"="];
         NSString *key = [parameterPair objectAtIndex:0];
         NSString *value = [parameterPair objectAtIndex:1];
         if ([key isEqualToString:kMendeleyOAuth2ResponseType])
         {
             code = value;
         }
     }];
    return code;
}
@end
