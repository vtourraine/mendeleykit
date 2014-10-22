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

#import "MendeleyResponse.h"
#import <OCMock/OCMock.h>
#import "MendeleyKitTestBaseClass.h"
#import "MendeleyError.h"

@interface MockHTTPURLResponse : NSHTTPURLResponse
@property(readwrite, atomic) NSInteger statusCode;
@end

@implementation MockHTTPURLResponse

- (id)init
{
    self = [super init];
    return self;
}

@end

@interface MendeleyResponse (CHANGE_VISIBILITY_FOR_TEST)

- (BOOL)jsonObjectHasValidData:(id)jsonObject error:(NSError **)error;
- (void)obtainContentTypeFromHeader:(NSDictionary *)header;
- (void)parseURLResponse:(NSURLResponse *)urlResponse;
- (void)parseHTTPHeader:(NSHTTPURLResponse *)httpResponse;

@end

@interface MendeleyResponseTests : MendeleyKitTestBaseClass
@property (nonatomic, strong) NSDictionary *testHeader;
@property (nonatomic, strong) NSData *jsonObjectData;
@end

@implementation MendeleyResponseTests

- (void)setUp
{
    [super setUp];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *jsonObjectPath = [bundle pathForResource:@"document.json" ofType:nil];

    NSData *jsonObject = [NSData dataWithContentsOfFile:jsonObjectPath];
    self.jsonObjectData = jsonObject;

    self.testHeader = @{
        @"Date": @"Wed, 04 Jun 2014 10:56:51 GMT",
        @"Last-Modified": @"Wed, 30 Jun 2010 18:09:55 GMT",
        @"Server": @"AmazonS3",
        @"X-Amz-Request-Id": @"F4343290B9FB4F3B",
        @"Etag": @"\"c4d749b9acf8fc78b699a2c6a4b7dfe2\"",
        @"Vary": @"Origin, Access-Control-Request-Headers, Access-Control-Request-Method",
        @"Access-Control-Allow-Methods": @"GET",
        @"Content-Type": @"application/pdf",
        @"Access-Control-Allow-Origin": @"*",
        @"Access-Control-Max-Age": @"3000",
        @"Content-Disposition": @"attachment;filename=\"1948-The_mathematical_theory_of_communication._1963..pdf\"",
        @"Accept-Ranges": @"bytes",
        @"Content-Length": @"366296",
        @"X-Amz-Id-2": @"8+Ekf8kMDZ182xdUXbyh+mpWtNm3vkCFijKySN/OIKDvNrnLlATwg5S9L6oIgvUb"
    };
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testParseURLResponse
{
    MockHTTPURLResponse *mockResponse = [[MockHTTPURLResponse alloc] init];

    mockResponse.statusCode = 404;
    MendeleyResponse *response = [[MendeleyResponse alloc] init];
    [response parseURLResponse:mockResponse];

    XCTAssertFalse(response.success, @"The response should not have been successful");
    XCTAssertNotNil(response.responseMessage, @"Response message should not be nil");
    if (nil != response.responseMessage)
    {
        NSRange foundRange = [[response.responseMessage lowercaseString] rangeOfString:@"not found"];
        XCTAssertFalse(foundRange.location == NSNotFound, @"The 'not found' string should be present");
    }
    for (int i = 200; i < 300; i++)
    {
        mockResponse.statusCode = i;
        [response parseURLResponse:mockResponse];
        XCTAssertTrue(response.success, @"The response should be successful for status code 200 to 299");
    }


    id mockURLResponse = [OCMockObject mockForClass:[NSURLResponse class]];
    [response parseURLResponse:mockURLResponse];
    XCTAssertFalse(response.success, @"");
    XCTAssertNotNil(response.responseMessage, @"response message should not be nil");
    if (nil != response.responseMessage)
    {
        XCTAssertTrue([response.responseMessage isEqualToString:@"Unknown URL response. Unable to process."]);
    }

}

- (void)testObtainContentTypeFromHeader
{
    MendeleyResponse *response = [[MendeleyResponse alloc] init];

    [response obtainContentTypeFromHeader:self.testHeader];
    XCTAssertTrue(PDFBody == response.contentType, @"The response content type should be of type PDF");
}

- (void)testJSONObjectHasValidData
{
    NSDictionary *jsonDict = @{ kMendeleyJSONErrorMessage : @"Error message" };
    NSError *error = nil;
    MendeleyResponse *response = [[MendeleyResponse alloc] init];

    BOOL success = [response jsonObjectHasValidData:jsonDict error:&error];

    XCTAssertFalse(success, @"The success flag should be NO");
    XCTAssertNotNil(error, @"We should get a not nil error object back");
    if (nil != error)
    {
        XCTAssertNotNil(error.localizedDescription, @"The error should have a localized Description");
        if (nil != error.localizedDescription)
        {
            XCTAssertEqual(error.code, kMendeleyJSONTypeNotMappedToModelErrorCode, @"Wrong error code %ld", (long) error.code);
        }
    }

    error = nil;
    id parsedJson = [NSJSONSerialization JSONObjectWithData:self.jsonObjectData options:NSJSONReadingAllowFragments error:&error];

    XCTAssertNil(error, @"Parsing error should be nil");
    XCTAssertNotNil(parsedJson, @"parsedJSON should not be nil");

    if (nil != parsedJson)
    {
        XCTAssertTrue([parsedJson isKindOfClass:[NSDictionary class]], @"parsedJson should be of type NSDictionary");
        if ([parsedJson isKindOfClass:[NSDictionary class]])
        {
            NSError *successError = nil;
            success = [response jsonObjectHasValidData:parsedJson error:&successError];
            XCTAssertNil(successError, @"This time we should be successful, and the error should be nil");
            XCTAssertTrue(success, @"The method should return success = YES for a valid JSON model");
        }
    }

}

@end
