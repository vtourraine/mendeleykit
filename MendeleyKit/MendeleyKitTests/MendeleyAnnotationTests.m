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
#ifndef MendeleyKitiOSFramework
#import "MendeleyModeller.h"
#import "MendeleyModels.h"
#endif
#import "MendeleyKitTestBaseClass.h"

@interface MendeleyAnnotationTests : MendeleyKitTestBaseClass
#if TARGET_OS_IPHONE
@property (nonatomic, strong) UIColor *color;
#endif
@property (nonatomic, strong) NSDictionary <NSString *, NSNumber *> *colorDictionary;

@property (nonatomic, strong) MendeleyHighlightBox *highlightBox;
@property (nonatomic, strong) NSDictionary <NSString *, NSNumber *> *boxDictionary;
@end

@implementation MendeleyAnnotationTests

- (void)setUp
{
    [super setUp];

#if TARGET_OS_IPHONE
    self.color = [UIColor colorWithRed:248.f / 255.f green:232.f / 255.f blue:116.f / 255.f alpha:1.f];
#endif

    CGFloat x = 145.3185;
    CGFloat y = 701.9816;
    CGRect frame = CGRectMake(x, y, 0, 0);
    self.highlightBox = [MendeleyHighlightBox new];
    self.highlightBox.box = frame;
    self.highlightBox.page = [NSNumber numberWithInt:1];

    self.colorDictionary = @{ kMendeleyJSONColorRed : [NSNumber numberWithInt:248],
                              kMendeleyJSONColorGreen : [NSNumber numberWithInt:232],
                              kMendeleyJSONColorBlue : [NSNumber numberWithInt:116] };

    NSDictionary *topLeft = @{ kMendeleyJSONPositionX : [NSNumber numberWithFloat:145.3185],
                               kMendeleyJSONPositionY : [NSNumber numberWithFloat:701.9816] };

    NSDictionary *bottomRight = @{ kMendeleyJSONPositionX : [NSNumber numberWithFloat:145.3185],
                                   kMendeleyJSONPositionY : [NSNumber numberWithFloat:701.9816] };

    self.boxDictionary = @{ kMendeleyJSONPage : [NSNumber numberWithInt:1],
                            kMendeleyJSONTopLeft : topLeft,
                            kMendeleyJSONBottomRight : bottomRight };
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#if TARGET_OS_IPHONE
- (void)testColorFromColorParameters
{
    NSError *error = nil;
    UIColor *color = [MendeleyAnnotation colorFromParameters:self.colorDictionary error:&error];

    XCTAssertNotNil(color, @"colour must not be nil");

    CGFloat red, green, blue, alpha;

    [color getRed:&red green:&green blue:&blue alpha:&alpha];

    red *= 255.f;
    green *= 255.f;
    blue *= 255.f;

    XCTAssertTrue(248.f == floorf(red), @"red should be 248 but is %f", red);
    XCTAssertTrue(232.f == floorf(green), @"red should be 232 but is %f", green);
    XCTAssertTrue(116.f == floorf(blue), @"red should be 116 but is %f", blue);
}

- (void)testJSONColorParametersFromColor
{
    NSError *error = nil;
    NSDictionary *dictionary = [MendeleyAnnotation jsonColorFromColor:self.color error:&error];

    XCTAssertNotNil(dictionary, @"dictionary should not be nil");
    NSNumber *red = dictionary[kMendeleyJSONColorRed];
    NSNumber *green = dictionary[kMendeleyJSONColorGreen];
    NSNumber *blue = dictionary[kMendeleyJSONColorBlue];

    XCTAssertTrue(248.f == floorf([red floatValue]), @"red should be 248 but is %f", [red floatValue]);
    XCTAssertTrue(232.f == floorf([green floatValue]), @"red should be 232 but is %f", [green floatValue]);
    XCTAssertTrue(116.f == floorf([blue floatValue]), @"red should be 116 but is %f", [blue floatValue]);
}
#endif

- (void)testBoxFromJSONParameters
{
    NSError *error = nil;
    MendeleyHighlightBox *box = [MendeleyHighlightBox boxFromJSONParameters:self.boxDictionary error:&error];

    XCTAssertNotNil(box, @"we should get a not nil box back");
    XCTAssertNotNil(box.page, @"box page should not be nil");

    XCTAssertTrue([box.page isEqualToNumber:self.highlightBox.page], @"the highlight box page should be 1");
    CGFloat x = box.box.origin.x;
    CGFloat y = box.box.origin.y;
    CGFloat width = box.box.size.width;
    CGFloat height = box.box.size.height;

    XCTAssertTrue(145.3185f == x, @"x should be 145.3185 but is %f", x);
    XCTAssertTrue(701.9816f == y, @"y should be 701.9816 but is %f", y);
    XCTAssertTrue(0.f == width, @"width should be 0 but is %f", width);
    XCTAssertTrue(0.f == height, @"height should be 0 but is %f", height);
}

- (void)testJSONBoxFromHighlightBox
{
    NSError *error = nil;
    NSDictionary *dict = [MendeleyHighlightBox jsonBoxFromHighlightBox:self.highlightBox error:&error];

    XCTAssertNotNil(dict, @"the dictionary should not be nil");

    NSNumber *page = dict[kMendeleyJSONPage];
    id topLeft = dict[kMendeleyJSONTopLeft];
    id botRight = dict[kMendeleyJSONBottomRight];

    XCTAssertNotNil(page, @"the page object should not be nil");
    XCTAssertNotNil(topLeft, @"the top_left object should not be nil");
    XCTAssertNotNil(botRight, @"the bottom_right object should not be nil");

    if (nil != page)
    {
        XCTAssertEqual(1, [page intValue], @"page should be 1 but is %d", [page intValue]);
    }

    if (nil != topLeft)
    {
        XCTAssertTrue([topLeft isKindOfClass:[NSDictionary class]], @"topleft should be of type NSDictionary");
        NSDictionary *dictionary = (NSDictionary *) topLeft;
        NSNumber *xNumber = dictionary[kMendeleyJSONPositionX];
        NSNumber *yNumber = dictionary[kMendeleyJSONPositionY];

        XCTAssertTrue(145.3185f == [xNumber floatValue], @"x should be 145.3185f but is %f", [xNumber floatValue]);
        XCTAssertTrue(701.9816f == [yNumber floatValue], @"y should be 701.9816f but is %f", [yNumber floatValue]);
    }

    if (nil != botRight)
    {
        XCTAssertTrue([botRight isKindOfClass:[NSDictionary class]], @"botRight should be of type NSDictionary");
        NSDictionary *dictionary = (NSDictionary *) botRight;
        NSNumber *xNumber = dictionary[kMendeleyJSONPositionX];
        NSNumber *yNumber = dictionary[kMendeleyJSONPositionY];

        XCTAssertTrue(145.3185f == [xNumber floatValue], @"x should be 145.3185f but is %f", [xNumber floatValue]);
        XCTAssertTrue(701.9816f == [yNumber floatValue], @"y should be 701.9816f but is %f", [yNumber floatValue]);
    }
}

@end
