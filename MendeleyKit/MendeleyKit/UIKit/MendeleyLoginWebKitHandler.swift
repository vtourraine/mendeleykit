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
        helper.cleanCookiesAndURLCache()
        let request: NSURLRequest = helper.getOAuthRequest(redirectURI, clientID: clientID)
        self.webView?.loadRequest(request)
    }
    
    public func configureWebView(controller: UIViewController)
    {
        let configuration = WKWebViewConfiguration()
        let webView = WKWebView(frame: controller.view.frame, configuration: configuration)
        webView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        webView.navigationDelegate = self
        controller.view.addSubview(webView)

        self.webView = webView
    }

    public func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void)
    {
        let baseURL = MendeleyKitConfiguration.sharedInstance().baseAPIURL.absoluteString
        let requestURL = navigationAction.request.URL
        if let requestURL = requestURL
        {
            if requestURL.absoluteString.hasPrefix(baseURL)
            {
                decisionHandler(.Allow)
                return
            }
        }

        let helper = MendeleyKitLoginHelper()
        if let code = helper.getAuthenticationCode(requestURL!)
        {
            oAuthProvider.authenticateWithAuthenticationCode(code, completionBlock: oAuthCompletionBlock!)
        }

        decisionHandler(.Cancel)
    }
    
    public func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
        let userInfo = error.userInfo
        if let failingURLString = userInfo[NSURLErrorFailingURLStringErrorKey] as? String
        {
            if oAuthProvider.urlStringIsRedirectURI(failingURLString)
            {
                return
            }
        }

        if let unwrappedCompletionBlock = completionBlock
        {
            unwrappedCompletionBlock(success: false, error: error)
        }
    }
}
