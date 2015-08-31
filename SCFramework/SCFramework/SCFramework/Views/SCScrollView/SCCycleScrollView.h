//
//  SCCycleScrollView.h
//  SCFramework
//
//  Created by Angzn on 15/6/3.
//  Copyright (c) 2015年 Richer VC. All rights reserved.
//

#import "SCView.h"

@class SCScrollView;

@protocol SCCycleScrollViewDataSource;
@protocol SCCycleScrollViewDelegate;

@interface SCCycleScrollView : SCView
<
UIScrollViewDelegate
>

@property (nonatomic, weak) id <SCCycleScrollViewDataSource> dataSource;
@property (nonatomic, weak) id <SCCycleScrollViewDelegate> delegate;

@property (nonatomic, strong, readonly) SCScrollView *scrollView;
@property (nonatomic, assign, readonly) NSInteger currentPage;

@property (nonatomic, assign) NSTimeInterval scrollingDuration;

- (void)reloadData;

- (void)startPageing;
- (void)stopPageing;
- (BOOL)isPaging;

- (void)goToPreviousPage;
- (void)goToNextPage;

@end

@protocol SCCycleScrollViewDataSource <NSObject>

@required
- (NSInteger)numberOfPagesInCycleScrollView:(SCCycleScrollView *)cycleView;
- (UIView *)cycleScrollView:(SCCycleScrollView *)cycleView pageAtIndex:(NSInteger)index;

@end

@protocol SCCycleScrollViewDelegate <NSObject>

@optional
- (void)cycleScrollView:(SCCycleScrollView *)cycleView didSelectPageAtIndex:(NSInteger)index;
- (void)cycleScrollViewDidScroll:(SCCycleScrollView *)cycleView;

@end
