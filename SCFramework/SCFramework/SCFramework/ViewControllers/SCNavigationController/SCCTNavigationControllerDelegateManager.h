//
//  SCCTNavigationControllerDelegateManager.h
//  SCFramework
//
//  Created by Angzn on 5/13/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  导航控制器委托管理类
 */
@interface SCCTNavigationControllerDelegateManager : NSObject
<
UINavigationControllerDelegate
>

/// 手势交互转场动画
@property (strong, nonatomic) UIPercentDrivenInteractiveTransition *interactiveAnimator;

@end
