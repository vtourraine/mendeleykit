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

#import "DocumentListTableViewController.h"
#import <MendeleyKitiOS/MendeleyKitiOS.h>
#import "DocumentDetailTableViewController.h"

@interface DocumentListTableViewController ()
@property (nonatomic, strong) NSArray <MendeleyDocument *> *documents;
@end

@implementation DocumentListTableViewController

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        _documents = @[];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = NSLocalizedString(@"Documents", nil);

    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    /**
       This call gets the first page of documents - default size 20 - from the library.
     */
    MendeleyDocumentParameters *parameters = [MendeleyDocumentParameters new];
    [[MendeleyKit sharedInstance] documentListWithQueryParameters:parameters completionBlock:^(NSArray *objectArray, MendeleySyncInfo *syncInfo, NSError *error) {
         if (nil == objectArray)
         {
             [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

             UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Oh dear" message:@"We couldn't get our documents" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
             [errorAlert show];
         }
         else
         {
             [self pageThroughDocuments:syncInfo documents:objectArray];
         }
     }];

}

- (void)pageThroughDocuments:(MendeleySyncInfo *)syncInfo documents:(NSArray *)documents
{
    NSURL *next = syncInfo.linkDictionary[kMendeleyRESTHTTPLinkNext];

    if (nil == next)
    {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [self updateTableWithDocuments:documents];
        return;
    }

    [[MendeleyKit sharedInstance] documentListWithLinkedURL:next completionBlock:^(NSArray *objectArray, MendeleySyncInfo *updatedSyncInfo, NSError *error) {
        if (nil == objectArray)
        {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

            UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Oh dear" message:@"We couldn't get our documents" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [errorAlert show];

            [self updateTableWithDocuments:documents];
        }
        else
        {
            NSArray *array = [documents arrayByAddingObjectsFromArray:objectArray];
            [self pageThroughDocuments:updatedSyncInfo documents:array];
        }
    }];
}

- (void)updateTableWithDocuments:(NSArray <MendeleyDocument *> *)documents
{
    self.documents = documents;

    if (nil != self.documents || 0 < self.documents.count)
    {
        [self.tableView reloadData];
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.documents != nil && [self.documents isKindOfClass:[NSArray class]] == NO)
    {
        NSLog(@"What the heck happened here? This should be an array not a MendeleyDocument object");
        return 0;
    }
    return self.documents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"docIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];

    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    MendeleyDocument *document = self.documents[indexPath.row];
    cell.textLabel.text = document.title;

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MendeleyDocument *document = self.documents[indexPath.row];
    DocumentDetailTableViewController *controller = [[DocumentDetailTableViewController alloc] initWithDocument:document file:nil];
    
    [self.navigationController pushViewController:controller animated:YES];
}

@end
