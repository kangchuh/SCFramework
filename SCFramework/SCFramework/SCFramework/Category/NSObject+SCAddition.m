//
//  NSObject+SCAddition.m
//  SCFramework
//
//  Created by Angzn on 3/28/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import "NSObject+SCAddition.h"
#import <objc/runtime.h>

#pragma GCC diagnostic ignored "-Wgnu"

static NSString * const SCNSObjectAutocodingException = @"SCNSObjectAutocodingException";

@implementation NSObject (SCAddition)
/*
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
            if ( value ) {
                [self setValue:value forKey:key];
            }
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
        if ( value ) {
            [aCoder encodeObject:value forKey:key];
        }
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

- (NSDictionary *)dictionaryRepresentation
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
*/

#pragma mark - NSSecureCoding

+ (BOOL)supportsSecureCoding
{
    return YES;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [self init];
    if (self) {
        BOOL secureAvailable = [aDecoder respondsToSelector:@selector(decodeObjectOfClass:forKey:)];
        BOOL secureSupported = [[self class] supportsSecureCoding];
        
        NSDictionary *properties = [self codableProperties];
        for (NSString *key in properties) {
            id object = nil;
            Class propertyClass = properties[key];
            if (secureAvailable) {
                object = [aDecoder decodeObjectOfClass:propertyClass forKey:key];
            } else {
                object = [aDecoder decodeObjectForKey:key];
            }
            if (object) {
                if (secureSupported && ![object isKindOfClass:propertyClass]) {
                    [NSException raise:SCNSObjectAutocodingException
                                format:@"Expected '%@' to be a %@, but was actually a %@",
                     key, propertyClass, [object class]];
                }
                [self setValue:object forKey:key];
            }
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    for (NSString *key in [self codableProperties]) {
        id object = [self valueForKey:key];
        if (object) {
            [aCoder encodeObject:object forKey:key];
        }
    }
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];
    for (NSString *key in [self codableProperties]) {
        id object = [self valueForKey:key];
        if (object) {
            [copy setValue:object forKey:key];
        }
    }
    return copy;
}

#pragma mark - Public Method

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    for (__unsafe_unretained NSString *key in [self codableProperties]) {
        id value = [self valueForKey:key];
        if ( value ) {
            dictionary[key] = value;
        }
    }
    return dictionary;
}

+ (instancetype)objectWithContentsOfFile:(NSString *)filePath
{
    //load the file
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    //attempt to deserialise data as a plist
    id object = nil;
    if ( data ) {
        NSPropertyListFormat format;
        object = [NSPropertyListSerialization propertyListWithData:data
                                                           options:NSPropertyListImmutable
                                                            format:&format
                                                             error:NULL];
		//success?
		if ( object ) {
			//check if object is an NSCoded unarchive
			if ([object respondsToSelector:@selector(objectForKey:)] &&
                [(NSDictionary *)object objectForKey:@"$archiver"]) {
				object = [NSKeyedUnarchiver unarchiveObjectWithData:data];
			}
		} else {
			//return raw data
			object = data;
		}
    }
    
	//return object
	return object;
}

- (BOOL)writeToFile:(NSString *)filePath atomically:(BOOL)useAuxiliaryFile
{
    //Note: NSData, NSDictionary and NSArray already implement this method
    //and do not save using NSCoding, however the objectWithContentsOfFile
    //method will correctly recover these objects anyway
    
    //archive object
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    return [data writeToFile:filePath atomically:useAuxiliaryFile];
}

#pragma mark - Private Method

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

@end
