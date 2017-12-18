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

@interface MendeleyDatasetModellerTests : MendeleyKitTestBaseClass

@end


@implementation MendeleyDatasetModellerTests

- (void)testParseDatasetListObject
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *jsonArrayPath = [bundle pathForResource:@"datasets.json" ofType:nil];
    NSData *jsonArrayData = [NSData dataWithContentsOfFile:jsonArrayPath];
    XCTAssertTrue(jsonArrayData);

    NSError *parseError = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonArrayData options:NSJSONReadingAllowFragments error:&parseError];
    XCTAssertNotNil(jsonObject, @"we expected the JSON data to be parsed without error (error: %@)", parseError);

    MendeleyModeller *modeller = [MendeleyModeller sharedInstance];
    [modeller parseJSONData:jsonObject expectedType:kMendeleyModelDataset completionBlock:^(id parsedObject, NSError *error) {
        XCTAssertNotNil(parsedObject, @"We expected the parsing to return without error (error: %@)", error);

        XCTAssertTrue([parsedObject isKindOfClass:[NSArray class]]);
        XCTAssertEqual(((NSArray *)parsedObject).count, 50);

        for (id parsedElement in parsedObject)
        {
            XCTAssertTrue([parsedElement isKindOfClass:[MendeleyDataset class]]);
            XCTAssertNotNil(((MendeleyDataset *)parsedElement).object_ID);
        }

        MendeleyDataset *firstDataset = [parsedObject firstObject];
        XCTAssertEqualObjects(firstDataset.object_ID, @"4dypw2dy8c");

        MendeleyDataset *lastDataset = [parsedObject lastObject];
        XCTAssertEqualObjects(lastDataset.object_ID, @"spv45dw942");
    }];
}

