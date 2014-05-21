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
    
    if ( _touchDelegate &&
        [_touchDelegate respondsToSelector:
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
    
    if ( _touchDelegate &&
        [_touchDelegate respondsToSelector:
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

@end