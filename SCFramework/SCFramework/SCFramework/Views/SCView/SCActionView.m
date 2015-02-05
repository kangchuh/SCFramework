//
//  SCActionView.m
//  SCFramework
//
//  Created by Angzn on 9/19/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import "SCActionView.h"

const static CGFloat SCActionViewAnimationDuration = 0.25;

const static CGFloat SCActionViewAnimationShowAlpha = 1.0;
const static CGFloat SCActionViewAnimationDismissAlpha = 0.0;

const static CGFloat SCActionViewMaskShowAlpha = 0.5;
const static CGFloat SCActionViewMaskDismissAlpha = 0.0;

@interface SCActionView ()

@property (nonatomic, strong) UIControl *mask;

@property (nonatomic) BOOL visible;

@end

@implementation SCActionView

#pragma mark - Init Method

- (void)initialize
{
    self.duration = SCActionViewAnimationDuration;
    self.animationOptions = UIViewAnimationOptionCurveEaseInOut;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

#pragma mark - Override Method

- (UIControl *)mask
{
    if (!_mask) {
        _mask = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _mask.backgroundColor = [UIColor blackColor];
        _mask.alpha = SCActionViewMaskDismissAlpha;
        [_mask addTarget:self
                  action:@selector(cancel)
        forControlEvents:UIControlEventTouchUpInside];
    }
    return _mask;
}

#pragma mark - Action Method

- (void)cancel
{
    if (_willTapCancelHandler) {
        BOOL canCancel = _willTapCancelHandler();
        if (!canCancel) {
            return;
        }
    }
    
    [self dismiss];
    
    if (_didTapCancelHandler) {
        _didTapCancelHandler();
    }
}

#pragma mark - Public Method

- (void)showInView:(UIView *)view
{
    if (self.isVisible) {
        if (view == self.superview) {
            return;
        } else {
            [self dismiss];
        }
    }
    
    [self showInView:view beginForAction:_actionAnimations];
    
    [UIView animateWithDuration:_duration
                          delay:_delay
                        options:_animationOptions
                     animations:[self showInView:view animationsForAction:_actionAnimations]
                     completion:[self showInView:view completionForAction:_actionAnimations]];
}

- (void)dismiss
{
    [UIView animateWithDuration:_duration
                          delay:_delay
                        options:_animationOptions
                     animations:[self dismissAnimationsForAction:_actionAnimations]
                     completion:[self dismissCompletionForAction:_actionAnimations]];
}

#pragma mark - Private Method

- (void)showInView:(UIView *)view beginForAction:(SCViewActionAnimations)actionAnimations
{
    UIWindow *window = view.window;
    if (actionAnimations == SCViewActionAnimationActionSheet) {
        self.top = window.height;
    } else if (actionAnimations == SCViewActionAnimationAlert) {
        self.center = window.middle;
        self.alpha = SCActionViewAnimationDismissAlpha;
    }
    [window addSubview:self.mask];
    [window addSubview:self];
}

- (void(^)(void))showInView:(UIView *)view animationsForAction:(SCViewActionAnimations)actionAnimations
{
    __weak __typeof(&*self)weakSelf = self;
    void(^animations)(void) = NULL;
    if (actionAnimations == SCViewActionAnimationActionSheet) {
        animations = ^(void) {
            UIWindow *window = view.window;
            weakSelf.mask.alpha = SCActionViewMaskShowAlpha;
            weakSelf.top = window.height - weakSelf.height;
        };
    } else if (actionAnimations == SCViewActionAnimationAlert) {
        animations = ^(void) {
            weakSelf.mask.alpha = SCActionViewMaskShowAlpha;
            weakSelf.alpha = SCActionViewAnimationShowAlpha;
        };
    }
    return animations;
}

- (void(^)(void))dismissAnimationsForAction:(SCViewActionAnimations)actionAnimations
{
    __weak __typeof(&*self)weakSelf = self;
    void(^animations)(void) = NULL;
    if (actionAnimations == SCViewActionAnimationActionSheet) {
        animations = ^(void) {
            UIWindow *window = weakSelf.window;
            weakSelf.mask.alpha = SCActionViewMaskDismissAlpha;
            weakSelf.top = window.height;
        };
    } else if (actionAnimations == SCViewActionAnimationAlert) {
        animations = ^(void) {
            weakSelf.mask.alpha = SCActionViewMaskDismissAlpha;
            weakSelf.alpha = SCActionViewAnimationDismissAlpha;
        };
    }
    return animations;
}

- (void(^)(BOOL finished))showInView:(UIView *)view completionForAction:(SCViewActionAnimations)actionAnimations
{
    __weak __typeof(&*self)weakSelf = self;
    void(^completion)(BOOL finished) = NULL;
    if (actionAnimations == SCViewActionAnimationActionSheet) {
        completion = ^(BOOL finished) {
            weakSelf.visible = YES;
        };
    } else if (actionAnimations == SCViewActionAnimationAlert) {
        completion = ^(BOOL finished) {
            weakSelf.visible = YES;
        };
    }
    return completion;
}

- (void(^)(BOOL finished))dismissCompletionForAction:(SCViewActionAnimations)actionAnimations
{
    __weak __typeof(&*self)weakSelf = self;
    void(^completion)(BOOL finished) = NULL;
    if (actionAnimations == SCViewActionAnimationActionSheet) {
        completion = ^(BOOL finished) {
            [weakSelf.mask removeFromSuperview];
            [weakSelf removeFromSuperview];
            weakSelf.visible = NO;
        };
    } else if (actionAnimations == SCViewActionAnimationAlert) {
        completion = ^(BOOL finished) {
            [weakSelf.mask removeFromSuperview];
            [weakSelf removeFromSuperview];
            weakSelf.visible = NO;
        };
    }
    return completion;
}

@end
