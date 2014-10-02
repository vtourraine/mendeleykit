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

#import <Foundation/Foundation.h>

typedef NS_ENUM (int, MendeleyPerformanceMeterConfiguration)
{
    kMendeleyPerformanceMeterConfigurationDeactivated = 0,
    kMendeleyPerformanceMeterConfigurationConsoleOnly,
    kMendeleyPerformanceMeterConfigurationConsoleAndDiskReport
};


@interface MendeleyPerformanceMeter : NSObject

@property (nonatomic, assign) MendeleyPerformanceMeterConfiguration configuration;

+ (MendeleyPerformanceMeter *)sharedMeter;

- (NSString *)createSimpleTimerWithName:(NSString *)timerName;
- (void)startSimpleTimerWithID:(NSString *)timerID;
- (NSString *)stopAndSaveSimpleTimerWithID:(NSString *)timerID;

- (NSString *)createNewSessionWithName:(NSString *)sessionName;
- (NSString *)addTimerWithName:(NSString *)timerName ToSession:(NSString *)sessionID;
- (void)startTimerWithID:(NSString *)timerID inSession:(NSString *)sessionID;
- (void)stopTimerWithID:(NSString *)timerID inSession:(NSString *)sessionID;
- (NSString *)saveReportAndFinalizeSession:(NSString *)sessionID;

- (void)cleanUpPerformancesReportFiles;

@end