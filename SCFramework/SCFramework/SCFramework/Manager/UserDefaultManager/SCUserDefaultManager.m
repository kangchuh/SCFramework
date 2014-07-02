//
//  SCUserDefaultManager.m
//  SCFramework
//
//  Created by Angzn on 3/6/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import "SCUserDefaultManager.h"
#import "SCSingleton.h"

@interface SCUserDefaultManager ()

@property (nonatomic, weak) NSUserDefaults *userDefaults;

@end


@implementation SCUserDefaultManager

SCSINGLETON(SCUserDefaultManager);

- (id)init
{
    self = [super init];
    if (self) {
        _userDefaults = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

#pragma mark - Get Methods

- (BOOL)getBoolForKey:(NSString *)key
{
    return [_userDefaults boolForKey:key];
}

- (NSInteger)getIntegerForKey:(NSString *)key
{
    return [_userDefaults integerForKey:key];
}

- (id)getObjectForKey:(NSString *)key
{
    return [_userDefaults objectForKey:key];
}

- (NSString *)getStringForKey:(NSString *)key
{
    return [_userDefaults stringForKey:key];
}

- (NSArray *)getArrayForKey:(NSString *)key
{
    return [_userDefaults arrayForKey:key];
}

- (NSDictionary *)getDictionaryForKey:(NSString *)key
{
    return [_userDefaults dictionaryForKey:key];
}

- (NSData *)getDataForKey:(NSString *)key
{
    return [_userDefaults dataForKey:key];
}

- (float)getFloatForKey:(NSString *)key
{
    return [_userDefaults floatForKey:key];
}

- (double)getDoubleForKey:(NSString *)key
{
    return [_userDefaults doubleForKey:key];
}

- (NSURL *)getURLForKey:(NSString *)key
{
    return [_userDefaults URLForKey:key];
}

- (SCModel *)getModelForKey:(NSString *)key
{
    NSData *data = [_userDefaults objectForKey:key];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

#pragma mark - Set Methods

- (void)setBool:(BOOL)bValue forKey:(NSString *)key
{
    [_userDefaults setBool:bValue forKey:key];
    [_userDefaults synchronize];
}

- (void)setInteger:(NSInteger)iVaule forKey:(NSString *)key
{
    [_userDefaults setInteger:iVaule forKey:key];
    [_userDefaults synchronize];
}

- (void)setObject:(id)objValue forKey:(NSString *)key
{
    [_userDefaults setObject:objValue forKey:key];
    [_userDefaults synchronize];
}

- (void)setFloat:(float)fValue forKey:(NSString *)key
{
    [_userDefaults setFloat:fValue forKey:key];
    [_userDefaults synchronize];
}

- (void)setDouble:(double)dValue forKey:(NSString *)key
{
    [_userDefaults setDouble:dValue forKey:key];
    [_userDefaults synchronize];
}

- (void)setURL:(NSURL *)url forKey:(NSString *)key
{
    [_userDefaults setURL:url forKey:key];
    [_userDefaults synchronize];
}

- (void)setModel:(SCModel *)model forKey:(NSString *)key
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
    [_userDefaults setObject:data forKey:key];
    [_userDefaults synchronize];
}

#pragma mark - Remove Methods

- (void)removeObjectForKey:(NSString *)key
{
    [_userDefaults removeObjectForKey:key];
    [_userDefaults synchronize];
}

@end
