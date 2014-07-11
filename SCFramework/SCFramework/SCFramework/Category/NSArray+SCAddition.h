//
//  NSArray+SCAddition.h
//  SCFramework
//
//  Created by Angzn on 3/5/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (SCAddition)

- (BOOL)isNotEmpty;

@end


@interface NSMutableArray(SCAddition)

+ (NSMutableArray *)arrayWithCapacity:(NSUInteger)capacity
                           withObject:(id)theObject;

- (void)replaceAllObjectsWithObject:(id)theObject;
- (void)replaceAllObjectsWithNULL;

@end