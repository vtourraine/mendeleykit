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

#import "GroupListTableViewController.h"
#import "MendeleyModels.h"
#import "MendeleyKit.h"

@interface GroupListTableViewController ()
@property (nonatomic, strong) NSArray *groups;
@end

@implementation GroupListTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        _groups = [NSArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[MendeleyKit sharedInstance] groupListWithQueryParameters:nil completionBlock:^(NSArray *array, MendeleySyncInfo *syncInfo, NSError *error) {
         if (nil != array && 0 < array.count)
         {
             self.groups = [NSArray arrayWithArray:array];
             [self.tableView reloadData];
         }
     }];


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.groups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"GroupcellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];

    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }

    MendeleyGroup *group = [self.groups objectAtIndex:indexPath.row];
    cell.textLabel.text = group.name;

    if (nil != group.photo && nil != group.photo.squareImageData)
    {
        cell.imageView.image = [UIImage imageWithData:group.photo.squareImageData];
    }

    return cell;
}
@end