- (void)testParseDatasetObject
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *jsonObjectPath = [bundle pathForResource:@"dataset.json" ofType:nil];
    NSData *jsonObjectData = [NSData dataWithContentsOfFile:jsonObjectPath];
    XCTAssertTrue(jsonObjectData);

    NSError *parseError = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonObjectData options:NSJSONReadingAllowFragments error:&parseError];
    XCTAssertNotNil(jsonObject, @"we expected the JSON data to be parsed without error (error: %@)", parseError);

    MendeleyModeller *modeller = [MendeleyModeller sharedInstance];
    [modeller parseJSONData:jsonObject expectedType:kMendeleyModelDataset completionBlock:^(id parsedObject, NSError *error) {
        XCTAssertNotNil(parsedObject, @"We expected the parsing to return without error (error: %@)", error);

        XCTAssertTrue([parsedObject isKindOfClass:[MendeleyDataset class]]);

        MendeleyDataset *dataset = parsedObject;
        XCTAssertEqualObjects(dataset.object_ID, @"4dypw2dy8c");

        MendeleyDOI *doi = dataset.doi;
        XCTAssertTrue([doi isKindOfClass:[MendeleyDOI class]]);
        XCTAssertEqualObjects(doi.object_ID, @"10.17632/4dypw2dy8c.1");
        XCTAssertEqualObjects(doi.status, @"allocated");

        XCTAssertEqualObjects(dataset.name, @"Annex 1: Network Information and Demand of Scenario 1");
        XCTAssertEqualObjects(dataset.objectDescription, @"This data is the network information and demand of scenario 1 for the sample network");
        XCTAssertEqualObjects(dataset.owner_id, @"c7c2d1fa-a840-31c0-92a9-c8c5f70ac307");
        XCTAssertEqualObjects(dataset.object_version, @1);
        XCTAssertEqualObjects(dataset.publish_date, [self dateFromJSONDateTimeFormattedString:@"2016-02-24T10:32:59.867Z"]);

        MendeleyLicenceInfo *licenseInfo = dataset.data_licence;
        XCTAssertTrue([licenseInfo isKindOfClass:[MendeleyLicenceInfo class]]);
        XCTAssertEqualObjects(licenseInfo.object_ID, @"01d9c749-3c4d-4431-9df3-620b2dcfe144");
        XCTAssertEqualObjects(licenseInfo.short_name, @"CC BY 4.0");
        XCTAssertEqualObjects(licenseInfo.full_name, @"Creative Commons Attribution 4.0 International");
        XCTAssertEqualObjects(licenseInfo.objectDescription, @"Unless indicated otherwise, you can share, copy and modify the images or other third party material in this article so long as you give appropriate credit, provide a link to the license, and indicate if changes were made.\nIf the material is not included under the Creative Commons license, users will need to obtain permission from the license holder to reproduce the material.");
        XCTAssertEqualObjects(licenseInfo.url, @"http://creativecommons.org/licenses/by/4.0");

        XCTAssertTrue([dataset.contributors isKindOfClass:[NSArray class]]);
        XCTAssertEqual(dataset.contributors.count, 1);
        MendeleyPublicContributorDetails *contributor = dataset.contributors.firstObject;
        XCTAssertTrue([contributor isKindOfClass:[MendeleyPublicContributorDetails class]]);
        XCTAssertEqualObjects(contributor.profile_id, @"c7c2d1fa-a840-31c0-92a9-c8c5f70ac307");
        XCTAssertEqualObjects(contributor.first_name, @"Parham");
        XCTAssertEqualObjects(contributor.last_name, @"Hamouni");

        XCTAssertTrue([dataset.versions isKindOfClass:[NSArray class]]);
        XCTAssertEqual(dataset.versions.count, 1);
        MendeleyVersionMetadata *version = dataset.versions.firstObject;
        XCTAssertTrue([version isKindOfClass:[MendeleyVersionMetadata class]]);
        XCTAssertEqualObjects(version.object_version, @1);
        XCTAssertEqualObjects(version.publish_date, [self dateFromJSONDateTimeFormattedString:@"2016-02-24T10:32:59.867Z"]);
        XCTAssertEqualObjects(version.available, @YES);

        XCTAssertTrue([dataset.files isKindOfClass:[NSArray class]]);
        XCTAssertEqual(dataset.files.count, 1);
        MendeleyFileMetadata *fileMetadata = dataset.files.firstObject;
        XCTAssertTrue([fileMetadata isKindOfClass:[MendeleyFileMetadata class]]);
        XCTAssertEqualObjects(fileMetadata.filename, @"Annex 1.pdf");
        XCTAssertEqualObjects(fileMetadata.objectDescription, @"");

        XCTAssertTrue([fileMetadata.content_details isKindOfClass:[MendeleyFileData class]]);
        XCTAssertEqualObjects(fileMetadata.content_details.object_ID, @"c18e9c5f-b65a-43c5-8cfa-ba43b0d00047");
        XCTAssertEqualObjects(fileMetadata.content_details.sha256_hash, @"910ee12ba4830ab36db1e8e732ab926f2b40a4b2547595297be810593342c4d8");
        XCTAssertEqualObjects(fileMetadata.content_details.content_type, @"application/pdf");
        XCTAssertEqualObjects(fileMetadata.content_details.size, @922183);
        XCTAssertEqualObjects(fileMetadata.content_details.created_date, [self dateFromJSONDateTimeFormattedString:@"2016-02-24T00:00:00.000Z"]);
        XCTAssertEqualObjects(fileMetadata.content_details.download_url, @"https://api.mendeley.com/datasets/redirect/eyJ0eXBlIjoiZG93bmxvYWRfZmlsZSIsImRhdGFzZXRJZCI6IjRkeXB3MmR5OGMiLCJkYXRhc2V0VmVyc2lvbiI6MSwiZmlsZUlkIjoiYzE4ZTljNWYtYjY1YS00M2M1LThjZmEtYmE0M2IwZDAwMDQ3IiwiZGVzdGluYXRpb24iOiJodHRwczovL2NvbS1tZW5kZWxleS1pbnRlcm5hbC5zMy5hbWF6b25hd3MuY29tL3BsYXRmb3JtL3JkbS9wcm9kdWN0aW9uLzk2NTVjYjkyLTg3M2QtNGIwNy1iYTc2LWMzZjAzMmFmMmJiYj9yZXNwb25zZS1jb250ZW50LWRpc3Bvc2l0aW9uPWF0dGFjaG1lbnQlM0IlMjBmaWxlbmFtZSUzRCUyMkFubmV4JTIwMS5wZGYlMjIlM0IlMjBmaWxlbmFtZSUyQSUzRFVURi04JTI3JTI3QW5uZXglMjUyMDEucGRmJnJlc3BvbnNlLWNvbnRlbnQtdHlwZT1hcHBsaWNhdGlvbiUyRnBkZiZBV1NBY2Nlc3NLZXlJZD1BS0lBSTZEWlhPR0lDTEtWR1lFQSZFeHBpcmVzPTE0Njg0MDU3NDQmU2lnbmF0dXJlPXNiUXlZRTF4V25MQmtSb1M1ZFNvU0VCOFZGYyUzRCJ9");
        XCTAssertEqualObjects(fileMetadata.content_details.view_url, @"https://api.mendeley.com/datasets/redirect/eyJ0eXBlIjoidmlld19maWxlIiwiZGF0YXNldElkIjoiNGR5cHcyZHk4YyIsImRhdGFzZXRWZXJzaW9uIjoxLCJmaWxlSWQiOiJjMThlOWM1Zi1iNjVhLTQzYzUtOGNmYS1iYTQzYjBkMDAwNDciLCJkZXN0aW5hdGlvbiI6Imh0dHBzOi8vY29tLW1lbmRlbGV5LWludGVybmFsLnMzLmFtYXpvbmF3cy5jb20vcGxhdGZvcm0vcmRtL3Byb2R1Y3Rpb24vOTY1NWNiOTItODczZC00YjA3LWJhNzYtYzNmMDMyYWYyYmJiP3Jlc3BvbnNlLWNvbnRlbnQtZGlzcG9zaXRpb249aW5saW5lJTNCJTIwZmlsZW5hbWUlM0QlMjJBbm5leCUyMDEucGRmJTIyJTNCJTIwZmlsZW5hbWUlMkElM0RVVEYtOCUyNyUyN0FubmV4JTI1MjAxLnBkZiZyZXNwb25zZS1jb250ZW50LXR5cGU9YXBwbGljYXRpb24lMkZwZGYmQVdTQWNjZXNzS2V5SWQ9QUtJQUk2RFpYT0dJQ0xLVkdZRUEmRXhwaXJlcz0xNDY4NDA1NzQ0JlNpZ25hdHVyZT1rQUglMkYzN3IwVUtPNGlSU0ZZYVA5RDQxeVZwTSUzRCJ9");
        // XCTAssertEqualObjects(fileMetadata.content_details.download_expiry_time, @"2016-07-13T10:29:04.689Z");

        XCTAssertTrue([fileMetadata.metrics isKindOfClass:[MendeleyFileMetrics class]]);
        XCTAssertEqualObjects(fileMetadata.metrics.downloads, @2);
        XCTAssertEqualObjects(fileMetadata.metrics.previews, @0);

        XCTAssertTrue([dataset.articles isKindOfClass:[NSArray class]]);
        XCTAssertEqual(dataset.articles.count, 0);

        XCTAssertTrue([dataset.categories isKindOfClass:[NSArray class]]);
        XCTAssertEqual(dataset.categories.count, 1);
        XCTAssertEqualObjects(dataset.categories.firstObject.object_ID, @"http://data.elsevier.com/vocabulary/OmniScience/Concept-170589324");
        XCTAssertEqualObjects(dataset.categories.firstObject.label, @"Applied Sciences");

        XCTAssertTrue([dataset.institutions isKindOfClass:[NSArray class]]);
        XCTAssertEqual(dataset.institutions.count, 0);

        XCTAssertTrue([dataset.metrics isKindOfClass:[MendeleyDatasetMetrics class]]);
        XCTAssertEqualObjects(dataset.metrics.views, @11);
        XCTAssertEqualObjects(dataset.metrics.file_downloads, @2);
        XCTAssertEqualObjects(dataset.metrics.file_previews, @0);

        XCTAssertEqualObjects(dataset.available, @YES);

        XCTAssertTrue([dataset.related_links isKindOfClass:[NSArray class]]);
        XCTAssertEqual(dataset.related_links.count, 0);
    }];
}

