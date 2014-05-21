//
//  NSDictionary+SCAddition.h
//  SCFramework
//
//  Created by Angzn on 3/5/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (SCAddition)

- (NSArray *)arrayForKey:(id)aKey;
- (NSDictionary *)dictionaryForKey:(id)aKey;

- (NSString *)stringForKey:(id)aKey;
- (NSInteger)integerForKey:(id)aKey;
- (int)intForKey:(id)aKey;
- (float)floatForKey:(id)aKey;
- (double)doubleForKey:(id)aKey;

@end
