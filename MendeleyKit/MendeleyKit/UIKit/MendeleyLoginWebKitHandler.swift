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
    let idPlusProvider = MendeleyKitConfiguration.sharedInstance().idPlusProvider
    public var webView: WKWebView?
    var completionBlock: MendeleySuccessClosure?
    var oAuthCompletionBlock: MendeleyOAuthCompletionBlock?
    var redirectURI: String?
    var parentViewController: UIViewController?
    
    public func startLoginProcess(_ clientID: String, redirectURI: String, controller: UIViewController, completionHandler: MendeleyCompletionBlock?, oauthHandler: MendeleyOAuthCompletionBlock?)
    {
        completionBlock = completionHandler
        oAuthCompletionBlock = oauthHandler
        self.redirectURI = redirectURI
        parentViewController = controller
        configureWebView(controller)
        
        let helper = MendeleyKitLoginHelper()
        helper.cleanCookiesAndURLCache()
        
        if let request = idPlusProvider?.getAuthURLRequest(withIDPlusClientID: kIDPlusClientID) {
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
    
    
    //@TODO: fix code
    public func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        if let requestURL = webView.url {
            guard let code = idPlusProvider?.getAuthCodeAndState(from: requestURL)?.code
                else {
                    let error = MendeleyErrorManager.sharedInstance().error(withDomain: kMendeleyErrorDomain, code: MendeleyErrorCode.dataNotAvailableErrorCode.rawValue)
                    self.completionBlock?(false, (error as NSError?))
                    return
            }
            
            idPlusProvider?.obtainIDPlusAccessTokens(withAuthorizationCode: code, completionBlock: { (idPlusCredentials: MendeleyIDPlusCredentials?, idPlusError: Error?) in
                guard let idPlusCredentials = idPlusCredentials
                    else {
                        self.completionBlock?(false, (idPlusError as NSError?))
                        return
                }
                self.idPlusProvider?.obtainAccessTokens(withAuthorizationCode: code, completionBlock: { (oAuthCredentials: MendeleyOAuthCredentials?, oAuthError: Error?) in
                    guard let oAuthCredentials = oAuthCredentials
                        else {
                         self.completionBlock?(false, (oAuthError as NSError?))
                            return
                    }
                    self.oAuthCompletionBlock?(oAuthCredentials, nil)
                    self.idPlusProvider?.postProfile(with: idPlusCredentials, completionBlock: { (object: MendeleySecureObject?, state: Int, error: Error?) in
                        if object == nil {
                                self.completionBlock?(false, error as NSError?)
                                return
                        }
                        
                        switch state {
                        case 200:
                            if let profileStatus = object as? MendeleyProfileVerificationStatus {
                                
                                if profileStatus.autolink_verification_status == "VERIFIED" {
                                    
                                    self.completeLogin(withMendeleyCredentials: oAuthCredentials, idPlusCredentials: idPlusCredentials)
                                    
                                } else {
                                    
                                    self.verifyProfile(profileID: profileStatus.profile_uuid)
                                }
                            }
                        case 201:
                            print("state: 201")
                            self.askForConsent()
                            
                        default:
                            print("default")
                            self.completionBlock?(false, (error as NSError?))
                        }
                    })
                })

            })
            
        }
    }
    
    func completeLogin(withMendeleyCredentials oAuthCredentials: MendeleyOAuthCredentials, idPlusCredentials: MendeleyIDPlusCredentials)
    {
        //check if verified and start verification flow if not
        print("state: 200")                            // start complete profile flow
        self.idPlusProvider?.obtainMendeleyAPIAccessTokens(withMendeleyCredentials: oAuthCredentials, idPlusCredentials: idPlusCredentials, completionBlock: { (oAuthCredentials: MendeleyOAuthCredentials?, error: Error?) in
            guard let oAuthCredentials = oAuthCredentials
                else {
                    self.completionBlock?(false, (error as NSError?))
                    return
            }
            self.idPlusProvider?.obtainMendeleyAPIAccessTokens(withMendeleyCredentials: oAuthCredentials, idPlusCredentials: idPlusCredentials, completionBlock: { (mendeleyCredentials: MendeleyOAuthCredentials?, error: Error?) in
                self.oAuthCompletionBlock?(mendeleyCredentials, error as NSError?)
                self.completionBlock?(mendeleyCredentials != nil, error as NSError?)
            })
        })
    }
    
    func verifyProfile(profileID: String) {
        // TODO: Use base API URL once it works
        let baseURL = URL(string: "https://staging.mendeley.com")
        guard let redirect = redirectURI
            else { return }
        
        let requestURL = "verify/\(profileID)/?routeTo=\(redirect)"
        
        let url = URL(string: requestURL, relativeTo: baseURL)
        
        let request = URLRequest(url: url!)
        
        _ = webView?.load(request)
    }
    
    func askForConsent() {
        let consentViewController = MendeleyLoginConsentViewController(nibName: "MendeleyLoginConsentViewController", bundle: nil)
        
        parentViewController?.present(consentViewController, animated: true, completion: nil)
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
        
        if let token = idPlusProvider?.getAuthCodeAndState(from: requestURL!)
        {
            idPlusProvider?.obtainAccessTokens(withAuthorizationCode: token.code, completionBlock: oAuthCompletionBlock!)
        }
        
        decisionHandler(.cancel)
    }
    
    @nonobjc public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: NSError) {
        let userInfo = error.userInfo
        if let failingURLString = userInfo[NSURLErrorFailingURLStringErrorKey] as? String
        {
            if (idPlusProvider?.urlStringIsRedirectURI(failingURLString))!
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
