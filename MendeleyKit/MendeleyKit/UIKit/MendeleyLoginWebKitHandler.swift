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
    var consentViewController: MendeleyLoginConsentViewController?
    
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
                            self.askForConsent(withMendeleyCredentials: oAuthCredentials, idPlusCredentials: idPlusCredentials)
//                            if let profileStatus = object as? MendeleyProfileVerificationStatus {
//                                
//                                if profileStatus.autolink_verification_status == "VERIFIED" {
//                                    
//                                    self.completeLogin(withMendeleyCredentials: oAuthCredentials, idPlusCredentials: idPlusCredentials)
//                                    
//                                } else {
//                                    
//                                    self.verifyProfile(profileID: profileStatus.profile_uuid)
//                                }
//                            }
                        case 201:
                            print("state: 201")
                            self.askForConsent(withMendeleyCredentials: oAuthCredentials, idPlusCredentials: idPlusCredentials)
                            
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
    
    // MARK: - Verification journey
    
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
    
    // MARK: - Consent journey
    
    func askForConsent(withMendeleyCredentials oAuthCredentials: MendeleyOAuthCredentials, idPlusCredentials: MendeleyIDPlusCredentials) {
        let podBundle = Bundle(for: MendeleyLoginConsentViewController.self)
        let bundleURL = podBundle.url(forResource: "MendeleyKitiOS", withExtension: "bundle")
        let bundle = Bundle(url: bundleURL!)
        
        if consentViewController == nil {
            consentViewController = MendeleyLoginConsentViewController(nibName: "MendeleyLoginConsentViewController",
                                                                       bundle: bundle)
        }
        
        var frame = webView?.frame ?? CGRect.zero
        
        if frame != CGRect.zero {
            if let topHeight = parentViewController?.topLayoutGuide.length {
                frame.origin.y = frame.origin.y + topHeight
                frame.size.height = frame.size.height - topHeight
            }
        }
        
        consentViewController!.view.frame = frame
        consentViewController!.view.autoresizingMask = (webView?.autoresizingMask)!
        
        let completionBlock: (MendeleyAmendmentProfile, Bool) -> Void = {
            (newProfile: MendeleyAmendmentProfile, isPublicProfile: Bool) -> Void in
            
            self.finishConsentJournery(withMendeleyCredentials: oAuthCredentials,
                                       idPlusCredentials: idPlusCredentials,
                                       newProfile: newProfile,
                                       isPublicProfile: isPublicProfile)
        }
        
        consentViewController?.completionBlock = completionBlock
        
        parentViewController?.view.addSubview(consentViewController!.view)
    }
    
    func finishConsentJournery(withMendeleyCredentials oAuthCredentials: MendeleyOAuthCredentials, idPlusCredentials: MendeleyIDPlusCredentials, newProfile: MendeleyAmendmentProfile, isPublicProfile: Bool)
    {
        let networkProvider = MendeleyKitConfiguration.sharedInstance().networkProvider
        let baseURL = MendeleyKitConfiguration.sharedInstance().baseAPIURL
        
        let profileAPI = MendeleyProfilesAPI(networkProvider: networkProvider, baseURL: baseURL)
        
        if isPublicProfile {
            // By default, new profile is private. Update user's privacy settings if they choose to make their profile public.
            let loginAPI = MendeleyLoginAPI(networkProvider: networkProvider, baseURL: baseURL)
            
            let settings = MendeleyProfilePrivacySettingsWrapper()
            settings.privacy = MendeleyProfilePrivacySettings()
            settings.privacy.privacy_visibility = "everyone"
            settings.privacy.privacy_follower_restricted = false
            settings.privacy.privacy_search_engine_indexable = true
            
            let loginTask = MendeleyTask()
            
            loginAPI?.updateCurrentProfilePrivacySettings(settings.privacy, task: loginTask, completionBlock: { (object: MendeleyObject?, syncInfo: MendeleySyncInfo?, error: Error?) in
            
                let profileTask = MendeleyTask()
                
                profileAPI?.updateMyProfile(newProfile, task: profileTask, completionBlock: { (object: MendeleyObject?, syncInfo: MendeleySyncInfo?, error: Error?) in
                    self.completeLogin(withMendeleyCredentials: oAuthCredentials, idPlusCredentials: idPlusCredentials)
                })
            })
        } else {
            let profileTask = MendeleyTask()
            
            profileAPI?.updateMyProfile(newProfile, task: profileTask, completionBlock: { (object: MendeleyObject?, syncInfo: MendeleySyncInfo?, error: Error?) in
                self.completeLogin(withMendeleyCredentials: oAuthCredentials, idPlusCredentials: idPlusCredentials)
            })
        }
    }
    
    // MARK: - Web view delegate
    
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
