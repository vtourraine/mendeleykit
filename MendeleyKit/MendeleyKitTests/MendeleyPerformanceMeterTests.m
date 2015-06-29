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

#import "MendeleyGlobals.h"
#import "MendeleyPerformanceMeter.h"
#import "MendeleyTimer.h"

#define kTimerTestDuration 1.0

@interface MendeleyPerformanceMeter (CHANGE_VISIBILITY_FOR_TEST)

- (NSDictionary *)reportForTimerWithID:(NSString *)timerID;
- (NSDictionary *)reportForTimerWithID:(NSString *)timerID inSession:(NSString *)sessionID;
- (NSString *)getPerformanceFilesPath;

@end

@interface MendeleyPerformanceMeterTests : MendeleyKitTestBaseClass

@end

@implementation MendeleyPerformanceMeterTests

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

- (void)testStopWatch
{
    MendeleyTimer *aStopWatch = [MendeleyTimer timerWithName:[NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__]];

    [aStopWatch start];
    [NSThread sleepForTimeInterval:kTimerTestDuration];
    [aStopWatch stop];

    UInt64 nsTime = [aStopWatch nsElapsed];

    XCTAssertTrue(nsTime >= kTimerTestDuration * 1000, @"The time misured (%llu ns) is less then the time spent in the test activity (%f ns)", nsTime, kTimerTestDuration * 1000 * 1000);
}

- (void)testPerformanceMeterWithAStopWatch
{
    [[MendeleyPerformanceMeter sharedMeter] setConfiguration:kMendeleyPerformanceMeterConfigurationConsoleAndDiskReport];

    NSString *aStopWatchID = [[MendeleyPerformanceMeter sharedMeter] createSimpleTimerWithName:[NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__]];

    if (aStopWatchID)
    {
        [[MendeleyPerformanceMeter sharedMeter] startSimpleTimerWithID:aStopWatchID];
        [NSThread sleepForTimeInterval:kTimerTestDuration];
        NSString *reportFilePath =  [[MendeleyPerformanceMeter sharedMeter] stopAndSaveSimpleTimerWithID:aStopWatchID];


        if (reportFilePath)
        {
            [NSThread sleepForTimeInterval:kTimerTestDuration];

            NSDictionary *result = [NSMutableDictionary dictionaryWithContentsOfURL:[NSURL fileURLWithPath:reportFilePath]];

            if (result)
            {
                UInt64 elapsedTimeValue = [result[kMendeleyPerformanceReportFileKeyTimerElapsedTime] unsignedLongLongValue];

                XCTAssertTrue(elapsedTimeValue >= kTimerTestDuration * 1000, @"The time misured (%llu ns) is less then the time spent in the test activity (%f ns)", elapsedTimeValue, kTimerTestDuration * 1000 * 1000);
            }
            else
            {
                XCTFail(@"Unable to read report from disk");
            }

        }
        else
        {
            XCTFail(@"Unable to create a report");
        }
    }
    else
    {
        XCTFail(@"Unable to create a simple timer");
    }

    NSString *anotherStopWatchID = [[MendeleyPerformanceMeter sharedMeter] createSimpleTimerWithName:nil];
    XCTAssertTrue(anotherStopWatchID != nil, @"Unable to create a timer without name");
    [[MendeleyPerformanceMeter sharedMeter] cleanUpPerformancesReportFiles];
}

