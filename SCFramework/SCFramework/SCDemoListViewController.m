//
//  SCDemoListViewController.m
//  SCFramework
//
//  Created by Angzn on 3/10/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import "SCDemoListViewController.h"

#import "SCTableViewCell.h"

#import "SCDemoDetailViewController.h"

static NSInteger rows = 20;

@interface SCDemoListViewController ()

@end

@implementation SCDemoListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30.f)];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.font = kSCBOLDSYSTEMFONT(18.f);
    titleView.textAlignment = NSTextAlignmentCenter;
    titleView.text = @"列表页面";
    self.navigationItem.titleView = titleView;
//    self.title = @"列表页面";

    self.tableView.refreshEnabled = YES;
    self.tableView.loadEnabled = YES;    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //[self.tableView tableViewDataSourceWillStartRefresh];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //[self.tableView tableViewDataSourceWillStartRefresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCTableViewCell *cell = (SCTableViewCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = [UIColor orangeColor];
    cell.textLabel.font = kSCBOLDSYSTEMFONT(18);
    cell.textLabel.text = [NSString stringWithFormat:@"Section is "NSI" - Row is "NSI,
                           indexPath.section, indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SCDemoDetailViewController *vc = [[SCDemoDetailViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.tableView tableViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate
{
    [self.tableView tableViewDidEndDragging:scrollView];
}

#pragma mark - SCTableViewPullDelegate

- (void)tableViewDidStartRefresh:(SCTableView *)tableView
{
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [tableView tableViewDataSourceDidFinishedRefresh];
        
        rows = 20;
        
        [self.tableView reloadData];
    });
}

- (void)tableViewDidStartLoadMore:(SCTableView *)tableView
{
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [tableView tableViewDataSourceDidFinishedLoadMore];
        
        rows += 20;
        
        [self.tableView reloadData];
    });
}

@end
