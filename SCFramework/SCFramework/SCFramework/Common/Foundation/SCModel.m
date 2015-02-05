//
//  SCModel.m
//  ZhongTouBang
//
//  Created by Angzn on 6/16/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import "SCModel.h"
#import "NSObject+SCAddition.h"
#import "NSDictionary+SCAddition.h"
#import "NSString+SCAddition.h"

#import <objc/runtime.h>

#pragma GCC diagnostic ignored "-Wgnu"

static NSString * const SCNSObjectAutocodingException = @"SCNSObjectAutocodingException";

@implementation SCModel

#pragma mark - NSSecureCoding

+ (BOOL)supportsSecureCoding
{
    return YES;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
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

- (instancetype)initWithPropertyDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        // Initialization code
        for (__unsafe_unretained NSString *key in [self codableProperties]) {
            id value = dictionary[key];
            if ( value ) {
                [self setValue:value forKey:key];
            }
        }
    }
    return self;
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    for (__unsafe_unretained NSString *key in [self codableProperties]) {
        id value = [self valueForKey:key];
        if ( value ) {
            dictionary[key] = value;
        } else {
            dictionary[key] = [NSNull null];
        }
    }
    return [NSDictionary dictionaryWithDictionary:dictionary];
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

- (NSDictionary *)JSONDictionary
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    for (__unsafe_unretained NSString *key in [self codableProperties]) {
        NSString *JSONKey = [self JSONKeyForPropertyKey:key];
        id value = [self valueForKey:key];
        if ( value ) {
            dictionary[JSONKey] = value;
        } else {
            dictionary[JSONKey] = [NSNull null];
        }
    }
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (NSString *)JSONKeyForPropertyKey:(NSString *)propertyKey
{
    NSParameterAssert(propertyKey != nil);
    
    if (![self.class respondsToSelector:@selector(JSONKeysByPropertyKey)]) {
        return propertyKey;
    }
    
    NSDictionary *JSONKeys = [self.class JSONKeysByPropertyKey];
    NSString *JSONKey = [JSONKeys stringForKey:propertyKey];
    
    return [JSONKey isNotEmpty] ? JSONKey : propertyKey;
}

@end
