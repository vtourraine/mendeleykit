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

#ifndef MendeleyKitiOSFramework
#import "MendeleyModeller.h"
#import "MendeleyModels.h"
#endif
#import "MendeleyKitTestBaseClass.h"

@interface MendeleyModellerTest : MendeleyKitTestBaseClass

@property (nonatomic, strong) NSData *jsonObjectData;
@property (nonatomic, strong) NSData *jsonArrayData;

@end

@implementation MendeleyModellerTest

- (void)setUp
{
    [super setUp];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *jsonObjectPath = [bundle pathForResource:@"document.json" ofType:nil];
    NSString *jsonArrayPath = [bundle pathForResource:@"documentList.json" ofType:nil];

    NSData *jsonObject = [NSData dataWithContentsOfFile:jsonObjectPath];
    NSData *jsonArray = [NSData dataWithContentsOfFile:jsonArrayPath];

    self.jsonArrayData = jsonArray;
    self.jsonObjectData = jsonObject;
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testParseJSONObject
{
    XCTAssertTrue(self.jsonObjectData, @"We expected the jsonObject to be not NIL");
    NSError *parseError = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:self.jsonObjectData options:NSJSONReadingAllowFragments error:&parseError];
    XCTAssertNil(parseError, @"we expected the JSON data to be parsed without error");
    if (nil == parseError)
    {
        MendeleyModeller *modeller = [MendeleyModeller sharedInstance];
        [modeller parseJSONData:jsonObject expectedType:kMendeleyModelDocument completionBlock:^(id parsedObject, NSError *error) {
             XCTAssertNil(error, @"We expected the parsing to return without error");
             if (error)
             {
                 NSLog(@"Error provided is %@", [error localizedDescription]);
             }
             else
             {
                 XCTAssertTrue([parsedObject isKindOfClass:[MendeleyDocument class]], @"We expected an object of type PWESDocument but got back %@", NSStringFromClass([parsedObject class]));
                 if ([parsedObject isKindOfClass:[MendeleyDocument class]])
                 {
                     // title
                     NSString *title = ((MendeleyDocument *) parsedObject).title;
                     XCTAssertTrue([title isEqualToString:@"iPhone Forensics: Recovering Evidence, Personal Data, and Corporate Assets"], @"We got an unexpected title back %@", title);
                     
                     // object_id
                     NSString *objectID = ((MendeleyDocument *) parsedObject).object_ID;
                     XCTAssertTrue([objectID isEqualToString:@"6e7f4efb-e162-36f7-bae8-ce8f1a55860d"], @"We got an unexpected object id back %@", objectID);
                     
                     // profile_id
                     NSString *profileID = ((MendeleyDocument *) parsedObject).profile_id;
                     XCTAssertTrue([profileID isEqualToString:@"9fb1d5a8-c4e2-30e9-bc58-2d5e604e4827"], @"We got an unexpected profile id back %@", profileID);
                     
                     // type
                     NSString *type = ((MendeleyDocument *) parsedObject).type;
                     XCTAssertTrue([type isEqualToString:@"book"], @"We got an unexpected type back %@", type);
                     
                     // authors
                     NSArray *authors = ((MendeleyDocument *) parsedObject).authors;
                     XCTAssertTrue(1 == authors.count, @"We expected 1 author, but got back %ld", (long) authors.count);
                     
                     [authors enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                         XCTAssertTrue([obj isKindOfClass:[MendeleyPerson class]], @"We expected an object of type PWESPerson but got back %@", NSStringFromClass([MendeleyPerson class]));
                         MendeleyPerson *person = (MendeleyPerson *) obj;
                         XCTAssertTrue([person.first_name isEqualToString:@"J."], @"We expected J. but got back %@", person.first_name);
                         XCTAssertTrue([person.last_name isEqualToString:@"Zdziarski"], @"We expected Zdziarski but got back %@", person.last_name);
                     }];
                     
                     // editors
                     NSArray *editors = ((MendeleyDocument *) parsedObject).editors;
                     XCTAssertTrue(2 == editors.count, @"We expected 2 editors, but got back %ld", (long) editors.count);

                     [editors enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                         XCTAssertTrue([obj isKindOfClass:[MendeleyPerson class]], @"We expected an object of type PWESPerson but got back %@", NSStringFromClass([MendeleyPerson class]));
                         MendeleyPerson *person = (MendeleyPerson *) obj;
                         XCTAssertTrue([person.first_name hasPrefix:@"Ed"], @"We expected Ed* but got back %@", person.first_name);
                         XCTAssertTrue([person.last_name hasPrefix:@"Itor"], @"We expected Itor* but got back %@", person.last_name);
                     }];
                     
                     // translators
                     NSArray *translators = ((MendeleyDocument *) parsedObject).translators;
                     XCTAssertTrue(1 == translators.count, @"We expected 1 translator, but got back %ld", (long) translators.count);
                     
                     [translators enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                         XCTAssertTrue([obj isKindOfClass:[MendeleyPerson class]], @"We expected an object of type PWESPerson but got back %@", NSStringFromClass([MendeleyPerson class]));
                         MendeleyPerson *person = (MendeleyPerson *) obj;
                         XCTAssertTrue([person.first_name isEqualToString:@"Trans"], @"We expected Trans but got back %@", person.first_name);
                         XCTAssertTrue([person.last_name isEqualToString:@"Lator"], @"We expected Lator but got back %@", person.last_name);
                     }];
                     
                     // year
                     NSNumber *year = ((MendeleyDocument *) parsedObject).year;
                     XCTAssertTrue(2008 == [year integerValue], @"We expected 2008 but got back %ld", (long) [year integerValue]);
                     
                     // month
                     NSNumber *month = ((MendeleyDocument *) parsedObject).month;
                     XCTAssertTrue(1 == [month integerValue], @"We expected 1 but got back %ld", (long) [month integerValue]);
                     
                     // day
                     NSNumber *day = ((MendeleyDocument *) parsedObject).day;
                     XCTAssertTrue(16 == [day integerValue], @"We expected 16 but got back %ld", (long) [day integerValue]);
                     
                     // source
                     NSString *source = ((MendeleyDocument *) parsedObject).source;
                     XCTAssertTrue([source isEqualToString:@"Journal of the Electrochemical Society"], @"We got an unexpected source back %@", type);
                     
                     // revision
                     NSString *revision = ((MendeleyDocument *) parsedObject).revision;
                     XCTAssertTrue([revision isEqualToString:@"revision: unspecified"], @"We got an unexpected revision back %@", type);
                     
                     // identifiers
                     NSDictionary *identifiers = ((MendeleyDocument *) parsedObject).identifiers;
                     XCTAssertTrue(identifiers.allKeys.count == 1, @"We expected 1 identifier but got back %ld", (unsigned long) identifiers.allKeys.count);

                     // Note: can't compare using a real date as the hour may vary
                     NSDate *created = ((MendeleyDocument *) parsedObject).created;
                     NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:created];
                     
                     XCTAssertTrue(components.year == 2014, @"We expected 2014 but got back %zd", components.year);
                     XCTAssertTrue(components.month == 5, @"We expected 5 but got back %zd", components.month);
                     XCTAssertTrue(components.day == 22, @"We expected 22 but got back %zd", components.day);

                     // "2014-05-22T15:55:29.000Z",
                     NSDate *last_modified = ((MendeleyDocument *) parsedObject).last_modified;
                     components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:last_modified];
                     
                     XCTAssertTrue(components.year == 2014, @"We expected 2014 but got back %zd", components.year);
                     XCTAssertTrue(components.month == 5, @"We expected 5 but got back %zd", components.month);
                     XCTAssertTrue(components.day == 22, @"We expected 22 but got back %zd", components.day);
                     
                     // pages
                     NSString *pages = ((MendeleyDocument *) parsedObject).pages;
                     XCTAssertTrue([pages isEqualToString:@"120"], @"We got an unexpected pages back %@", pages);
                     
                     // volume
                     NSString *volume = ((MendeleyDocument *) parsedObject).volume;
                     XCTAssertTrue([volume isEqualToString:@"129"], @"We got an unexpected volume back %@", volume);
                     
                     // issue
                     NSString *issue = ((MendeleyDocument *) parsedObject).issue;
                     XCTAssertTrue([issue isEqualToString:@"14"], @"We got an unexpected issue back %@", issue);
                     
                     // publisher
                     NSString *publisher = ((MendeleyDocument *) parsedObject).publisher;
                     XCTAssertTrue([publisher isEqualToString:@"Elsevier Ireland Ltd"], @"We got an unexpected publisher back %@", publisher);
                     
                     // city
                     NSString *city = ((MendeleyDocument *) parsedObject).city;
                     XCTAssertTrue([city isEqualToString:@"city: unspecified"], @"We got an unexpected city back %@", city);
                     
                     // edition
                     NSString *edition = ((MendeleyDocument *) parsedObject).edition;
                     XCTAssertTrue([edition isEqualToString:@"edition: unspecified"], @"We got an unexpected edition back %@", edition);
                     
                     // institution
                     NSString *institution = ((MendeleyDocument *) parsedObject).institution;
                     XCTAssertTrue([institution isEqualToString:@"institution: unspecified"], @"We got an unexpected institution back %@", institution);
                     
                     // series
                     NSString *series = ((MendeleyDocument *) parsedObject).series;
                     XCTAssertTrue([series isEqualToString:@"series: unspecified"], @"We got an unexpected series back %@", series);
                     
                     // chapter
                     NSString *chapter = ((MendeleyDocument *) parsedObject).chapter;
                     XCTAssertTrue([chapter isEqualToString:@"chapter: unspecified"], @"We got an unexpected chapter back %@", chapter);
                     
                     // accessed
                     NSString *accessed = ((MendeleyDocument *) parsedObject).accessed;
                     XCTAssertTrue([accessed isEqualToString:@"2014-07-09"], @"We got an unexpected accessed back %@", accessed);
                     
                     // citation_key
                     NSString *citation_key = ((MendeleyDocument *) parsedObject).citation_key;
                     XCTAssertTrue([citation_key isEqualToString:@"citation_key: unspecified"], @"We got an unexpected citation_key back %@", citation_key);
                     
                     // source_type
                     NSString *source_type = ((MendeleyDocument *) parsedObject).source_type;
                     XCTAssertTrue([source_type isEqualToString:@"source_type: unspecified"], @"We got an unexpected citation_key back %@", source_type);
                     
                     // language
                     NSString *language = ((MendeleyDocument *) parsedObject).language;
                     XCTAssertTrue([language isEqualToString:@"language: unspecified"], @"We got an unexpected language back %@", language);
                     
                     // short_title
                     NSString *short_title = ((MendeleyDocument *) parsedObject).short_title;
                     XCTAssertTrue([short_title isEqualToString:@"short_title: unspecified"], @"We got an unexpected short_title back %@", short_title);
                     
                     // reprint_edition
                     NSString *reprint_edition = ((MendeleyDocument *) parsedObject).reprint_edition;
                     XCTAssertTrue([reprint_edition isEqualToString:@"reprint_edition: unspecified"], @"We got an unexpected reprint_edition back %@", reprint_edition);
                     
                     // genre
                     NSString *genre = ((MendeleyDocument *) parsedObject).genre;
                     XCTAssertTrue([genre isEqualToString:@"Computation and Language"], @"We got an unexpected genre back %@", genre);
                     
                     // country
                     NSString *country = ((MendeleyDocument *) parsedObject).country;
                     XCTAssertTrue([country isEqualToString:@"country: unspecified"], @"We got an unexpected country back %@", country);
                     
                     // series_editor
                     NSString *series_editor = ((MendeleyDocument *) parsedObject).series_editor;
                     XCTAssertTrue([series_editor isEqualToString:@"series_editor: unspecified"], @"We got an unexpected series_editor back %@", series_editor);
                     
                     // code
                     NSString *code = ((MendeleyDocument *) parsedObject).code;
                     XCTAssertTrue([code isEqualToString:@"code: unspecified"], @"We got an unexpected code back %@", code);
                     
                     // medium
                     NSString *medium = ((MendeleyDocument *) parsedObject).medium;
                     XCTAssertTrue([medium isEqualToString:@"medium: unspecified"], @"We got an unexpected medium back %@", medium);
                     
                     // user_context
                     NSString *user_context = ((MendeleyDocument *) parsedObject).user_context;
                     XCTAssertTrue([user_context isEqualToString:@"user_context: unspecified"], @"We got an unexpected user_context back %@", user_context);
                     
                     // department
                     NSString *department = ((MendeleyDocument *) parsedObject).department;
                     XCTAssertTrue([department isEqualToString:@"department: unspecified"], @"We got an unexpected department back %@", department);
                     
                     // patent_owner
                     NSString *patent_owner = ((MendeleyDocument *) parsedObject).patent_owner;
                     XCTAssertTrue([patent_owner isEqualToString:@"patent_owner: unspecified"], @"We got an unexpected patent_owner back %@", patent_owner);
                     
                     // patent_application_number
                     NSString *patent_application_number = ((MendeleyDocument *) parsedObject).patent_application_number;
                     XCTAssertTrue([patent_application_number isEqualToString:@"patent_application_number: unspecified"], @"We got an unexpected patent_application_number back %@", patent_application_number);
                     
                     // patent_legal_status
                     NSString *patent_legal_status = ((MendeleyDocument *) parsedObject).patent_legal_status;
                     XCTAssertTrue([patent_legal_status isEqualToString:@"patent_legal_status: unspecified"], @"We got an unexpected patent_legal_status back %@", patent_legal_status);
                     
                     // websites
                     NSArray *websites = ((MendeleyDocument *) parsedObject).websites;
                     XCTAssertTrue(1 == websites.count, @"We expected 1 websites, but got back %ld", (long) websites.count);
                     
                     [websites enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                         NSString *webUrl = (NSString *)obj;
                         XCTAssertTrue([webUrl isEqualToString:@"http://books.google.com/books?id=R1XArTHPn9QC"], @"We expected http://books.google.com/books?id=R1XArTHPn9QC but got back %@", webUrl);
                     }];
                     
                     // keywords
                     NSArray *keywords = ((MendeleyDocument *) parsedObject).keywords;
                     XCTAssertTrue(2 == keywords.count, @"We expected 2 keywords, but got back %ld", (long) keywords.count);
                     
                     [keywords enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                         NSString *keyword = (NSString *) obj;
                         XCTAssertTrue([keyword hasPrefix:@"keyword-"], @"We expected keyword-* but got back %@", keyword);
                     }];

                     // tags
                     NSArray *tags = ((MendeleyDocument *) parsedObject).tags;
                     XCTAssertTrue(2 == tags.count, @"We expected 2 tags, but got back %ld", (long) tags.count);

                     [tags enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                         NSString *tag = (NSString *) obj;
                         XCTAssertTrue([tag hasPrefix:@"No tags examples-"], @"We expected No tags examples-* but got back %@", tag);
                     }];
                     
                     NSNumber *file_attached_num = ((MendeleyDocument *) parsedObject).file_attached;
                     BOOL file_attached = [file_attached_num boolValue];
                     XCTAssertTrue(file_attached, @"file_attached: We expected true but got back %@", file_attached ? @"true" : @"false");

                     // read
                     NSNumber *read_num = ((MendeleyDocument *) parsedObject).read;
                     BOOL read_flag = [read_num boolValue];
                     XCTAssertTrue(!read_flag, @"file_attached: We expected false but got back %@", read_flag ?  @"true" : @"false");
                     
                     // starred
                     NSNumber *starred_num = ((MendeleyDocument *) parsedObject).starred;
                     BOOL starred = [starred_num boolValue];
                     XCTAssertTrue(!starred, @"starred: We expected false but got back %@", starred ? @"true" : @"false");
                     
                     // authored
                     NSNumber *authored_num = ((MendeleyDocument *) parsedObject).authored;
                     BOOL authored = [authored_num boolValue];
                     XCTAssertTrue(!authored, @"authored: We expected true but got back %@", authored ? @"true" : @"false");
                     
                     // confirmed
                     NSNumber *confirmed_num = ((MendeleyDocument *) parsedObject).confirmed;
                     BOOL confirmed = [confirmed_num boolValue];
                     XCTAssertTrue(confirmed, @"confirmed: We expected true but got back %@", confirmed ? @"true" : @"false");
                     
                     // hidden
                     NSNumber *hidden_num = ((MendeleyDocument *) parsedObject).hidden;
                     BOOL hidden = [hidden_num boolValue];
                     XCTAssertTrue(!hidden, @"hidden: We expected true but got back %@", hidden ? @"true" : @"false");
                     
                     // abstract
                     NSString *abstract = ((MendeleyDocument *) parsedObject).abstract;
                     XCTAssertTrue([abstract isEqualToString:@"Describes how to recover, analyze, and destroy data from an iPhone, iPhone 3G, and an iPod Touch."], @"We got an unexpected abstract back %@", abstract);

                     // group_id
                     NSString *group_id = ((MendeleyDocument *) parsedObject).group_id;
                     XCTAssertTrue([group_id isEqualToString:@"group_id: unspecified"], @"We got an unexpected group_id back %@", group_id);
                     
                     // notes
                     NSString *notes = ((MendeleyDocument *) parsedObject).notes;
                     XCTAssertTrue([notes isEqualToString:@"First note that we did together"], @"We got an unexpected notes back %@", notes);
                     
                     // series_number
                     NSString *series_number = ((MendeleyDocument *) parsedObject).series_number;
                     XCTAssertTrue([series_number isEqualToString:@"series_number: unspecified"], @"We got an unexpected series_number back %@", series_number);
                     
                     // Identifiers ISBN
                     NSString *isbnValue = [identifiers objectForKey:@"isbn"];
                     XCTAssertNotNil(isbnValue, @"should have a isbn value");
                     if (nil != isbnValue)
                     {
                         XCTAssertTrue([isbnValue isEqualToString:@"9780596153588"], @"Unexpected pmid value %@", isbnValue);
                     }
                 }
             }
         }];
    }
    else
    {
        NSLog(@"Parse error returns %@", [parseError localizedDescription]);
    }
}

