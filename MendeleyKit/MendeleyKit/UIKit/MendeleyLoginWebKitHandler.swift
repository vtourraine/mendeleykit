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

import UIKit
import WebKit

@available (iOS 9.0, *)
public class MendeleyLoginWebKitHandler: NSObject, WKNavigationDelegate, MendeleyLoginHandler
{
    let oAuthServer: NSURL = MendeleyKitConfiguration.sharedInstance().baseAPIURL
    let oAuthProvider = MendeleyKitConfiguration.sharedInstance().oauthProvider
    public var webView: WKWebView?
    var completionBlock: MendeleySuccessClosure?
    var oAuthCompletionBlock: MendeleyOAuthClosure?

    public func startLoginProcess(clientID: String, redirectURI: String, controller: UIViewController, completionHandler: MendeleySuccessClosure, oauthHandler: MendeleyOAuthClosure)
    {
        completionBlock = completionHandler
        oAuthCompletionBlock = oauthHandler
        configureWebView(controller)
        
        let helper = MendeleyKitLoginHelper()
//        helper.cleanCookiesAndURLCache()
        let request: NSURLRequest = helper.getOAuthRequest(redirectURI, clientID: clientID)
        print("request URL = \(request.URL)")
        self.webView!.loadRequest(request)
        
        print("loaded request")
    }
    
    public func configureWebView(controller: UIViewController)
    {
        let configuration = WKWebViewConfiguration()
        webView = WKWebView(frame: controller.view.frame, configuration: configuration)
        webView!.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
        controller.view.addSubview(webView!)
        
        webView!.navigationDelegate = self
    }
    
    public func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("starting to load the login page")
    }
    
    public func webView(webView: WKWebView, didReceiveAuthenticationChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
        print("did receive an authentication challenge")
    }
    
    
    public func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!)
    {
        print("did Finish navigation for webview")
    }
    
    public func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void)
    {
        print("decidePolicyForNavigationAction")
        let baseURL = MendeleyKitConfiguration.sharedInstance().baseAPIURL.absoluteString
        let requestURL = navigationAction.request.URL
        if nil != requestURL
        {
            if requestURL!.absoluteString.hasPrefix(baseURL)
            {
                decisionHandler(.Allow)
                return
            }
        }
        
        let helper = MendeleyKitLoginHelper()
        let code = helper.getAuthenticationCode(navigationAction.request.URL!)
        if nil != code
        {
            oAuthProvider.authenticateWithAuthenticationCode(code!, completionBlock: oAuthCompletionBlock!)
        }
        

        decisionHandler(.Cancel)
    }
    
    
    public func webView(webView: WKWebView, decidePolicyForNavigationResponse navigationResponse: WKNavigationResponse, decisionHandler: (WKNavigationResponsePolicy) -> Void)
    {
        print("decidePolicyForNavigationResponse")
       let baseURL = MendeleyKitConfiguration.sharedInstance().baseAPIURL.absoluteString
        let requestURL = navigationResponse.response.URL
        if nil != requestURL
        {
            if requestURL!.absoluteString.hasPrefix(baseURL)
            {
                decisionHandler(.Allow)
                return
            }
        }
        
        let helper = MendeleyKitLoginHelper()
        let url = navigationResponse.response.URL
        if nil != url
        {
            let code = helper.getAuthenticationCode(url!)
            if nil != code
            {
                oAuthProvider.authenticateWithAuthenticationCode(code!, completionBlock: oAuthCompletionBlock!)
            }
        }
        
        
        decisionHandler(.Cancel)
    }
    
    public func webView(webView: WKWebView, didCommitNavigation navigation: WKNavigation!)
    {
        print("committed navigation")
    }
    
    public func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        print("didFailProvisionalNavigation \(error)")
    }
    
    
    public func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
        print("didFailNavigation \(error)")
        let userInfo = error.userInfo
        let failingURLString: String? = userInfo[NSURLErrorFailingURLStringErrorKey] as? String
        if nil != failingURLString
        {
            if oAuthProvider.urlStringIsRedirectURI(failingURLString)
            {
                return
            }
            
        }
        if nil != completionBlock
        {
            completionBlock!(success: false, error: error)
        }
    }
    
    public func webView(webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!)
    {
        print("didReceiveServerRedirectForProvisionalNavigation for navigation")
    }
    
}
