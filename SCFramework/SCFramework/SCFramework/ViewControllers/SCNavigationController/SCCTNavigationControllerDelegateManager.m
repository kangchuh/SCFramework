//
//  SCCTNavigationControllerDelegateManager.m
//  SCFramework
//
//  Created by Angzn on 5/13/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import "SCCTNavigationControllerDelegateManager.h"

#import "SCViewControllerTransitionAnimator.h"

@interface SCCTNavigationControllerDelegateManager ()

/// 控制器转场动画
@property (strong, nonatomic) SCViewControllerTransitionAnimator *transitionAnimator;

@end

@implementation SCCTNavigationControllerDelegateManager

#pragma mark - Init Method

- (instancetype)init
{
    self = [super init];
    if (self) {
        _transitionAnimator = [[SCViewControllerTransitionAnimator alloc] init];
    }
    return self;
}

#pragma mark - UINavigationControllerDelegate

- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController
{
    return _interactiveAnimator;
}

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC
{
    
    if ([navigationController isKindOfClass:[SCCTNavigationController class]] ||
        [navigationController isMemberOfClass:[SCCTNavigationController class]]) {
        SCCTNavigationController *navigationVC = (SCCTNavigationController *)navigationController;
        if ([navigationVC respondsToSelector:@selector(transitionDirection)]) {
            _transitionAnimator.direction = [navigationVC transitionDirection];
        }
    }
    _transitionAnimator.operation = (SCViewControllerTransitionOperation)operation;
    return _transitionAnimator;
}

@end
