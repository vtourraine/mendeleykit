//
//  MendeleyLoginHandler.swift
//  MendeleyKit
//
//  Created by Peter Schmidt on 22/06/2015.
//  Copyright © 2015 Mendeley. All rights reserved.
//

import UIKit

public typealias MendeleySuccessClosure = (success: Bool, error: NSError?) -> Void
public typealias MendeleyOAuthClosure = (credentials: MendeleyOAuthCredentials?, error: NSError?) -> Void

@objc
public protocol MendeleyLoginHandler
{
     func startLoginProcess(clientID: String, redirectURI: String, controller: UIViewController, completionHandler: MendeleySuccessClosure, oauthHandler: MendeleyOAuthClosure)

}