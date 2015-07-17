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

#import "MendeleyKitTestBaseClass.h"

#ifndef MendeleyKitiOSFramework
#import "MendeleyModeller.h"
#import "MendeleyFollow.h"
#endif


@interface MendeleyFollowTests : MendeleyKitTestBaseClass
@property (nonatomic, strong) NSData *jsonData;
@end

@implementation MendeleyFollowTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (NSData *)jsonDataForFileWithName:(NSString *)fileName
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *jsonPath = [bundle pathForResource:fileName ofType:@"json"];
    return [NSData dataWithContentsOfFile:jsonPath];
}

- (void)testDeserializeFollowJsonArray
{
    self.jsonData = [self jsonDataForFileWithName:@"followers"];
    XCTAssertTrue(self.jsonData, @"We expected the jsonData to be not NIL");
    NSError *parseError = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:self.jsonData options:NSJSONReadingAllowFragments error:&parseError];
    XCTAssertNil(parseError, @"we expected the JSON data to be parsed without error");
    if (nil != jsonObject)
    {
        MendeleyModeller *modeller = [MendeleyModeller sharedInstance];
        [modeller parseJSONData:jsonObject expectedType:kMendeleyModelFollow completionBlock:^(id parsedObject, NSError *error) {
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
                     XCTAssertTrue(0 < ((NSArray *) parsedObject).count, @"There should be some Follows in the array");
                     BOOL foundFollows = NO;
                     for (MendeleyFollow *follow in (NSArray *) parsedObject)
                     {
                         NSString *object_id = follow.object_ID;
                         if ([object_id isEqualToString:@"d0fdf611-d314-3f01-8f05-26106607378f"])
                         {
                             foundFollows = YES;
                             XCTAssertTrue([follow.followed_id isEqualToString:@"e8c6f844-d356-398c-956d-6e2051ab6d26"], @"The followed_id should be e8c6f844-d356-398c-956d-6e2051ab6d26");
                             XCTAssertTrue([follow.follower_id isEqualToString:@"3064564d-9b66-3693-af3a-25b84524a014"], @"The follower_id should be 3064564d-9b66-3693-af3a-25b84524a014");
                             XCTAssertTrue([follow.status isEqualToString:@"pending"], @"The status should be pending");
                         }
                     }
                     XCTAssertTrue(foundFollows, @"the array should contain a Follow with file_id \"aFileID\"");
                 }

             }
         }];
    }
}

- (void)testSerializeFollowJsonRequest
{
    self.jsonData = [self jsonDataForFileWithName:@"followRequest"];
    XCTAssertTrue(self.jsonData, @"We expected the jsonData to be not NIL");
    NSError *parseError = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:self.jsonData options:NSJSONReadingAllowFragments error:&parseError];
    XCTAssertNil(parseError, @"we expected the JSON data to be parsed without error");
    
    if (nil != jsonObject)
    {
        MendeleyFollowRequest *followRequest = [MendeleyFollowRequest new];
        followRequest.followed = @"d0fdf611-d314-3f01-8f05-26106607378f";
        
        MendeleyModeller *modeller = [MendeleyModeller sharedInstance];
        NSData *jsonData = [modeller jsonObjectFromModelOrModels:followRequest error:&parseError];
        XCTAssertNil(parseError, @"We expected the error to bi nil");
        XCTAssertNotNil(jsonData, @"We expected the jsonData not to be nil");
        NSString *JSONStringFromFile = [[NSString alloc] initWithData:self.jsonData encoding:NSUTF8StringEncoding];
        NSString *cleanStringFromFile = [JSONStringFromFile stringByReplacingOccurrencesOfString:@"\\s" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, JSONStringFromFile.length)];
        NSString *JSONStringFromObject = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSString *cleanStringFromObject = [JSONStringFromObject stringByReplacingOccurrencesOfString:@"\\s" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, JSONStringFromObject.length)];
        XCTAssertEqualObjects(cleanStringFromFile, cleanStringFromObject, @"We expected the 2 strings to be the same");
    }
}

- (void)testSerializeFollowJSONAcceptance
{
    self.jsonData = [self jsonDataForFileWithName:@"followAcceptance"];
    XCTAssertTrue(self.jsonData, @"We expected the jsonData to be not NIL");
    NSError *parseError = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:self.jsonData options:NSJSONReadingAllowFragments error:&parseError];
    XCTAssertNil(parseError, @"we expected the JSON data to be parsed without error");
    
    if (nil != jsonObject)
    {
        MendeletyFollowAcceptance *followAcceptance = [MendeletyFollowAcceptance new];
        followAcceptance.status = kMendeleyRESTAPIQueryFollowersTypeFollowing;
        
        MendeleyModeller *modeller = [MendeleyModeller sharedInstance];
        NSData *jsonData = [modeller jsonObjectFromModelOrModels:followAcceptance error:&parseError];
        XCTAssertNil(parseError, @"We expected the error to bi nil");
        XCTAssertNotNil(jsonData, @"We expected the jsonData not to be nil");
        NSString *JSONStringFromFile = [[NSString alloc] initWithData:self.jsonData encoding:NSUTF8StringEncoding];
        NSString *cleanStringFromFile = [JSONStringFromFile stringByReplacingOccurrencesOfString:@"\\s" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, JSONStringFromFile.length)];
        NSString *JSONStringFromObject = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSString *cleanStringFromObject = [JSONStringFromObject stringByReplacingOccurrencesOfString:@"\\s" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, JSONStringFromObject.length)];
        XCTAssertEqualObjects(cleanStringFromFile, cleanStringFromObject, @"We expected the 2 strings to be the same");
    }
}

@end
