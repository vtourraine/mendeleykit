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

#import "DocumentDetailTableViewController.h"
#import <MendeleyPerson.h>
#import <MendeleyKit.h>
#import <MendeleyFile.h>

#define kAbstractTag 1

@interface DocumentDetailTableViewController ()
@property (nonatomic, strong) MendeleyDocument *document;
@property (nonatomic, strong) MendeleyFile *file;
@end

@implementation DocumentDetailTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (id)initWithDocument:(MendeleyDocument *)document file:(MendeleyFile *)file
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (nil != self)
    {
        _document = document;
        _file = file;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return (nil != self.file) ? 6 : 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0: // title
            return 1;
        case 1: // type
            return 1;
        case 2: // abstract
            return 1;
        case 3: // year published
            return 1;
        case 4: // authors
        {
            NSArray *authors = self.document.authors;
            if (nil != authors)
            {
                return authors.count;
            }
            else
            {
                return 0;
            }
        }
        case 5: // download
            return 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (2 == indexPath.section)
    {
        return 90;
    }
    else
    {
        return self.tableView.rowHeight;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *view = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 30)];
    NSString *headerText = @"";

    switch (section)
    {
        case 0:
            headerText = NSLocalizedString(@"Title", nil);
            break;
        case 1:
            headerText = NSLocalizedString(@"Type", nil);
            break;
        case 2:
            headerText = NSLocalizedString(@"Abstract", nil);
            break;
        case 3:
            headerText = NSLocalizedString(@"Year Published", nil);
            break;
        case 4:
            headerText = NSLocalizedString(@"Author(s)", nil);
            break;
        case 5:
            headerText = NSLocalizedString(@"Download file", nil);
            break;
    }
    view.text = headerText;
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    UILabel *label = nil;

    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        if (4 == indexPath.section)
        {
            label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.tableView.frame.size.width, 90)];
            label.numberOfLines = 0;
            label.tag = kAbstractTag;
            [cell.contentView addSubview:label];
        }
    }
    else
    {
        if (4 == indexPath.section)
        {
            label = (UILabel *) [cell.contentView viewWithTag:kAbstractTag];
        }
    }

    switch (indexPath.section)
    {
        case 0:
            cell.textLabel.text = self.document.title;
            break;
        case 1:
            cell.textLabel.text = (nil != self.document.type) ? self.document.type : @"No type given";
            break;
        case 2:
            cell.textLabel.text = (nil != self.document.abstract) ? self.document.abstract : @"No abstract";
            break;
        case 3:
            cell.textLabel.text = (nil != self.document.year) ? [NSString stringWithFormat:@"%d", [self.document.year intValue]] : @"No year specified";
            break;
        case 4:
        {
            NSArray *authors = self.document.authors;
            MendeleyPerson *author = [authors objectAtIndex:indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", author.first_name, author.last_name];
            break;
        }
        case 5:
            cell.textLabel.text = self.file.file_name;
            break;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (5 == indexPath.section)
    {
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [spinner setHidesWhenStopped:YES];
        [spinner setCenter:self.view.center];
        [self.view addSubview:spinner];
        [spinner startAnimating];
        NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        NSString *filePath = [documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.pdf", self.file.file_name]];
        NSURL *fileURL = [NSURL fileURLWithPath:filePath];
        [[MendeleyKit sharedInstance] fileWithFileID:self.file.object_ID saveToURL:fileURL progressBlock:nil completionBlock:^(BOOL success, NSError *error) {
             [spinner stopAnimating];
             if (success)
             {
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Success", nil) message:NSLocalizedString(@"File successfully downloaded", nil) delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                 [alert show];
             }
             else
             {
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:error.localizedDescription delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                 [alert show];
             }


         }];
    }
}

@end
