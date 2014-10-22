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
#import "MendeleyModels.h"
#import "MendeleyKit.h"
#import "MendeleyQueryRequestParameters.h"
#import "MendeleySyncInfo.h"
#import "DocumentDetailTableViewController.h"

@interface DocumentListTableViewController ()
@property (nonatomic, strong) NSArray *documents;
@end

@implementation DocumentListTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        _documents = [NSArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    /**
       This call gets the first page of documents - default size 20 - from the library.
     */
    MendeleyDocumentParameters *parameters = [MendeleyDocumentParameters new];
    [[MendeleyKit sharedInstance] documentListWithQueryParameters:parameters completionBlock:^(NSArray *objectArray, MendeleySyncInfo *syncInfo, NSError *error) {
         if (nil == objectArray)
         {
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

    if (nil != next)
    {
        [[MendeleyKit sharedInstance] documentListWithLinkedURL:next completionBlock:^(NSArray *objectArray, MendeleySyncInfo *updatedSyncInfo, NSError *error) {
             if (nil == objectArray)
             {
                 UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Oh dear" message:@"We couldn't get our documents" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                 [errorAlert show];
                 self.documents = documents;
                 [self updateTable];
             }
             else
             {
                 NSMutableArray *array = [NSMutableArray arrayWithArray:documents];
                 [array addObjectsFromArray:objectArray];
                 [self pageThroughDocuments:updatedSyncInfo documents:array];
             }
         }];
    }
    else
    {
        self.documents = documents;
        [self updateTable];
    }

}

- (void)updateTable
{
    if (nil != self.documents || 0 < self.documents.count)
    {
        [self.tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"in numberOfRowsInSection");
    if ([self.documents isKindOfClass:[MendeleyDocument class]])
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
    MendeleyDocument *document = [self.documents objectAtIndex:indexPath.row];
    cell.textLabel.text = document.title;


    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MendeleyDocument *document = [self.documents objectAtIndex:indexPath.row];
    DocumentDetailTableViewController *controller = [[DocumentDetailTableViewController alloc] initWithDocument:document file:nil];
    
    [self.navigationController pushViewController:controller animated:YES];
}
@end
