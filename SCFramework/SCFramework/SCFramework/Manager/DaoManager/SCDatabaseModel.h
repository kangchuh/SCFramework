//
//  SCDatabaseModel.h
//  ZhongTouBang
//
//  Created by Angzn on 8/22/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SCDatabaseModel <NSObject>

@required
/**
 *  @brief  数据库表名称
 */
+ (NSString *)tableName;

@optional
/**
 *  @brief  数据库表主键
 *
 *  @discussion 支持单主键和多主键, 多主键用逗号隔开
 */
+ (NSString *)primaryKey;

@end
