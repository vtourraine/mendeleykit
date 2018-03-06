/*
 ******************************************************************************
 * Copyright (C) 2014-2017 Elsevier/Mendeley.
 *
 * This file is part of the Mendeley OS X SDK.
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

#import <Cocoa/Cocoa.h>

/**
 Note: the defines below must NEVER be checked into the mendeley github
 repository.
 Any pull requests containing any real values for the defines below will be rejected
 and/or removed
 */
#define kMyClientSecret      @"42FJEXdZ8q4wbQJnMpw7"
#define kMyClientID          @"7"
#define kMyClientRedirectURI @"http://localhost/auth_return"

@class MendeleyDocument;


@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (nonatomic, strong) NSArray <MendeleyDocument *> *documents;

- (IBAction)signOut:(id)sender;

@end
