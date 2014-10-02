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

#import "MendeleyKitConfiguration.h"
#import "MendeleyMockNetworkProvider.h"
#import "MendeleyKitTestBaseClass.h"

@interface MendeleyKitConfigurationTests : MendeleyKitTestBaseClass

@end

@implementation MendeleyKitConfigurationTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSetConfiguration
{
    NSDictionary *parameters = @{ kMendeleyBaseAPIURLKey : @"https://mix-staging.mendeley.com",
                                  kMendeleyTrustedSSLServerKey : @(1) };

    MendeleyKitConfiguration *configuration = [MendeleyKitConfiguration sharedInstance];

    [configuration changeConfigurationWithParameters:parameters];

    XCTAssertTrue([configuration.baseAPIURL isEqual:[NSURL URLWithString:@"https://mix-staging.mendeley.com"]], @"Expected the base URL to be staging but got back %@", configuration.baseAPIURL);

    XCTAssertTrue(configuration.isTrustedSSLServer, @"Should be trusted SSL server");


    parameters = @{ kMendeleyBaseAPIURLKey : kMendeleyKitURL,
                    kMendeleyTrustedSSLServerKey : @(0) };


    [configuration changeConfigurationWithParameters:parameters];
    XCTAssertTrue([configuration.baseAPIURL isEqual:[NSURL URLWithString:kMendeleyKitURL]], @"Expected the base URL to be default but got back %@", configuration.baseAPIURL);
    XCTAssertFalse(configuration.isTrustedSSLServer, @"Should NOT be trusted SSL server");
}

- (void)testChangeNetworkProvider
{
    NSDictionary *parameters = @{
        kMendeleyNetworkProviderKey: NSStringFromClass([MendeleyMockNetworkProvider class])
    };
    MendeleyKitConfiguration *configuration = [MendeleyKitConfiguration sharedInstance];

    [configuration changeConfigurationWithParameters:parameters];
    XCTAssertNotNil(configuration.networkProvider, @"The network provider should not be nil");
    XCTAssertTrue([configuration.networkProvider isKindOfClass:[MendeleyMockNetworkProvider class]], @"The provider should be of type MendeleyMockNetworkProvider but isn't");
}
@end
