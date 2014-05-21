//
//  SCCTNavigationController.h
//  SCFramework
//
//  Created by Angzn on 5/12/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import "SCNavigationController.h"

#if __IPHONE_OS_VERSION_MIN_REQUIRED < 70000
#warning 该导航控制器只支持iOS7及以上SDK
#endif

#import "SCViewControllerTransition.h"
#import "SCCTNavigationControllerDelegateManager.h"

/**
 *  自定义返回手势及转场动画导航控制器类(iOS7+), 使用iOS7的转场动画实现
 */
@interface SCCTNavigationController : SCNavigationController
<
SCViewControllerTransition
>

/// 转场方向
@property (assign, nonatomic) SCViewControllerTransitionDirection direction;

/// 委托管理对象
@property (strong, nonatomic) SCCTNavigationControllerDelegateManager *delegateManager;

@end
