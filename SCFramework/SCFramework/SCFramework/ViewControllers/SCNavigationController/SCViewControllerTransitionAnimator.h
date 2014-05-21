//
//  SCViewControllerTransitionAnimator.h
//  SCFramework
//
//  Created by Angzn on 5/7/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SCViewControllerTransition.h"

/**
 *  视图控制器转场动画类
 */
@interface SCViewControllerTransitionAnimator : NSObject
<
UIViewControllerAnimatedTransitioning
>

/// 转场动画时间
@property (nonatomic) NSTimeInterval duration;

/// 转场方向
@property (nonatomic) SCViewControllerTransitionDirection direction;

/// 转场动作
@property (nonatomic) SCViewControllerTransitionOperation operation;

@end
