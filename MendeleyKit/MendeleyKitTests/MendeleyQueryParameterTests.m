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

#import "MendeleyQueryRequestParameters.h"
#import "MendeleyObjectHelper.h"

@interface MendeleyQueryParameterTests : MendeleyKitTestBaseClass

@end

@implementation MendeleyQueryParameterTests

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

- (void)testQueryParameters
{
    MendeleyDocumentParameters *parameters = [[MendeleyDocumentParameters alloc] init];

    XCTAssertTrue([parameters.limit isEqualToNumber:[NSNumber numberWithInt:kMendeleyRESTAPIDefaultPageSize]], @"We expected the default page size to be set to %d, but got back %d", kMendeleyRESTAPIDefaultPageSize, [parameters.limit intValue]);

    parameters.limit = [NSNumber numberWithInt:-1];
    XCTAssertTrue([parameters.limit isEqualToNumber:[NSNumber numberWithInt:kMendeleyRESTAPIDefaultPageSize]], @"We expected the default page size to be set to %d, but got back %d", kMendeleyRESTAPIDefaultPageSize, [parameters.limit intValue]);

    parameters.limit = [NSNumber numberWithInt:kMendeleyRESTAPIMaxPageSize];
    XCTAssertTrue([parameters.limit isEqualToNumber:[NSNumber numberWithInt:kMendeleyRESTAPIMaxPageSize]], @"We expected the max page size to be set to %d, but got back %d", kMendeleyRESTAPIMaxPageSize, [parameters.limit intValue]);

    parameters.limit = [NSNumber numberWithInt:kMendeleyRESTAPIMaxPageSize + 1];
    XCTAssertTrue([parameters.limit isEqualToNumber:[NSNumber numberWithInt:kMendeleyRESTAPIMaxPageSize]], @"We expected the max page size to be set to %d, but got back %d", kMendeleyRESTAPIMaxPageSize, [parameters.limit intValue]);


    parameters.sort = @"Any string";
    XCTAssertNil(parameters.sort, @"We shouldn't be able to set a value other than asc or desc");

    parameters.sort = kMendeleyRESTAPIQuerySortAsc;
    XCTAssertTrue([parameters.sort isEqualToString:kMendeleyRESTAPIQuerySortAsc], @"The sort order should be asc but instead is %@", parameters.sort);

    parameters.sort = @"Any oTHER string";
    XCTAssertNil(parameters.sort, @"We shouldn't be able to set a value other than asc or desc");

    parameters.order = @"Author";
    XCTAssertNil(parameters.order, @"Author is not a supported sort order option and should return nil");

    parameters.order = kMendeleyRESTAPIQueryOrderByCreated;
    XCTAssertTrue([parameters.order isEqualToString:kMendeleyRESTAPIQueryOrderByCreated], @"The sort order should be by added date but instead is %@", parameters.order);

}

- (void)testValueStringDictionary
{
    MendeleyDocumentParameters *parameters = [[MendeleyDocumentParameters alloc] init];

    parameters.limit = [NSNumber numberWithInt:20];
    NSString *limitString = [NSString stringWithFormat:@"%d", 20];
    NSDate *date = [NSDate date];
    NSDateFormatter *isoFormatter = [MendeleyObjectHelper jsonDateFormatter];
    NSString *testDateString = [isoFormatter stringFromDate:date];

    parameters.sort = kMendeleyRESTAPIQuerySortAsc;
    parameters.order = kMendeleyRESTAPIQueryOrderByTitle;
    parameters.modified_since = date;

    parameters.reverse = [NSNumber numberWithBool:NO];
    NSString *boolString = @"false";


    NSDictionary *values = [parameters valueStringDictionary];
    NSString *value = [values objectForKey:kMendeleyRESTAPIQueryLimit];
    XCTAssertNotNil(value, @"we set the limit property so this should not be nil");
    if (nil != value)
    {
        XCTAssertTrue([limitString isEqualToString:value], @"the limit string should be '20', but is %@", value);
    }

    value = [values objectForKey:kMendeleyRESTAPIQueryReverse];
    XCTAssertNotNil(value, @"we set the reverse property so this should not be nil");
    if (nil != value)
    {
        XCTAssertTrue([boolString isEqualToString:value], @"the reverse string should be 'false', but is %@", value);
    }

    value = [values objectForKey:kMendeleyRESTAPIQueryModifiedSince];
    XCTAssertNotNil(value, @"we set the modified_since property so this should not be nil");
    if (nil != value)
    {
        XCTAssertTrue([testDateString isEqualToString:value], @"the date string should be %@, but is %@", testDateString, value);
    }

    value = [values objectForKey:kMendeleyRESTAPIQueryDeletedSince];
    XCTAssertNil(value, @"we didn't set the deleted_since property so this should be nil");

    value = [values objectForKey:kMendeleyRESTAPIQuerySort];
    XCTAssertNotNil(value, @"we set the sort property so this should not be nil");
    if (nil != value)
    {
        XCTAssertTrue([kMendeleyRESTAPIQuerySortAsc isEqualToString:value], @"the date string should be 'asc', but is %@", value);
    }

    value = [values objectForKey:kMendeleyRESTAPIQueryOrder];
    XCTAssertNotNil(value, @"we set the order property so this should not be nil");
    if (nil != value)
    {
        XCTAssertTrue([kMendeleyRESTAPIQueryOrderByTitle isEqualToString:value], @"the date string should be 'title', but is %@", value);
    }
}

- (void)testCatalogParameters
{
    MendeleyCatalogParameters *parameters = [MendeleyCatalogParameters new];

    BOOL exists = [parameters hasQueryParameterWithName:@"pmid"];

    XCTAssertTrue(exists, @"property should exist");
    exists = [parameters hasQueryParameterWithName:@"filehash"];
    XCTAssertTrue(exists, @"filehash property should exist");

    exists = [parameters hasQueryParameterWithName:@"someOtherProperty"];
    XCTAssertFalse(exists, @"someOtherProperty should not exist");

}

@end
