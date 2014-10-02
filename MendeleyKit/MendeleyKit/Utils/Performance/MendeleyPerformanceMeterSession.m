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

#import "MendeleyPerformanceMeterSession.h"


@interface MendeleyPerformanceMeterSession ()

@property (nonatomic, strong) NSMutableDictionary *onGoingTimers;
@property (nonatomic, strong) NSMutableArray *sessionResults;

@end

@implementation MendeleyPerformanceMeterSession

- (instancetype)initWithName:(NSString *)name
{
    self = [super init];
    if (self)
    {
        _sessionID = [[NSUUID UUID] UUIDString];

        if (name)
        {
            _name = name;
        }
        else
        {
            _name = @"no name";
        }
        _onGoingTimers = [NSMutableDictionary dictionary];
        _sessionResults = [NSMutableArray array];

    }
    return self;
}

+ (MendeleyPerformanceMeterSession *)sessionWithName:(NSString *)sessionName
{
    MendeleyPerformanceMeterSession *pms = [[MendeleyPerformanceMeterSession alloc] initWithName:sessionName];

    return pms;
}

- (NSString *)createTimerWithName:(NSString *)timerName
{
    MendeleyTimer *aTimer = [MendeleyTimer timerWithName:timerName];

    [_onGoingTimers addEntriesFromDictionary:@{ aTimer.timerID: aTimer }];
    return aTimer.timerID;
}

- (void)startTimerWithID:(NSString *)timerID
{
    if (_onGoingTimers[timerID])
    {
        [(MendeleyTimer *) _onGoingTimers[timerID] start];
    }
    else
    {
        MendeleyLogMessage(kMendeleyPerformanceDomain, kSDKLogLevelError, @"No timer with ID %@ found", timerID);
    }
}

- (void)stopTimerWithID:(NSString *)timerID
{
    if (_onGoingTimers[timerID])
    {
        [(MendeleyTimer *) _onGoingTimers[timerID] stop];
        [_sessionResults addObject:[self createReportWithTimer:_onGoingTimers[timerID]]];
        [_onGoingTimers removeObjectForKey:timerID];
    }
    else
    {
        MendeleyLogMessage(kMendeleyPerformanceDomain, kSDKLogLevelError, @"No timer with ID %@ found", timerID);
    }
}

- (NSDictionary *)createReportWithTimer:(MendeleyTimer *)aTimer
{
    if (aTimer.nsElapsed == 0)
    {
        MendeleyLogMessage(kMendeleyPerformanceDomain, kSDKLogLevelWarning, @"Timer: %@ not started or not stopped yet", aTimer.name);
    }
    NSDictionary *thisTimerResults = @{ kMendeleyPerformanceReportFileKeyTimerTitle: aTimer.name,
                                        kMendeleyPerformanceReportFileKeyTimerID:aTimer.timerID,
                                        kMendeleyPerformanceReportFileKeyTimerStartTime: aTimer.absoluteStartTime,
                                        kMendeleyPerformanceReportFileKeyTimerElapsedTime: [NSNumber numberWithLongLong:aTimer.nsElapsed] };
    return thisTimerResults;
}

- (NSDictionary *)reportWithTimerID:(NSString *)timerID
{
    NSUInteger resultIndex = [_sessionResults indexOfObjectPassingTest: ^BOOL (id obj, NSUInteger idx, BOOL *stop) {
                                  NSDictionary *result = (NSDictionary *) obj;
                                  if ([result[kMendeleyPerformanceReportFileKeyTimerID] isEqualToString:timerID])
                                  {
                                      *stop = YES;
                                      return YES;
                                  }
                                  return NO;
                              }];

    NSDictionary *results = nil;

    if (resultIndex != NSNotFound)
    {
        results = [_sessionResults objectAtIndex:resultIndex];
    }

    if (results)
    {
        return results;
    }
    else
    {
        if (_onGoingTimers[timerID])
        {
            [(MendeleyTimer *) _onGoingTimers[timerID] invalidate];
            return [self createReportWithTimer:_onGoingTimers[timerID]];
        }
        else
        {
            MendeleyLogMessage(kMendeleyPerformanceDomain, kSDKLogLevelError, @"No timer with ID %@ found", timerID);
            return nil;
        }
    }
}

- (NSDictionary *)sessionReport
{
    UInt64 totalTimeElapsed = 0;

    for (NSDictionary *aStopWatchResults in _sessionResults)
    {
        totalTimeElapsed += [aStopWatchResults[kMendeleyPerformanceReportFileKeyTimerElapsedTime] unsignedLongLongValue];
    }
    NSDictionary *results = @{ kMendeleyPerformanceReportFileKeySessionTitle : _name,
                               kMendeleyPerformanceReportFileKeySessionID : _sessionID,
                               kMendeleyPerformanceReportFileKeySessionTotalTime: [NSNumber numberWithLongLong:totalTimeElapsed],
                               kMendeleyPerformanceReportFileKeySessionJobList: _sessionResults };
    MendeleyLogMessage(kMendeleyPerformanceDomain, kSDKLogLevelInfo, @"Report created for session: %@ \n %@", _name, results);
    return results;
}

- (NSDictionary *)finishSessionAndGetResults
{
    for (NSString *aTimerID in[_onGoingTimers allKeys])
    {
        [(MendeleyTimer *) _onGoingTimers[aTimerID] invalidate];
    }
    [_onGoingTimers removeAllObjects];

    return [self sessionReport];
}

@end
