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
import WebKit

open class MendeleyKitLoginHelper: NSObject
{
//    open func getOAuthRequest(_ redirect: String, clientID: String) -> URLRequest
//    {
//        return
//        let baseURL = MendeleyKitConfiguration.sharedInstance().baseAPIURL.appendingPathComponent(kMendeleyOAuthPathAuthorize)
//        
//        let parameters = [kMendeleyOAuthAuthorizationCodeKey: kMendeleyOAuthAuthorizationCode,
//            kMendeleyOAuth2RedirectURLKey: redirect,
//            kMendeleyOAuth2ScopeKey: kMendeleyOAuth2Scope,
//            kMendeleyOAuth2ClientIDKey: clientID,
//            kMendeleyOAuth2ResponseTypeKey: kMendeleyOAuth2ResponseType]
//        
//        let baseOAuthURL = MendeleyURLBuilder.url(withBaseURL: baseURL, parameters: parameters, query: true)
//        let request = NSMutableURLRequest(url: baseOAuthURL)
//
//        request.httpMethod = "GET"
//        request.allHTTPHeaderFields = MendeleyURLBuilder.defaultHeader()
//        return request as URLRequest
//    }
    
//    open func getAuthenticationCode(_ redirectURL: URL) -> String?
//    {
//        var code: String?
//
//        if let queryString = redirectURL.query
//        {
//            let components: [String] = queryString.components(separatedBy: "&")
//            for component in components
//            {
//                let parameterPair = component.components(separatedBy: "=")
//                let key = parameterPair[0]
//                let value = parameterPair[1]
//                if kMendeleyOAuth2ResponseType == key
//                {
//                    code = value
//                }
//            }
//        }
//
//        return code
//    }

    open func cleanCookiesAndURLCache()
    {
        if #available(iOS 9.0, OSX 10.11, *) {
            let dataStore = WKWebsiteDataStore.default()
            let dataTypes = WKWebsiteDataStore.allWebsiteDataTypes()
            
            dataStore.fetchDataRecords(ofTypes: dataTypes) { (records: [WKWebsiteDataRecord]) in
                dataStore.removeData(ofTypes: dataTypes, for: records, completionHandler: {
                })
            }
        } else {
            if let libraryPath = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first {
                let cookiesFolderPath = libraryPath + "/Cookies"
                do {
                    try FileManager.default.removeItem(at: URL(fileURLWithPath: cookiesFolderPath))
                } catch {}
            }
            
        }
    }
}
