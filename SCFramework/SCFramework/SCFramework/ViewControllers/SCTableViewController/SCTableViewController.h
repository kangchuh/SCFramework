//
//  SCTableViewController.h
//  SCFramework
//
//  Created by Angzn on 3/10/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import "SCViewController.h"

@class SCTableView;

@interface SCTableViewController : SCViewController
<
UITableViewDataSource,
UITableViewDelegate,
SCTableViewPullDelegate
>

@property (nonatomic, strong) SCTableView *tableView;

- (id)initWithStyle:(UITableViewStyle)style;

@end
