//
//  MendeleyKitIDPlusLoginTests.swift
//  MendeleyKit
//
//  Created by Tunney, Aaron (ELS) on 26/06/2017.
//  Copyright © 2017 Mendeley. All rights reserved.
//

import XCTest
import WebKit
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


class MockIDPlusNetworkProvider: NSObject, MendeleyNetworkProvider {

    enum ServerFlow {
        case Standard
        case ConsentRequired
        case VerificationRequired
    }
    
    public var flow = ServerFlow.Standard
    
    // MARK: - Helper methods
    
    func idPlusTokenResponse() -> MendeleyResponse {
        let json = [ kMendeleyRefreshTokenKey : "hjhajhjsh",
                     kMendeleyIdPlusIdTokenKey : "hdfhjkhsdfjhjfsdhv",
                     kMendeleyTokenTypeKey : "Bearer",
                     kMendeleyAccessTokenKey: "jhdjkfjdhf",
                     kMendeleyExpiryDateKey: 7199 ] as [String : Any]
        
        return createResponse(withBody: json, statusCode: 200)
    }
    
    func oAuthTokenResponse() -> MendeleyResponse {
        let json = [ kMendeleyAccessTokenKey : "hdjhajhdfhjdahfsk",
                     kMendeleyTokenTypeKey : "bearer",
                     kMendeleyExpiryDateKey : 3599,
                     kMendeleyRefreshTokenKey : "hsdfjkhdfasjkhafdjkhjkadfhjkdfhjadfs",
                     kMendeleyOAuth2ScopeKey : "all" ] as [String: Any]
        
        return createResponse(withBody: json, statusCode: 200)
    }
    
    func profilesResponse() -> MendeleyResponse {
        var verificationStatus: String
        var statusCode: Int
        switch flow {
        case .Standard:
            statusCode = 200
            verificationStatus = "VERIFIED"
        case .ConsentRequired:
            statusCode = 201
            verificationStatus = ""
        default:
            statusCode = 200
            verificationStatus = "UNVERIFIED"
        }
        let json = [ "profile_uuid" : "bfsjhfjnueionxieu",
                     "autolink_verification_status" : verificationStatus ]
        
        return createResponse(withBody: json, statusCode: statusCode)
    }
    
    func successResponse() -> MendeleyResponse {
        return createResponse(withBody: nil, statusCode: 200)
    }
    
    func createResponse(withBody json: [String: Any]?, statusCode: Int) -> MendeleyResponse {
        // Create HTTP response
        let url = URL(string: "http://www.mendeley.com")
        
        let headerFields = ["Content-Type" : "application/json;charset=utf-8"]
        
        let urlResponse = HTTPURLResponse(url: url!, statusCode: statusCode, httpVersion: "HTTP/1.1", headerFields: headerFields)
        
        // Convert to Mendeley Response
        let mendeleyResponse = MendeleyResponse.mendeleyReponse(for: urlResponse)
        
        // Add data
        if json != nil {
            if let data = try? JSONSerialization.data(withJSONObject: json!, options: .prettyPrinted) {
                try? mendeleyResponse?.deserialiseRawResponseData(data)
            }
        }
        
        // Return
        return mendeleyResponse!
    }
    
    // MARK: - Mendeley Network Provider delegate methods
    
    func invokeDownload(toFileURL fileURL: URL!, baseURL: URL!, api: String!, additionalHeaders: [AnyHashable : Any]!, queryParameters: [AnyHashable : Any]!, authenticationRequired: Bool, task: MendeleyTask!, progressBlock: MendeleyResponseProgressBlock?, completionBlock: MendeleyResponseCompletionBlock? = nil) {
        assertionFailure("Method is stubbed")
    }
    
    func invokeUpload(forFileURL fileURL: URL!, baseURL: URL!, api: String!, additionalHeaders: [AnyHashable : Any]!, authenticationRequired: Bool, task: MendeleyTask!, progressBlock: MendeleyResponseProgressBlock?, completionBlock: MendeleyResponseCompletionBlock? = nil) {
        assertionFailure("Method is stubbed")
    }
    
    func invokeGET(_ linkURL: URL!, additionalHeaders: [AnyHashable : Any]!, queryParameters: [AnyHashable : Any]!, authenticationRequired: Bool, task: MendeleyTask!, completionBlock: MendeleyResponseCompletionBlock? = nil) {
        assertionFailure("Method is stubbed")
    }
    
    func invokeGET(_ baseURL: URL!, api: String!, additionalHeaders: [AnyHashable : Any]!, queryParameters: [AnyHashable : Any]!, authenticationRequired: Bool, task: MendeleyTask!, completionBlock: MendeleyResponseCompletionBlock? = nil) {
        assertionFailure("Method is stubbed")
    }
    