- (void)testPerformanceMeterSessionAndFileExportAndCleanUp
{
    [[MendeleyPerformanceMeter sharedMeter] setConfiguration:kMendeleyPerformanceMeterConfigurationConsoleAndDiskReport];
    NSString *sessionID = [[MendeleyPerformanceMeter sharedMeter] createNewSessionWithName:[NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__]];

    if (sessionID)
    {
        NSMutableArray *timersID = [NSMutableArray array];

        for (int i = 0; i < 5; i++)
        {
            NSString *aStopWatchID = [[MendeleyPerformanceMeter sharedMeter] addTimerWithName:[NSString stringWithFormat:@"Test timer no. %i", i]
                                                                                    ToSession:sessionID];
            if (aStopWatchID)
            {
                [timersID addObject:aStopWatchID];
                [[MendeleyPerformanceMeter sharedMeter] startTimerWithID:aStopWatchID
                                                               inSession:sessionID];
            }
            else
            {
                XCTFail(@"Unable to create a timer in session");
            }
        }

        [NSThread sleepForTimeInterval:kTimerTestDuration];

        for (NSString *timerID in timersID)
        {
            [[MendeleyPerformanceMeter sharedMeter] stopTimerWithID:timerID
                                                          inSession:sessionID];
        }

        NSString *anotherStopWatchID = [[MendeleyPerformanceMeter sharedMeter] addTimerWithName:[NSString stringWithFormat:@"Test timer not stopped"]
                                                                                      ToSession:sessionID];
        if (anotherStopWatchID)
        {
            [timersID addObject:anotherStopWatchID];
            [[MendeleyPerformanceMeter sharedMeter] startTimerWithID:anotherStopWatchID
                                                           inSession:sessionID];
        }
        else
        {
            XCTFail(@"Unable to create a timer in session");
        }

        NSString *reportFilePath = [[MendeleyPerformanceMeter sharedMeter] saveReportAndFinalizeSession:sessionID];


        if (reportFilePath)
        {
            [NSThread sleepForTimeInterval:kTimerTestDuration];

            NSDictionary *reportDict = [NSMutableDictionary dictionaryWithContentsOfURL:[NSURL fileURLWithPath:reportFilePath]];
            if (reportDict)
            {
                NSString *sessionIDRead = reportDict[kMendeleyPerformanceReportFileKeySessionID];
                XCTAssertTrue([sessionIDRead isEqualToString:sessionID], @"The session read (%@) isn't the session just executed (%@)", sessionIDRead, sessionID);
                UInt64 elapsedTimeValue = [reportDict[kMendeleyPerformanceReportFileKeySessionTotalTime] unsignedLongLongValue];
                XCTAssertTrue(elapsedTimeValue > kTimerTestDuration,  @"The time misured (%llu ns) is less then the time spent in the test activity (%f ns)", elapsedTimeValue, kTimerTestDuration * 1000 * 1000);
            }
            else
            {
                XCTFail(@"Unable to read report from disk");
            }
        }
        else
        {
            XCTFail(@"Unable to create a report");
        }
    }
    else
    {
        XCTFail(@"Unable to create a perfomance session");
    }

    [[MendeleyPerformanceMeter sharedMeter] cleanUpPerformancesReportFiles];

    NSString *folderPath = [[MendeleyPerformanceMeter sharedMeter] getPerformanceFilesPath];
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:folderPath
                                                                         error:nil];
    NSMutableString *fileName = [NSMutableString stringWithString:kMendeleyPerformanceReportFileNamePrefix];

    [fileName replaceOccurrencesOfString:@" " withString:@"_"
                                 options:NSCaseInsensitiveSearch
                                   range:NSMakeRange(0, [fileName length])];

    NSArray *filesWithSelectedPrefix = [files filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self BEGINSWITH[cd] %@", fileName]];

    XCTAssertTrue([filesWithSelectedPrefix count] == 0,  @"Performance Report File(s) not deleted!");
}

