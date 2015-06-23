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

public class MendeleyLoginUIWebViewHandler: NSObject, UIWebViewDelegate, MendeleyLoginHandler
{

    let oAuthServer: NSURL = MendeleyKitConfiguration.sharedInstance().baseAPIURL
    let oAuthProvider = MendeleyKitConfiguration.sharedInstance().oauthProvider
    var webView: UIWebView?
    
    
    public func startLoginProcess(clientID: String, clientSecret: String, redirectURI: String, controller: UIViewController, completionHandler: MendeleyCompletionBlock, oauthHandler: MendeleyOAuthCompletionBlock)
    {
        configureWebView(controller)
        let helper = MendeleyKitLoginHelper()
        helper.cleanCookiesAndURLCache()
        let request: NSURLRequest = helper.configureOAuthRequest(redirectURI, clientID: clientID)
        webView?.loadRequest(request)
    }
    
    func configureWebView(controller: UIViewController)
    {
        let localWebView = UIWebView(frame: controller.view.bounds)
        localWebView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth , UIViewAutoresizing.FlexibleHeight]
        localWebView.delegate = self
        controller.view.addSubview(localWebView)
        
        webView = localWebView
    }
    
    public func webView(webView: UIWebView, didFailLoadWithError error: NSError?)
    {
        if nil != error
        {
            let userInfo = error!.userInfo
            let failingURLString: String? = userInfo[NSURLErrorFailingURLStringErrorKey] as? String
            if nil != failingURLString
            {
                if oAuthProvider.urlStringIsRedirectURI(failingURLString)
                {
                    return
                }
                
            }
        }
    }
    
    
    
    public func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool
    {
        if(( request.URL?.absoluteString.hasPrefix(oAuthServer.absoluteString)) != nil)
        {
            return true
        }
        
        return false
    }
    
}
