//
//  NSObject+SCAddition.m
//  SCFramework
//
//  Created by Angzn on 3/28/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import "NSObject+SCAddition.h"
#import <objc/runtime.h>

@implementation NSObject (SCAddition)

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ( (self = [self init]) ) {
        unsigned int ivarsCount = 0;
        Ivar *ivars = class_copyIvarList([self class], &ivarsCount);
        
        for ( int i = 0; i < ivarsCount; i++ ) {
            Ivar thisIvar = ivars[i];
            const char *ivarName = ivar_getName(thisIvar);
            NSString *key = [NSString stringWithUTF8String:ivarName];
            id value = [aDecoder decodeObjectForKey:key];
            [self setValue:value forKey:key];
        }
        
        free(ivars);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    unsigned int ivarsCount = 0;
    Ivar *ivars = class_copyIvarList([self class], &ivarsCount);
    
    for ( int i = 0; i < ivarsCount; i++ ) {
        Ivar thisIvar = ivars[i];
        const char *ivarName = ivar_getName(thisIvar);
        NSString *key = [NSString stringWithUTF8String:ivarName];
        id value = [self valueForKey:key];
        [aCoder encodeObject:value forKey:key];
    }
    
    free(ivars);
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    NSObject *copy = [[[self class] allocWithZone:zone] init];
    
    unsigned ivarsCount = 0;
    objc_property_t *properties = class_copyPropertyList([self class],
                                                         &ivarsCount);
    
    for ( int i = 0; i < ivarsCount; i++ ) {
        const char *propertyName = property_getName(properties[i]);
        NSString *key = [NSString stringWithUTF8String:propertyName];
        id value = [self valueForKey:key];
        if ( value ) {
            [copy setValue:value forKey:key];
        }
    }
    
    free(properties);
    
    return copy;
}

#pragma mark - Public Method

- (NSDictionary *)dictionaryValue
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    unsigned ivarsCount = 0;
    objc_property_t *properties = class_copyPropertyList([self class],
                                                         &ivarsCount);
    
    for ( int i = 0; i < ivarsCount; i++ ) {
        const char *propertyName = property_getName(properties[i]);
        NSString *key = [NSString stringWithUTF8String:propertyName];
        id value = [self valueForKey:key];
        if ( value ) {
            [dictionary setObject:value forKey:key];
        }
    }
    
    free(properties);
    
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

@end
