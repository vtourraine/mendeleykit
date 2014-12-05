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

#import "AppDelegate.h"

#import <MendeleyGlobals.h>
#import <MendeleyKit.h>
#import <MendeleyKitConfiguration.h>
#import <MendeleySyncInfo.h>
#import <MendeleyNSURLConnectionProvider.h>

#import "MendeleyLoginWindowController.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;

@property (strong) MendeleyLoginWindowController *loginController;

- (void)showLoginView;

- (void)refreshDocuments;

- (void)pageThroughDocuments:(MendeleySyncInfo *)syncInfo
                   documents:(NSArray *)documents;

- (void)sheetDidEnd:(NSWindow *)sheet
         returnCode:(NSInteger)returnCode
        contextInfo:(void *)contextInfo;

@end


@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [[MendeleyKitConfiguration sharedInstance] configureOAuthWithParameters:
     @{ kMendeleyOAuth2ClientIDKey:     kMyClientID,
        kMendeleyOAuth2ClientSecretKey: kMyClientSecret,
        kMendeleyOAuth2RedirectURLKey:  kMyClientRedirectURI }];

    NSDictionary *networkProviderParameters = @{kMendeleyNetworkProviderKey: NSStringFromClass([MendeleyNSURLConnectionProvider class])};
    [[MendeleyKitConfiguration sharedInstance] changeConfigurationWithParameters:networkProviderParameters];

    if ([[MendeleyKit sharedInstance] isAuthenticated]) {
        [self refreshDocuments];
    }
    else {
        [self showLoginView];
    }
}

- (void)showLoginView {
    if (!self.loginController) {
        self.loginController = [[MendeleyLoginWindowController alloc]
                                initWithClientKey:kMyClientID
                                clientSecret:kMyClientSecret
                                redirectURI:kMyClientRedirectURI
                                completionBlock:^(BOOL success, NSError *error) {
                                    [NSApp endSheet:self.loginController.window];
                                    self.loginController = nil;

                                    [self refreshDocuments];
                                }];
    }

    [NSApp beginSheet:self.loginController.window
       modalForWindow:self.window
        modalDelegate:self
       didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:)
          contextInfo:nil];
}


#pragma mark - Refresh data

- (void)refreshDocuments {
    [[MendeleyKit sharedInstance] documentListWithQueryParameters:nil completionBlock:^(NSArray *objectArray, MendeleySyncInfo *syncInfo, NSError *error) {
        if (!objectArray) {
            [NSAlert alertWithError:error];
        }
        else {
            [self pageThroughDocuments:syncInfo documents:objectArray];
        }
    }];
}

- (void)pageThroughDocuments:(MendeleySyncInfo *)syncInfo documents:(NSArray *)documents {
    NSURL *next = [syncInfo.linkDictionary objectForKey:kMendeleyRESTHTTPLinkNext];

    if (!next) {
        self.documents = documents;
        return;
    }

    [[MendeleyKit sharedInstance] documentListWithLinkedURL:next completionBlock:^(NSArray *objectArray, MendeleySyncInfo *updatedSyncInfo, NSError *error) {
        if (nil == objectArray) {
            [NSAlert alertWithError:error];
            self.documents = documents;
        }
        else {
            NSMutableArray *array = [NSMutableArray arrayWithArray:documents];
            [array addObjectsFromArray:objectArray];
            [self pageThroughDocuments:updatedSyncInfo documents:array];
        }
    }];
}


#pragma mark - Actions

- (IBAction)signOut:(id)sender {
    self.documents = @[];
    [[MendeleyKit sharedInstance] clearAuthentication];
    [self showLoginView];
}


#pragma mark - Modal delegate

- (void)sheetDidEnd:(NSWindow *)sheet
         returnCode:(NSInteger)returnCode
        contextInfo:(void *)contextInfo {
    self.loginController = nil;
    [sheet orderOut:self];
}

@end
