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
#import <MendeleyKitiOS/MendeleyKitiOS.h>

@interface GroupListTableViewController ()
@property (nonatomic, strong) NSArray <MendeleyGroup *> *groups;
@end

@implementation GroupListTableViewController

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (nil != self)
    {
        _groups = @[];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = NSLocalizedString(@"Groups", nil);

    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    /**
     This code downloads the first 'page' of groups. MendeleyKit has a default page size of 50
     which for most users will be sufficient downloading all of their groups.
     If paging is required - look into
     DocumentListTableViewController
     to see how the paging algorithm works. The paging algorithms for /files, /documents, /groups, /folders API
     are all equivalent.
     */
    MendeleyGroupParameters *parameters = [MendeleyGroupParameters new];
    
    /**
     This is the code that downloads the groups with icons.
     The standard icon type used is 'SquareIcon'. OriginalIcon uses the original size, StandardIcon
     is a larger rectangle.
     */
    [[MendeleyKit sharedInstance] groupListWithQueryParameters:parameters iconType:SquareIcon completionBlock:^(NSArray *array, MendeleySyncInfo *syncInfo, NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

        self.groups = array;
        [self.tableView reloadData];
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.groups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"GroupCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];

    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }

    MendeleyGroup *group = self.groups[indexPath.row];
    cell.textLabel.text = group.name;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (nil != group.photo.squareImageData)
    {
        cell.imageView.image = [UIImage imageWithData:group.photo.squareImageData];
    }

    return cell;
}

@end