- (void)testPerformanceMeterSessionTimersNotStopped
{
    [[MendeleyPerformanceMeter sharedMeter] setConfiguration:kMendeleyPerformanceMeterConfigurationConsoleAndDiskReport];
    NSString *sessionID = [[MendeleyPerformanceMeter sharedMeter] createNewSessionWithName:[NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__]];

    if (sessionID)
    {
        NSMutableArray *timersID = [NSMutableArray array];

        for (int i = 0; i < 5; i++)
        {
            NSString *aStopWatchID = [[MendeleyPerformanceMeter sharedMeter] addTimerWithName:[NSString stringWithFormat:@"Test timer no. %i", i]
                                                                                    ToSession:sessionID];
            if (aStopWatchID)
            {
                [timersID addObject:aStopWatchID];
                [[MendeleyPerformanceMeter sharedMeter] startTimerWithID:aStopWatchID
                                                               inSession:sessionID];
            }
            else
            {
                XCTFail(@"Unable to create a timer in session");
            }
        }
        [NSThread sleepForTimeInterval:kTimerTestDuration];

        NSString *reportFilePath = [[MendeleyPerformanceMeter sharedMeter] saveReportAndFinalizeSession:sessionID];

        if (reportFilePath)
        {
            [NSThread sleepForTimeInterval:kTimerTestDuration];

            NSDictionary *reportDict = [NSMutableDictionary dictionaryWithContentsOfURL:[NSURL fileURLWithPath:reportFilePath]];
            if (reportDict)
            {
                NSString *sessionIDRead = reportDict[kMendeleyPerformanceReportFileKeySessionID];
                XCTAssertTrue([sessionIDRead isEqualToString:sessionID], @"The session read (%@) isn't the session just executed (%@)", sessionIDRead, sessionID);
                UInt64 elapsedTimeValue = [reportDict[kMendeleyPerformanceReportFileKeySessionTotalTime] unsignedLongLongValue];
                XCTAssertTrue(elapsedTimeValue == 0,  @"The time misured (%llu ns) is more then the time expected (0 ns): no one of the timer where stopped and they are all invalidated", elapsedTimeValue);
            }
            else
            {
                XCTFail(@"Unable to read report from disk");
            }
        }
        else
        {
            XCTFail(@"Unable to create a report");
        }
    }

    else
    {
        XCTFail(@"Unable to create a perfomance session");
    }

    [[MendeleyPerformanceMeter sharedMeter] cleanUpPerformancesReportFiles];
}

- (void)testWrongTimerID
{
    [[MendeleyPerformanceMeter sharedMeter] setConfiguration:kMendeleyPerformanceMeterConfigurationConsoleAndDiskReport];
    NSString *aStopWatchID = [[MendeleyPerformanceMeter sharedMeter] createSimpleTimerWithName:[NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__]];

    if (aStopWatchID)
    {
        [[MendeleyPerformanceMeter sharedMeter] startSimpleTimerWithID:[[NSUUID UUID] UUIDString]];
        [NSThread sleepForTimeInterval:kTimerTestDuration];
        NSString *reportFilePath =  [[MendeleyPerformanceMeter sharedMeter] stopAndSaveSimpleTimerWithID:[[NSUUID UUID] UUIDString]];
        if (reportFilePath)
        {
            [NSThread sleepForTimeInterval:kTimerTestDuration];

            NSDictionary *result = [NSMutableDictionary dictionaryWithContentsOfURL:[NSURL fileURLWithPath:reportFilePath]];

            XCTAssertTrue(result == nil, @"As a wrong timer ID was called we have to receive an empty result file");
        }
        else
        {
            XCTFail(@"Unable to create a report");
        }

    }
    else
    {
        XCTFail(@"Unable to create a simple timer");
    }

    [[MendeleyPerformanceMeter sharedMeter] cleanUpPerformancesReportFiles];
}

- (void)testPerformanceMeterWrongSessionID
{
    [[MendeleyPerformanceMeter sharedMeter] setConfiguration:kMendeleyPerformanceMeterConfigurationConsoleAndDiskReport];
    NSString *sessionID = [[MendeleyPerformanceMeter sharedMeter] createNewSessionWithName:[NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__]];

    if (sessionID)
    {
        [[MendeleyPerformanceMeter sharedMeter] startTimerWithID:[[NSUUID UUID] UUIDString]
                                                       inSession:[[NSUUID UUID] UUIDString]];

        [[MendeleyPerformanceMeter sharedMeter] stopTimerWithID:[[NSUUID UUID] UUIDString]
                                                      inSession:[[NSUUID UUID] UUIDString]];

        [[MendeleyPerformanceMeter sharedMeter] reportForTimerWithID:[[NSUUID UUID] UUIDString]
                                                           inSession:[[NSUUID UUID] UUIDString]];

        NSString *reportFilePath = [[MendeleyPerformanceMeter sharedMeter] saveReportAndFinalizeSession:[[NSUUID UUID] UUIDString]];

        [NSThread sleepForTimeInterval:kTimerTestDuration];

        NSDictionary *reportDict = nil;

        if (reportFilePath != nil)
        {
            reportDict = [NSMutableDictionary dictionaryWithContentsOfURL:[NSURL fileURLWithPath:reportFilePath]];
        }
        XCTAssertTrue(reportDict == nil, @"As a wrong session ID was called we have to receive an empty result file");
    }
    else
    {
        XCTFail(@"Unable to create a perfomance session");
    }
    [[MendeleyPerformanceMeter sharedMeter] cleanUpPerformancesReportFiles];
}