- (void)testParseJSONArray
{
    XCTAssertTrue(self.jsonArrayData, @"We expected the jsonArray to be not NIL");
    NSError *parseError = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:self.jsonArrayData options:NSJSONReadingAllowFragments error:&parseError];
    XCTAssertNil(parseError, @"we expected the JSON data to be parsed without error");
    if (nil == parseError)
    {
        MendeleyModeller *modeller = [MendeleyModeller sharedInstance];
        [modeller parseJSONData:jsonObject expectedType:kMendeleyModelDocument completionBlock:^(id parsedObject, NSError *error) {
             XCTAssertNil(error, @"We expected the parsing to return without error");
             if (error)
             {
                 NSLog(@"Error provided is %@", [error localizedDescription]);
             }
             else
             {
                 XCTAssertTrue([parsedObject isKindOfClass:[NSArray class]], @"We expected an object of type NSArray but got back %@", NSStringFromClass([parsedObject class]));
                 if ([parsedObject isKindOfClass:[NSArray class]])
                 {
                     XCTAssertTrue(10 == ((NSArray *) parsedObject).count, @"We expected 10 MendeleyDocument in the array but got %ld", (long) ((NSArray *) parsedObject).count);
                     [(NSArray *) parsedObject enumerateObjectsUsingBlock :^(id obj, NSUInteger idx, BOOL *stop) {
                          XCTAssertTrue([obj isKindOfClass:[MendeleyDocument class]], @"We expected the array objects to be of type PWESDocument but got back %@", NSStringFromClass([obj class]));
                      }];
                 }

             }
         }];
    }
    else
    {
        NSLog(@"Parse error returns %@", [parseError localizedDescription]);
    }

}

