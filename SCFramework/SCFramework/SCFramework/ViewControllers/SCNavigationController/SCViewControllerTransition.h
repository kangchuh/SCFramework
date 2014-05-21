//
//  SCViewControllerTransition.h
//  SCFramework
//
//  Created by Angzn on 5/13/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import <Foundation/Foundation.h>

// 转场方向
typedef NS_ENUM(NSInteger, SCViewControllerTransitionDirection) {
    SCViewControllerTransitionDirectionHorizontal,
    SCViewControllerTransitionDirectionVertical,
};

// 转场动作
typedef NS_ENUM(NSInteger, SCViewControllerTransitionOperation) {
    SCViewControllerTransitionOperationNone = UINavigationControllerOperationNone,
    SCViewControllerTransitionOperationPush = UINavigationControllerOperationPush,
    SCViewControllerTransitionOperationPop = UINavigationControllerOperationPop,
};

/**
 *  视图控制器转场协议
 */
@protocol SCViewControllerTransition <NSObject>

/**
 *  @brief 转场方向
 */
- (SCViewControllerTransitionDirection)transitionDirection;

@end
