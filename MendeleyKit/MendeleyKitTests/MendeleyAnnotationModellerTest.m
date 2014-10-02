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

@interface MendeleyAnnotationModellerTest : MendeleyKitTestBaseClass
@property (nonatomic, strong) NSData *jsonArrayData;
@end

@implementation MendeleyAnnotationModellerTest

- (void)setUp
{
    [super setUp];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *jsonArrayPath = [bundle pathForResource:@"annotation.json" ofType:nil];
    NSData *jsonArray = [NSData dataWithContentsOfFile:jsonArrayPath];
    self.jsonArrayData = jsonArray;
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testParseAnnotationJSON
{
    XCTAssertTrue(self.jsonArrayData, @"We expected the jsonArray to be not NIL");
    NSError *parseError = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:self.jsonArrayData options:NSJSONReadingAllowFragments error:&parseError];
    XCTAssertNil(parseError, @"we expected the JSON data to be parsed without error");
    if (nil != jsonObject)
    {
        MendeleyModeller *modeller = [MendeleyModeller sharedInstance];
        [modeller parseJSONData:jsonObject expectedType:kMendeleyModelAnnotation completionBlock:^(id parsedObject, NSError *error) {
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
                     XCTAssertTrue(0 < ((NSArray *) parsedObject).count, @"There should be some annotations in the array");
                     BOOL foundSampleAnnotation = NO;
                     for (MendeleyAnnotation * annotation in(NSArray *) parsedObject)
                     {
                         NSString *objectID = annotation.object_ID;
                         if ([objectID isEqualToString:@"3906d1e7-dea8-4313-9cdb-5cd5b776b7db"])
                         {
                             foundSampleAnnotation = YES;
                             XCTAssertTrue([annotation.type isEqualToString:@"highlight"], @"We should have a highlight, instead we get %@", annotation.type);
                             XCTAssertTrue([annotation.profile_id isEqualToString:@"1b17179a-08d6-342b-a63d-ab0a9264aac8"], @"Unexpected profile id");
                             XCTAssertTrue([annotation.document_id isEqualToString:@"68e3bce9-4c35-3e8d-aa79-b007f50405a4"], @"Unexpected document ID");
                             XCTAssertTrue([annotation.filehash isEqualToString:@"4787da46c9b91cb69f7f3449e20b210fe970e234"], @"Unexpected filehash");
                             XCTAssertTrue([annotation.privacy_level isEqualToString:@"private"], @"Unexpected privacy_level");
                             id color = annotation.color;
                             XCTAssertTrue([color isKindOfClass:[UIColor class]], @"For iOS this should be a UIColor object");
                             if ([color isKindOfClass:[UIColor class]])
                             {
                                 UIColor *colour = (UIColor *) color;
                                 CGFloat red, green, blue, alpha;
                                 [colour getRed:&red green:&green blue:&blue alpha:&alpha];
                                 red *= 255.f;
                                 green *= 255.f;
                                 blue *= 255.f;
                                 XCTAssertTrue(248.f == floorf(red), @"red should be 248 but is %f", red);
                                 XCTAssertTrue(232.f == floorf(green), @"green should be 232 but is %f", green);
                                 XCTAssertTrue(116.f == floorf(blue), @"blue should be 116 but is %f", blue);
                             }
                             NSArray *positions = annotation.positions;
                             XCTAssertNotNil(positions, @"positions should not be nil");
                             XCTAssertTrue(0 < positions.count, @"We should have a few annotation positions in there");

                             for (MendeleyHighlighBox * box in positions)
                             {
                                 CGRect frame = box.box;
                                 NSNumber *page = box.page;
                                 XCTAssertTrue(0 < [page intValue], @"page should start with 1 at least");
                                 XCTAssertTrue(0 < frame.origin.x, @"x value top left should not be 0");
                                 XCTAssertTrue(0 < frame.origin.y, @"y value top left should not be 0");
                                 XCTAssertTrue(0 < frame.size.width, @"width should not be 0");
                                 XCTAssertTrue(0 < frame.size.height, @"height should not be 0");
                             }

                         }
                     }
                     XCTAssertTrue(foundSampleAnnotation, @"we should have found this sample annotation");
                 }

             }
         }];
    }
}

