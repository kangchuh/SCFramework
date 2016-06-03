//
//  SCActionView.m
//  SCFramework
//
//  Created by Angzn on 9/19/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import "SCActionView.h"

#import "UIView+SCAddition.h"

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
        _mask = [[UIControl alloc] initWithFrame:CGRectZero];
        _mask.backgroundColor = [UIColor blackColor];
        _mask.alpha = SCActionViewMaskDismissAlpha;
        _mask.autoresizingMask = (UIViewAutoresizingFlexibleWidth |
                                  UIViewAutoresizingFlexibleHeight);
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

- (void)setTapCancelDisabled:(BOOL)tapCancelDisabled
{
    _tapCancelDisabled = tapCancelDisabled;
    self.mask.enabled = !tapCancelDisabled;
}

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
    UIView *containerView = [self viewForShowIn:view];
    self.mask.size = containerView.orientationSize;
    self.mask.center = containerView.orientationMiddle;
    if (actionAnimations == SCViewActionAnimationActionSheet) {
        self.top = containerView.orientationHeight;
        self.width = containerView.orientationWidth;
        self.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin |
                                 UIViewAutoresizingFlexibleWidth);
    } else if (actionAnimations == SCViewActionAnimationAlert) {
        self.center = containerView.orientationMiddle;
        self.alpha = SCActionViewAnimationDismissAlpha;
        self.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
                                 UIViewAutoresizingFlexibleTopMargin |
                                 UIViewAutoresizingFlexibleRightMargin |
                                 UIViewAutoresizingFlexibleBottomMargin);
    }
    [containerView addSubview:self.mask];
    [containerView addSubview:self];
}

- (void(^)(void))showInView:(UIView *)view animationsForAction:(SCViewActionAnimations)actionAnimations
{
    __weak __typeof(&*self)weakSelf = self;
    void(^animations)(void) = NULL;
    if (actionAnimations == SCViewActionAnimationActionSheet) {
        animations = ^(void) {
            UIView *containerView = [self viewForShowIn:view];
            weakSelf.mask.alpha = SCActionViewMaskShowAlpha;
            weakSelf.top = containerView.orientationHeight - weakSelf.height;
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
            UIView *containerView = self.superview;
            weakSelf.mask.alpha = SCActionViewMaskDismissAlpha;
            weakSelf.top = containerView.orientationHeight;
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

#pragma mark - Rotate Orientation

- (UIView *)viewForShowIn:(UIView *)view
{
    UIWindow *window = view.window;
    UIView *windowView = [window.subviews firstObject];
    return windowView ?: view;
}

@end
