//
//  SCDBNavigationController.h
//  SCFramework
//
//  Created by Angzn on 5/14/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import "SCNavigationController.h"

typedef NS_ENUM(NSInteger, SCDBNavigationControllerInteractiveDragMode) {
    SCDBNavigationControllerInteractiveDragModeFadeOut,//淡出
    SCDBNavigationControllerInteractiveDragModeComeUp,//上浮
};

/**
 *  拖动返回导航控制器类
 *  
 *  在导航视图底部插入上一屏幕截图, 导航视图随拖动右移,
 *  手势结束时, 判断是否满足返回条件,
 *  满足条件, 完成返回; 反之.
 */
@interface SCDBNavigationController : SCNavigationController

/// 是否可以拖动返回, 默认为YES
@property (nonatomic, assign) BOOL canDragBack;

/// 交互拖动模式, 默认为FadeOut
@property (nonatomic, assign) SCDBNavigationControllerInteractiveDragMode interactiveMode;

- (instancetype)initWithNavigationBarClass:(Class)navigationBarClass;

@end
