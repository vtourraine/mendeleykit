//
//  MendeleyKitLoginHelper.swift
//  MendeleyKit
//
//  Created by Peter Schmidt on 22/06/2015.
//  Copyright © 2015 Mendeley. All rights reserved.
//

import UIKit
import Foundation

class MendeleyKitLoginHelper: NSObject
{

    var clientID: String?
    var redirect: String?
    
    
    func configureOAuthRequest() -> NSURLRequest
    {
        let baseURL = MendeleyKitConfiguration.sharedInstance().baseAPIURL.URLByAppendingPathComponent(kMendeleyOAuthPathAuthorize)
        
        let parameters = [kMendeleyOAuthAuthorizationCodeKey: kMendeleyOAuthAuthorizationCode,
            kMendeleyOAuth2RedirectURLKey: redirect!,
            kMendeleyOAuth2ScopeKey: kMendeleyOAuth2Scope,
            kMendeleyOAuth2ClientIDKey: clientID!,
            kMendeleyOAuth2ResponseTypeKey: kMendeleyOAuth2ResponseType]
        
        let baseOAuthURL = MendeleyURLBuilder.urlWithBaseURL(baseURL, parameters: parameters, query: true)
        let request = NSMutableURLRequest(URL: baseOAuthURL)
        
        
        request.HTTPMethod = "GET"
        request.allHTTPHeaderFields = MendeleyURLBuilder.defaultHeader() as? [String : String]
        return request
    }
    
    func getAuthenticationCode(request: NSURLRequest) -> String
    {
        return ""
    }
    
}
