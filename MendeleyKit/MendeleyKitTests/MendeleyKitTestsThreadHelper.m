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

#import "MendeleyKitTestsThreadHelper.h"

void waitForBlock(testBlock testBlockIn)
{
    @autoreleasepool {
        testBlock block = [testBlockIn copy];

        __strong NSDate *timeoutDate = [NSDate dateWithTimeIntervalSinceNow:20000];

        NSTimeInterval timeoutTime = [timeoutDate timeIntervalSinceReferenceDate];
        NSTimeInterval currentTime;

        __block BOOL hasCalledBack = NO;

        block(&hasCalledBack);

        for (currentTime = [NSDate timeIntervalSinceReferenceDate];
             hasCalledBack == NO && currentTime < timeoutTime;
             currentTime = [NSDate timeIntervalSinceReferenceDate])
        {
            __strong NSDate *runTime = [NSDate dateWithTimeIntervalSinceNow:0.1];
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                     beforeDate:runTime];
        }
    }
}


