//
//  UINavigationController+SCAddition.h
//  SCFramework
//
//  Created by Angzn on 5/8/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (SCAddition)

- (BOOL)isOnlyContainRootViewController;
- (UIViewController *)rootViewController;

- (NSArray *)popToViewControllerWithClass:(Class)viewControllerClass animated:(BOOL)animated;
- (NSArray *)popToViewControllerWithLevel:(NSInteger)level animated:(BOOL)animated;

@end
