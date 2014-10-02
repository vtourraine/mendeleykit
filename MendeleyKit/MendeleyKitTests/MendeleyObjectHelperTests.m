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

#import "MendeleyOAuthCredentials.h"
#import "MendeleyModels.h"
#import "MendeleyKitTestBaseClass.h"
#import "MendeleyObjectHelper.h"

@interface MendeleyObjectHelperTests : MendeleyKitTestBaseClass

@end

@implementation MendeleyObjectHelperTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testPropertiesAndAttributesForModel
{
    MendeleyDocument *document = [[MendeleyDocument alloc] init];

    document.object_ID = @"1234567890";
    document.title = @"some title";
    document.year = [NSNumber numberWithInt:2014];

    NSDictionary *modelDictionary = [MendeleyObjectHelper propertiesAndAttributesForModel:document];

    XCTAssertNotNil(modelDictionary, @"We expected the dictionary to be not nil");
    XCTAssertTrue(0 < modelDictionary.allKeys.count, @"We expected to have some properties in the dictionary, but got back 0");

    if (nil != modelDictionary && 0 < modelDictionary.allKeys.count)
    {
        __block NSString *objectID = nil;
        __block NSString *title = nil;
        __block NSString *year = nil;
        __block NSString *trashed = nil;
        [modelDictionary enumerateKeysAndObjectsUsingBlock:^(NSString *propertyName, id attribute, BOOL *stop) {
             if ([propertyName isEqualToString:@"object_ID"])
             {
                 objectID = propertyName;
             }
             else if ([propertyName isEqualToString:@"year"])
             {
                 year = propertyName;
             }
             else if ([propertyName isEqualToString:@"trashed"])
             {
                 trashed = propertyName;
             }
             else if ([propertyName isEqualToString:@"title"])
             {
                 title = propertyName;
             }
         }];


        XCTAssertNotNil(objectID, @"we should have an object ID");
        XCTAssertNotNil(title, @"we should have a title");
        XCTAssertNotNil(year, @"we should have a year value");
    }


}

- (void)testPropertyNamesForModel
{
    MendeleyDocument *document = [[MendeleyDocument alloc] init];

    document.object_ID = @"1234567890";
    document.title = @"some title";
    document.year = [NSNumber numberWithInt:2014];

    NSArray *properties = [MendeleyObjectHelper propertyNamesForModel:document];
    XCTAssertTrue([properties containsObject:@"object_ID"], @"should contain objectID");
    XCTAssertTrue([properties containsObject:@"title"], @"should contain title");
    XCTAssertTrue([properties containsObject:@"year"], @"should contain year");

}

- (void)testPropertyDictionaryForModel
{
    MendeleyDocument *document = [[MendeleyDocument alloc] init];
    NSDictionary *modelDictionary = [MendeleyObjectHelper propertiesAndAttributesForModel:document];

    ///this should be false, the id should be mapped to objectID
    XCTAssertFalse([modelDictionary objectForKey:kMendeleyJSONID], @"the object should not contain a property called id");

    ///the objectID comes from the superclass
    XCTAssertTrue([modelDictionary objectForKey:kMendeleyObjectID], @"the object must contain an objectID property");
    ///the properties below are defined in MendeleyDocument
    XCTAssertTrue([modelDictionary objectForKey:kMendeleyJSONMonth], @"the object must contain an month property");
    XCTAssertTrue([modelDictionary objectForKey:kMendeleyJSONYear], @"the object must contain an year property");
    XCTAssertTrue([modelDictionary objectForKey:kMendeleyJSONDay], @"the object must contain an day property");
    XCTAssertTrue([modelDictionary objectForKey:kMendeleyJSONRead], @"the object must contain an read property");
    XCTAssertTrue([modelDictionary objectForKey:kMendeleyJSONStarred], @"the object must contain an starred property");
    XCTAssertTrue([modelDictionary objectForKey:kMendeleyJSONAuthored], @"the object must contain an authored property");
    XCTAssertTrue([modelDictionary objectForKey:kMendeleyJSONConfirmed], @"the object must contain an confirmed property");
    XCTAssertTrue([modelDictionary objectForKey:kMendeleyJSONHidden], @"the object must contain an hidden property");
    XCTAssertTrue([modelDictionary objectForKey:kMendeleyJSONAuthors], @"the object must contain an authors property");
    XCTAssertTrue([modelDictionary objectForKey:kMendeleyJSONEditors], @"the object must contain an editors property");
    XCTAssertTrue([modelDictionary objectForKey:kMendeleyJSONIdentifiers], @"the object must contain an identifiers property");
    XCTAssertTrue([modelDictionary objectForKey:kMendeleyJSONLastModified], @"the object must contain an last_modified property");
    XCTAssertTrue([modelDictionary objectForKey:kMendeleyJSONCreated], @"the object must contain an added property");
    XCTAssertTrue([modelDictionary objectForKey:kMendeleyJSONType], @"the object must contain an type property");
    XCTAssertTrue([modelDictionary objectForKey:kMendeleyJSONGroupID], @"the object must contain an group_id property");
    XCTAssertTrue([modelDictionary objectForKey:kMendeleyJSONSource], @"the object must contain an source property");
    XCTAssertTrue([modelDictionary objectForKey:kMendeleyJSONTitle], @"the object must contain an title property");
    XCTAssertTrue([modelDictionary objectForKey:kMendeleyJSONRevision], @"the object must contain an revision property");
    XCTAssertTrue([modelDictionary objectForKey:kMendeleyJSONAbstract], @"the object must contain an abstract property");
    XCTAssertTrue([modelDictionary objectForKey:kMendeleyJSONProfileID], @"the object must contain an profile_id property");
    XCTAssertTrue([modelDictionary objectForKey:kMendeleyJSONPages], @"the object must contain an pages property");
    XCTAssertTrue([modelDictionary objectForKey:kMendeleyJSONVolume], @"the object must contain an volume property");
    XCTAssertTrue([modelDictionary objectForKey:kMendeleyJSONIssue], @"the object must contain an issue property");
    XCTAssertTrue([modelDictionary objectForKey:kMendeleyJSONWebsites], @"the object must contain an websites property");
    XCTAssertTrue([modelDictionary objectForKey:kMendeleyJSONPublisher], @"the object must contain an publisher property");
    XCTAssertTrue([modelDictionary objectForKey:kMendeleyJSONCity], @"the object must contain an city property");
    XCTAssertTrue([modelDictionary objectForKey:kMendeleyJSONEdition], @"the object must contain an edition property");
    XCTAssertTrue([modelDictionary objectForKey:kMendeleyJSONInstitution], @"the object must contain an institution property");
    XCTAssertTrue([modelDictionary objectForKey:kMendeleyJSONSeries], @"the object must contain an series property");
    XCTAssertTrue([modelDictionary objectForKey:kMendeleyJSONChapter], @"the object must contain an chapter property");
    XCTAssertTrue([modelDictionary objectForKey:kMendeleyJSONFileAttached], @"the object must contain an file attached property");
}

