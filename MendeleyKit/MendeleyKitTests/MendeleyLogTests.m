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

#import "MendeleyKitTestBaseClass.h"
#import "MendeleyLog.h"
#include <stdlib.h>

@interface MendeleyLogTests : MendeleyKitTestBaseClass

@end

@implementation MendeleyLogTests

- (void)tearDown
{
    [super tearDown];
}

- (void)setUp
{
    [super setUp];
}

- (void)testActivityLog
{
    NSArray *logsArrayBefore = [[MendeleyLog sharedInstance] temporaryLogQueue];
    NSUInteger logCountBeforeTest = [logsArrayBefore count];

    MendeleyLogMessage(kMendeleyLogDomain, kSDKLogLevelInfo, @"Activity Log Test");

    // logs are saved asynchronously, so we need to wait to make sure this call gets registered
    XCTestExpectation *expectation = [self expectationWithDescription:@"Record log"];

    // we wait for 0.1 second before we check the log queue
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *logsArrayAfter = [[MendeleyLog sharedInstance] temporaryLogQueue];
        NSUInteger logCountAfterTest = [logsArrayAfter count];
        const BOOL logCountHasChanged = (logCountBeforeTest < logCountAfterTest) || (logCountBeforeTest == 1000);
        if (logCountHasChanged)
        {
            [expectation fulfill];
        }
        else
        {
            XCTAssertTrue(logCountHasChanged, @"Log not recorded. Log count before test is %@ and after test is %@", @(logCountBeforeTest), @(logCountAfterTest));
        }
    });

    // we tell the test framework to wait for 1 second for the expectation to be fulfilled
    [self waitForExpectationsWithTimeout:1 handler:nil];
}

- (void)testLogError
{
    NSArray *logsArrayBefore = [[MendeleyLog sharedInstance] temporaryLogQueue];
    NSUInteger logCountBeforeTest = [logsArrayBefore count];

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"fileThatNotExistsAtAll.txt"];
    NSError *error;

    [self fooFromPath:path error:&error];
    MendeleyLogMessageWithError(kMendeleyLogDomain, error);

    BOOL updated = NO;
    while (!updated)
    {
        NSArray *logsArrayAfter = [[MendeleyLog sharedInstance] temporaryLogQueue];
        NSUInteger logCountAfterTest = [logsArrayAfter count];
        if ((logCountBeforeTest < logCountAfterTest) || (logCountBeforeTest == 1000))
        {
            updated = YES;
        }
    }

    NSArray *logsArray = [[MendeleyLog sharedInstance] temporaryLogQueue];
    XCTAssertTrue([(NSString *) [[logsArray lastObject] objectForKey:@"level"] isEqualToString: @"ERROR"], @"Direct NSError Log not recorded, last object is: %@", [logsArray lastObject]);
}

- (void)testActivityLogExport
{
    NSURL *fileURL = [[MendeleyLog sharedInstance] createFormattedActivityLogFileAndExportURL];

    XCTAssertTrue(fileURL != nil, @"Exported Log File empty path");
    NSDictionary *plist = [NSMutableDictionary dictionaryWithContentsOfURL:fileURL];
    XCTAssertTrue(plist != nil || ![plist isKindOfClass:[NSDictionary class]], @"Exported Log File not successiful");
    XCTAssertTrue([plist objectForKey:@"summary"], @"Exported Log File has not summary");
    [[MendeleyLog sharedInstance] cleanExportedLogFile];
}

- (void)testActivityLogLimit
{
    for (int i = 0; i < 1100; i++)
    {
        MendeleyLogMessage(kMendeleyLogDomain, arc4random() % 4, @"%i", i);
    }

    // test limit and order on memory
    NSArray *logsArray = [[MendeleyLog sharedInstance] temporaryLogQueue];
    XCTAssertTrue(!([logsArray count] > 1000), @"Memory Flow Array size exceed the limit. Should be 1000 but is %lu", (unsigned long) logsArray.count);
    NSString *lastObjectMessage = [[logsArray lastObject] objectForKey:@"message"];
    BOOL isRightEndMessage = [lastObjectMessage isEqualToString:@"1099"] || [lastObjectMessage isEqualToString:@"1098"];
    XCTAssertTrue(isRightEndMessage, @"Last Log Inserted in Memory Flow Array is not last flow object. last message is %@", lastObjectMessage);

    // test limit and order on disk
    NSURL *fileURL = [[MendeleyLog sharedInstance] createFormattedActivityLogFileAndExportURL];
    NSDictionary *plist = [NSMutableDictionary dictionaryWithContentsOfURL:fileURL];
    XCTAssertTrue(!([[plist objectForKey:@"flow"] count] > 1000), @"Disk Flow Array size exceed the limit");
    NSString *lastObjectMessageOnDisk = [[(NSArray *) [plist objectForKey:@"flow"] lastObject] objectForKey:@"message"];
    XCTAssertTrue([lastObjectMessageOnDisk isEqualToString:@"1099"], @"Last Object written to disk '%@' is not last flow object", lastObjectMessageOnDisk);
    [[MendeleyLog sharedInstance] cleanExportedLogFile];
}

- (NSString *)fooFromPath:(NSString *)path error:(NSError **)anError
{
    const char *fileRep = [path fileSystemRepresentation];
    int fd = open(fileRep, O_RDWR | O_NONBLOCK, 0);

    if (fd == -1)
    {
        if (anError != NULL)
        {
            NSString *description;
            int errCode = 0;

            if (errno == ENOENT)
            {
                description = @"No file or directory at requested location";
                errCode = 1;
            }
            else if (errno == EIO)
            {
                // Continue for each possible POSIX error...
            }

            // Create the underlying error.
            NSError *underlyingError = [[NSError alloc] initWithDomain:NSPOSIXErrorDomain
                                                                  code:errno userInfo:nil];
            // Create and return the custom domain error.
            NSDictionary *errorDictionary = @{ NSLocalizedDescriptionKey : description,
                                               NSUnderlyingErrorKey : underlyingError, NSFilePathErrorKey : path };

            *anError = [[NSError alloc] initWithDomain:@"Foo Error Domain"
                                                  code:errCode userInfo:errorDictionary];
        }
        return nil;
    }
    return nil;
}

@end
