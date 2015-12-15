//
//  SCCycleScrollView.m
//  SCFramework
//
//  Created by Angzn on 15/6/3.
//  Copyright (c) 2015年 Richer VC. All rights reserved.
//

#import "SCCycleScrollView.h"

#import "SCScrollView.h"

#import "UIView+SCAddition.h"
#import "NSArray+SCAddition.h"
#import "NSDictionary+SCAddition.h"
#import "NSTimer+SCAddition.h"

static NSString * const SCCycleScrollViewPreviousKey = @"SCCycleScrollViewPreviousKey";
static NSString * const SCCycleScrollViewCurrentKey = @"SCCycleScrollViewCurrentKey";
static NSString * const SCCycleScrollViewNextKey = @"SCCycleScrollViewNextKey";

/// 循环滚动时间间隔
static const CGFloat SCCycleScrollingDuration = 5.0;

@interface SCCycleScrollView ()
{
    /// 当前可(需要)加载的视图
    NSMutableDictionary *_loadableViews;
}

/// 内容视图
@property (nonatomic, strong) SCScrollView *scrollView;

/// 当前页码
@property (nonatomic, assign) NSInteger currentPage;

/// 循环滚动计时器
@property (nonatomic, strong) NSTimer *scrollingTimer;

@end

@implementation SCCycleScrollView

- (void)dealloc
{
	_scrollView.delegate = nil;
}

#pragma mark - Init Method

- (void)initialize
{
	_scrollView = [[SCScrollView alloc] initWithFrame:self.bounds];
	_scrollView.autoresizingMask = (UIViewAutoresizingFlexibleWidth |
	                                UIViewAutoresizingFlexibleHeight);
	_scrollView.showsHorizontalScrollIndicator = NO;
	_scrollView.showsVerticalScrollIndicator = NO;
	_scrollView.pagingEnabled = YES;
	_scrollView.delegate = self;
	[self addSubview:_scrollView];

	_scrollingDuration = SCCycleScrollingDuration;
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self initialize];
	}
	return self;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	NSInteger offsetX = scrollView.contentOffset.x;

	if (offsetX <= 0) {
		NSInteger previousPage = [self __constructPreviousPage:_currentPage];
		self.currentPage = previousPage;
		[self __reloadData];
	}

	if (offsetX >= 2 * scrollView.width) {
		NSInteger nextPage = [self __constructNextPage:_currentPage];
		self.currentPage = nextPage;
		[self __reloadData];
	}

	if ([_delegate respondsToSelector:@selector(cycleScrollViewDidScroll:)]) {
		[_delegate cycleScrollViewDidScroll:self];
	}
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
	[self.scrollingTimer pause];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	[self.scrollingTimer resumeAfterTimeInterval:_scrollingDuration];
}

#pragma mark - Public Method

- (void)reloadData
{
	[self __reloadData];
}

- (void)startPageing
{
	NSInteger totalPgaes = [self __GETNumberOfPages];
	if (totalPgaes <= 0) {
		return;
	}

	self.scrollingTimer = [NSTimer scheduledTimerWithTimeInterval:_scrollingDuration
                                                           target:self
                                                         selector:@selector(goToNextPage)
                                                         userInfo:nil
                                                          repeats:YES];
}

- (void)stopPageing
{
	if ([self.scrollingTimer isValid]) {
		[self.scrollingTimer invalidate];
	}
	self.scrollingTimer = nil;
}

- (BOOL)isPaging
{
    return self.scrollingTimer.isValid;
}

- (void)goToPreviousPage
{
	[self.scrollView scrollToPreviousPage:YES];
}

- (void)goToNextPage
{
	[self.scrollView scrollToNextPage:YES];
}

#pragma mark - Private Method

- (NSInteger)__GETNumberOfPages
{
	return [_dataSource numberOfPagesInCycleScrollView:self];
}

- (UIView *)__GETPageViewAtIndex:(NSInteger)index
{
	return [_dataSource cycleScrollView:self pageAtIndex:index];
}

- (NSInteger)__constructValidPageValue:(NSInteger)value
{
	NSInteger totalPgaes = [self __GETNumberOfPages];
	NSInteger lastPage = totalPgaes - 1;
	NSInteger firstPage = 0;

	if (value < firstPage) {
		value = lastPage;
	}

	if (value > lastPage) {
		value = firstPage;
	}

	return value;
}

- (NSInteger)__constructPreviousPage:(NSInteger)currentPage
{
	return [self __constructValidPageValue:currentPage - 1];
}

- (NSInteger)__constructNextPage:(NSInteger)currentPage
{
	return [self __constructValidPageValue:currentPage + 1];
}