- (void)testDeactivatedPerformanceTool
{
    [[MendeleyPerformanceMeter sharedMeter] setConfiguration:kMendeleyPerformanceMeterConfigurationDeactivated];
    NSString *sessionID = [[MendeleyPerformanceMeter sharedMeter] createNewSessionWithName:[NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__]];
    XCTAssertTrue(sessionID == nil, @"As the configuration is set to deactivated we have to receive a nil sessionID");
    NSString *aStopWatchID = [[MendeleyPerformanceMeter sharedMeter] createSimpleTimerWithName:[NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__]];
    XCTAssertTrue(aStopWatchID == nil, @"As the configuration is set to deactivated we have to receive a nil timerID");
}

- (void)testDiskOnlyPerformanceTool
{
    [[MendeleyPerformanceMeter sharedMeter] setConfiguration:kMendeleyPerformanceMeterConfigurationConsoleOnly];
    [[MendeleyPerformanceMeter sharedMeter] cleanUpPerformancesReportFiles];

    NSString *aStopWatchID = [[MendeleyPerformanceMeter sharedMeter] createSimpleTimerWithName:[NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__]];

    if (aStopWatchID)
    {
        [[MendeleyPerformanceMeter sharedMeter] startSimpleTimerWithID:aStopWatchID];
        [NSThread sleepForTimeInterval:kTimerTestDuration];
        NSString *reportFilePath =  [[MendeleyPerformanceMeter sharedMeter] stopAndSaveSimpleTimerWithID:aStopWatchID];

        XCTAssertTrue(reportFilePath == nil, @"The report file has generated altought we setted the configuration to print only in console");
    }
    else
    {
        XCTFail(@"Unable to create a simple timer");
    }

    NSString *sessionID = [[MendeleyPerformanceMeter sharedMeter] createNewSessionWithName:[NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__]];

    if (sessionID)
    {
        NSMutableArray *timersID = [NSMutableArray array];

        for (int i = 0; i < 5; i++)
        {
            NSString *aStopWatchID = [[MendeleyPerformanceMeter sharedMeter] addTimerWithName:[NSString stringWithFormat:@"Test timer no. %i", i]
                                                                                    ToSession:sessionID];
            if (aStopWatchID)
            {
                [timersID addObject:aStopWatchID];
                [[MendeleyPerformanceMeter sharedMeter] startTimerWithID:aStopWatchID
                                                               inSession:sessionID];
            }
            else
            {
                XCTFail(@"Unable to create a timer in session");
            }
        }

        [NSThread sleepForTimeInterval:kTimerTestDuration];

        for (NSString *timerID in timersID)
        {
            [[MendeleyPerformanceMeter sharedMeter] stopTimerWithID:timerID
                                                          inSession:sessionID];
        }

        NSString *reportFilePath = [[MendeleyPerformanceMeter sharedMeter] saveReportAndFinalizeSession:sessionID];


        XCTAssertTrue(reportFilePath == nil, @"The report file has generated altought we setted the configuration to print only in console");
    }
    else
    {
        XCTFail(@"Unable to create a perfomance session");
    }


    NSString *folderPath = [[MendeleyPerformanceMeter sharedMeter] getPerformanceFilesPath];
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:folderPath
                                                                         error:nil];
    NSMutableString *fileName = [NSMutableString stringWithString:kMendeleyPerformanceReportFileNamePrefix];

    [fileName replaceOccurrencesOfString:@" " withString:@"_"
                                 options:NSCaseInsensitiveSearch
                                   range:NSMakeRange(0, [fileName length])];

    NSArray *filesWithSelectedPrefix = [files filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self BEGINSWITH[cd] %@", fileName]];

    XCTAssertTrue([filesWithSelectedPrefix count] == 0,  @"Performance Report File(s) created altought we setted the configuration to print only in console!");
}


@end
