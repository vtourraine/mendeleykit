//
//  MendeleyRecentlyReadTests.m
//  MendeleyKit
//
//  Created by Stefano Piamonti on 11/03/2015.
//  Copyright (c) 2015 Mendeley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "MendeleyKitTestBaseClass.h"
#import "MendeleyFile.h"
#import "MendeleyModeller.h"
#include <stdlib.h>

@interface MendeleyRecentlyReadTests : MendeleyKitTestBaseClass
@property (nonatomic, strong) NSData *jsonArrayData;
@property (nonatomic, strong) NSData *jsonObjectData;
@property (nonatomic, strong) MendeleyRecentlyRead *exampleObject;
@end

@implementation MendeleyRecentlyReadTests

- (void)setUp
{
    [super setUp];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];

    NSString *jsonArrayPath = [bundle pathForResource:@"recentlyReadArray.json" ofType:nil];
    NSData *jsonArray = [NSData dataWithContentsOfFile:jsonArrayPath];
    self.jsonArrayData = jsonArray;

    NSString *jsonObjectPath = [bundle pathForResource:@"recentlyReadObject.json" ofType:nil];
    NSData *jsonObject = [NSData dataWithContentsOfFile:jsonObjectPath];
    self.jsonObjectData = jsonObject;

    self.exampleObject = [[MendeleyRecentlyRead alloc] init];
    self.exampleObject.file_id = [[NSUUID UUID] UUIDString];
    self.exampleObject.page = @(arc4random_uniform(1984));
    self.exampleObject.vertical_position = @(arc4random_uniform(2015));
    self.exampleObject.date = [NSDate date];

}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testParseRecentlyReadJsonArray
{
    XCTAssertTrue(self.jsonArrayData, @"We expected the jsonArray to be not NIL");
    NSError *parseError = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:self.jsonArrayData options:NSJSONReadingAllowFragments error:&parseError];
    XCTAssertNil(parseError, @"we expected the JSON data to be parsed without error");
    if (nil != jsonObject)
    {
        MendeleyModeller *modeller = [MendeleyModeller sharedInstance];
        [modeller parseJSONData:jsonObject expectedType:kMendeleyModelRecentlyRead completionBlock:^(id parsedObject, NSError *error) {
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
                     XCTAssertTrue(0 < ((NSArray *) parsedObject).count, @"There should be some RecentlyReads in the array");
                     BOOL foundRecentlyReads = NO;
                     for (MendeleyRecentlyRead *recentlyRead in (NSArray *) parsedObject)
                     {
                         NSString *file_id = recentlyRead.file_id;
                         if ([file_id isEqualToString:@"aFileID"])
                         {
                             foundRecentlyReads = YES;
                             XCTAssertTrue([recentlyRead.page isEqualToNumber:@(0)], @"The page number should be 0");
                             XCTAssertTrue([recentlyRead.vertical_position isEqualToNumber:@(10)], @"The vertical_position number should be 10");

                             NSString *dateString = @"2014-12-03T14:25:06.000Z";
                             NSDateFormatter *dateFormatter;
                             dateFormatter = [[NSDateFormatter alloc] init];
                             [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
                             [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
                             dateString = [dateString substringWithRange:NSMakeRange(0, [dateString length] - 5)];
                             XCTAssertTrue([recentlyRead.date isEqualToDate:[dateFormatter dateFromString:dateString]], @"The page number should be 0");
                         }
                     }
                     XCTAssertTrue(foundRecentlyReads, @"the array should contain a RecentlyRead with file_id \"aFileID\"");
                 }

             }
         }];
    }
}

