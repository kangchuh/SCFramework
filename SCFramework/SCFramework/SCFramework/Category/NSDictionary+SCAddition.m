//
//  NSDictionary+SCAddition.m
//  SCFramework
//
//  Created by Angzn on 3/5/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import "NSDictionary+SCAddition.h"

@implementation NSDictionary (SCAddition)

- (NSArray *)arrayForKey:(id)aKey
{
    id object = [self objectForKey:aKey];
    if ([object isEqual:[NSNull null]]) {
        return nil;
    } else {
        if ([object isKindOfClass:[NSArray class]]) {
            return object;
        }
    }
    return nil;
}

- (NSDictionary *)dictionaryForKey:(id)aKey
{
    id object = [self objectForKey:aKey];
    if ([object isEqual:[NSNull null]]) {
        return nil;
    } else {
        if ([object isKindOfClass:[NSDictionary class]]) {
            return object;
        }
    }
    return nil;
}

- (NSString *)stringForKey:(id)aKey
{
    id object = [self objectForKey:aKey];
    if ([object isEqual:[NSNull null]]) {
        return nil;
    } else {
        if ([object isKindOfClass:[NSNumber class]]) {
            return [(NSNumber *)object stringValue];
        } else if ([object isKindOfClass:[NSString class]]) {
            return (NSString *)object;
        }
    }
    return nil;
}

- (NSInteger)integerForKey:(id)aKey
{
    id object = [self objectForKey:aKey];
    if ([object isEqual:[NSNull null]]) {
        return 0;
    } else {
        if ([object isKindOfClass:[NSString class]]) {
            return [(NSString *)object integerValue];
        } else if ([object isKindOfClass:[NSNumber class]]) {
            return [(NSNumber *)object integerValue];
        }
    }
    return 0;
}

- (int)intForKey:(id)aKey
{
    id object = [self objectForKey:aKey];
    if ([object isEqual:[NSNull null]]) {
        return (int)0;
    } else {
        if ([object isKindOfClass:[NSString class]]) {
            return [(NSString *)object intValue];
        } else if ([object isKindOfClass:[NSNumber class]]) {
            return [(NSNumber *)object intValue];
        }
    }
    return (int)0;
}

- (float)floatForKey:(id)aKey
{
    id object = [self objectForKey:aKey];
    if ([object isEqual:[NSNull null]]) {
        return (float)0;
    } else {
        if ([object isKindOfClass:[NSString class]]) {
            return [(NSString *)object floatValue];
        } else if ([object isKindOfClass:[NSNumber class]]) {
            return [(NSNumber *)object floatValue];
        }
    }
    return (float)0;
}

- (double)doubleForKey:(id)aKey
{
    id object = [self objectForKey:aKey];
    if ([object isEqual:[NSNull null]]) {
        return (double)0;
    } else {
        if ([object isKindOfClass:[NSString class]]) {
            return [(NSString *)object doubleValue];
        } else if ([object isKindOfClass:[NSNumber class]]) {
            return [(NSNumber *)object doubleValue];
        }
    }
    return (double)0;
}

- (NSString *)paramString
{
    NSMutableArray *paramPairs = [NSMutableArray array];
    
	for (NSString *key in [self keyEnumerator]) {
        id value = [self valueForKey:key];
		if ([value isKindOfClass:[NSString class]]) {
			[paramPairs addObject:[NSString stringWithFormat:@"%@=%@",
                                   key, [(NSString *)value URLEncodedString]]];
		} else if ([value isKindOfClass:[NSNumber class]]) {
            [paramPairs addObject:[NSString stringWithFormat:@"%@=%@",
                                   key, [(NSNumber *)value stringValue]]];
        }
	}
	
	return [paramPairs componentsJoinedByString:@"&"];
}

@end
