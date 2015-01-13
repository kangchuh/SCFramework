//
//  SCKeyValueStore.h
//  SCFramework
//
//  Created by Angzn on 15/1/8.
//  Copyright (c) 2015年 Richer VC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCKeyValueItem : NSObject

/**
 *  键(数据键)
 */
@property (strong, nonatomic) NSString *key;
/**
 *  值(数据对象)
 */
@property (strong, nonatomic) id       value;
/**
 *  创建时间
 */
@property (strong, nonatomic) NSDate   *createdTime;

@end


@interface SCKeyValueStore : NSObject

+ (SCKeyValueStore *)sharedInstance;

- (instancetype)initWithName:(NSString *)dbName;
- (instancetype)initWithPath:(NSString *)dbPath;

- (BOOL)existTable:(NSString *)tableName;
- (BOOL)createTable:(NSString *)tableName;
- (BOOL)dropTable:(NSString *)tableName;

- (SCKeyValueItem *)queryItemForKey:(NSString *)key fromTable:(NSString *)tableName;
- (NSArray *)queryFromTable:(NSString *)tableName;

- (BOOL)putObject:(id)object forKey:(NSString *)key intoTable:(NSString *)tableName;
- (id)getObjectForKey:(NSString *)key fromTable:(NSString *)tableName;

- (BOOL)putString:(NSString *)string forKey:(NSString *)key intoTable:(NSString *)tableName;
- (NSString *)getStringForKey:(NSString *)key fromTable:(NSString *)tableName;

- (BOOL)putNumber:(NSNumber *)number forKey:(NSString *)key intoTable:(NSString *)tableName;
- (NSNumber *)getNumberForKey:(NSString *)key fromTable:(NSString *)tableName;

- (BOOL)deleteForKey:(NSString *)key fromTable:(NSString *)tableName;
- (BOOL)deleteForKeys:(NSArray *)keys fromTable:(NSString *)tableName;
- (BOOL)deleteForKeyContainPrefix:(NSString *)keyPrefix fromTable:(NSString *)tableName;
- (BOOL)deleteFromTable:(NSString *)tableName;

- (void)close;

@end
