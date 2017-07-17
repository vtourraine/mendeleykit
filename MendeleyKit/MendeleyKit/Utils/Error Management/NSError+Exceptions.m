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

#import "NSError+Exceptions.h"

@implementation NSError (Exceptions)

+ (void)assertArgumentNotNil:(id)argument argumentName:(NSString *)argumentName
{
    if (nil == argument)
    {
        NSString *message = [NSString stringWithFormat:@"%@ must not be nil", argumentName];
#ifdef DEBUG
        NSException *exception = [NSException exceptionWithName:NSInvalidArgumentException reason:message userInfo:nil];
        @throw exception;
#else
        NSLog(@"%s: %@", __PRETTY_FUNCTION__, message);
#endif
    }
}

+ (void)assertStringArgumentNotNilOrEmpty:(NSString *)argument argumentName:(NSString *)argumentName
{
    NSString *message = nil;
    
    if (nil == argument)
    {
        message = [NSString stringWithFormat:@"%@ must not be nil", argumentName];
    }
    else if ([argument isEqualToString:@""])
    {
        message = [NSString stringWithFormat:@"%@ must not be empty", argumentName];
    }
    
    if (message)
    {
#ifdef DEBUG
        NSException *exception = [NSException exceptionWithName:NSInvalidArgumentException reason:message userInfo:nil];
        @throw exception;
#else
        NSLog(@"%s: %@", __PRETTY_FUNCTION__, message);
#endif
    }
}

+ (void)assertURLArgumentNotNilOrMissing:(NSURL *)argument argumentName:(NSString *)argumentName
{
    NSString *message = nil;
    
    if (nil == argument)
    {
        message = [NSString stringWithFormat:@"%@ must not be nil", argumentName];
    }
    else if (![[NSFileManager defaultManager] fileExistsAtPath:argument.path])
    {
        message = [NSString stringWithFormat:@"%@ not found", argumentName];
    }
    
    if (message)
    {
#ifdef DEBUG
        NSException *exception = [NSException exceptionWithName:NSInvalidArgumentException reason:message userInfo:nil];
        @throw exception;
#else
        NSLog(@"%s: %@", __PRETTY_FUNCTION__, message);
#endif
    }
}

@end
