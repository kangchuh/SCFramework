//
//  SCModel.h
//  ZhongTouBang
//
//  Created by Angzn on 6/16/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SCJSONSerializing.h"

@interface SCModel : NSObject
<
SCJSONSerializing,
NSSecureCoding,
NSCopying
>

/**
 *  @brief  初始化对象
 *
 *  @param  dictionary 数据模型所有字段键值对
 *
 *  @return 数据模型对象
 */
- (instancetype)initWithPropertyDictionary:(NSDictionary *)dictionary;

/**
 *  @brief  解析数据模型为字典
 *
 *  @return 数据模型所有字段键值对
 */
- (NSDictionary *)dictionaryRepresentation;

/**
 *  @brief  初始化对象
 *
 *  @param  path 本地化文件路径
 *
 *  @return 数据模型对象
 */
+ (instancetype)objectWithContentsOfFile:(NSString *)path;

/**
 *  @brief  保存对象到文件
 *
 *  @param  filePath         本地化文件路径
 *  @param  useAuxiliaryFile 原子性
 *
 *  @return YES, 保存成功; NO, 保存失败
 */
- (BOOL)writeToFile:(NSString *)filePath atomically:(BOOL)useAuxiliaryFile;

/**
 *  @brief  解析数据模型为字典
 *
 *  @return JSON所有字段键值对
 */
- (NSDictionary *)JSONDictionary;

/**
 *  @brief  根据属性字段名获取JSON字段名
 *
 *  @param  propertyKey 属性字段名
 *
 *  @return JSON字段名
 */
- (NSString *)JSONKeyForPropertyKey:(NSString *)propertyKey;

@end