- (void)testRoundTripForModel
{
    XCTAssertTrue(self.jsonObjectData, @"We expected the jsonObject to be not NIL");
    NSError *parseError = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:self.jsonObjectData options:NSJSONReadingAllowFragments error:&parseError];
    XCTAssertNil(parseError, @"we expected the JSON data to be parsed without error");
    if (nil == parseError)
    {
        MendeleyModeller *modeller = [MendeleyModeller sharedInstance];
        [modeller parseJSONData:jsonObject expectedType:kMendeleyModelDocument completionBlock:^(id parsedObject, NSError *error) {
             XCTAssertNil(error, @"We expected the parsing to return without error");
             if (error)
             {
                 NSLog(@"Error provided is %@", [error localizedDescription]);
             }
             else
             {
                 XCTAssertTrue([parsedObject isKindOfClass:[MendeleyDocument class]], @"expected class of type MendeleyDocument but got back %@", NSStringFromClass([parsedObject class]));
                 if ([parsedObject isKindOfClass:[MendeleyDocument class]])
                 {
                     MendeleyDocument *doc = (MendeleyDocument *) parsedObject;
                     NSError *writeError = nil;
                     NSData *jsonData = [modeller jsonObjectFromModelOrModels:doc error:&writeError];
                     XCTAssertNotNil(jsonData, @"we expected the conversion to JSON data to succeed");
                     if (nil != jsonData)
                     {
                         id jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&writeError];
                         XCTAssertNotNil(jsonObj, @"We expected the parsed JSON data to be valid");
                         if (nil != jsonObj)
                         {
                             XCTAssertTrue([jsonObj isKindOfClass:[NSDictionary class]], @"We expected the json object to be of type NSDictionary, but got back %@", NSStringFromClass([jsonObj class]));

                             if ([jsonObj isKindOfClass:[NSDictionary class]])
                             {
                                 NSDictionary *dict = (NSDictionary *) jsonObj;
                                 id dictObj = [dict objectForKey:kMendeleyJSONTitle];
                                 XCTAssertNotNil(dictObj, @"we should have a title");
                                 XCTAssertTrue([dictObj isKindOfClass:[NSString class]], @"The class should be of type NSString but is %@", NSStringFromClass([dictObj class]));
                                 if ([dictObj isKindOfClass:[NSString class]])
                                 {
                                     XCTAssertTrue([dictObj isEqualToString:@"iPhone Forensics: Recovering Evidence, Personal Data, and Corporate Assets"], @"Unexpected title %@", dictObj);
                                 }

                                 dictObj = [dict objectForKey:kMendeleyJSONYear];
                                 XCTAssertNotNil(dictObj, @"expected a year");
                                 XCTAssertTrue([dictObj isKindOfClass:[NSNumber class]], @"The class should be of type NSNumber but is %@", NSStringFromClass([dictObj class]));
                                 if ([dictObj isKindOfClass:[NSNumber class]])
                                 {
                                     XCTAssertTrue([dictObj isEqualToNumber:[NSNumber numberWithInt:2008]], @"Unexpected number value %d", [dictObj intValue]);
                                 }

                                 dictObj = [dict objectForKey:kMendeleyJSONAuthors];
                                 XCTAssertNotNil(dictObj, @"expected a authors field");
                                 XCTAssertTrue([dictObj isKindOfClass:[NSArray class]], @"The class should be of type NSArray but is %@", NSStringFromClass([dictObj class]));


                                 dictObj = [dict objectForKey:kMendeleyJSONIdentifiers];
                                 XCTAssertNotNil(dictObj, @"expected a identifiers");
                                 XCTAssertTrue([dictObj isKindOfClass:[NSDictionary class]], @"The class should be of type NSDictionary but is %@", NSStringFromClass([dictObj class]));
                                 if ([dictObj isKindOfClass:[NSDictionary class]])
                                 {
                                     NSString *value = [(NSDictionary *) dictObj objectForKey : @"isbn"];
                                     XCTAssertNotNil(value, @"We should have a valid 'isbn' key in the identifiers property");
                                 }

                             }
                         }
                     }
                 }
             }

         }];
    }
}

