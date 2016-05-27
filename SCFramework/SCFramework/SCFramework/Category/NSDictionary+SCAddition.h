//
//  NSDictionary+SCAddition.h
//  SCFramework
//
//  Created by Angzn on 3/5/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (SCAddition)

- (BOOL)isNotEmpty;

- (NSArray *)arrayForKey:(id)aKey;
- (NSDictionary *)dictionaryForKey:(id)aKey;

- (NSString *)stringForKey:(id)aKey;
- (NSInteger)integerForKey:(id)aKey;
- (int)intForKey:(id)aKey;
- (float)floatForKey:(id)aKey;
- (double)doubleForKey:(id)aKey;
- (BOOL)boolForKey:(id)aKey;

- (NSArray *)sc_arrayForKey:(id)aKey;
- (NSDictionary *)sc_dictionaryForKey:(id)aKey;

- (NSString *)sc_stringForKey:(id)aKey;
- (NSInteger)sc_integerForKey:(id)aKey;
- (int)sc_intForKey:(id)aKey;
- (float)sc_floatForKey:(id)aKey;
- (double)sc_doubleForKey:(id)aKey;
- (BOOL)sc_boolForKey:(id)aKey;

- (NSString *)paramString;

@end
