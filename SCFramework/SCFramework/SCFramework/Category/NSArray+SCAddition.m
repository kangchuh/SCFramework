//
//  NSArray+SCAddition.m
//  SCFramework
//
//  Created by Angzn on 3/5/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import "NSArray+SCAddition.h"

@implementation NSArray (SCAddition)

/**
 *  @brief 判断是否为空
 */
- (BOOL)isNotEmpty
{
    return (![(NSNull *)self isEqual:[NSNull null]]
            && [self isKindOfClass:[NSArray class]]
            && self.count > 0);
}

@end


@implementation NSMutableArray(SCAddition)

+ (NSMutableArray *)arrayWithCapacity:(NSUInteger)capacity
                           withObject:(id)theObject
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:capacity];
    for (int i = 0; i < capacity; ++i) {
        [array addObject:theObject];
    }
    return array;
}

- (void)replaceAllObjectsWithObject:(id)theObject
{
    if (!self.isNotEmpty) {
        return;
    }
    if (!theObject) {
        return;
    }
    for (int i = 0; i < [self count]; ++i) {
        [self replaceObjectAtIndex:i withObject:theObject];
    }
}

- (void)replaceAllObjectsWithNULL
{
    [self replaceAllObjectsWithObject:[NSNull null]];
}

@end