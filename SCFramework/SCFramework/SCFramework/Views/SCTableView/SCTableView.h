//
//  SCTableView.h
//  SCFramework
//
//  Created by Angzn on 3/6/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCPullRefreshView;
@class SCPullLoadView;

@protocol SCTableViewPullDelegate;

@interface SCTableView : UITableView

@property (nonatomic, weak) id <SCTableViewPullDelegate> pullDelegate;

@property (nonatomic, strong, readonly) SCPullRefreshView *pullRefreshView;
@property (nonatomic, strong, readonly) SCPullLoadView *pullLoadView;

@property (nonatomic, assign, getter = isRefreshEnabled) BOOL refreshEnabled;
@property (nonatomic, assign, getter = isLoadEnabled) BOOL loadEnabled;

@property (nonatomic, assign, readonly, getter = isRefreshing) BOOL refreshing;
@property (nonatomic, assign, readonly, getter = isLoading) BOOL loading;

- (void)tableViewDidScroll:(UIScrollView *)scrollView;
- (void)tableViewDidEndDragging:(UIScrollView *)scrollView;

- (void)tableViewDataSourceDidFinishedRefresh;
- (void)tableViewDataSourceDidFinishedLoadMore;

- (void)tableViewDataSourceWillStartRefresh;

@property (nonatomic, assign) BOOL endEditingWhenTouch;

@end


@protocol SCTableViewPullDelegate <NSObject>

@optional
- (void)tableViewDidStartRefresh:(SCTableView *)tableView;
- (NSDate *)tableViewRefreshFinishedDate;

- (void)tableViewDidStartLoadMore:(SCTableView *)tableView;

@end
