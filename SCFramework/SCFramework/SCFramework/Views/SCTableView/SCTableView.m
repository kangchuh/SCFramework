//
//  SCTableView.m
//  SCFramework
//
//  Created by Angzn on 3/6/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import "SCTableView.h"
#import "SCPullRefreshView.h"
#import "SCPullLoadView.h"

@interface SCTableView ()

@end


@implementation SCTableView

- (void)dealloc
{}

#pragma mark - Init Methods

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self defaultInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self defaultInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self defaultInit];
    }
    return self;
}

- (void)defaultInit
{}

#pragma mark - UIResponder Touch Event Methods

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ( _endEditingWhenTouch ) {
        [self endEditing:YES];
    }
    [super touchesEnded:touches withEvent:event];
}

#pragma mark - UIScrollView Touch Event Methods

- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event
             inContentView:(UIView *)view
{
    if ( _endEditingWhenTouch ) {
        [self endEditing:YES];
    }
    return [super touchesShouldBegin:touches withEvent:event inContentView:view];
}

#pragma mark - Public Methods

- (void)setRefreshEnabled:(BOOL)refreshEnabled
{
    if (_refreshEnabled != refreshEnabled) {
        _refreshEnabled = refreshEnabled;
        if (_refreshEnabled) {
            _pullRefreshView = [[SCPullRefreshView alloc] initWithFrame:
                                CGRectMake(0.0f,
                                           - kSCPullRefreshViewHeight,
                                           CGRectGetWidth(self.frame),
                                           kSCPullRefreshViewHeight)];
            [self addSubview:_pullRefreshView];
        } else {
            [_pullRefreshView removeFromSuperview];
            _pullRefreshView = nil;
        }
    }
}

- (void)setLoadEnabled:(BOOL)loadEnabled
{
    if (_loadEnabled != loadEnabled) {
        _loadEnabled = loadEnabled;
        if (_loadEnabled) {
            _pullLoadView = [[SCPullLoadView alloc] initWithFrame:
                             CGRectMake(0.0f,
                                        0.0f,
                                        CGRectGetWidth(self.frame),
                                        kSCPullLoadViewHeight)];
            self.tableFooterView = _pullLoadView;
        } else {
            self.tableFooterView = nil;
            _pullLoadView = nil;
        }
    }
}

- (void)tableViewDidScroll:(UIScrollView *)scrollView
{
    CGSize frameSize          = scrollView.frame.size;
    CGSize contentSize        = scrollView.contentSize;
    CGPoint contentOffset     = scrollView.contentOffset;
    UIEdgeInsets contentInset = scrollView.contentInset;
    
    CGFloat topMargin    = contentOffset.y + contentInset.top;
    CGFloat bottomMargin = contentOffset.y + frameSize.height - contentSize.height;
    
    if (_refreshEnabled && !_refreshing) {
        if (topMargin < -kSCPullDownDistance) {
            _pullRefreshView.state = SCPullDownStatePulling;
        } else if (topMargin >= -kSCPullDownDistance &&
                   topMargin < 0.0) {
            _pullRefreshView.state = SCPullDownStateNormal;
            _pullRefreshView.pullScale = -topMargin / kSCPullDownDistance;
        }
    }
    
    if (_loadEnabled && !_loading) {
        if (bottomMargin > kSCPullUpDistance) {
            _pullLoadView.state = SCPullUpStatePulling;
        } else if (bottomMargin <= kSCPullUpDistance &&
                   bottomMargin > 0.0 - kSCPullLoadViewHeight) {
            _pullLoadView.state = SCPullUpStateNormal;
        }
    }
}

- (void)tableViewDidEndDragging:(UIScrollView *)scrollView
{
    if (_refreshing || _loading) {
        return;
    }
    
    if (_pullRefreshView.state == SCPullDownStatePulling) {
        _refreshing = YES;
        _pullRefreshView.state = SCPullDownStateRefreshing;
        [UIView animateWithDuration:0.18f
                         animations:^{
                             UIEdgeInsets contentInset = self.contentInset;
                             contentInset.top += kSCPullRefreshViewHeight;
                             self.contentInset = contentInset;
                         }];
        if (_pullDelegate && [_pullDelegate respondsToSelector:
                              @selector(tableViewDidStartRefresh:)]) {
            [_pullDelegate tableViewDidStartRefresh:self];
        }
    }
    
    if (_pullLoadView.state == SCPullUpStatePulling) {
        _loading = YES;
        _pullLoadView.state = SCPullUpStateLoading;
        if (_pullDelegate && [_pullDelegate respondsToSelector:
                              @selector(tableViewDidStartLoadMore:)]) {
            [_pullDelegate tableViewDidStartLoadMore:self];
        }
    }
}

- (void)tableViewDataSourceDidFinishedRefresh
{
    if (_refreshing) {
        _refreshing = NO;
        _pullRefreshView.state = SCPullDownStateNormal;
        [UIView animateWithDuration:0.18f
                         animations:^{
                             UIEdgeInsets contentInset = self.contentInset;
                             contentInset.top -= kSCPullRefreshViewHeight;
                             self.contentInset = contentInset;
                         }];
        
        NSDate *lastUpdatedDate = nil;
        if (_pullDelegate && [_pullDelegate respondsToSelector:
                              @selector(tableViewRefreshFinishedDate)]) {
            lastUpdatedDate = [_pullDelegate tableViewRefreshFinishedDate];
        } else {
            lastUpdatedDate = [NSDate date];
        }
        [_pullRefreshView refreshLastUpdatedDate:lastUpdatedDate];
    }
}

- (void)tableViewDataSourceDidFinishedLoadMore
{
    if (_loading) {
        _loading = NO;
        _pullLoadView.state = SCPullUpStateNormal;
    }
}

- (void)tableViewDataSourceWillStartRefresh
{
    if (_refreshing) {
        return;
    }
    
    _refreshing = YES;
    _pullRefreshView.state = SCPullDownStateRefreshing;
    [UIView animateWithDuration:0.18f
                     animations:^{
                         UIEdgeInsets contentInset = self.contentInset;
                         contentInset.top += kSCPullRefreshViewHeight;
                         self.contentInset = contentInset;
                         self.contentOffset = CGPointMake(0.0f, -contentInset.top);
                     }];
    if (_pullDelegate && [_pullDelegate respondsToSelector:
                          @selector(tableViewDidStartRefresh:)]) {
        [_pullDelegate tableViewDidStartRefresh:self];
    }
}

@end
