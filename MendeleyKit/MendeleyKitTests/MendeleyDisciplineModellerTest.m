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

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "MendeleyModeller.h"
#import "MendeleyModels.h"
#import "MendeleyKitTestBaseClass.h"

#define kExampleName           @"a name"
#define KExampleSubdisciplines @[@"first subdiscipline", @"second subdiscipline"]

@interface MendeleyDisciplineModellerTest : MendeleyKitTestBaseClass
@property (nonatomic, strong) NSData *jsonArrayData;
@property (nonatomic, strong) MendeleyDiscipline *exampleDiscipline;
@end


@implementation MendeleyDisciplineModellerTest

- (void)setUp
{
    [super setUp];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *jsonArrayPath = [bundle pathForResource:@"disciplines.json" ofType:nil];
    NSData *jsonArray = [NSData dataWithContentsOfFile:jsonArrayPath];
    self.jsonArrayData = jsonArray;

    self.exampleDiscipline = [[MendeleyDiscipline alloc] init];
    self.exampleDiscipline.name = kExampleName;
    self.exampleDiscipline.subdisciplines = KExampleSubdisciplines;
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testParseDisciplineModels
{
    XCTAssertTrue(self.jsonArrayData, @"We expected the jsonArray to be not NIL");
    NSError *parseError = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:self.jsonArrayData options:NSJSONReadingAllowFragments error:&parseError];
    XCTAssertNil(parseError, @"we expected the JSON data to be parsed without error");
    if (nil != jsonObject)
    {
        MendeleyModeller *modeller = [MendeleyModeller sharedInstance];
        [modeller parseJSONData:jsonObject expectedType:kMendeleyModelDiscipline completionBlock:^(id parsedObject, NSError *error) {
             XCTAssertNil(error, @"We expected the error to be nil");
             if (nil != error)
             {
                 NSLog(@"Error message is %@", [error localizedDescription]);
             }
             else
             {
                 XCTAssertTrue([parsedObject isKindOfClass:[NSArray class]], @"We expected an object of type NSArray but got back %@", NSStringFromClass([parsedObject class]));
                 if ([parsedObject isKindOfClass:[NSArray class]])
                 {
                     XCTAssertTrue(0 < ((NSArray *) parsedObject).count, @"There should be some disciplines in the array");
                     BOOL foundDisciplines = NO;
                     for (MendeleyDiscipline *discipline in (NSArray *) parsedObject)
                     {
                         NSString *name = discipline.name;
                         if ([name isEqualToString:@"Earth Sciences"])
                         {
                             foundDisciplines = YES;
                             NSArray *subdisciplines = discipline.subdisciplines;
                             XCTAssertTrue(0 < subdisciplines.count, @"'Earth Sciences' should have an array of subdisciplines");
                         }
                     }
                     XCTAssertTrue(foundDisciplines, @"the array should contain a discipline called 'Earth Sciences'");
                 }

             }
         }];
    }
}

- (void)testParseDisciplineObject
{
    XCTAssertTrue(self.exampleDiscipline, @"We expected the example discipline to be not NIL");
    MendeleyDiscipline *discipline = (MendeleyDiscipline *) self.exampleDiscipline;
    MendeleyModeller *modeller = [MendeleyModeller sharedInstance];

    NSError *writeError = nil;
    NSData *jsonData = [modeller jsonObjectFromModelOrModels:discipline error:&writeError];
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
                id dictObj = [dict objectForKey:kMendeleyJSONName];
                XCTAssertNotNil(dictObj, @"we should have a name");
                XCTAssertTrue([dictObj isKindOfClass:[NSString class]], @"The class should be of type NSString but is %@", NSStringFromClass([dictObj class]));
                if ([dictObj isKindOfClass:[NSString class]])
                {
                    XCTAssertTrue([dictObj isEqualToString:kExampleName]);
                }

                dictObj = [dict objectForKey:kMendeleyJSONSubdisciplines];
                XCTAssertNotNil(dictObj, @"expected a subdiscipline");
                XCTAssertTrue([dictObj isKindOfClass:[NSArray class]], @"The class should be of type NSArray but is %@", NSStringFromClass([dictObj class]));
                if ([dictObj isKindOfClass:[NSArray class]])
                {
                    NSArray *theArray = KExampleSubdisciplines;
                    XCTAssertTrue([dictObj isEqualToArray:theArray], @"Unexpected array value");
                }
            }
        }
    }
}

@end
