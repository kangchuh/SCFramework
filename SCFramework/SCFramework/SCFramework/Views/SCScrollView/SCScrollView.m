//
//  SCScrollView.m
//  SCFramework
//
//  Created by Angzn on 3/6/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import "SCScrollView.h"

@implementation SCScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark - UIResponder Touch Event Methods

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ( _endEditingWhenTouch ) {
        [self endEditing:YES];
    }
    
    if ( _touchDelegate && [_touchDelegate respondsToSelector:
                            @selector(scrollView:touchEnded:withEvent:)] ) {
        [_touchDelegate scrollView:self
                        touchEnded:touches
                         withEvent:event];
    }
}

#pragma mark - UIScrollView Touch Event Methods

- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event
             inContentView:(UIView *)view
{
    if ( _endEditingWhenTouch ) {
        [self endEditing:YES];
    }
    
    if ( _touchDelegate && [_touchDelegate respondsToSelector:
                            @selector(scrollView:touchShouldBegin:withEvent:inContentView:)] ) {
        [_touchDelegate scrollView:self
                  touchShouldBegin:touches
                         withEvent:event
                     inContentView:view];
    }
    // 返回 YES, 立即发送 tracking events 到子视图, 响应子视图Touch事件;
    // NO 不发送(YES 不滚动, NO 滚动).
    return YES;
}

- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    // 返回 YES, 当触摸在子视图上时 ScrollView 可以滚动;
    // NO 当触摸在子视图上时 ScrollView 不可以滚动.
    return YES;
}

#pragma mark - Public Method

- (void)setPagingEnabled:(BOOL)pagingEnabled
{
    [super setPagingEnabled:pagingEnabled];
    
    if (self.pagingEnabled) {
        if (_pageDirection == SCScrollViewPageDirectionVertical) {
            self.contentSize = CGSizeMake(self.width, self.height*_numberOfPages);
        } else {
            self.contentSize = CGSizeMake(self.width*_numberOfPages, self.height);
        }
    } else {
        self.contentSize = CGSizeZero;
    }
}

- (void)setNumberOfPages:(NSInteger)numberOfPages
{
    _numberOfPages = numberOfPages;
    
    if (self.pagingEnabled) {
        if (_pageDirection == SCScrollViewPageDirectionVertical) {
            self.contentSize = CGSizeMake(self.width, self.height*_numberOfPages);
        } else {
            self.contentSize = CGSizeMake(self.width*_numberOfPages, self.height);
        }
    }
}

- (void)setPageDirection:(SCScrollViewPageDirection)pageDirection
{
    _pageDirection = pageDirection;
    
    if (self.pagingEnabled) {
        if (_pageDirection == SCScrollViewPageDirectionVertical) {
            self.contentSize = CGSizeMake(self.width, self.height*_numberOfPages);
        } else {
            self.contentSize = CGSizeMake(self.width*_numberOfPages, self.height);
        }
    }
}

- (NSInteger)currentPage
{
    if (self.pagingEnabled) {
        if (_pageDirection == SCScrollViewPageDirectionVertical) {
            return floor((self.contentOffset.y + self.height / 2.0) / self.height);
        } else {
            return floor((self.contentOffset.x + self.width / 2.0) / self.width);
        }
    } else {
        return 0;
    }
}

- (BOOL)isFirstPage
{
    return (self.currentPage == 0);
}

- (BOOL)isLastPage
{
    return (self.currentPage == self.numberOfPages - 1);
}

- (void)scrollToPreviousPage
{
    if (self.pagingEnabled) {
        CGPoint contentOffset = self.contentOffset;
        if (_pageDirection == SCScrollViewPageDirectionVertical) {
            if (contentOffset.y <= 0) {
                return;
            }
            contentOffset.y -= self.height;
        } else {
            if (contentOffset.x <= 0) {
                return;
            }
            contentOffset.x -= self.width;
        }
        self.contentOffset = contentOffset;
    }
}

- (void)scrollToNextPage
{
    if (self.pagingEnabled) {
        CGPoint contentOffset = self.contentOffset;
        if (_pageDirection == SCScrollViewPageDirectionVertical) {
            if (contentOffset.y >= self.contentSize.height - self.height) {
                return;
            }
            contentOffset.y += self.height;
        } else {
            if (contentOffset.x >= self.contentSize.width - self.width) {
                return;
            }
            contentOffset.x += self.width;
        }
        self.contentOffset = contentOffset;
    }
}

- (void)scrollToFirstPage
{
    if (self.pagingEnabled) {
        CGPoint contentOffset = self.contentOffset;
        if (_pageDirection == SCScrollViewPageDirectionVertical) {
            contentOffset.y = 0.0;
        } else {
            contentOffset.x = 0.0;
        }
        self.contentOffset = contentOffset;
    }
}

- (void)scrollToLastPage
{
    if (self.pagingEnabled) {
        CGPoint contentOffset = self.contentOffset;
        if (_pageDirection == SCScrollViewPageDirectionVertical) {
            contentOffset.y = self.contentSize.height - self.height;
        } else {
            contentOffset.x = self.contentSize.width - self.width;
        }
        self.contentOffset = contentOffset;
    }
}

@end
