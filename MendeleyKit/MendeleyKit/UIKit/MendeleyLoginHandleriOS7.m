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

#ifndef MendeleyKitiOSFramework

#import "MendeleyLoginHandleriOS7.h"
#import "MendeleyURLBuilder.h"
#import "MendeleyKitConfiguration.h"
#import "MendeleyOAuthConstants.h"
#import "MendeleyOAuthStore.h"
#import "MendeleyDefaultOAuthProvider.h"
#import "NSError+MendeleyError.h"

@interface MendeleyLoginHandleriOS7 ()
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSURL *oauthServer;
@property (nonatomic, strong) NSString *clientID;
@property (nonatomic, strong) NSString *redirectURI;
@property (nonatomic, copy) MendeleyCompletionBlock completionBlock;
@property (nonatomic, strong) MendeleyOAuthCompletionBlock oAuthCompletionBlock;
@property (nonatomic, strong) id<MendeleyOAuthProvider> oauthProvider;
@end

@implementation MendeleyLoginHandleriOS7
- (void)startLoginProcessWithClientID:(NSString *)clientID
                          redirectURI:(NSString *)redirectURI
                           controller:(UIViewController *)controller
                      completionBlock:(MendeleyCompletionBlock)completionBlock
                 oauthCompletionBlock:(MendeleyOAuthCompletionBlock)oauthCompletionBlock
{
    self.oauthProvider = [[MendeleyKitConfiguration sharedInstance] oauthProvider];
    self.clientID = clientID;
    self.redirectURI = redirectURI;
    self.oAuthCompletionBlock = oauthCompletionBlock;
    self.completionBlock = completionBlock;
    self.oauthServer = [MendeleyKitConfiguration sharedInstance].baseAPIURL;
    [self cleanCookiesAndURLCache];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:controller.view.bounds];
    [webView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    webView.delegate = self;
    [controller.view addSubview:webView];
    self.webView = webView;
    
    NSURLRequest *loginRequest = [self oauthURLRequest];
    [self.webView loadRequest:loginRequest];
}

- (BOOL)webView:(nonnull UIWebView *)webView shouldStartLoadWithRequest:(nonnull NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
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

- (void)webView:(nonnull UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
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
    self.webView.delegate = nil;
    self.webView = nil;
    
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
#endif