//
//  SCTableViewController.m
//  SCFramework
//
//  Created by Angzn on 3/10/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import "SCTableViewController.h"
#import "SCTableView.h"
#import "SCTableViewCell.h"

@interface SCTableViewController ()

@property (nonatomic) UITableViewStyle style;

@end

@implementation SCTableViewController

- (void)dealloc
{
    _tableView.dataSource = nil;
    _tableView.delegate = nil;
    _tableView.pullDelegate = nil;
}

#pragma mark - Init Methods

- (id)init
{
    self = [super init];
    if (self) {
        _style = UITableViewStylePlain;
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super init];
    if (self) {
        _style = style;
    }
    return self;
}

#pragma mark - View LifeCycle

- (void)loadView
{
    [super loadView];
    
    _tableView = [[SCTableView alloc] initWithFrame:self.view.bounds
                                              style:_style];
    _tableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth |
                                   UIViewAutoresizingFlexibleHeight);
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.pullDelegate = self;
    [self.view addSubview:_tableView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    SCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[SCTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier];
    }
    return cell;
}

@end
