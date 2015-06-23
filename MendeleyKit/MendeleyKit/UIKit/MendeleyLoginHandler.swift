//
//  MendeleyLoginHandler.swift
//  MendeleyKit
//
//  Created by Peter Schmidt on 22/06/2015.
//  Copyright © 2015 Mendeley. All rights reserved.
//

import UIKit

@objc
public protocol MendeleyLoginHandler
{
     func startLoginProcess(clientID: String, clientSecret: String, redirectURI: String, controller: UIViewController, completionHandler: MendeleyCompletionBlock, oauthHandler: MendeleyOAuthCompletionBlock)

}