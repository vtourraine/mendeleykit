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

#import "ViewController.h"
#import <MendeleyKitiOS/MendeleyKitiOS.h>
#import "DocumentListTableViewController.h"
#import "FilesWithDocumentTableViewController.h"
#import "GroupListTableViewController.h"
#import "GroupListLazyLoadingTableViewController.h"
#import "DatasetListTableViewController.h"

// Uncomment to log in with deprecated Mendeley OAuth service
//#define OAUTH_LOGIN

/**
   By default the MendeleyKit uses NSURLSession based network actions - called in and used by the
   MendeleyDefaultNetworkProvider.
   If instead of using NSURLSession API you want to use NSURLConnection API uncomment the include below
   Also, see viewDidLoad comment to override the default network provider with the NSURLConnection based provider
 */
// #import "MendeleyNSURLConnectionProvider.h"

#ifdef OAUTH_LOGIN
static NSDictionary * clientOAuthConfig()
{
    return @{ kMendeleyOAuth2ClientIDKey: kMyClientID,
              kMendeleyOAuth2ClientSecretKey : kMyClientSecret,
              kMendeleyOAuth2RedirectURLKey : kMyClientRedirectURI };
}
#else
static NSDictionary * clientAuthenticationConfig()
{
    return @{ kMendeleyOAuth2ClientIDKey: kMyClientID,
              kMendeleyOAuth2ClientSecretKey : kMyClientSecret,
              kMendeleyOAuth2RedirectURLKey : kMyClientRedirectURI,
              kMendeleyIDPlusClientIdKey : kMyIDPlusID,
              kMendeleyIDPlusSecretKey : kMyIDPlusSecret,
              kMendeleyIDPlusRedirectUriKey : kMyIDPlusRedirectURI };
}
#endif

NS_ENUM(NSInteger, MenuRow) {
    MenuRowGetDocumentsNoFiles = 0,
    MenuRowGetDocumentsCheckForFiles,
    MenuRowGetGroupsAutomaticIconDownload,
    MenuRowGetGroupsNoIconDownload,
    MenuRowGetDatasets
};

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

#ifdef OAUTH_LOGIN
    [[MendeleyKitConfiguration sharedInstance] configureOAuthWithParameters:clientOAuthConfig()];
#else
    [[MendeleyKitConfiguration sharedInstance] configureAuthenticationWithParameters:clientAuthenticationConfig()];
#endif
    
    /**
       MendeleyKit comes with a network provider based on NSURLConnection (instead of the default one which
       is based on NSURLSession).
       you can enable the MendeleyNSURLConnectionProvider by
       1. uncommenting #import "MendeleyNSURLConnectionProvider.h"
       2. uncommenting the 2 lines below

       The code also demonstrates how to override the network provider with any other custom provider.
       Generally only the network provider needs to be overwritten.
       You may also override the use of a custom OAuth provider - although this is not really encouraged.
     */

    /**
       NSDictionary *networkProviderParameters = @{kMendeleyNetworkProviderKey: NSStringFromClass([MendeleyNSURLConnectionProvider class])};
       [[MendeleyKitConfiguration sharedInstance] changeConfigurationWithParameters:networkProviderParameters];
     */

    if ([[MendeleyKit sharedInstance] isAuthenticated])
    {
        self.navigationItem.rightBarButtonItem.title = @"Logout";
    }
    else
    {
        self.navigationItem.rightBarButtonItem.title = @"Login";
    }
}


#pragma mark - Navigation

- (IBAction)loginOrOut:(id)sender
{
    if ([[MendeleyKit sharedInstance] isAuthenticated])
    {
        [self logout];
    }
    else
    {
        [self presentLoginViewController];
    }
}

- (void)presentLoginViewController
{
    MendeleyStateCompletionBlock loginCompletion = ^void (NSInteger loginState, NSError *loginError){
        if (loginState == LoginResultSuccessful || loginState == LoginResultVerifed)
        {
            self.navigationItem.rightBarButtonItem.title = @"Logout";
            UIAlertView *successAlert = [[UIAlertView alloc] initWithTitle:@"Hurrah" message:@"We successfully logged in" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [successAlert show];
        }
        else
        {
            UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Oh dear" message:@"We couldn't log in" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [errorAlert show];
        }
        [self.navigationController popViewControllerAnimated:YES];
    };

#ifdef OAUTH_LOGIN
    MendeleyLoginViewController *loginController = [[MendeleyLoginViewController alloc] initWithCompletionBlock:loginCompletion customOAuthProvider: nil];
#else
    MendeleyLoginViewController *loginController = [[MendeleyLoginViewController alloc]
                                                    initWithCompletionBlock:loginCompletion customIDPlusProvider:nil];
#endif
    
    [self.navigationController pushViewController:loginController animated:YES];
}

- (void)logout
{
    [[MendeleyKit sharedInstance] clearAuthentication];
    self.navigationItem.rightBarButtonItem.title = @"Login";
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ControllerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    switch (indexPath.row)
    {
        case MenuRowGetDocumentsNoFiles:
            cell.textLabel.text = @"Get Documents (no files)";
            break;

        case MenuRowGetDocumentsCheckForFiles:
            cell.textLabel.text = @"Get Documents (check for files)";
            break;

        case MenuRowGetGroupsAutomaticIconDownload:
            cell.textLabel.text = @"Get Groups (automatic icon download)";
            break;

        case MenuRowGetGroupsNoIconDownload:
            cell.textLabel.text = @"Get Groups (no icon download)";
            break;

        case MenuRowGetDatasets:
            cell.textLabel.text = @"Get Datasets";
            break;
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Class contentViewControllerClass = [self contentViewControllerClassForIndexPath:indexPath];
    UITableViewController *viewController = [[contentViewControllerClass alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (Class)contentViewControllerClassForIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case MenuRowGetDocumentsNoFiles:
            return [DocumentListTableViewController class];

        case MenuRowGetDocumentsCheckForFiles:
            return [FilesWithDocumentTableViewController class];

        case MenuRowGetGroupsAutomaticIconDownload:
            return [GroupListTableViewController class];

        case MenuRowGetGroupsNoIconDownload:
            return [GroupListLazyLoadingTableViewController class];

        case MenuRowGetDatasets:
            return [DatasetListTableViewController class];
    }

    return nil;
}

@end
