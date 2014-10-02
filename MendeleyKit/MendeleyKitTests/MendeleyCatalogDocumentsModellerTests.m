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

#import <XCTest/XCTest.h>
#import "MendeleyModeller.h"
#import "MendeleyModels.h"
#import "MendeleyKitTestBaseClass.h"

@interface MendeleyCatalogDocumentsModellerTests : MendeleyKitTestBaseClass
@property (nonatomic, strong) NSData *jsonDictionary;
@property (nonatomic, strong) NSData *jsonArrayData;
@end

@implementation MendeleyCatalogDocumentsModellerTests

- (void)setUp
{
    [super setUp];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *jsonPath = [bundle pathForResource:@"catalogue.json" ofType:nil];
    NSData *jsonDict = [NSData dataWithContentsOfFile:jsonPath];
    self.jsonDictionary = jsonDict;
    NSString *jsonArrayPath = [bundle pathForResource:@"catalogueArray.json" ofType:nil];
    NSData *jsonArray = [NSData dataWithContentsOfFile:jsonArrayPath];
    self.jsonArrayData = jsonArray;
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testParseCatalogDocument
{
    XCTAssertNotNil(self.jsonDictionary, @"the loaded test data should not be nil");

    NSError *parseError = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:self.jsonDictionary options:NSJSONReadingAllowFragments error:&parseError];

    XCTAssertNotNil(jsonObject, @"we should have a valid json object");
    XCTAssertNil(parseError, @"the parsing should not return an error");
    XCTAssertTrue([jsonObject isKindOfClass:[NSDictionary class]], @"the json object should be of type NSDictionary");
    if (nil == jsonObject || ![jsonObject isKindOfClass:[NSDictionary class]])
    {
        return;
    }

    NSDictionary *jsonDict = (NSDictionary *) jsonObject;
    MendeleyModeller *modeller = [MendeleyModeller sharedInstance];
    [modeller parseJSONData:jsonDict expectedType:kMendeleyModelCatalogDocument completionBlock:^(id parsedObject, NSError *error) {
         XCTAssertNotNil(parsedObject, @"the parsed object should not be nil");
         XCTAssertNil(error, @"we should not get an error while parsing");

         MendeleyCatalogDocument *catDocument = (MendeleyCatalogDocument *) parsedObject;

         [self parseMendeleyCatalogDocument:catDocument];

     }];

}

- (void)testParseCatalogArray
{
    XCTAssertNotNil(self.jsonArrayData, @"the loaded test data should not be nil");

    NSError *parseError = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:self.jsonArrayData options:NSJSONReadingAllowFragments error:&parseError];

    XCTAssertNotNil(jsonObject, @"we should have a valid json object");
    XCTAssertNil(parseError, @"the parsing should not return an error");
    XCTAssertTrue([jsonObject isKindOfClass:[NSArray class]], @"the json object should be of type NSDictionary");
    if (nil == jsonObject || ![jsonObject isKindOfClass:[NSArray class]])
    {
        return;
    }

    NSArray *jsonArray = (NSArray *) jsonObject;

    MendeleyModeller *modeller = [MendeleyModeller sharedInstance];
    [modeller parseJSONData:jsonArray expectedType:kMendeleyModelCatalogDocument completionBlock:^(id parsedObject, NSError *error) {
         XCTAssertNotNil(parsedObject, @"the object should not be nil");
         XCTAssertNil(error, @"we should have no parsing error");

         NSArray *array = (NSArray *) parsedObject;
         XCTAssertTrue(1 == array.count, @"we should have exactly one catalog Document in the array but instead got %ld", (long) array.count);
         if (0 < array.count)
         {
             [self parseMendeleyCatalogDocument:array[0]];
         }
     }];

}

