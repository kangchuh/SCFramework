//
//  SCUserDefaultManager.h
//  SCFramework
//
//  Created by Angzn on 3/6/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SCModel;

@interface SCUserDefaultManager : NSObject

+ (SCUserDefaultManager *)sharedInstance;

- (BOOL)getBoolForKey:(NSString *)key;
- (NSInteger)getIntegerForKey:(NSString *)key;
- (id)getObjectForKey:(NSString *)key;
- (NSString *)getStringForKey:(NSString *)key;
- (NSArray *)getArrayForKey:(NSString *)key;
- (NSDictionary *)getDictionaryForKey:(NSString *)key;
- (NSData *)getDataForKey:(NSString *)key;
- (float)getFloatForKey:(NSString *)key;
- (double)getDoubleForKey:(NSString *)key;
- (NSURL *)getURLForKey:(NSString *)key;
- (SCModel *)getModelForKey:(NSString *)key;

- (void)setBool:(BOOL)bValue forKey:(NSString *)key;
- (void)setInteger:(NSInteger)iVaule forKey:(NSString *)key;
- (void)setObject:(id)objValue forKey:(NSString *)key;
- (void)setFloat:(float)fValue forKey:(NSString *)key;
- (void)setDouble:(double)dValue forKey:(NSString *)key;
- (void)setURL:(NSURL *)url forKey:(NSString *)key;
- (void)setModel:(SCModel *)model forKey:(NSString *)key;

- (void)removeObjectForKey:(NSString *)key;

@end