    func invokePUT(_ baseURL: URL!, api: String!, additionalHeaders: [AnyHashable : Any]!, jsonData: Data!, authenticationRequired: Bool, task: MendeleyTask!, completionBlock: MendeleyResponseCompletionBlock? = nil) {
        assertionFailure("Method is stubbed")
    }
    
    func invokePUT(_ baseURL: URL!, api: String!, additionalHeaders: [AnyHashable : Any]!, bodyParameters: [AnyHashable : Any]!, authenticationRequired: Bool, task: MendeleyTask!, completionBlock: MendeleyResponseCompletionBlock? = nil) {
        assertionFailure("Method is stubbed")
    }
    
    func invokePOST(_ baseURL: URL!, api: String!, additionalHeaders: [AnyHashable : Any]!, jsonData: Data!, authenticationRequired: Bool, task: MendeleyTask!, completionBlock: MendeleyResponseCompletionBlock? = nil) {
        
        switch (api) {
        case "profiles/v1":
            completionBlock?(profilesResponse(), nil)
        default:
            assertionFailure("Method is stubbed")
        }
    }
    
    func invokePOST(_ baseURL: URL!, api: String!, additionalHeaders: [AnyHashable : Any]!, bodyParameters: [AnyHashable : Any]!, isJSON: Bool, authenticationRequired: Bool, task: MendeleyTask!, completionBlock: MendeleyResponseCompletionBlock? = nil) {
        switch api {
        case "as/token.oauth2":
            completionBlock?(idPlusTokenResponse(), nil)
        case "oauth/token":
            completionBlock?(oAuthTokenResponse(), nil)
        default:
            assertionFailure("Method is stubbed")
        }
    }
    
    func invokeDELETE(_ baseURL: URL!, api: String!, additionalHeaders: [AnyHashable : Any]!, bodyParameters: [AnyHashable : Any]!, authenticationRequired: Bool, task: MendeleyTask!, completionBlock: MendeleyResponseCompletionBlock? = nil) {
        assertionFailure("Method is stubbed")
    }
    
    func invokePATCH(_ baseURL: URL!, api: String!, additionalHeaders: [AnyHashable : Any]!, jsonData: Data!, authenticationRequired: Bool, task: MendeleyTask!, completionBlock: MendeleyResponseCompletionBlock? = nil) {
        switch (api) {
        case "profiles/me/privacy_settings":
            fallthrough
        case "profiles/me":
            completionBlock?(successResponse(), nil)
        default:
            assertionFailure("Method is stubbed")
        }
    }
    
    func invokePATCH(_ baseURL: URL!, api: String!, additionalHeaders: [AnyHashable : Any]!, bodyParameters: [AnyHashable : Any]!, authenticationRequired: Bool, task: MendeleyTask!, completionBlock: MendeleyResponseCompletionBlock? = nil) {
        assertionFailure("Method is stubbed")
    }
    
    func invokeHEAD(_ baseURL: URL!, api: String!, authenticationRequired: Bool, task: MendeleyTask!, completionBlock: MendeleyResponseCompletionBlock? = nil) {
        assertionFailure("Method is stubbed")
    }
    
    func cancel(_ task: MendeleyTask!, completionBlock: MendeleyCompletionBlock? = nil) {
        assertionFailure("Method is stubbed")
    }
    
    func cancelAllTasks(_ completionBlock: MendeleyCompletionBlock? = nil) {
        assertionFailure("Method is stubbed")
    }
}


class MockWebView: WKWebView {
    
    var _url: URL?
    override var url: URL? {
        get {
            return _url
        }
    }
    
    override func load(_ request: URLRequest) -> WKNavigation? {
        if request.url?.absoluteString.hasPrefix("https://staging.mendeley.com") ?? false {
            _url = URL(string: defaultRedirectURI)
        } else {
            let urlString = "http://localhost/auth_return?code=\(defaultCode)&state=\(defaultState)"
            _url = URL(string: urlString)
        }
        
        navigationDelegate?.webView!(self, didReceiveServerRedirectForProvisionalNavigation: nil)
        
        return nil
    }
}

class MockConsentViewController: MendeleyLoginConsentViewController {
    override func viewDidLoad() {
        
        DispatchQueue.main.async {
            let discipline = MendeleyDiscipline()
            discipline.name = "Discipline"
            
            let amendmentProfile = MendeleyAmendmentProfile()
            amendmentProfile.academic_status = "Academic Status"
            amendmentProfile.disciplines = [discipline]
            
            self.completionBlock?(amendmentProfile, true)
        }
    }
}

class MendeleyKitIDPlusLoginTests: XCTestCase {
    
    var idPlusProvider: MendeleyIDPlusAuthProvider?
    