- (void)testAnnotationToJSON
{
    MendeleyAnnotation *annotation = [self annotationForTesting];

    XCTAssertNotNil(annotation, @"created annotation should not be nil");

    MendeleyModeller *modeller = [MendeleyModeller sharedInstance];
    NSError *jsonError = nil;
    NSData *jsonData = [modeller jsonObjectFromModelOrModels:annotation error:&jsonError];

    XCTAssertNotNil(jsonData, @"jsonData should not be nil");
    XCTAssertNil(jsonError, @"we should get no error back");


}

- (MendeleyAnnotation *)annotationForTesting
{
    MendeleyAnnotation *annotation = [MendeleyAnnotation new];

    annotation.object_ID = @"eb74f036-dd94-4632-b37d-2d80cd207fa4";
    annotation.type = @"highlight";
    UIColor *color = [UIColor colorWithRed:248.f / 255.f green:232.f / 255.f blue:116.f / 255.f alpha:1.0f];
    annotation.color = color;

    annotation.profile_id = @"1b17179a-08d6-342b-a63d-ab0a9264aac8";
    CGFloat topX = 168.6518f;
    CGFloat topY = 691.9816f;
    CGFloat botX = 216.3005f;
    CGFloat botY = 704.2911;

    CGFloat width = botX - topX;
    CGFloat height = botY - topY;


    MendeleyHighlighBox *box = [MendeleyHighlighBox new];
    box.page = [NSNumber numberWithInt:2];
    box.box = CGRectMake(topX, topY, width, height);

    annotation.positions = @[box];

    annotation.document_id = @"456eba17-3ddd-3475-b640-d5aa9865eae1";
    annotation.filehash = @"fa6422db5e9ba190464c77017bea9fc6e3a4256f";
    annotation.privacy_level = @"private";

    NSString *createdDate = @"2014-02-11T16:50:27.490Z";
    NSString *lastModified = @"2014-02-11T16:50:30.918Z";

    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = kMendeleyJSONDateTimeFormat;
    annotation.created = [formatter dateFromString:createdDate];
    annotation.last_modified = [formatter dateFromString:lastModified];

    return annotation;
}

- (void)testAnnotationRoundTrip
{
    XCTAssertTrue(self.jsonArrayData, @"We expected the jsonArray to be not NIL");
    NSError *parseError = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:self.jsonArrayData options:NSJSONReadingAllowFragments error:&parseError];
    XCTAssertNil(parseError, @"we expected the JSON data to be parsed without error");
    if (nil != jsonObject)
    {
        MendeleyModeller *modeller = [MendeleyModeller sharedInstance];
        [modeller parseJSONData:jsonObject expectedType:kMendeleyModelAnnotation completionBlock:^(id parsedObject, NSError *error) {
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
                     NSUInteger count = ((NSArray *) parsedObject).count;
                     NSError *jsonError = nil;
                     NSData *jsonData = [modeller jsonObjectFromModelOrModels:parsedObject error:&jsonError];
                     XCTAssertNil(jsonError, @"the json error should be nil");
                     XCTAssertNotNil(jsonData, @"the json data must not be nil");

                     if (nil != jsonData)
                     {
                         id foundationObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                               options:NSJSONReadingMutableContainers
                                                                                 error:&jsonError];

                         XCTAssertTrue([foundationObject isKindOfClass:[NSArray class]], @"foundation object should be of type NSArray");
                         if ([foundationObject isKindOfClass:[NSArray class]])
                         {
                             NSArray *foundationArray = (NSArray *) foundationObject;
                             XCTAssertTrue(count == foundationArray.count, @"We should get the same number of annotations back as before, which ");
                         }
                     }

                 }
             }
         }];
    }
}

@end
