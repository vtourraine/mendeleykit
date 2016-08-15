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

#import "FilesWithDocumentTableViewController.h"
#import <MendeleyKitiOS/MendeleyKitiOS.h>
#import "DocumentDetailTableViewController.h"

#define kPDFLabelTag   99
#define kTitleLabelTag 100

@interface FilesWithDocumentTableViewController ()
@property (nonatomic, strong) NSArray <MendeleyDocument *> *documents;
@property (nonatomic, strong) NSArray <MendeleyFile *> *files;
@property (nonatomic, strong) UILabel *headerView;
@end

@implementation FilesWithDocumentTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = NSLocalizedString(@"Documents", nil);

    self.documents = @[];
    [self getFilesFromServer];
}

- (void)getFilesFromServer
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    [[MendeleyKit sharedInstance] fileListWithQueryParameters:nil completionBlock:^(NSArray *array, MendeleySyncInfo *syncInfo, NSError *error) {
         if (nil == array)
         {
             [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

             UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Oh dear" message:@"An error occurred when retrieving files" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
             [errorAlert show];
         }
         else
         {
             self.files = array;
             [self getDocumentsFromServer];
         }
     }];
}

/**
   this method will have to be implemented, once paging is enabled for /files API
 */
// - (void)pageThroughFiles:(MendeleySyncInfo *)syncInfo files:(NSArray *)files
// {
//
// }

- (void)getDocumentsFromServer
{
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
    NSURL *next = [syncInfo.linkDictionary objectForKey:kMendeleyRESTHTTPLinkNext];

    if (nil == next)
    {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

        self.documents = documents;
        [self updateTable];

        return;
    }

    [[MendeleyKit sharedInstance] documentListWithLinkedURL:next completionBlock:^(NSArray *objectArray, MendeleySyncInfo *updatedSyncInfo, NSError *error) {
        if (nil == objectArray)
        {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

            UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Oh dear" message:@"We couldn't get our documents" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [errorAlert show];

            self.documents = documents;
            [self updateTable];
        }
        else
        {
            NSArray *array = [documents arrayByAddingObjectsFromArray:objectArray];
            [self pageThroughDocuments:updatedSyncInfo documents:array];
        }
    }];
}

- (void)updateTable
{
    if (nil != self.documents || 0 < self.documents.count)
    {
        [self.tableView reloadData];
    }
    if (nil != self.headerView)
    {
        self.headerView.text = @"";
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.documents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identfier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identfier];

    UILabel *label = nil;
    UILabel *pdfLabel = nil;

    const NSInteger RowHeight = 44;
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identfier];

        label = [[UILabel alloc] initWithFrame:CGRectMake(65, 0, 250, RowHeight)];
        label.backgroundColor = [UIColor clearColor];
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:12];
        label.tag = kTitleLabelTag;
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [cell.contentView addSubview:label];

        pdfLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 40, RowHeight)];
        pdfLabel.textColor = [UIColor redColor];
        pdfLabel.backgroundColor = [UIColor clearColor];
        pdfLabel.tag = kPDFLabelTag;
        [cell.contentView addSubview:pdfLabel];
    }
    else
    {
        label = (UILabel *) [cell.contentView viewWithTag:kTitleLabelTag];
        pdfLabel = (UILabel *) [cell.contentView viewWithTag:kPDFLabelTag];
    }

    MendeleyDocument *document = self.documents[indexPath.row];
    label.text = document.title;
    NSArray *foundIDs = nil;
    if (nil != self.files && 0 < self.files.count)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"document_id contains %@", document.object_ID];
        foundIDs = [self.files filteredArrayUsingPredicate:predicate];
    }

    if (0 < foundIDs.count)
    {
        pdfLabel.text = @"PDF";
    }
    else
    {
        pdfLabel.text = @"";
    }

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MendeleyDocument *document = self.documents[indexPath.row];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.document_id = %@", document.object_ID];
    MendeleyFile *file = [[self.files filteredArrayUsingPredicate:predicate] lastObject];
    DocumentDetailTableViewController *controller = [[DocumentDetailTableViewController alloc] initWithDocument:document file:file];

    [self.navigationController pushViewController:controller animated:YES];
}

@end
