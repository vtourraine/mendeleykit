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

import Foundation

public class MendeleyKitLoginHelper: NSObject
{
    public func getOAuthRequest(redirect: String, clientID: String) -> NSURLRequest
    {
        let baseURL = MendeleyKitConfiguration.sharedInstance().baseAPIURL.URLByAppendingPathComponent(kMendeleyOAuthPathAuthorize)
        
        let parameters = [kMendeleyOAuthAuthorizationCodeKey: kMendeleyOAuthAuthorizationCode,
            kMendeleyOAuth2RedirectURLKey: redirect,
            kMendeleyOAuth2ScopeKey: kMendeleyOAuth2Scope,
            kMendeleyOAuth2ClientIDKey: clientID,
            kMendeleyOAuth2ResponseTypeKey: kMendeleyOAuth2ResponseType]
        
        let baseOAuthURL = MendeleyURLBuilder.urlWithBaseURL(baseURL, parameters: parameters, query: true)
        let request = NSMutableURLRequest(URL: baseOAuthURL)

        request.HTTPMethod = "GET"
        request.allHTTPHeaderFields = MendeleyURLBuilder.defaultHeader() as? [String : String]
        return request as NSURLRequest
    }
    
    public func getAuthenticationCode(redirectURL: NSURL) -> String?
    {
        var code: String?

        if let queryString = redirectURL.query
        {
            let components: [String] = queryString.componentsSeparatedByString("&")
            for component in components
            {
                let parameterPair = component.componentsSeparatedByString("=")
                let key = parameterPair[0]
                let value = parameterPair[1]
                if kMendeleyOAuth2ResponseType == key
                {
                    code = value
                }
            }
        }

        return code
    }

    public func cleanCookiesAndURLCache()
    {
        let oauthServer = MendeleyKitConfiguration.sharedInstance().baseAPIURL
        NSURLCache.sharedURLCache().removeAllCachedResponses()

        let cookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()

        guard let cookies = cookieStorage.cookies as [NSHTTPCookie]?
            else { return }

        for cookie in cookies
        {
            let domain = cookie.domain
            if domain == kMendeleyKitURL || domain == oauthServer.host
            {
                cookieStorage.deleteCookie(cookie)
            }
        }
    }
}