- (NSDictionary *)__constructLoadableViews:(NSInteger)currentPage
{
	NSInteger totalPgaes = [self __GETNumberOfPages];
	if (totalPgaes == 0) {
		return nil;
	} else if (totalPgaes == 1) {
		UIView *currentView = [self __GETPageViewAtIndex:currentPage];

        NSDictionary *views = @{ SCCycleScrollViewCurrentKey: currentView };

		return views;
	} else {
		NSInteger previousPage = [self __constructPreviousPage:currentPage];
		NSInteger nextPage = [self __constructNextPage:currentPage];

		UIView *previousView = _loadableViews[SCCycleScrollViewPreviousKey];
        if (!previousView) {
            previousView = [self __GETPageViewAtIndex:previousPage];
        }
		UIView *currentView = _loadableViews[SCCycleScrollViewCurrentKey];
        if (!currentView) {
            currentView = [self __GETPageViewAtIndex:currentPage];
        }
		UIView *nextView = _loadableViews[SCCycleScrollViewNextKey];
        if (!nextView) {
            nextView = [self __GETPageViewAtIndex:nextPage];
        }

        NSDictionary *views = @{ SCCycleScrollViewPreviousKey: previousView,
                                 SCCycleScrollViewCurrentKey: currentView,
                                 SCCycleScrollViewNextKey: nextView };

		return views;
	}
}

- (void)__reloadData
{
	if (!_loadableViews) {
		_loadableViews = [[NSMutableDictionary alloc] init];
	}

    NSDictionary *loadableViews = [self __constructLoadableViews:_currentPage];
    if ([_loadableViews isNotEmpty]) {
        for (UIView *view in _loadableViews.allValues) {
            if ([view respondsToSelector:@selector(removeFromSuperview)]) {
                [view removeFromSuperview];
            }
        }
        [_loadableViews removeAllObjects];
    }
    [_loadableViews addEntriesFromDictionary:loadableViews];

    NSInteger itemsCount = _loadableViews.count;
    if (itemsCount == 0) {
        _scrollView.contentSize = CGSizeZero;
        _scrollView.contentOffset = CGPointZero;
    } else if (itemsCount == 1) {
        UIView *currentView = _loadableViews[SCCycleScrollViewCurrentKey];
        [self __configFrameToLoadableView:currentView forIndex:0];
        [self __configEventToLoadableView:currentView];
        [_scrollView addSubview:currentView];
        
        _scrollView.contentSize = ({
            CGFloat contentWidth = _scrollView.width;
            CGFloat contentHeight = _scrollView.height;
            CGSize contentSize = CGSizeMake(contentWidth, contentHeight);
            contentSize;
        });
        _scrollView.contentOffset = CGPointZero;
    } else {
        UIView *previousView = _loadableViews[SCCycleScrollViewPreviousKey];
        [self __configFrameToLoadableView:previousView forIndex:0];
        [self __configEventToLoadableView:previousView];
        [_scrollView addSubview:previousView];
        
        UIView *currentView = _loadableViews[SCCycleScrollViewCurrentKey];
        [self __configFrameToLoadableView:currentView forIndex:1];
        [self __configEventToLoadableView:currentView];
        [_scrollView addSubview:currentView];
        
        UIView *nextView = _loadableViews[SCCycleScrollViewNextKey];
        [self __configFrameToLoadableView:nextView forIndex:2];
        [self __configEventToLoadableView:nextView];
        [_scrollView addSubview:nextView];
        
        _scrollView.contentSize = ({
            CGFloat contentWidth = _scrollView.width;
            CGFloat contentHeight = _scrollView.height;
            CGSize contentSize = CGSizeMake(contentWidth * itemsCount, contentHeight);
            contentSize;
        });
        _scrollView.contentOffset = ({
            CGFloat contentWidth = _scrollView.width;
            CGPoint contentOffset = CGPointMake(contentWidth, 0.0);
            contentOffset;
        });
    }
}

- (void)__configFrameToLoadableView:(UIView *)view forIndex:(NSInteger)index
{
	view.frame = ({
		CGFloat contentWidth = _scrollView.width;
		CGFloat contentHeight = _scrollView.height;
		CGRect frame = CGRectMake(0.0, 0.0, contentWidth, contentHeight);
		frame = CGRectOffset(frame, contentWidth * index, 0.0);
		frame;
	});
}

- (void)__configEventToLoadableView:(UIView *)view
{
	UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
	                                      initWithTarget:self
	                                      action:@selector(__handleTapGesture:)];
	view.userInteractionEnabled = YES;
	[view addGestureRecognizer:tapGesture];
}

- (void)__handleTapGesture:(UITapGestureRecognizer *)recognizer
{
	if ([_delegate respondsToSelector:@selector(cycleScrollView:didSelectPageAtIndex:)]) {
		[_delegate cycleScrollView:self didSelectPageAtIndex:_currentPage];
	}
}

@end
