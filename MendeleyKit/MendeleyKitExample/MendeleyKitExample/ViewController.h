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

#import <UIKit/UIKit.h>

/**
 Note: the defines below must NEVER be checked into the mendeley github
 repository.
 Any pull requests containing any real values for the defines below will be rejected
 and/or removed
 */
#define kMyClientSecret      @"<YOUR CLIENT SECRET>"
#define kMyClientID          @"<YOUR CLIENT ID>"
#define kMyClientRedirectURI @"<YOUR REDIRECT URI>"


@interface ViewController : UITableViewController
/**
 @name ViewController
 This is the entry point to the MendeleyKitExample app.
 It allows the following actions
 - login/logout
 - get documents (no check if attached files)
 - get documents (with check if attached files)
 - get groups (with automatic icon download)
 - get groups (with lazy loading of icons)
 */
@property (nonatomic, weak) IBOutlet UIBarButtonItem *loginButton;
- (IBAction)loginOrOut:(id)sender;
@end
