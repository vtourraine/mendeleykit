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

NS_ENUM(NSInteger, DocumentSection) {
    DocumentSectionTitle = 0,
    DocumentSectionType,
    DocumentSectionAbstract,
    DocumentSectionYearPublished,
    DocumentSectionAuthors,
    DocumentSectionFiles
};

#define kAbstractTag 1

@interface DocumentDetailTableViewController ()
@property (nonatomic, strong) MendeleyDocument *document;
@property (nonatomic, strong) MendeleyFile *file;
@end

@implementation DocumentDetailTableViewController

- (instancetype)initWithDocument:(MendeleyDocument *)document file:(MendeleyFile *)file
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

    self.title = self.document.title;
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
        case DocumentSectionTitle:
        case DocumentSectionType:
        case DocumentSectionAbstract:
        case DocumentSectionYearPublished:
        case DocumentSectionFiles:
            return 1;

        case DocumentSectionAuthors:
            return self.document.authors.count;
    }

    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case DocumentSectionTitle:
            return NSLocalizedString(@"Title", nil);
        case DocumentSectionType:
            return NSLocalizedString(@"Type", nil);
        case DocumentSectionAbstract:
            return NSLocalizedString(@"Abstract", nil);
        case DocumentSectionYearPublished:
            return NSLocalizedString(@"Year Published", nil);
        case DocumentSectionAuthors:
            return NSLocalizedString(@"Author(s)", nil);
        case DocumentSectionFiles:
            return NSLocalizedString(@"Download file", nil);
    }

    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"CellIdentifier";
    if (DocumentSectionAbstract == indexPath.section)
    {
        cellIdentifier = @"AbstractCellIdentifier";
    }

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    UILabel *label = nil;

    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        if (DocumentSectionAbstract == indexPath.section)
        {
            const CGFloat SideMargin = 20;
            label = [[UILabel alloc] initWithFrame:CGRectMake(SideMargin, 0, CGRectGetWidth(cell.contentView.frame) - 2*SideMargin, CGRectGetHeight(cell.contentView.frame))];
            label.numberOfLines = 0;
            label.tag = kAbstractTag;
            label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            [cell.contentView addSubview:label];
        }
    }
    else
    {
        if (DocumentSectionAbstract == indexPath.section)
        {
            label = (UILabel *) [cell.contentView viewWithTag:kAbstractTag];
        }
    }

    switch (indexPath.section)
    {
        case DocumentSectionTitle:
            cell.textLabel.text = self.document.title;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        case DocumentSectionType:
            cell.textLabel.text = (nil != self.document.type) ? self.document.type : @"No type given";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        case DocumentSectionAbstract:
            label.text = (nil != self.document.abstract) ? self.document.abstract : @"No abstract";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        case DocumentSectionYearPublished:
            cell.textLabel.text = (nil != self.document.year) ? [self.document.year stringValue] : @"No year specified";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        case DocumentSectionAuthors:
        {
            MendeleyPerson *author = self.document.authors[indexPath.row];
            if (nil != [NSPersonNameComponentsFormatter class])
            {
                NSPersonNameComponents *components = [[NSPersonNameComponents alloc] init];
                components.familyName = author.last_name;
                components.givenName = author.first_name;
                NSPersonNameComponentsFormatter *formatter = [[NSPersonNameComponentsFormatter alloc] init];
                cell.textLabel.text = [formatter stringFromPersonNameComponents:components];
            }
            else
            {
                cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", author.first_name, author.last_name];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        }
        case DocumentSectionFiles:
            cell.textLabel.text = self.file.file_name;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            break;
    }

    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (DocumentSectionAbstract == indexPath.section)
    {
        return 90;
    }
    else
    {
        return self.tableView.rowHeight;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (DocumentSectionFiles != indexPath.section)
    {
        return;
    }

    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.pdf", self.file.file_name]];
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    [[MendeleyKit sharedInstance] fileWithFileID:self.file.object_ID saveToURL:fileURL progressBlock:nil completionBlock:^(BOOL success, NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

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

@end
