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

#import "MendeleyOAuthConstants.h"
#import "MendeleyLoginController.h"
#import "MendeleyKitConfiguration.h"
#import "MendeleyKitTestBaseClass.h"

@interface MendeleyLoginController (CHANGE_VISIBILITY_FOR_TEST)

@property (nonatomic, strong) NSString *clientID;
@property (nonatomic, strong) NSString *redirectURI;
- (NSURLRequest *)oauthURLRequest;
- (NSString *)authenticationCodeFromURLRequest:(NSURLRequest *)request;
@property (nonatomic, strong) NSURL *oauthServer;

@end


@interface MendeleyLoginControllerTests : MendeleyKitTestBaseClass

@end

@implementation MendeleyLoginControllerTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testOAuthURLRequest
{
    NSString *testURLString = @"https://api.mendeley.com/oauth/authorize";
    MendeleyLoginController *controller = [[MendeleyLoginController alloc] init];

    controller.clientID = @"1";
    controller.redirectURI = @"http://redirect";

    controller.oauthServer = [MendeleyKitConfiguration sharedInstance].baseAPIURL;

    NSURLRequest *request = [controller oauthURLRequest];

    XCTAssertTrue([request.HTTPMethod isEqualToString:@"GET"], @"we expected GET HTTP method but got %@ instead", request.HTTPMethod);

    NSMutableString *actualURLString = (NSMutableString *) [request.URL absoluteString];
    XCTAssertTrue([actualURLString hasPrefix:testURLString], @"The actual URL string looks different to what we expect. It should start with %@ but actually is %@", testURLString, actualURLString);

    XCTAssertFalse(NSNotFound == [actualURLString rangeOfString:@"?"].location, @"Expected to find the question mark");
    XCTAssertFalse(NSNotFound == [actualURLString rangeOfString:kMendeleyOAuthAuthorizationCode].location, @"Expected to find %@", kMendeleyOAuthAuthorizationCode);
    XCTAssertFalse(NSNotFound == [actualURLString rangeOfString:controller.redirectURI].location, @"Expected to find %@", controller.redirectURI);
    XCTAssertFalse(NSNotFound == [actualURLString rangeOfString:kMendeleyOAuth2Scope].location, @"Expected to find %@", kMendeleyOAuth2Scope);
    XCTAssertFalse(NSNotFound == [actualURLString rangeOfString:controller.clientID].location, @"Expected to find %@", controller.clientID);
    XCTAssertFalse(NSNotFound == [actualURLString rangeOfString:kMendeleyOAuth2ResponseType].location, @"Expected to find %@", kMendeleyOAuth2ResponseType);

}

- (void)testAuthenticationCodeFromURLRequest
{
    NSURL *url = [NSURL URLWithString:@"http://localhost/auth_return?code=1234"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    MendeleyLoginController *controller = [[MendeleyLoginController alloc] init];

    NSString *code = [controller authenticationCodeFromURLRequest:request];

    XCTAssertTrue([code isEqualToString:@"1234"], @"we expected the authorisation code to be 1234 but got %@ instead", code);
}
@end
