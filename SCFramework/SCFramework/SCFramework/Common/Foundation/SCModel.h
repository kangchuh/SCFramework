//
//  SCModel.h
//  ZhongTouBang
//
//  Created by Angzn on 6/16/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCModel : NSObject
<
NSSecureCoding,
NSCopying
>

/**
 *  解析对象为字典
 *
 *  @return 对象所有字段键值对
 */
- (NSDictionary *)dictionaryRepresentation;

/**
 *  初始化对象
 *
 *  @param path 本地化文件路径
 */
+ (instancetype)objectWithContentsOfFile:(NSString *)path;

/**
 *  保存对象到文件
 *
 *  @param filePath         本地化文件路径
 *  @param useAuxiliaryFile 原子性
 *
 *  @return YES, 保存成功; NO, 保存失败
 */
- (BOOL)writeToFile:(NSString *)filePath atomically:(BOOL)useAuxiliaryFile;

@end
