//
//  SCViewControllerTransitionAnimator.m
//  SCFramework
//
//  Created by Angzn on 5/7/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import "SCViewControllerTransitionAnimator.h"
#import "UIView+SCAddition.h"

// 默认转场动画时间
static const CGFloat kSCTransitionDurationDefault = 0.30;

// 转场宽度
static const CGFloat kSCTransitionWidth = 180.0;

// 转场缩放比例
static const CGFloat kSCTransitionScale = 0.9;

@implementation SCViewControllerTransitionAnimator

#pragma mark - Init Method

- (void)defaultInit
{
    _duration = kSCTransitionDurationDefault;
    _direction = SCViewControllerTransitionDirectionHorizontal;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self defaultInit];
    }
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning

/**
 *  @brief 转场动画持续时间
 */
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return _duration;
}

/**
 *  @brief 转场动画
 */
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    if (_direction == SCViewControllerTransitionDirectionHorizontal &&
        _operation == SCViewControllerTransitionOperationPush) {
        [self animationHorizontalPush:transitionContext];
    } else if (_direction == SCViewControllerTransitionDirectionHorizontal &&
               _operation == SCViewControllerTransitionOperationPop) {
        [self animationHorizontalPop:transitionContext];
    } else if (_direction == SCViewControllerTransitionDirectionVertical &&
               _operation == SCViewControllerTransitionOperationPush) {
        [self animationVerticalPush:transitionContext];
    } else if (_direction == SCViewControllerTransitionDirectionVertical &&
               _operation == SCViewControllerTransitionOperationPop) {
        [self animationVerticalPop:transitionContext];
    }
}

#pragma mark - Private Method

/**
 *  @brief 横向Push动画
 */
- (void)animationHorizontalPush:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toVC   = [transitionContext viewControllerForKey:
                                UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:
                                UITransitionContextFromViewControllerKey];
    
    UIView *toView   = toVC.view;
    UIView *fromView = fromVC.view;
    UITabBar *tabBar = fromVC.tabBarController.tabBar;
    
    UIView *tabBarSuperView = tabBar.superview;
    
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:tabBar];
    [containerView addSubview:toView];
    
    toView.transform = CGAffineTransformMakeTranslation(toView.width, 0);
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         fromView.transform = CGAffineTransformMakeTranslation(-kSCTransitionWidth, 0);
                         toView.transform = CGAffineTransformIdentity;
                         tabBar.transform = CGAffineTransformMakeTranslation(tabBar.width - kSCTransitionWidth, 0);
                     }
                     completion:^(BOOL finished) {
                         fromView.transform = CGAffineTransformIdentity;
                         toView.transform = CGAffineTransformIdentity;
                         tabBar.transform = CGAffineTransformIdentity;
                         tabBar.left = 0.0;
                         [tabBarSuperView addSubview:tabBar];
                         BOOL cancelled = [transitionContext transitionWasCancelled];
                         [transitionContext completeTransition:!cancelled];
                     }];
}

/**
 *  @brief 横向Pop动画
 */
- (void)animationHorizontalPop:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toVC   = [transitionContext viewControllerForKey:
                                UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:
                                UITransitionContextFromViewControllerKey];
    
    UIView *toView   = toVC.view;
    UIView *fromView = fromVC.view;
    UITabBar *tabBar = toVC.tabBarController.tabBar;
    
    UIView *tabBarSuperView = tabBar.superview;
    
    UIView *containerView = [transitionContext containerView];
    [containerView insertSubview:toView belowSubview:fromView];
    [containerView insertSubview:tabBar belowSubview:fromView];
    
    toView.transform = CGAffineTransformMakeTranslation(-kSCTransitionWidth, 0);
    tabBar.left = -kSCTransitionWidth;
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         fromView.transform = CGAffineTransformMakeTranslation(fromView.width, 0);
                         toView.transform = CGAffineTransformIdentity;
                         tabBar.left = 0.0;
                     }
                     completion:^(BOOL finished) {
                         fromView.transform = CGAffineTransformIdentity;
                         toView.transform = CGAffineTransformIdentity;
                         tabBar.left = 0.0;
                         [tabBarSuperView addSubview:tabBar];
                         BOOL cancelled = [transitionContext transitionWasCancelled];
                         [transitionContext completeTransition:!cancelled];
                     }];
}

/**
 *  @brief 纵向Push动画
 */
- (void)animationVerticalPush:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toVC   = [transitionContext viewControllerForKey:
                                UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:
                                UITransitionContextFromViewControllerKey];
    
    UIView *toView   = toVC.view;
    UIView *fromView = fromVC.view;
    UITabBar *tabBar = fromVC.tabBarController.tabBar;
    
    UIView *tabBarSuperView = tabBar.superview;
    
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:tabBar];
    [containerView addSubview:toView];
    
    //toView.transform = CGAffineTransformMakeTranslation(0, toView.height);
    toView.transform = CGAffineTransformMakeScale(0.0, 0.0);
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         fromView.transform = CGAffineTransformMakeScale(kSCTransitionScale, kSCTransitionScale);
                         toView.transform = CGAffineTransformIdentity;
                         tabBar.transform = CGAffineTransformMakeTranslation(tabBar.width, 0);
                     }
                     completion:^(BOOL finished) {
                         fromView.transform = CGAffineTransformIdentity;
                         toView.transform = CGAffineTransformIdentity;
                         tabBar.transform = CGAffineTransformIdentity;
                         tabBar.left = 0.0;
                         [tabBarSuperView addSubview:tabBar];
                         BOOL cancelled = [transitionContext transitionWasCancelled];
                         [transitionContext completeTransition:!cancelled];
                     }];
}

/**
 *  @brief 纵向Pop动画
 */
- (void)animationVerticalPop:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toVC   = [transitionContext viewControllerForKey:
                                UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:
                                UITransitionContextFromViewControllerKey];
    
    UIView *toView   = toVC.view;
    UIView *fromView = fromVC.view;
    UITabBar *tabBar = toVC.tabBarController.tabBar;
    
    UIView *tabBarSuperView = tabBar.superview;
    
    UIView *containerView = [transitionContext containerView];
    [containerView insertSubview:toView belowSubview:fromView];
    [containerView insertSubview:tabBar belowSubview:fromView];
    
    toView.transform = CGAffineTransformMakeScale(kSCTransitionScale, kSCTransitionScale);
    tabBar.left = 0.0;
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         //fromView.transform = CGAffineTransformMakeTranslation(0, fromView.height);
                         fromView.transform = CGAffineTransformMakeScale(0.0, 0.0);
                         toView.transform = CGAffineTransformIdentity;
                     }
                     completion:^(BOOL finished) {
                         fromView.transform = CGAffineTransformIdentity;
                         toView.transform = CGAffineTransformIdentity;
                         tabBar.left = 0.0;
                         [tabBarSuperView addSubview:tabBar];
                         BOOL cancelled = [transitionContext transitionWasCancelled];
                         [transitionContext completeTransition:!cancelled];
                     }];
}

@end