- (void)testParseLicencesListObject
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *jsonArrayPath = [bundle pathForResource:@"licences.json" ofType:nil];
    NSData *jsonArrayData = [NSData dataWithContentsOfFile:jsonArrayPath];
    XCTAssertTrue(jsonArrayData);

    NSError *parseError = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonArrayData options:NSJSONReadingAllowFragments error:&parseError];
    XCTAssertNotNil(jsonObject, @"we expected the JSON data to be parsed without error (error: %@)", parseError);

    MendeleyModeller *modeller = [MendeleyModeller sharedInstance];
    [modeller parseJSONData:jsonObject expectedType:kMendeleyModelLicenceInfo completionBlock:^(id parsedObject, NSError *error) {
        XCTAssertNotNil(parsedObject, @"We expected the parsing to return without error (error: %@)", error);

        XCTAssertTrue([parsedObject isKindOfClass:[NSArray class]]);
        XCTAssertEqual(((NSArray *)parsedObject).count, 8);

        for (id parsedElement in parsedObject)
        {
            XCTAssertTrue([parsedElement isKindOfClass:[MendeleyLicenceInfo class]]);
            XCTAssertNotNil(((MendeleyLicenceInfo *)parsedElement).object_ID);
        }

        MendeleyLicenceInfo *firstLincenceInfo = [parsedObject firstObject];
        XCTAssertEqualObjects(firstLincenceInfo.object_ID, @"02c4e271-e833-4ed1-856d-f4085d84e0d3");
        XCTAssertEqualObjects(firstLincenceInfo.short_name, @"CC0 1.0");
        XCTAssertEqualObjects(firstLincenceInfo.full_name, @"Public Domain Dedication");
        XCTAssertEqualObjects(firstLincenceInfo.objectDescription, @"You can copy, modify, distribute and perform the work, even for commercial purposes, all without asking permission.");
        XCTAssertEqualObjects(firstLincenceInfo.url, @"http://creativecommons.org/publicdomain/zero/1.0/");
    }];
}

