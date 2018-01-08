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

#import "DatasetListTableViewController.h"
#import "DatasetDetailTableViewController.h"
#import <MendeleyKitiOS/MendeleyKitiOS.h>

@interface DatasetListTableViewController ()
@property (nonatomic, strong, nullable) NSArray <MendeleyDataset *> *datasets;
@end

@implementation DatasetListTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = NSLocalizedString(@"Datasets", nil);

    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    /**
     This call gets the first page of datasets from the library.
     */
    MendeleyDatasetParameters *parameters = [MendeleyDatasetParameters new];
    [[MendeleyKit sharedInstance] datasetListWithQueryParameters:parameters completionBlock:^(NSArray *objectArray, MendeleySyncInfo *syncInfo, NSError *error) {
        if (nil == objectArray)
        {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

            UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Oh dear" message:@"We couldn't get our datasets" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [errorAlert show];
        }
        else
        {
            [self pageThroughDatasets:syncInfo datasets:objectArray];
        }
    }];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Create New" style:UIBarButtonItemStyleDone target:self action:@selector(createDataset:)];
}

- (void)createDataset:(id)sender {
    MendeleyDataset *dataset = [[MendeleyDataset alloc] init];
    dataset.name = @"Test MendeleyKit";
    dataset.objectDescription = @"Dataset with 1 file";

    NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"test-file.txt"];
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    [@"Test Content" writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];

    [[MendeleyKit sharedInstance] createDatasetFile:fileURL filename:@"Test File.txt" contentType:@"text/plain" progressBlock:nil completionBlock:^(MendeleyObject * _Nullable mendeleyObject, MendeleySyncInfo * _Nullable syncInfo, NSError * _Nullable error) {

        dataset.files = @[mendeleyObject];

        [[MendeleyKit sharedInstance] createDataset:dataset completionBlock:^(MendeleyObject * _Nullable mendeleyObject, MendeleySyncInfo * _Nullable syncInfo, NSError * _Nullable error) {

            if (mendeleyObject) {
                UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"New Dataset Created" message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [errorAlert show];
            }
            else {
                UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Cannot Create Dataset" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [errorAlert show];
            }
        }];
    }];
}

- (void)pageThroughDatasets:(MendeleySyncInfo *)syncInfo datasets:(NSArray <MendeleyDataset *> *)datasets
{
    NSURL *next = [syncInfo.linkDictionary objectForKey:kMendeleyRESTHTTPLinkNext];

    if (nil == next || datasets.count > 100)
    {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

        self.datasets = datasets;
        [self.tableView reloadData];

        return;
    }

    [[MendeleyKit sharedInstance] datasetListWithLinkedURL:next completionBlock:^(NSArray *objectArray, MendeleySyncInfo *updatedSyncInfo, NSError *error) {
        if (nil == objectArray)
        {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

            UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Oh dear" message:@"We couldn't get our datasets" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [errorAlert show];

            self.datasets = datasets;
            [self.tableView reloadData];
        }
        else
        {
            NSArray *array = [datasets arrayByAddingObjectsFromArray:objectArray];
            [self pageThroughDatasets:updatedSyncInfo datasets:array];
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.datasets != nil && [self.datasets isKindOfClass:[NSArray class]] == NO)
    {
        NSLog(@"What the heck happened here? This should be an array");
        return 0;
    }

    return self.datasets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"datasetIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];

    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }

    MendeleyDataset *dataset = self.datasets[indexPath.row];
    cell.textLabel.text = dataset.object_ID;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DatasetDetailTableViewController *controller = [[DatasetDetailTableViewController alloc] init];
    controller.dataset = self.datasets[indexPath.row];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