- (void)testRoundTripForModelArray
{
    XCTAssertTrue(self.jsonArrayData, @"We expected the jsonArray to be not NIL");
    NSError *parseError = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:self.jsonArrayData options:NSJSONReadingAllowFragments error:&parseError];
    XCTAssertNil(parseError, @"we expected the JSON data to be parsed without error");
    if (nil == parseError)
    {
        MendeleyModeller *modeller = [MendeleyModeller sharedInstance];
        [modeller parseJSONData:jsonObject expectedType:kMendeleyModelDocument completionBlock:^(id parsedObject, NSError *error) {
             XCTAssertNil(error, @"We expected the parsing to return without error");
             if (error)
             {
                 NSLog(@"Error provided is %@", [error localizedDescription]);
             }
             else
             {
                 XCTAssertTrue([parsedObject isKindOfClass:[NSArray class]], @"We expected an object of type NSArray but got back %@", NSStringFromClass([parsedObject class]));
                 if ([parsedObject isKindOfClass:[NSArray class]])
                 {
                     XCTAssertTrue(10 == ((NSArray *) parsedObject).count, @"We expected 10 MendeleyDocument in the array but got %ld", (long) ((NSArray *) parsedObject).count);
                     [(NSArray *) parsedObject enumerateObjectsUsingBlock :^(id obj, NSUInteger idx, BOOL *stop) {
                          XCTAssertTrue([obj isKindOfClass:[MendeleyDocument class]], @"We expected the array objects to be of type PWESDocument but got back %@", NSStringFromClass([obj class]));
                      }];

                     NSError *writeError = nil;
                     NSData *jsonArray = [modeller jsonObjectFromModelOrModels:parsedObject error:&writeError];
                     XCTAssertNotNil(jsonArray, @"We expected a valid JSON data set back");

                     if (nil != jsonArray)
                     {
                         id arrayObj = [NSJSONSerialization JSONObjectWithData:jsonArray options:NSJSONReadingAllowFragments error:&writeError];
                         XCTAssertNotNil(arrayObj, @"we should be able to parse the json data but got back an error");
                         XCTAssertTrue([arrayObj isKindOfClass:[NSArray class]], @"The class should be of type NSArray but is instead %@", NSStringFromClass([arrayObj class]));
                         if ([arrayObj isKindOfClass:[NSArray class]])
                         {
                             NSArray *array = (NSArray *) arrayObj;
                             XCTAssertTrue(10 == array.count, @"We should get back 10 items");
                         }
                     }
                 }
             }
         }];
    }
}

