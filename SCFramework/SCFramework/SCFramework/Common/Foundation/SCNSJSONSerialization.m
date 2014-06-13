//
//  SCNSJSONSerialization.m
//  ZhongTouBang
//
//  Created by Angzn on 6/11/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import "SCNSJSONSerialization.h"

@implementation SCNSJSONSerialization

+ (id)objectFromData:(NSData *)data
{
    return [self.class objectFromData:data error:nil];
}

+ (NSData *)dataFromObject:(id)object
{
    return [self.class dataFromObject:object error:nil];
}

+ (id)objectFromData:(NSData *)data error:(NSError **)error
{
    return [NSJSONSerialization JSONObjectWithData:data options:0 error:error];
}

+ (NSData *)dataFromObject:(id)object error:(NSError **)error
{
    return [NSJSONSerialization dataWithJSONObject:object options:0 error:error];
}

@end
