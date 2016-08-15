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

//#import <UIKit/UIKit.h>

#import <XCTest/XCTest.h>
#import "MendeleyKitTestBaseClass.h"

#ifndef MendeleyKitiOSFramework
#import "MendeleyModeller.h"
#import "MendeleyModels.h"
#import "MendeleyAcademicStatus.h"
#endif


@interface MendeleyAcademicStatusTests : MendeleyKitTestBaseClass
@property (nonatomic, strong) NSData *jsonArrayData;
@end

@implementation MendeleyAcademicStatusTests

- (void)setUp
{
    [super setUp];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *jsonArrayPath = [bundle pathForResource:@"academic_statuses.json" ofType:nil];
    NSData *jsonArray = [NSData dataWithContentsOfFile:jsonArrayPath];
    self.jsonArrayData = jsonArray;
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testGetAcademicStatuses
{
    XCTAssertTrue(self.jsonArrayData, @"We expected the jsonArray to be not NIL");
    NSError *parseError = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:self.jsonArrayData options:NSJSONReadingAllowFragments error:&parseError];
    XCTAssertNil(parseError, @"we expected the JSON data to be parsed without error");
    if (nil != jsonObject)
    {
        MendeleyModeller *modeller = [MendeleyModeller sharedInstance];
        [modeller parseJSONData:jsonObject expectedType:kMendeleyModelAcademicStatus completionBlock:^(id parsedObject, NSError *error) {
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
                     BOOL foundStatus = NO;
                     for (MendeleyAcademicStatus  * academicStatus in(NSArray *) parsedObject)
                     {
                         NSString *status = academicStatus.objectDescription;
                         if ([status isEqualToString:@"Doctoral Student"])
                         {
                             foundStatus = YES;
                         }

                     }
                     XCTAssertTrue(foundStatus, @"the array should contain a academic status called 'Doctoral Student'");
                 }

             }
         }];
    }
}


@end