    override func setUp() {
        super.setUp()

        MendeleyKitConfiguration.sharedInstance().change(withParameters: [kMendeleyNetworkProviderKey:"MendeleyKitiOSTests.MockIDPlusNetworkProvider"])
        
        let oAuthParams = [ kMendeleyOAuth2ClientIDKey : "999",
                          kMendeleyOAuth2ClientSecretKey : "secret",
                          kMendeleyOAuth2RedirectURLKey : defaultRedirectURI ]
        
        MendeleyKitConfiguration.sharedInstance().configureOAuth(withParameters: oAuthParams)
    
        idPlusProvider = MendeleyKitConfiguration.sharedInstance().idPlusProvider
        
        configureIDPlusParameters(idPlusProvider: idPlusProvider!)
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
    
    func testSuccessfulLogin() {
        (MendeleyKitConfiguration.sharedInstance().networkProvider as! MockIDPlusNetworkProvider).flow = .Standard
        if #available(iOS 9.0, *) {
            let dummyVC = UIViewController()
            let webkitHandler = MendeleyLoginWebKitHandler(controller: dummyVC)
            
            let webView = MockWebView()
            webView.navigationDelegate = webkitHandler
            
            webkitHandler.webView = webView
            
            let completionExpectation = expectation(description: "completion block")
            let oAuthExpectation = expectation(description: "OAuth block")
            oAuthExpectation.expectedFulfillmentCount = 2
            
            webkitHandler.startLoginProcess(defaultClientID, redirectURI: defaultRedirectURI, completionHandler: { ( success: Bool, error: Error?) in

                XCTAssertTrue(success, "Success should be true")
                XCTAssertNil(error, error!.localizedDescription)
                
                completionExpectation.fulfill()
            }, oauthHandler: { ( credentials: MendeleyOAuthCredentials?, error: Error? ) in

                XCTAssertNotNil(credentials, "Credentials are not nil")
                XCTAssertNil(error, error!.localizedDescription)
                
                oAuthExpectation.fulfill()
            })
            
            wait(for: [completionExpectation, oAuthExpectation], timeout: 10.0)
        } else {
            // Do nothing
        }
    }
    
    func testConsentLogin() {
        (MendeleyKitConfiguration.sharedInstance().networkProvider as! MockIDPlusNetworkProvider).flow = .ConsentRequired
        if #available(iOS 9.0, *) {
            
            let dummyVC = UIViewController()
            let webkitHandler = MendeleyLoginWebKitHandler(controller: dummyVC)
            
            let mockConsentVC = MockConsentViewController()
            webkitHandler.consentViewController = mockConsentVC
            
            let webView = MockWebView()
            webView.navigationDelegate = webkitHandler
            
            webkitHandler.webView = webView
            
            let completionExpectation = expectation(description: "completion block")
            let oAuthExpectation = expectation(description: "OAuth block")
            oAuthExpectation.expectedFulfillmentCount = 2
            
            webkitHandler.startLoginProcess(defaultClientID, redirectURI: defaultRedirectURI, completionHandler: { ( success: Bool, error: Error?) in

                XCTAssertTrue(success, "Success should be true")
                XCTAssertNil(error, error!.localizedDescription)
                
                completionExpectation.fulfill()
            }, oauthHandler: { ( credentials: MendeleyOAuthCredentials?, error: Error? ) in

                XCTAssertNotNil(credentials, "Credentials are not nil")
                XCTAssertNil(error, error!.localizedDescription)
                
                oAuthExpectation.fulfill()
            })
            
            wait(for: [completionExpectation, oAuthExpectation], timeout: 10.0)
        } else {
            // Do nothing
        }
    }
    
    func testCreateAccountLogin() {
        (MendeleyKitConfiguration.sharedInstance().networkProvider as! MockIDPlusNetworkProvider).flow = .VerificationRequired
        if #available(iOS 9.0, *) {
            
            let dummyVC = UIViewController()
            let webkitHandler = MendeleyLoginWebKitHandler(controller: dummyVC)
            
            let mockConsentVC = MockConsentViewController()
            webkitHandler.consentViewController = mockConsentVC
            
            let webView = MockWebView()
            webView.navigationDelegate = webkitHandler
            
            webkitHandler.webView = webView
            
            let completionExpectation = expectation(description: "completion block")
            let oAuthExpectation = expectation(description: "OAuth block")
            oAuthExpectation.expectedFulfillmentCount = 2
            
            webkitHandler.startLoginProcess(defaultClientID, redirectURI: defaultRedirectURI, completionHandler: { ( success: Bool, error: Error?) in
                
                XCTAssertTrue(success, "Success should be true")
                XCTAssertNil(error, error!.localizedDescription)
                
                completionExpectation.fulfill()
            }, oauthHandler: { ( credentials: MendeleyOAuthCredentials?, error: Error? ) in

                XCTAssertNotNil(credentials, "Credentials are not nil")
                XCTAssertNil(error, error!.localizedDescription)
                
                oAuthExpectation.fulfill()
            })
            
            wait(for: [completionExpectation, oAuthExpectation], timeout: 10.0)
        } else {
            // Do nothing
        }
    }
}
