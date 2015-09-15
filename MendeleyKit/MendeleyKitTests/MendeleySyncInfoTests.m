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

#import "MendeleyKitTestBaseClass.h"

#import "MendeleySyncInfo.h"
#import "MendeleyGlobals.h"

static NSDictionary * headerFields()
{
    NSDictionary *header = @{ @"Content-Encoding" : @"gzip",
                              @"Content-Type" : @"application/vnd.mendeley-document.1+json",
                              @"Date" : @"Thu, 22 May 2014 10:55:53 GMT",
                              @"Link" : @"<https://mix.mendeley.com/documents?limit=20&reverse=false&order=asc>; rel=\"first\" , <https://mix.mendeley.com/documents?limit=20&reverse=true&order=asc&marker=b13b1ba6-b9cf-3fe2-9bf7-dcafc67b282d>; rel=\"previous\"",
                              @"Vary" : @"Accept-Encoding, User-Agent",
                              @"X-Mendeley-Trace-Id" : @"M1Pg6C2Yqng",
                              @"Content-Length" : @"3888",
                              @"Connection" : @"keep-alive" };

    return header;
}


@interface MendeleySyncInfo (CHANGE_VISIBILITY_FOR_TEST)

- (NSDictionary *)linkDictionaryFromLinkString:(NSString *)linkString;
- (NSString *)qualifierFromString:(NSString *)string;
- (NSURL *)urlFromString:(NSString *)string;

@end

@interface MendeleySyncInfoTests : MendeleyKitTestBaseClass

@end

@implementation MendeleySyncInfoTests

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

- (void)testQualifierString
{
    NSString *testLink = [headerFields() objectForKey:@"Link"];

    XCTAssertNotNil(testLink, @"we should have a Link field");
    if (nil == testLink)
    {
        return;
    }

    NSArray *components = [testLink componentsSeparatedByString:@","];
    XCTAssertTrue(2 == components.count, @"We expected the Link to contain 2 comma separated components, instead we get %luuu components", (unsigned long) components.count);

    if (2 == components.count)
    {
        NSString *component1 = components[0];
        NSString *component2 = components[1];

        MendeleySyncInfo *syncInfo = [[MendeleySyncInfo alloc] init];
        NSString *qualifier1 = [syncInfo qualifierFromString:component1];
        XCTAssertNotNil(qualifier1, @"we should have found 1 qualifier in first part");
        if (nil != qualifier1)
        {
            XCTAssertTrue([qualifier1 isEqualToString:@"first"], @"We expected 'first' but got back %@ ", qualifier1);
        }

        NSString *qualifier2 = [syncInfo qualifierFromString:component2];
        XCTAssertNotNil(qualifier2, @"we should have found 1 qualifier in second part");
        if (nil != qualifier2)
        {
            XCTAssertTrue([qualifier2 isEqualToString:@"previous"], @"We expected 'previous' but got back %@ ", qualifier2);
        }
    }

}

- (void)testURLString
{
    NSString *testLink = [headerFields() objectForKey:@"Link"];

    XCTAssertNotNil(testLink, @"we should have a Link field");
    if (nil == testLink)
    {
        return;
    }

    NSArray *components = [testLink componentsSeparatedByString:@","];
    XCTAssertTrue(2 == components.count, @"We expected the Link to contain 2 comma separated components, instead we get %lu components", (unsigned long) components.count);

    if (2 == components.count)
    {
        NSString *component1 = components[0];
        NSString *component2 = components[1];

        MendeleySyncInfo *syncInfo = [[MendeleySyncInfo alloc] init];
        NSURL *url1 = [syncInfo urlFromString:component1];
        NSURL *url2 = [syncInfo urlFromString:component2];

        XCTAssertNotNil(url1, @"We should have found the URL");
        XCTAssertNotNil(url2, @"We should have found the second URL");

        if (nil != url1)
        {
            XCTAssertTrue([[url1 absoluteString] isEqualToString:@"https://mix.mendeley.com/documents?limit=20&reverse=false&order=asc"], @"Got the wrong URL1 %@", url1);
        }
        if (nil != url2)
        {
            XCTAssertTrue([[url2 absoluteString] isEqualToString:@"https://mix.mendeley.com/documents?limit=20&reverse=true&order=asc&marker=b13b1ba6-b9cf-3fe2-9bf7-dcafc67b282d"], @"Got the wrong URL2 %@", url2);
        }
    }
}

- (void)testLinkDictionaryFromLinkString
{
    NSString *testLink = [headerFields() objectForKey:@"Link"];

    XCTAssertNotNil(testLink, @"we should have a Link field");
    if (nil == testLink)
    {
        return;
    }

    MendeleySyncInfo *info = [[MendeleySyncInfo alloc] init];
    NSDictionary *dict = [info linkDictionaryFromLinkString:testLink];

    NSURL *first = [dict objectForKey:kMendeleyRESTHTTPLinkFirst];
    XCTAssertNotNil(first, @"The parsed header should contain a first link URL");
    if (nil != first)
    {
        XCTAssertTrue([[first absoluteString] isEqualToString:@"https://mix.mendeley.com/documents?limit=20&reverse=false&order=asc"], @"Wrong URL for first %@", first);
    }

    NSURL *previous = [dict objectForKey:kMendeleyRESTHTTPLinkPrevious];
    XCTAssertNotNil(previous, @"The parsed header should contain a previous link URL");
    if (nil != previous)
    {
        XCTAssertTrue([[previous absoluteString] isEqualToString:@"https://mix.mendeley.com/documents?limit=20&reverse=true&order=asc&marker=b13b1ba6-b9cf-3fe2-9bf7-dcafc67b282d"], @"Wrong URL for first %@", previous);
    }

}
@end
