//
//  SCNSJSONSerialization.h
//  ZhongTouBang
//
//  Created by Angzn on 6/11/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCNSJSONSerialization : NSObject

+ (id)objectFromData:(NSData *)data;
+ (NSData *)dataFromObject:(id)object;

+ (id)objectFromData:(NSData *)data error:(NSError **)error;
+ (NSData *)dataFromObject:(id)object error:(NSError **)error;

+ (id)objectFromString:(NSString *)string;
+ (NSString *)stringFromObject:(id)object;

+ (id)objectFromString:(NSString *)string error:(NSError **)error;
+ (NSString *)stringFromObject:(id)object error:(NSError **)error;

@end
