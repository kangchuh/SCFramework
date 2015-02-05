//
//  SCJSONSerializing.h
//  SCFramework
//
//  Created by Angzn on 2/5/15.
//  Copyright (c) 2015 Richer VC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SCJSONSerializing <NSObject>

@optional

/**
 *  @brief  返回属性字段名与JSON字段名键值对
 *
 *  @return {属性名字段:JSON字段名, ...}键值对
 */
+ (NSDictionary *)JSONKeysByPropertyKey;

@end
