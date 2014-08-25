//
//  NSObject+SCAddition.m
//  SCFramework
//
//  Created by Angzn on 3/28/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import "NSObject+SCAddition.h"
#import <objc/runtime.h>

NSString * const SCObjcTypeChar = @"char";
NSString * const SCObjcTypeInt = @"int";
NSString * const SCObjcTypeShort = @"short";
NSString * const SCObjcTypeInt32 = @"long int";
NSString * const SCObjcTypeInt64 = @"long long int";

NSString * const SCObjcTypeUChar = @"unsigned char";
NSString * const SCObjcTypeUInt = @"unsigned int";
NSString * const SCObjcTypeUShort = @"unsigned short";
NSString * const SCObjcTypeUInt32 = @"unsigned long int";
NSString * const SCObjcTypeUInt64 = @"unsigned long long int";

NSString * const SCObjcTypeFloat = @"float";
NSString * const SCObjcTypeDouble = @"double";

NSString * const SCObjcTypeBool = @"bool";

NSString * const SCObjcTypeCGPoint = @"CGPoint";
NSString * const SCObjcTypeCGSize = @"CGSize";
NSString * const SCObjcTypeCGRect = @"CGRect";

NSString * const SCObjcTypeNSDate   = @"NSDate";

NSString * const SCObjcTypeNSData   = @"NSData";

NSString * const SCObjcTypeNSString = @"NSString";

@implementation NSObject (SCAddition)

+ (NSDictionary *)codableProperties
{
    //deprecated
    SEL deprecatedSelector = NSSelectorFromString(@"codableKeys");
    if ([self respondsToSelector:deprecatedSelector] ||
        [self instancesRespondToSelector:deprecatedSelector])
    {
        DLog(@"AutoCoding Warning: codableKeys method is no longer supported."
             " Use codableProperties instead.");
    }
    deprecatedSelector = NSSelectorFromString(@"uncodableKeys");
    if ([self respondsToSelector:deprecatedSelector] ||
        [self instancesRespondToSelector:deprecatedSelector])
    {
        DLog(@"AutoCoding Warning: uncodableKeys method is no longer supported."
             " Use ivars, or synthesize your properties using non-KVC-compliant names to avoid coding them instead.");
    }
    deprecatedSelector = NSSelectorFromString(@"uncodableProperties");
    NSArray *uncodableProperties = nil;
    if ([self respondsToSelector:deprecatedSelector] ||
        [self instancesRespondToSelector:deprecatedSelector])
    {
        uncodableProperties = [self valueForKey:@"uncodableProperties"];
        DLog(@"AutoCoding Warning: uncodableProperties method is no longer supported."
             " Use ivars, or synthesize your properties using non-KVC-compliant names to avoid coding them instead.");
    }
    
    __autoreleasing NSMutableDictionary *codableProperties = [NSMutableDictionary dictionary];
    
    unsigned int propertyCount;
    objc_property_t *properties = class_copyPropertyList(self, &propertyCount);
    for (unsigned int i = 0; i < propertyCount; i++)
    {
        //get property name
        objc_property_t property = properties[i];
        const char *propertyName = property_getName(property);
        __autoreleasing NSString *key = @(propertyName);
        
        //check if codable
        if (![uncodableProperties containsObject:key])
        {
            //get property type
            Class propertyClass = nil;
            char *typeEncoding = property_copyAttributeValue(property, "T");
            switch (typeEncoding[0])
            {
                case '@':
                {
                    if (strlen(typeEncoding) >= 3)
                    {
                        char *className = strndup(typeEncoding + 2, strlen(typeEncoding) - 3);
                        __autoreleasing NSString *name = @(className);
                        NSRange range = [name rangeOfString:@"<"];
                        if (range.location != NSNotFound)
                        {
                            name = [name substringToIndex:range.location];
                        }
                        propertyClass = NSClassFromString(name) ?: [NSObject class];
                        free(className);
                    }
                    break;
                }
                case 'c':
                case 'i':
                case 's':
                case 'l':
                case 'q':
                case 'C':
                case 'I':
                case 'S':
                case 'L':
                case 'Q':
                case 'f':
                case 'd':
                case 'B':
                {
                    propertyClass = [NSNumber class];
                    break;
                }
                case '{':
                {
                    propertyClass = [NSValue class];
                    break;
                }
            }
            free(typeEncoding);
            
            if (propertyClass)
            {
                //check if there is a backing ivar
                char *ivar = property_copyAttributeValue(property, "V");
                if (ivar)
                {
                    //check if ivar has KVC-compliant name
                    __autoreleasing NSString *ivarName = @(ivar);
                    if ([ivarName isEqualToString:key] ||
                        [ivarName isEqualToString:[@"_" stringByAppendingString:key]])
                    {
                        //no setter, but setValue:forKey: will still work
                        codableProperties[key] = propertyClass;
                    }
                    free(ivar);
                }
                else
                {
                    //check if property is dynamic and readwrite
                    char *dynamic = property_copyAttributeValue(property, "D");
                    char *readonly = property_copyAttributeValue(property, "R");
                    if (dynamic && !readonly)
                    {
                        //no ivar, but setValue:forKey: will still work
                        codableProperties[key] = propertyClass;
                    }
                    free(dynamic);
                    free(readonly);
                }
            }
        }
    }
    free(properties);
    
    return codableProperties;
}

