//
//  MendeleyDisciplineModellerTest.m
//  MendeleyKit
//
//  Created by Peter Schmidt on 02/02/2015.
//  Copyright (c) 2015 Mendeley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "MendeleyModeller.h"
#import "MendeleyModels.h"
#import "MendeleyKitTestBaseClass.h"

@interface MendeleyDisciplineModellerTest : MendeleyKitTestBaseClass
@property (nonatomic, strong) NSData *jsonArrayData;
@end

@implementation MendeleyDisciplineModellerTest

- (void)setUp
{
    [super setUp];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *jsonArrayPath = [bundle pathForResource:@"disciplines.json" ofType:nil];
    NSData *jsonArray = [NSData dataWithContentsOfFile:jsonArrayPath];
    self.jsonArrayData = jsonArray;
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
                     for (MendeleyDiscipline  * discipline in(NSArray *) parsedObject)
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
@end
