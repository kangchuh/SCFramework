//
//  SCLocationManager.h
//  SCFramework
//
//  Created by Angzn on 14/10/20.
//  Copyright (c) 2014年 Richer VC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

/**
 *  位置访问权限认证类型
 */
typedef NS_ENUM(NSUInteger, CLLocationManagerAuthorizationType) {
    /**
     *  使用期间使用位置
     */
    CLLocationManagerAuthorizationTypeWhenInUse,
    /**
     *  始终使用位置
     */
    CLLocationManagerAuthorizationTypeAlways,
} NS_ENUM_AVAILABLE_IOS(8_0);

@interface CLLocationManager (SCLocationManager)

/**
 *  @brief  位置访问权限认证类型
 *
 *  Discussion:
 *      By default, CLLocationManagerAuthorizationTypeWhenInUse is used.
 */
@property (nonatomic) CLLocationManagerAuthorizationType authorizationType NS_AVAILABLE_IOS(8_0);

@end


/**
 *  @brief  定位完成操作
 *
 *  @param locations 位置数组
 */
typedef void(^SCLocationManagerDidUpdateHandler)(NSArray *locations);

/**
 *  @brief  定位失败操作
 *
 *  @param error 错误信息
 */
typedef void(^SCLocationManagerDidFailHandler)(NSError *error);

/**
 *  @brief  定位配置操作
 *
 *  @param manager 定位管理类
 */
typedef void(^SCLocationManagerConfigHandler)(CLLocationManager *manager);

@interface SCLocationManager : NSObject

/**
 *  @brief  定位完成时停止更新位置
 *
 *  Discussion:
 *      By default, YES.
 */
@property (nonatomic, assign) BOOL stopWhenDidUpdate;

/**
 *  @brief  定位失败时停止更新位置
 *
 *  Discussion:
 *      By default, YES.
 */
@property (nonatomic, assign) BOOL stopWhenDidFail;

/**
 *  @brief  定位失败时显示提示警告
 *
 *  Discussion:
 *      By default, YES.
 */
@property (nonatomic, assign) BOOL alertWhenDidFail;

+ (SCLocationManager *)sharedInstance;

- (void)startLocateWithConfig:(SCLocationManagerConfigHandler)configHandler
                    didUpdate:(SCLocationManagerDidUpdateHandler)didUpdateHandler
                      didFail:(SCLocationManagerDidFailHandler)didFailHandler;

@end