- (void)testParseJSONArrayOfIDStrings
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *jsonObjectPath = [bundle pathForResource:@"folderContent.json" ofType:nil];

    NSData *jsonArray = [NSData dataWithContentsOfFile:jsonObjectPath];

    NSError *parseError = nil;
    id parsedObject = [NSJSONSerialization JSONObjectWithData:jsonArray options:NSJSONReadingAllowFragments error:&parseError];

    XCTAssertNil(parseError, @"Expected the data to be parsed ok");
    waitForBlock (^(BOOL *hasCalledBack) {
                      if (nil != parsedObject)
                      {
                          XCTAssertTrue([parsedObject isKindOfClass:[NSArray class]], @"Expected the object to be of type NSArray");

                          MendeleyModeller *modeller = [MendeleyModeller sharedInstance];
                          [modeller parseJSONArrayOfIDDictionaries:(NSArray *) parsedObject completionBlock:^(NSArray *arrayOfStrings, NSError *error) {
                               XCTAssertTrue(nil != arrayOfStrings, @"We expected the array NOT to be nil");
                               if (nil != arrayOfStrings)
                               {
                                   XCTAssertTrue(0 < arrayOfStrings.count, @"We should get back a non-zero count");
                                   XCTAssertTrue([arrayOfStrings containsObject:@"7d8c5de2-017f-3bac-a5ab-61dfeeb1ff9a"], @"It should contain the specified ID, but doesn't");
                               }
                               *hasCalledBack = YES;

                           }];

                      }
                  });

}

- (void)testJSONForID
{
    NSString *testID = @"7d8c5de2-017f-3bac-a5ab-61dfeeb1ff9a";
    MendeleyModeller *modeller = [MendeleyModeller sharedInstance];
    NSError *serialError = nil;
    NSData *data = [modeller jsonObjectForID:testID error:&serialError];

    XCTAssertNotNil(data, @"we should be able to get valid JSON data back");
    if (nil != data)
    {
        id parsedObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&serialError];
        XCTAssertNotNil(parsedObject, @"the parsed Object should not be nil but is");
        if (nil != parsedObject)
        {
            XCTAssertTrue([parsedObject isKindOfClass:[NSDictionary class]], @"The type should be NSDictionary but isn't");
            if ([parsedObject isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *dict = (NSDictionary *) parsedObject;
                NSString *key = [dict objectForKey:kMendeleyJSONID];
                XCTAssertNotNil(key, @"we should find the key 'id'");
                if (nil != key)
                {
                    XCTAssertTrue([key isEqualToString:testID], @"we should get back the same ID");
                }
            }
        }
    }

}

@end
