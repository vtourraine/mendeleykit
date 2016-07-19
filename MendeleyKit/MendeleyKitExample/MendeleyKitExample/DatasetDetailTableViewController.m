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

#import "DatasetDetailTableViewController.h"
#import <MendeleyKitiOS/MendeleyKitiOS.h>

NS_ENUM(NSInteger, DatasetDetailRow) {
    DatasetDetailRowName = 0,
    DatasetDetailRowDOI,
    DatasetDetailRowVersion,
    DatasetDetailRowAvailable,
    DatasetDetailRowDescription,
    DatasetDetailRowMethod,
    DatasetDetailRowPublishDate
};

@implementation DatasetDetailTableViewController

#pragma mark - Life cycle

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[MendeleyKit sharedInstance] datasetWithDatasetID:self.dataset.object_ID completionBlock:^(MendeleyObject * _Nullable mendeleyObject, MendeleySyncInfo * _Nullable syncInfo, NSError * _Nullable error) {
        if ([mendeleyObject isKindOfClass:MendeleyDataset.class] == NO)
        {
            UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Oh dear" message:@"We couldn't get our dataset" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [errorAlert show];
        }
        else
        {
            self.dataset = (MendeleyDataset *)mendeleyObject;
            self.title = self.dataset.name;
            [self.tableView reloadData];
        }
    }];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:cellIdentifier];
    }

    NSString *label = nil;
    NSString *value = nil;

    switch (indexPath.row) {
        case DatasetDetailRowName:
            label = NSLocalizedString(@"Name", nil);
            value = self.dataset.name;
            break;

        case DatasetDetailRowDOI:
            label = NSLocalizedString(@"DOI", nil);
            value = self.dataset.doi.object_ID;
            break;

        case DatasetDetailRowVersion:
            label = NSLocalizedString(@"Version", nil);
            value = [self.dataset.object_version stringValue];
            break;

        case DatasetDetailRowAvailable:
            label = NSLocalizedString(@"Available", nil);
            value = self.dataset.available.boolValue ? NSLocalizedString(@"Yes", nil) : NSLocalizedString(@"No", nil);
            break;

        case DatasetDetailRowDescription:
            label = NSLocalizedString(@"Description", nil);
            value = self.dataset.objectDescription;
            break;

        case DatasetDetailRowMethod:
            label = NSLocalizedString(@"Method", nil);
            value = self.dataset.method;
            break;

        case DatasetDetailRowPublishDate:
            label = NSLocalizedString(@"Publish date", nil);
            value = [self.dataset.publish_date description];
            break;
    }

    cell.textLabel.text = label;
    cell.detailTextLabel.text = value;

    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

@end
