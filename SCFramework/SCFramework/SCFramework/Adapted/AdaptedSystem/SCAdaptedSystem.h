//
//  SCAdaptedSystem.h
//  SCFramework
//
//  Created by Angzn on 5/4/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  @brief 检查是否iOS7+
 */
extern BOOL SCiOS7OrLater(void);

/**
 *  @brief 检查是否iOS8+
 */
extern BOOL SCiOS8OrLater(void);

/**
 *  @brief 获取适配的坐标(此坐标是基于iOS7+的坐标系)
 */
CG_EXTERN CGRect CGRectAdapt(CGFloat x,
                             CGFloat y,
                             CGFloat width,
                             CGFloat height,
                             BOOL adaptedStatusBar,
                             BOOL adaptedNavBar,
                             BOOL adjustHeight);

@interface SCAdaptedSystem : NSObject

@end