- (NSDictionary *)codableProperties
{
    __autoreleasing NSDictionary *codableProperties = objc_getAssociatedObject([self class], _cmd);
    if (!codableProperties)
    {
        codableProperties = [NSMutableDictionary dictionary];
        Class subclass = [self class];
        while (subclass != [NSObject class])
        {
            [(NSMutableDictionary *)codableProperties addEntriesFromDictionary:[subclass codableProperties]];
            subclass = [subclass superclass];
        }
        codableProperties = [NSDictionary dictionaryWithDictionary:codableProperties];
        
        //make the association atomically so that we don't need to bother with an @synchronize
        objc_setAssociatedObject([self class], _cmd, codableProperties, OBJC_ASSOCIATION_RETAIN);
    }
    return codableProperties;
}

+ (NSDictionary *)storableProperties
{
    __autoreleasing NSMutableDictionary *storableProperties = [NSMutableDictionary dictionary];
    
    unsigned int propertyCount;
    objc_property_t *properties = class_copyPropertyList(self, &propertyCount);
    for (unsigned int i = 0; i < propertyCount; i++)
    {
        //get property name
        objc_property_t property = properties[i];
        const char *propertyName = property_getName(property);
        __autoreleasing NSString *key = @(propertyName);
        
        //get property type
        NSString *propertyType = nil;
        char *typeEncoding = property_copyAttributeValue(property, "T");
        switch (typeEncoding[0])
        {
            case '@':
            {
                if (strlen(typeEncoding) >= 3)
                {
                    char *className = strndup(typeEncoding + 2, strlen(typeEncoding) - 3);
                    __autoreleasing NSString *name = @(className);
                    NSRange range = [name rangeOfString:@"<"];
                    if (range.location != NSNotFound)
                    {
                        name = [name substringToIndex:range.location];
                    }
                    propertyType = name ?: NSStringFromClass([NSObject class]);
                    free(className);
                }
                break;
            }
            case 'c':
            {
                propertyType = SCObjcTypeChar;
                break;
            }
            case 'i':
            {
                propertyType = SCObjcTypeInt;
                break;
            }
            case 's':
            {
                propertyType = SCObjcTypeShort;
                break;
            }
            case 'l':
            {
                propertyType = SCObjcTypeInt32;
                break;
            }
            case 'q':
            {
                propertyType = SCObjcTypeInt64;
                break;
            }
            case 'C':
            {
                propertyType = SCObjcTypeUChar;
                break;
            }
            case 'I':
            {
                propertyType = SCObjcTypeUInt;
                break;
            }
            case 'S':
            {
                propertyType = SCObjcTypeUShort;
                break;
            }
            case 'L':
            {
                propertyType = SCObjcTypeUInt32;
                break;
            }
            case 'Q':
            {
                propertyType = SCObjcTypeUInt64;
                break;
            }
            case 'f':
            {
                propertyType = SCObjcTypeFloat;
                break;
            }
            case 'd':
            {
                propertyType = SCObjcTypeDouble;
                break;
            }
            case 'B':
            {
                propertyType = SCObjcTypeBool;
                break;
            }
            case '{':
            {
                __autoreleasing NSString *type = @(typeEncoding);
                NSRange range = [type rangeOfString:@"="];
                if (range.location != NSNotFound)
                {
                    type = [type substringWithRange:NSMakeRange(1, range.location-1)];
                }
                propertyType = type;
                break;
            }
        }
        free(typeEncoding);
        
        if (propertyType)
        {
            //check if there is a backing ivar
            char *ivar = property_copyAttributeValue(property, "V");
            if (ivar)
            {
                //check if ivar has KVC-compliant name
                __autoreleasing NSString *ivarName = @(ivar);
                if ([ivarName isEqualToString:key] ||
                    [ivarName isEqualToString:[@"_" stringByAppendingString:key]])
                {
                    //no setter, but setValue:forKey: will still work
                    storableProperties[key] = propertyType;
                }
                free(ivar);
            }
            else
            {
                //check if property is dynamic and readwrite
                char *dynamic = property_copyAttributeValue(property, "D");
                char *readonly = property_copyAttributeValue(property, "R");
                if (dynamic && !readonly)
                {
                    //no ivar, but setValue:forKey: will still work
                    storableProperties[key] = propertyType;
                }
                free(dynamic);
                free(readonly);
            }
        }
    }
    free(properties);
    
    return storableProperties;
}

- (NSDictionary *)storableProperties
{
    __autoreleasing NSDictionary *storableProperties = objc_getAssociatedObject([self class], _cmd);
    if (!storableProperties)
    {
        storableProperties = [NSMutableDictionary dictionary];
        Class subclass = [self class];
        while (subclass != [NSObject class])
        {
            [(NSMutableDictionary *)storableProperties addEntriesFromDictionary:[subclass storableProperties]];
            subclass = [subclass superclass];
        }
        storableProperties = [NSDictionary dictionaryWithDictionary:storableProperties];
        
        //make the association atomically so that we don't need to bother with an @synchronize
        objc_setAssociatedObject([self class], _cmd, storableProperties, OBJC_ASSOCIATION_RETAIN);
    }
    return storableProperties;
}

@end
