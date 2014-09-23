//
//  SCActionView.m
//  SCFramework
//
//  Created by Angzn on 9/19/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import "SCActionView.h"

const static CGFloat SCActionViewAnimationDuration = 0.25;

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
    [self dismiss];
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
    if (actionAnimations == SCViewActionAnimationActionSheet) {
        [view.window addSubview:self.mask];
        [view addSubview:self];
        self.top = view.height;
    }
}

- (void(^)(void))showInView:(UIView *)view animationsForAction:(SCViewActionAnimations)actionAnimations
{
    __weak __typeof(&*self)weakSelf = self;
    void(^animations)(void) = NULL;
    if (actionAnimations == SCViewActionAnimationActionSheet) {
        animations = ^(void) {
            weakSelf.mask.alpha = SCActionViewMaskShowAlpha;
            weakSelf.top = view.height - weakSelf.height;
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
            UIView *view = self.superview;
            weakSelf.mask.alpha = SCActionViewMaskDismissAlpha;
            weakSelf.top = view.height;
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
    }
    return completion;
}

@end
