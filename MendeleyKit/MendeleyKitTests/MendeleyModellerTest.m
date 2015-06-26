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
                     NSString *title = ((MendeleyDocument *) parsedObject).title;
                     XCTAssertTrue([title isEqualToString:@"iPhone Forensics: Recovering Evidence, Personal Data, and Corporate Assets"], @"We got an unexpected title back %@", title);
                     NSString *objectID = ((MendeleyDocument *) parsedObject).object_ID;
                     XCTAssertTrue([objectID isEqualToString:@"6e7f4efb-e162-36f7-bae8-ce8f1a55860d"], @"We got an unexpected object id back %@", objectID);
                     NSString *profileID = ((MendeleyDocument *) parsedObject).profile_id;
                     XCTAssertTrue([profileID isEqualToString:@"9fb1d5a8-c4e2-30e9-bc58-2d5e604e4827"], @"We got an unexpected profile id back %@", profileID);
                     NSString *type = ((MendeleyDocument *) parsedObject).type;
                     XCTAssertTrue([type isEqualToString:@"book"], @"We got an unexpected type back %@", type);
                     NSArray *authors = ((MendeleyDocument *) parsedObject).authors;
                     XCTAssertTrue(1 == authors.count, @"We expected 1 author, but got back %ld", (long) authors.count);
                     NSNumber *year = ((MendeleyDocument *) parsedObject).year;
                     XCTAssertTrue(2008 == [year integerValue], @"We expected 2009 but got back %ld", (long) [year integerValue]);
                     NSDictionary *identifiers = ((MendeleyDocument *) parsedObject).identifiers;
                     XCTAssertTrue(identifiers.allKeys.count == 1, @"We expected 1 identifier but got back %ld", (unsigned long) identifiers.allKeys.count);
                     NSString *isbnValue = [identifiers objectForKey:@"isbn"];
                     XCTAssertNotNil(isbnValue, @"should have a isbn value");
                     if (nil != isbnValue)
                     {
                         XCTAssertTrue([isbnValue isEqualToString:@"9780596153588"], @"Unexpected pmid value %@", isbnValue);
                     }

                     [authors enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                          XCTAssertTrue([obj isKindOfClass:[MendeleyPerson class]], @"We expected an object of type PWESPerson but got back %@", NSStringFromClass([MendeleyPerson class]));
                          MendeleyPerson *person = (MendeleyPerson *) obj;
                          XCTAssertTrue([person.first_name isEqualToString:@"J."], @"We expected J. but got back %@", person.first_name);
                          XCTAssertTrue([person.last_name isEqualToString:@"Zdziarski"], @"We expected Zdziarski but got back %@", person.last_name);
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
