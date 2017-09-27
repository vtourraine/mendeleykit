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
    let oAuthServer: URL = MendeleyKitConfiguration.sharedInstance().baseAPIURL
    let oauthProvider = MendeleyKitConfiguration.sharedInstance().oauthProvider
    public var webView: WKWebView?
    var completionBlock: MendeleyStateCompletionBlock?
    var oAuthCompletionBlock: MendeleyOAuthCompletionBlock?

    public required init(controller: UIViewController) {
        super.init()
        
        configureWebView(controller)
    }
    
    public func startLoginProcess(_ clientID: String, redirectURI: String, completionHandler: MendeleyStateCompletionBlock?, oauthHandler: MendeleyOAuthCompletionBlock?)
    {
        completionBlock = completionHandler
        oAuthCompletionBlock = oauthHandler

        let helper = MendeleyKitLoginHelper()
        helper.cleanCookiesAndURLCache()
        let request: URLRequest = helper.getOAuthRequest(redirectURI, clientID: clientID)
        _ = webView?.load(request)
    }
    
    public func configureWebView(_ controller: UIViewController)
    {
        let configuration = WKWebViewConfiguration()
        let newWebView = WKWebView(frame: controller.view.frame, configuration: configuration)
        newWebView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        newWebView.navigationDelegate = self
        controller.view.addSubview(newWebView)

        webView = newWebView
    }
    

    public func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        if let requestURL = webView.url {
            let helper = MendeleyKitLoginHelper()
            if let code = helper.getAuthenticationCode(requestURL)
            {
                oauthProvider?.authenticate(withAuthenticationCode: code, completionBlock: oAuthCompletionBlock!)
            }
            
        }
        
    }
    
    @nonobjc public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void)
    {
        let baseURL = MendeleyKitConfiguration.sharedInstance().baseAPIURL.absoluteString
        let requestURL = navigationAction.request.url
        if let requestURL = requestURL
        {
            if requestURL.absoluteString.hasPrefix(baseURL)
            {
                decisionHandler(.allow)
                return
            }
        }

        let helper = MendeleyKitLoginHelper()
        if let code = helper.getAuthenticationCode(requestURL!)
        {
            oauthProvider?.authenticate(withAuthenticationCode: code, completionBlock: oAuthCompletionBlock!)
        }

        decisionHandler(.cancel)
    }
    
    @nonobjc public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: NSError) {
        let userInfo = error.userInfo
        if let failingURLString = userInfo[NSURLErrorFailingURLStringErrorKey] as? String
        {
            if (oauthProvider?.urlStringIsRedirectURI(failingURLString))!
            {
                return
            }
        }

        completionBlock?(LoginResult.failed.rawValue, error)
    }
}