- (void)testParseFileContentsObject
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *jsonArrayPath = [bundle pathForResource:@"file_contents" ofType:@"json"];
    NSData *jsonArrayData = [NSData dataWithContentsOfFile:jsonArrayPath];
    XCTAssertTrue(jsonArrayData);

    NSError *parseError = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonArrayData options:NSJSONReadingAllowFragments error:&parseError];
    XCTAssertNotNil(jsonObject, @"we expected the JSON data to be parsed without error (error: %@)", parseError);

    MendeleyModeller *modeller = [MendeleyModeller sharedInstance];
    [modeller parseJSONData:jsonObject expectedType:kMendeleyModelContentTicket completionBlock:^(id parsedObject, NSError *error) {
        XCTAssertNotNil(parsedObject, @"We expected the parsing to return without error (error: %@)", error);

        XCTAssertTrue([parsedObject isKindOfClass:[MendeleyContentTicket class]]);
        XCTAssertEqualObjects(((MendeleyContentTicket *)parsedObject).object_ID, @"r39wcjmm2m");
    }];
}

- (void)testSerializationForNewDataset {
    MendeleyFileMetadata *fileMetadata = [[MendeleyFileMetadata alloc] init];
    fileMetadata.filename = @"test.pdf";

    MendeleyFileData *fileData = [[MendeleyFileData alloc] init];
    fileData.object_ID = @"#123#";
    fileMetadata.content_details = fileData;

    MendeleyDataset *dataset = [[MendeleyDataset alloc] init];
    dataset.name = @"Name";
    dataset.objectDescription = @"Test Desc";
    dataset.files = @[fileMetadata];

    MendeleyModeller *modeller = [MendeleyModeller sharedInstance];
    NSError *error = nil;
    NSDictionary *datasetDictionary = [modeller dictionaryFromModel:dataset error:&error];

    XCTAssertNotNil(datasetDictionary);
    XCTAssertNil(error);

    XCTAssertEqualObjects(datasetDictionary[kMendeleyJSONName], @"Name");
    XCTAssertEqualObjects(datasetDictionary[kMendeleyJSONDescription], @"Test Desc");

    NSArray *expectedFiles = @[@{@"filename": @"test.pdf", kMendeleyJSONContentDetails: @{kMendeleyJSONID: @"#123#"}}];
    XCTAssertEqualObjects(datasetDictionary[kMendeleyJSONFiles], expectedFiles);
}

@end