- (void)testParseRecentlyReadJsonObject
{
    XCTAssertTrue(self.jsonObjectData, @"We expected the jsonArray to be not NIL");
    NSError *parseError = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:self.jsonObjectData options:NSJSONReadingAllowFragments error:&parseError];
    XCTAssertNil(parseError, @"we expected the JSON data to be parsed without error");
    if (nil != jsonObject)
    {
        MendeleyModeller *modeller = [MendeleyModeller sharedInstance];
        [modeller parseJSONData:jsonObject expectedType:kMendeleyModelRecentlyRead completionBlock:^(id parsedObject, NSError *error) {
             XCTAssertNil(error, @"We expected the error to be nil");
             if (nil != error)
             {
                 NSLog(@"Error message is %@", [error localizedDescription]);
             }
             else
             {
                 XCTAssertTrue([parsedObject isKindOfClass:[MendeleyRecentlyRead class]], @"We expected an object of type MendeleyRecenetlyRead but got back %@", NSStringFromClass([parsedObject class]));
                 if ([parsedObject isKindOfClass:[MendeleyRecentlyRead class]])
                 {
                     MendeleyRecentlyRead *recentlyRead = (MendeleyRecentlyRead *) parsedObject;
                     XCTAssertTrue([recentlyRead.file_id isEqualToString:@"fileID"], @"The page number should be 0");
                     XCTAssertTrue([recentlyRead.page isEqualToNumber:@(12)], @"The page number should be 0");
                     XCTAssertTrue([recentlyRead.vertical_position isEqualToNumber:@(1000)], @"The vertical_position number should be 10");

                     NSString *dateString = @"2015-03-10T12:52:06.000Z";
                     NSDateFormatter *dateFormatter;
                     dateFormatter = [[NSDateFormatter alloc] init];
                     [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
                     [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
                     dateString = [dateString substringWithRange:NSMakeRange(0, [dateString length] - 5)];
                     XCTAssertTrue([recentlyRead.date isEqualToDate:[dateFormatter dateFromString:dateString]], @"The date should be %@", dateString);
                 }
             }
         }];
    }
}

- (void)testParseRecentlyReadObject
{
    XCTAssertTrue(self.exampleObject, @"We expected the example RecentlyRead to be not NIL");
    MendeleyRecentlyRead *recentlyRead = (MendeleyRecentlyRead *) self.exampleObject;
    MendeleyModeller *modeller = [MendeleyModeller sharedInstance];

    NSError *writeError = nil;
    NSData *jsonData = [modeller jsonObjectFromModelOrModels:recentlyRead error:&writeError];
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
                id dictObj = [dict objectForKey:@"file_id"];
                XCTAssertNotNil(dictObj, @"we should have a file_id");
                XCTAssertTrue([dictObj isKindOfClass:[NSString class]], @"The class should be of type NSString but is %@", NSStringFromClass([dictObj class]));
                if ([dictObj isKindOfClass:[NSString class]])
                {
                    XCTAssertTrue([dictObj isEqualToString:self.exampleObject.file_id], @"We expect the file_id to be \"%@\" \"instead of %@\"", self.exampleObject.file_id, dictObj);
                }

                dictObj = [dict objectForKey:@"page"];
                XCTAssertNotNil(dictObj, @"we should have a page");
                XCTAssertTrue([dictObj isKindOfClass:[NSNumber class]], @"The class should be of type NSNumber but is %@", NSStringFromClass([dictObj class]));
                if ([dictObj isKindOfClass:[NSNumber class]])
                {
                    XCTAssertTrue([dictObj isEqualToNumber:self.exampleObject.page], @"We expect the page to be \"%li\" \"instead of %li\"", [self.exampleObject.page integerValue], (long) [dictObj integerValue]);
                }

                dictObj = [dict objectForKey:@"vertical_position"];
                XCTAssertNotNil(dictObj, @"we should have a vertical_position");
                XCTAssertTrue([dictObj isKindOfClass:[NSNumber class]], @"The class should be of type NSNumber but is %@", NSStringFromClass([dictObj class]));
                if ([dictObj isKindOfClass:[NSNumber class]])
                {
                    XCTAssertTrue([dictObj isEqualToNumber:self.exampleObject.vertical_position], @"We expect the vertical_position to be \"%li\" \"instead of %li\"", [self.exampleObject.vertical_position integerValue], (long) [dictObj integerValue]);
                }

                dictObj = [dict objectForKey:@"date"];
                XCTAssertNotNil(dictObj, @"we should have a date");
                XCTAssertTrue([dictObj isKindOfClass:[NSString class]], @"The class should be of type NSString but is %@", NSStringFromClass([dictObj class]));
                if ([dictObj isKindOfClass:[NSString class]])
                {
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
                    [dateFormatter setLocale:enUSPOSIXLocale];
                    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];

                    NSString *iso8601String = [dateFormatter stringFromDate:self.exampleObject.date];

                    XCTAssertTrue([dictObj isEqualToString:iso8601String], @"We expect the date to be \"%@\" \"instead of %@\"", iso8601String, dictObj);
                }
            }
        }
    }
}

@end
