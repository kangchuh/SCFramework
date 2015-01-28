//
//  UIDevice+SCAddition.h
//  SCFramework
//
//  Created by Angzn on 3/6/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (SCAddition)

/// 获取设备型号
+ (NSString *)deviceVersion;

/// 获取iOS系统的版本号
+ (NSString *)systemVersion;

/// 判断当前设备是否iPad
+ (BOOL)iPad;

/// 判断当前设备是否iPhone
+ (BOOL)iPhone;

/// 竖屏
+ (BOOL)portrait;

/// 横屏
+ (BOOL)landscape;

/// 判断当前系统是否有摄像头
+ (BOOL)hasCamera;

/// 获取用户语言
+ (NSString *)preferredLanguages;

/// 平台信息
+ (NSString *)platform;

/// 设备型号
+ (NSString *)deviceModel;

/// 获取手机内存总量, 返回的是字节数
+ (NSUInteger)totalMemoryBytes;
/// 获取手机可用内存, 返回的是字节数
+ (NSUInteger)freeMemoryBytes;

/// 获取手机硬盘空闲空间, 返回的是字节数
+ (long long)freeDiskSpaceBytes;
/// 获取手机硬盘总空间, 返回的是字节数
+ (long long)totalDiskSpaceBytes;

@end
