//
//  MendeleyKitIDPlusLoginTests.swift
//  MendeleyKit
//
//  Created by Tunney, Aaron (ELS) on 26/06/2017.
//  Copyright © 2017 Mendeley. All rights reserved.
//

import XCTest
import MendeleyKitiOS


let defaultScope = "openid email profile"
let defaultState = "123456789"
let invalidState = "987654321"
let defaultAuthType = "SINGLE_SIGN_IN"
let defaultPlatSite = "TEST/test"
let defaultPrompt = "login"
let defaultRedirectURI = "http://localhost/auth_return"
let defaultResponseType = "code"
let defaultClientID = "TEST"
let defaultCode = "012345678"

class MendeleyKitIDPlusLoginTests: XCTestCase {
    
    var idPlusProvider: MendeleyIDPlusAuthProvider?
    
    override func setUp() {
        super.setUp()

        MendeleyKitConfiguration.sharedInstance().change(withParameters: [kMendeleyNetworkProviderKey:"MendeleyKitiOSTests.MockIDPlusNetworkProvider"])
        MendeleyKitConfiguration.sharedInstance().configureOAuth(withParameters: [AnyHashable:Any]())
    
        idPlusProvider = MendeleyKitConfiguration.sharedInstance().idPlusProvider
        
        configureIDPlusParameters(idPlusProvider: idPlusProvider!)
    }
    
    override func tearDown() {
        idPlusProvider = nil
        
        super.tearDown()
    }
    
    func requestUrl(withCode code: String?, state: String?) -> URL? {
        let requestString = "https://www.mendeley.com/as/authorization.oauth2?scope=openid%20email%20profile&state=\(state ?? "")&authType=SINGLE_SIGN_IN&platSite=TEST/mendeley&prompt=login&redirect_uri=http://localhost/auth_return&code=\(code ?? "")&client_id=Test"
        
        return URL(string: requestString)
    }
    
    func configureIDPlusParameters(idPlusProvider: MendeleyIDPlusAuthProvider) {
        
        let idPlusParams = [ kIDPlusScope : defaultScope,
                             kIDPlusState : defaultState,
                             kIDPlusAuthType : defaultAuthType,
                             kIDPlusPlatSite : defaultPlatSite,
                             kIDPlusPrompt : defaultPrompt,
                             kIDPlusRedirectUri : defaultRedirectURI,
                             kIDPlusResponseType :  defaultResponseType,
                             kIDPlusClientId : defaultClientID ]
        
        idPlusProvider.configure(withParameters: idPlusParams)
    }
    
    func testValidURLRequest() {
        let urlRequest = idPlusProvider?.getAuthURLRequest(withIDPlusClientID: kIDPlusClientID)
        
        XCTAssertNotNil(urlRequest, "URL Request is nil")
    }
    
    func testRequestURLContainsCodeAndState() {
        
        let stateOnlyURL = requestUrl(withCode: nil, state: defaultState)
        let stateOnlyToken = idPlusProvider?.getAuthCodeAndState(from: stateOnlyURL!)
        XCTAssertNotNil(stateOnlyToken, "Token should not be nil")
        XCTAssertTrue(stateOnlyToken?.state == defaultState, "State should match \(defaultState)")
        XCTAssertTrue(stateOnlyToken?.code.characters.count == 0, "Code should be empty")
        
        let codeOnlyURL = requestUrl(withCode: defaultCode, state: nil)
        let codeOnlyToken = idPlusProvider?.getAuthCodeAndState(from: codeOnlyURL!)
        XCTAssertNil(codeOnlyToken, "Token should be nil")
        
        let incorrectStateURL = requestUrl(withCode: defaultCode, state: invalidState)
        let incorrectStateToken = idPlusProvider?.getAuthCodeAndState(from: incorrectStateURL!)
        XCTAssertNil(incorrectStateToken, "Token should be nil")
        
        let validURL = requestUrl(withCode: defaultCode, state: defaultState)
        let validToken = idPlusProvider?.getAuthCodeAndState(from: validURL!)
        XCTAssertNotNil(validToken, "Token should not be nil")
        XCTAssertTrue(validToken?.state == defaultState, "State should match \(defaultState)")
        XCTAssertTrue(validToken?.code == defaultCode, "Code should match \(defaultCode)")
    }
}
