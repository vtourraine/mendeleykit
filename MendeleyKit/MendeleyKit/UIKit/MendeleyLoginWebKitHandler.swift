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
        
        if let request = idPlusProvider?.getAuthURLRequest(withIDPlusClientID: MendeleyKitConfiguration.sharedInstance().idPlusClientId) {
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
            guard let code = idPlusProvider?.getAuthCodeAndState(from: requestURL)?.code
                //TODO: manage errors properly
                else { self.completionBlock?(false, nil); return }
            
            idPlusProvider?.obtainIDPlusAccessTokens(withAuthorizationCode: code, completionBlock: { (idPlusCredentials: MendeleyIDPlusCredentials?, idPlusError: Error?) in
                
                if let idPlusCredentials = idPlusCredentials {
                    self.idPlusProvider?.obtainAccessTokens(withAuthorizationCode: code, completionBlock: { (oAuthCredentials: MendeleyOAuthCredentials?, oAuthError: Error?) in
                        if let oAuthCredentials = oAuthCredentials {
                            self.oAuthCompletionBlock?(oAuthCredentials, nil)
                            self.idPlusProvider?.postProfile(with: idPlusCredentials, completionBlock: { (object: MendeleySecureObject?, state: Int, error: Error?) in
                                guard let profile = object as? MendeleyProfile
                                    //TODO: manage errors properly
                                    else {self.completionBlock?(false, nil); return}
                                
                                switch state {
                                case 200:
                                    //check if verified and start verification flow if not
                                    print("state: 200")
                                    fallthrough
                                case 201:
                                    print("state: 201")
                                    // start complete profile flow
                                    self.idPlusProvider?.obtainMendeleyAPIAccessTokens(withMendeleyCredentials: oAuthCredentials, idPlusCredentials: idPlusCredentials, completionBlock: { (oAuthCredentials: MendeleyOAuthCredentials?, error: Error?) in
                                        guard let oAuthCredentials = oAuthCredentials
                                            //TODO: manage errors properly
                                            else {self.completionBlock?(false, nil); return}
                                        self.idPlusProvider?.obtainMendeleyAPIAccessTokens(withMendeleyCredentials: oAuthCredentials, idPlusCredentials: idPlusCredentials, completionBlock: { (mendeleyCredentials: MendeleyOAuthCredentials?, error: Error?) in
                                            
                                            self.oAuthCompletionBlock?(mendeleyCredentials, nil)
                                            //TODO handle error
                                            self.completionBlock?(mendeleyCredentials != nil, nil)
                                        })
                                    })
                                default:
                                    print("default")
                                    self.completionBlock?(false, nil)
                                }
                            })
                        } else {
                            //TODO: manage errors properly
                            self.completionBlock?(false, nil)
                        }
                    })
                } else {
                    //TODO: manage errors properly
                    self.completionBlock?(false, nil)
                }
            })
            
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
