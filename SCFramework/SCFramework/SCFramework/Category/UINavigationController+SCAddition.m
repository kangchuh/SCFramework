//
//  UINavigationController+SCAddition.m
//  SCFramework
//
//  Created by Angzn on 5/8/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import "UINavigationController+SCAddition.h"

@implementation UINavigationController (SCAddition)

- (BOOL)isOnlyContainRootViewController
{
    if (self.viewControllers.isNotEmpty &&
        self.viewControllers.count == 1) {
        return YES;
    }
    return NO;
}

- (UIViewController *)rootViewController
{
    if (self.viewControllers.isNotEmpty) {
        return [self.viewControllers firstObject];
    }
    return nil;
}

- (NSArray *)popToViewControllerWithClass:(Class)viewControllerClass animated:(BOOL)animated
{
    NSInteger viewControllersCount = self.viewControllers.count;
    for (int i = viewControllersCount - 1; i >= 0; --i) {
        UIViewController *viewController = self.viewControllers[i];
        if ([viewController isKindOfClass:viewControllerClass]) {
            return [self popToViewController:viewController animated:animated];
        }
    }
    return nil;
}

- (NSArray *)popToViewControllerWithLevel:(NSInteger)level animated:(BOOL)animated
{
    NSInteger viewControllersCount = self.viewControllers.count;
    if (viewControllersCount > level) {
        NSInteger idx = viewControllersCount - level - 1;
        UIViewController *viewController = self.viewControllers[idx];
        return [self popToViewController:viewController animated:animated];
    } else {
        return [self popToRootViewControllerAnimated:animated];
    }
}

@end
