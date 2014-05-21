//
//  SCAdaptedSystem.m
//  SCFramework
//
//  Created by Angzn on 5/4/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import "SCAdaptedSystem.h"
#import "SCConstant.h"
#import "SCLog.h"

/**
 *  @brief 检查是否iOS7坐标系
 */
BOOL SCiOS7OrLater(void)
{
    static BOOL iOS7OrLater;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
        //iOS7OrLater = YES;
        CGFloat systemVersion = [[[UIDevice currentDevice] systemVersion]
                                 doubleValue];
        if (systemVersion >= 7.f) {
            iOS7OrLater = YES;
        } else {
            iOS7OrLater = NO;
        }
#else
        iOS7OrLater = NO;
#endif
    });
    DLog(@"%@%@", @"iOS 7 Or Later : ", iOS7OrLater ? @"YES" : @"NO");
    return iOS7OrLater;
}

/**
 *  @brief 获取适配的坐标(此坐标是基于iOS7的坐标系)
 *
 *  @param x                x 坐标
 *  @param y                y 坐标
 *  @param width            宽度
 *  @param height           高度
 *  @param adaptedStatusBar 是否适配状态栏(YES, 高度在Y坐标计算范围内; 反之)
 *  @param adaptedNavBar    是否适配导航栏(YES, 高度在Y坐标计算范围内; 反之)
 *  @param adjustHeight     是否自适应高度
 *
 *  @return 适配的坐标
 */
CGRect CGRectAdapt(CGFloat x,
                   CGFloat y,
                   CGFloat width,
                   CGFloat height,
                   BOOL adaptedStatusBar,
                   BOOL adaptedNavBar,
                   BOOL adjustHeight)
{
    BOOL iOS7OrLater = SCiOS7OrLater();
    
    CGRect rect;
    rect.origin.x = x;
    rect.size.width = width;
    if (iOS7OrLater) {
        rect.origin.y = y;
        rect.size.height = height;
    } else {
        if (adaptedStatusBar && !adaptedNavBar) {
            rect.origin.y = y - kSCFW_STATUSBAR_HEIGHT;
        } else if (adaptedStatusBar && adaptedNavBar) {
            rect.origin.y = y - (kSCFW_STATUSBAR_HEIGHT +
                                 kSCFW_NAVIGATIONBAR_HEIGHT);
        } else {
            rect.origin.y = y;
        }
        if (adjustHeight && adaptedStatusBar && !adaptedNavBar) {
            rect.size.height = height + kSCFW_STATUSBAR_HEIGHT;
        } else if (adjustHeight && adaptedStatusBar && adaptedNavBar) {
            rect.size.height = height + (kSCFW_STATUSBAR_HEIGHT +
                                         kSCFW_NAVIGATIONBAR_HEIGHT);
        } else {
            rect.size.height = height;
        }
    }
    return rect;
}

@implementation SCAdaptedSystem

@end