- (void)parseMendeleyCatalogDocument:(MendeleyCatalogDocument *)catDocument
{
    XCTAssertNotNil(catDocument.object_ID, @"the catalog doc should have an object ID");
    XCTAssertTrue([catDocument.object_ID isEqualToString:@"ca7a641f-e3db-36c4-88b3-5ea69c210e4e"], @"unexpected ID %@", catDocument.object_ID);
    NSNumber *readers = catDocument.reader_count;
    XCTAssertNotNil(readers, @"there should be a value for readers");
    XCTAssertTrue(43 == [readers intValue], @"there should be 43 readers, but we got %d", [readers intValue]);

    XCTAssertTrue([catDocument.title isEqualToString:@"Differential Synchronization"], @"unexpected title %@", catDocument.title);

    XCTAssertTrue([catDocument.type isEqualToString:@"conference_proceedings"], @"unexpected type %@", catDocument.type);

    NSDictionary *academicStatusReaders = catDocument.reader_count_by_academic_status;
    XCTAssertNotNil(academicStatusReaders, @"we should have a count of readers by academic status");
    if (nil != academicStatusReaders)
    {
        XCTAssertTrue(9 == academicStatusReaders.allKeys.count, @"the readers by academic status dict should have 9 entries, but has actually %ld", (long) academicStatusReaders.allKeys.count);
    }

    NSDictionary *disciplineReaders = catDocument.reader_count_by_subdiscipline;
    XCTAssertNotNil(disciplineReaders, @"we should have count of readers by discipline");

    if (nil != disciplineReaders)
    {
        XCTAssertTrue(6 == disciplineReaders.allKeys.count, @"we should have 6 entries for discipline readers, but got %ld instead", (long) disciplineReaders.allKeys.count);
    }

    NSDictionary *countryReaders = catDocument.reader_count_by_country;
    XCTAssertNotNil(countryReaders, @"we should have a readers by country code");
    if (nil != countryReaders)
    {
        XCTAssertTrue(11 == countryReaders.allKeys.count, @"We should have 11 entries for country readers, but got %ld instead", (long) countryReaders.allKeys.count);
    }

    XCTAssertTrue((nil != catDocument.abstract) && (0 < catDocument.abstract.length), @"we shoud have an abstract");

    XCTAssertTrue([catDocument.link isEqualToString:@"http://www.mendeley.com/research/differential-synchronization"], @"unexpected link %@", catDocument.link);

    XCTAssertFalse([catDocument.file_attached boolValue], @"no file should be attached");

    NSArray *websites = catDocument.websites;
    XCTAssertNotNil(websites, @"a website should be listed");
    if (nil != websites)
    {
        XCTAssertTrue(1 == websites.count, @"we should have exactly 1 entry but don't %ld", (long) websites.count);
        XCTAssertTrue([[websites objectAtIndex:0] isEqualToString:@"http://portal.acm.org/citation.cfm?doid=1600193.1600198"], @"Unexpected website %@", [websites objectAtIndex:0]);
    }
    XCTAssertTrue([catDocument.series isEqualToString:@"DocEng 09"], @"Unexpected series %@", catDocument.series);

    XCTAssertTrue([catDocument.city isEqualToString:@"New York, NY, USA"], @"Unexpected city %@", catDocument.city);
    XCTAssertTrue([catDocument.publisher isEqualToString:@"ACM Press"], @"Unexpected publisher  %@", catDocument.publisher);
    XCTAssertTrue([catDocument.issue isEqualToString:@"January"], @"Unexpected issue %@", catDocument.issue);

    XCTAssertTrue([catDocument.pages isEqualToString:@"13-20"], @"Unexpected pages %@", catDocument.pages);

    NSArray *keywords = catDocument.keywords;
    XCTAssertNotNil(keywords, @"we should have keywords");
    if (nil != keywords)
    {
        XCTAssertTrue(2 == keywords.count, @"we should have 2 keywords but have %ld instead", (long) keywords.count);

        XCTAssertTrue([keywords containsObject:@"collaboration"], @"should contain collaboration");

        XCTAssertTrue([keywords containsObject:@"synchronization"], @"should contain synchronization");

        XCTAssertFalse([keywords containsObject:@"cloud"], @"should NOT contain cloud");
    }

    XCTAssertTrue(2009 == [catDocument.year intValue], @"year should be 2009 but is %d", [catDocument.year intValue]);

    XCTAssertTrue([catDocument.source isEqualToString:@"Proceedings of the 9th ACM symposium on Document engineering"], @"Unexpected source %@", catDocument.source);


    NSDictionary *identifiers = catDocument.identifiers;
    XCTAssertNotNil(identifiers, @"we should have identifiers");
    if (nil != identifiers)
    {
        XCTAssertNotNil([identifiers objectForKey:@"scopus"], @"we should have a scopus Identifier");
        XCTAssertNotNil([identifiers objectForKey:@"isbn"], @"we should have a isbn Identifier");
        XCTAssertNotNil([identifiers objectForKey:@"doi"], @"we should have a doi Identifier");
        XCTAssertNil([identifiers objectForKey:@"pmid"], @"we should NOT have a pmid Identifier");
        XCTAssertNil([identifiers objectForKey:@"issn"], @"we should NOT have a issn Identifier");
    }

    NSArray *authors = catDocument.authors;
    XCTAssertNotNil(authors, @"we should have authors");
    if (nil != authors)
    {
        XCTAssertTrue(1 == authors.count, @"the count of authors should be 1 but is %ld instead", (long) authors.count);
        if (0 < authors.count)
        {
            MendeleyPerson *person = authors[0];
            XCTAssertNotNil(person, @"we should get a valid person");
            if (nil != person)
            {
                XCTAssertTrue([person.first_name isEqualToString:@"Neil"], @"Unexpected first name %@", person.first_name);
                XCTAssertTrue([person.last_name isEqualToString:@"Fraser"], @"Unexpected last name %@", person.last_name);
            }
        }
    }

}

@end
