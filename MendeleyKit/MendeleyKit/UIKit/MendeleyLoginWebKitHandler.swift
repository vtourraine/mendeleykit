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
    let oAuthProvider = MendeleyKitConfiguration.sharedInstance().oauthProvider
    let idPlusProvider = MendeleyKitConfiguration.sharedInstance().idPlusProvider
    public var webView: WKWebView?
    var completionBlock: MendeleySuccessClosure?
    var oAuthCompletionBlock: MendeleyOAuthCompletionBlock?

    public func startLoginProcess(_ clientID: String, redirectURI: String, controller: UIViewController, completionHandler: MendeleyCompletionBlock?, oauthHandler: MendeleyOAuthCompletionBlock?)
    {
        completionBlock = completionHandler
        oAuthCompletionBlock = oauthHandler
        configureWebView(controller)

        let helper = MendeleyKitLoginHelper()
        helper.cleanCookiesAndURLCache()
//        let request: URLRequest = (oAuthProvider?.oauthURLRequest())! //helper.getOAuthRequest(redirectURI, clientID: clientID)
        
        if let request = idPlusProvider?.getAuthURLRequest(withClientID: "Mendeley") {
            _ = webView?.load(request)
        }
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
    

    //TODO fix code
    public func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        if let requestURL = webView.url {
            if let code = idPlusProvider?.getAuthCodeAndState(from: requestURL).code
            {
                idPlusProvider?.obtainIDPlusAccessTokens(withAuthorizationCode: code, completionBlock: { (credentials: MendeleyIDPlusCredentials?, error: Error?) in
                    
                    if let credentials = credentials {
                        self.oAuthProvider?.authenticate?(withIdPlusAuthenticationCode: code, completionBlock: { (credentials2: MendeleyOAuthCredentials?, error2: Error?) in
                            let mergedCredentials = MendeleyIDPlusCredentials()
                            mergedCredentials.id_plus_access_token = credentials.id_plus_access_token
                            mergedCredentials.id_plus_id_token = credentials.id_plus_id_token
                            mergedCredentials.id_plus_expires_in = credentials.id_plus_expires_in
                            mergedCredentials.id_plus_refresh_token = credentials.id_plus_refresh_token
                            mergedCredentials.id_plus_token_type = credentials.id_plus_token_type
                            mergedCredentials.access_token = credentials2?.access_token
                            mergedCredentials.expires_in = credentials2?.expires_in
                            mergedCredentials.refresh_token = credentials2?.refresh_token
                            mergedCredentials.token_type = credentials2?.token_type
                            
                            self.oAuthCompletionBlock?(mergedCredentials, error2)
                        })

                    }
                })

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

        if let code = oAuthProvider?.getAuthenticationCode(from: requestURL!)
        {
            oAuthProvider?.authenticate(withAuthenticationCode: code, completionBlock: oAuthCompletionBlock!)
        }

        decisionHandler(.cancel)
    }
    
    @nonobjc public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: NSError) {
        let userInfo = error.userInfo
        if let failingURLString = userInfo[NSURLErrorFailingURLStringErrorKey] as? String
        {
            if (oAuthProvider?.urlStringIsRedirectURI(failingURLString))!
            {
                return
            }
        }

        if let unwrappedCompletionBlock = completionBlock
        {
            unwrappedCompletionBlock(false, error)
        }
    }
}
