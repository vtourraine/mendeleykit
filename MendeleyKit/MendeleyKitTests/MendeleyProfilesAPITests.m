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
#import "MendeleyKitTestBaseClass.h"
#ifndef MendeleyKitiOSFramework
#import "MendeleyModeller.h"
#import "MendeleyModels.h"
#endif

@interface MendeleyProfilesAPITests : MendeleyKitTestBaseClass
@property (nonatomic, strong) NSData *profilesJSONData;
@end

@implementation MendeleyProfilesAPITests

- (void)setUp
{
    [super setUp];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *jsonObjectPath = [bundle pathForResource:@"profiles.json" ofType:nil];

    NSData *jsonObject = [NSData dataWithContentsOfFile:jsonObjectPath];
    if (nil != jsonObject)
    {
        self.profilesJSONData = jsonObject;
    }
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testProfilesJSON
{

    MendeleyModeller *modeller = [MendeleyModeller sharedInstance];
    NSError *parseError = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:self.profilesJSONData options:NSJSONReadingAllowFragments error:&parseError];

    XCTAssertNotNil(jsonObject, @"The jsonObject should not be nil");
    if (nil == jsonObject)
    {
        return;
    }


    [modeller parseJSONData:jsonObject
               expectedType:kMendeleyModelProfile
            completionBlock:^(id parsedObject, NSError *error) {

         XCTAssertNotNil(parsedObject, @"The parsed profiles should not be nil");
         XCTAssertNil(error, @"the error should be nil");
         if (nil != parsedObject)
         {
             MendeleyProfile *profile = (MendeleyProfile *) parsedObject;
             XCTAssertTrue([profile.object_ID isEqualToString:@"1b17179a-08d6-342b-a63d-ab0a9264aac8"], @"unexpected object ID %@", profile.object_ID);
             XCTAssertTrue([profile.first_name isEqualToString:@"Peter"], @"Unexpected first name %@", profile.first_name);
             XCTAssertTrue([profile.last_name isEqualToString:@"Schmidt"], @"Unexpected last name %@", profile.last_name);
             XCTAssertTrue([profile.display_name isEqualToString:@"Peter Schmidt"], @"Unexpected display name %@", profile.display_name);
             XCTAssertTrue([profile.email isEqualToString:@"peter.schmidt@mendeley.com"], @"Unexpected email %@", profile.email);
             XCTAssertTrue([profile.link isEqualToString:@"http://www.mendeley.com/profiles/peter-schmidt12/"], @"Unexpected link %@", profile.link);
             XCTAssertTrue([profile.academic_status isEqualToString:@"Post Doc"], @"Unexpected academic %@", profile.academic_status);
             XCTAssertTrue([profile.discipline.name isEqualToString:@"Computer and Information Science"], @"unexpected discipline %@", profile.discipline.name);

             XCTAssertTrue([profile.photo.standard isEqualToString:@"http://s3.amazonaws.com/mendeley-photos/awaiting.png"], @"Unexpected standard link %@", profile.photo.standard);
             XCTAssertTrue([profile.photo.square isEqualToString:@"http://s3.amazonaws.com/mendeley-photos/awaiting_square.png"], @"Unexpected sqaure link %@", profile.photo.square);

             XCTAssertTrue([profile.verified boolValue], @"The status should be verified == YES but isn't");
             XCTAssertTrue([profile.user_type isEqualToString:@"normal"], @"Unexpected user type %@", profile.user_type);
         }

     }];
}

@end
