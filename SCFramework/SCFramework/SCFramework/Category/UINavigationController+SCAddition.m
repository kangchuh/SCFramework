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

@end