- (void)testMatchedJSONKeyForKey
{
    NSString *key = [MendeleyObjectHelper matchedKeyForJSONKey:kMendeleyJSONID];

    XCTAssertTrue([key isEqualToString:kMendeleyObjectID], @"we expected objectID but got back %@", key);

    key = [MendeleyObjectHelper matchedKeyForJSONKey:kMendeleyJSONAbstract];
    XCTAssertTrue([key isEqualToString:kMendeleyJSONAbstract], @"we expected abstract but got back %@", key);
}

- (void)testMatchedKeyForJSONKey
{
    NSString *key = [MendeleyObjectHelper matchedJSONKeyForKey:kMendeleyObjectID];

    XCTAssertTrue([key isEqualToString:kMendeleyJSONID], @"we expected id but got back %@", key);

    key = [MendeleyObjectHelper matchedJSONKeyForKey:kMendeleyJSONAbstract];
    XCTAssertTrue([key isEqualToString:kMendeleyJSONAbstract], @"we expected abstract but got back %@", key);
}

- (void)testModelFromClassName
{
    NSError *error = nil;
    id model = [MendeleyObjectHelper modelFromClassName:kMendeleyModelDocument error:&error];

    XCTAssertNotNil(model, @"we expected to have a model class created");
    if (nil != model)
    {
        XCTAssertTrue([model isKindOfClass:[MendeleyDocument class]], @"We expected the model to be of type MendeleyDocument but got back %@", NSStringFromClass([model class]));
    }

    model = [MendeleyObjectHelper modelFromClassName:kMendeleyModelFile error:&error];
    XCTAssertNotNil(model, @"we expected to have a model class created");
    if (nil != model)
    {
        XCTAssertTrue([model isKindOfClass:[MendeleyFile class]], @"We expected the model to be of type MendeleyFile but got back %@", NSStringFromClass([model class]));
    }

    model = [MendeleyObjectHelper modelFromClassName:kMendeleyModelFolder error:&error];
    XCTAssertNotNil(model, @"we expected to have a model class created");
    if (nil != model)
    {
        XCTAssertTrue([model isKindOfClass:[MendeleyFolder class]], @"We expected the model to be of type MendeleyFolder but got back %@", NSStringFromClass([model class]));
    }

    model = [MendeleyObjectHelper modelFromClassName:kMendeleyModelOAuthCredentials error:&error];
    XCTAssertNotNil(model, @"we expected to have a model class created");
    if (nil != model)
    {
        XCTAssertTrue([model isKindOfClass:[MendeleyOAuthCredentials class]], @"We expected the model to be of type MendeleyOAuthCredentials but got back %@", NSStringFromClass([model class]));
    }

    model = [MendeleyObjectHelper modelFromClassName:kMendeleyModelPerson error:&error];
    XCTAssertNotNil(model, @"we expected to have a model class created");
    if (nil != model)
    {
        XCTAssertTrue([model isKindOfClass:[MendeleyPerson class]], @"We expected the model to be of type MendeleyPerson but got back %@", NSStringFromClass([model class]));
    }

    model = [MendeleyObjectHelper modelFromClassName:@"SomeClass" error:&error];
    XCTAssertNil(model, @"we shouldn't be able to create this class");
}

- (void)testArrayToModelDictionary
{
    NSString *modelName = [[MendeleyObjectHelper arrayToModelDictionary] objectForKey:kMendeleyJSONAuthors];

    XCTAssertNotNil(modelName, @"we should have a valid model name for authors");
    if (nil != modelName)
    {
        XCTAssertTrue([modelName isEqualToString:kMendeleyModelPerson], @"the model name should be Person, but instead is %@", modelName);
        NSError *error = nil;
        id model = [MendeleyObjectHelper modelFromClassName:modelName error:&error];
        XCTAssertNotNil(model, @"we should be able to create a model out of Person");
        if (nil != model)
        {
            XCTAssertTrue([model isKindOfClass:[MendeleyPerson class]], @"The model class should be of type Person but is %@ instead", NSStringFromClass([model class]));
        }
    }
}

@end
