//
//  SCKeyValueStore.m
//  SCFramework
//
//  Created by Angzn on 15/1/8.
//  Copyright (c) 2015年 Richer VC. All rights reserved.
//

#import "SCKeyValueStore.h"
#import "SCSingleton.h"

#import "FMDB.h"

static NSString * const SCKeyValueStoreKeyID          = @"ID";
static NSString * const SCKeyValueStoreKeyJSON        = @"JSON";
static NSString * const SCKeyValueStoreKeyCreatedTime = @"CREATEDTIME";

@implementation SCKeyValueItem

- (NSString *)description
{
    return [NSString stringWithFormat:
            @"%@ ( \
            Key : %@, \
            Value : %@, \
            Created : %@)",
            [super description],
            _key,
            _value,
            _createdTime];
}

@end


@interface SCKeyValueStore ()

@property (strong, nonatomic) FMDatabaseQueue * databaseQueue;

@end

@implementation SCKeyValueStore

SCSINGLETON(SCKeyValueStore);

- (void)dealloc
{
    [_databaseQueue close];
}

#pragma mark - Init Method

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString * dbName = [[SCApp bundleID] stringByAppendingString:@".sqlite"];
        NSString * dbPath = [self databasePathWithName:dbName];
        self.databaseQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    }
    return self;
}

- (instancetype)initWithName:(NSString *)dbName
{
    self = [super init];
    if (self) {
        NSString * dbPath = [self databasePathWithName:dbName];
        self.databaseQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    }
    return self;
}

- (instancetype)initWithPath:(NSString *)dbPath
{
    self = [super init];
    if (self) {
        self.databaseQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    }
    return self;
}

#pragma mark - Database

+ (BOOL)checkTableName:(NSString *)tableName
{
    if (![tableName isNotEmpty]
        || [tableName containsCharacterSet:
            [NSCharacterSet whitespaceCharacterSet]]) {
            DRedLog(@"ERROR. Table name <%@> format error.", tableName);
            return NO;
        }
    return YES;
}

- (BOOL)existTable:(NSString *)tableName
{
    if (![self.class checkTableName:tableName]) {
        return NO;
    }
    
    __block BOOL ret = NO;
    [_databaseQueue inDatabase:^(FMDatabase *db) {
        FMResultSet * rs = [db executeQuery:
                            @"select count(*) as 'count' from sqlite_master"
                            " where type ='table' and name = ?", tableName];
        while ( [rs next] ) {
            NSInteger count = [rs intForColumn:@"count"];
            if ( count > 0 ) {
                ret = YES;
            }
        }
        [rs close];
    }];
    return ret;
}

- (BOOL)createTable:(NSString *)tableName
{
    if (![self.class checkTableName:tableName]) {
        return NO;
    }
    
    NSString * sql = [self constructSQLForCreateTable:tableName];
    
    __block BOOL ret = NO;
    [_databaseQueue inDatabase:^(FMDatabase *db) {
        ret = [db executeUpdate:sql];
    }];
    return ret;
}

- (BOOL)dropTable:(NSString *)tableName
{
    if (![self.class checkTableName:tableName]) {
        return NO;
    }
    
    NSString * sql = [self constructSQLForDropTable:tableName];
    
    __block BOOL ret = NO;
    [_databaseQueue inDatabase:^(FMDatabase *db) {
        ret = [db executeUpdate:sql];
    }];
    return ret;
}

- (SCKeyValueItem *)queryItemForKey:(NSString *)key fromTable:(NSString *)tableName
{
    if (![self.class checkTableName:tableName]) {
        return nil;
    }
    
    NSString * sql = [self constructSQLForQueryItem:tableName];
    
    __block NSMutableArray * items = [NSMutableArray array];
    __weak __typeof(&*self)weakSelf = self;
    [_databaseQueue inDatabase:^(FMDatabase *db) {
        FMResultSet * rs = [db executeQuery:sql, key];
        [items addObjectsFromArray:[weakSelf parseResultSet:rs]];
        [rs close];
    }];
    return [items firstObject];
}

- (NSArray *)queryForKeyContainPrefix:(NSString *)keyPrefix fromTable:(NSString *)tableName
{
    if (![self.class checkTableName:tableName]) {
        return nil;
    }
    
    NSString * sql = [self constructSQLForQuery:tableName forKeyContainPrefix:keyPrefix];
    
    __block NSMutableArray * items = [NSMutableArray array];
    __weak __typeof(&*self)weakSelf = self;
    [_databaseQueue inDatabase:^(FMDatabase *db) {
        FMResultSet * rs = [db executeQuery:sql];
        [items addObjectsFromArray:[weakSelf parseResultSet:rs]];
        [rs close];
    }];
    return items;
}

- (NSArray *)queryFromTable:(NSString *)tableName
{
    if (![self.class checkTableName:tableName]) {
        return nil;
    }
    
    NSString * sql = [self constructSQLForQuery:tableName];
    
    __block NSMutableArray * items = [NSMutableArray array];
    __weak __typeof(&*self)weakSelf = self;
    [_databaseQueue inDatabase:^(FMDatabase *db) {
        FMResultSet * rs = [db executeQuery:sql];
        [items addObjectsFromArray:[weakSelf parseResultSet:rs]];
        [rs close];
    }];
    return items;
}

- (BOOL)putObject:(id)object forKey:(NSString *)key intoTable:(NSString *)tableName
{
    if (![self.class checkTableName:tableName]) {
        return NO;
    }
    
    if (![self existTable:tableName]) {
        if (![self createTable:tableName]) {
            return NO;
        }
    }
    
    if ( !object || !key ) {
        return NO;
    }
    
    NSError * error = nil;
    NSString * JSONString = [SCNSJSONSerialization
                             stringFromObject:object
                             error:&error];
    if ( error ) {
        return NO;
    }
    
    NSDate * createdTime = [NSDate date];
    
    NSString * sql = [self constructSQLForInsert:tableName];
    
    __block BOOL ret = NO;
    [_databaseQueue inDatabase:^(FMDatabase *db) {
        ret = [db executeUpdate:sql, key, JSONString, createdTime];
    }];
    return ret;
}

- (id)getObjectForKey:(NSString *)key fromTable:(NSString *)tableName
{
    SCKeyValueItem * item = [self queryItemForKey:key fromTable:tableName];
    return item ? item.value : nil;
}

- (BOOL)putString:(NSString *)string forKey:(NSString *)key intoTable:(NSString *)tableName
{
    return [self putObject:@[string] forKey:key intoTable:tableName];
}

- (NSString *)getStringForKey:(NSString *)key fromTable:(NSString *)tableName
{
    id object = [self getObjectForKey:key fromTable:tableName];
    if (object && [object isKindOfClass:[NSArray class]]) {
        return [(NSArray *)object firstObject];
    }
    return nil;
}

- (BOOL)putNumber:(NSNumber *)number forKey:(NSString *)key intoTable:(NSString *)tableName
{
    return [self putObject:@[number] forKey:key intoTable:tableName];
}

- (NSNumber *)getNumberForKey:(NSString *)key fromTable:(NSString *)tableName
{
    id object = [self getObjectForKey:key fromTable:tableName];
    if (object && [object isKindOfClass:[NSArray class]]) {
        return [(NSArray *)object firstObject];
    }
    return nil;
}

- (BOOL)deleteForKey:(NSString *)key fromTable:(NSString *)tableName
{
    if (![self.class checkTableName:tableName]) {
        return NO;
    }
    
    NSString * sql = [self constructSQLForDeleteItem:tableName];
    
    __block BOOL ret = NO;
    [_databaseQueue inDatabase:^(FMDatabase *db) {
        ret = [db executeUpdate:sql, key];
    }];
    return ret;
}

- (BOOL)deleteForKeys:(NSArray *)keys fromTable:(NSString *)tableName
{
    if (![self.class checkTableName:tableName]) {
        return NO;
    }
    
    NSString * sql = [self constructSQLForDelete:tableName forKeys:keys];
    
    __block BOOL ret = NO;
    [_databaseQueue inDatabase:^(FMDatabase *db) {
        ret = [db executeUpdate:sql];
    }];
    return ret;
}

- (BOOL)deleteForKeyContainPrefix:(NSString *)keyPrefix fromTable:(NSString *)tableName
{
    if (![self.class checkTableName:tableName]) {
        return NO;
    }
    
    NSString * sql = [self constructSQLForDelete:tableName forKeyContainPrefix:keyPrefix];
    
    __block BOOL ret = NO;
    [_databaseQueue inDatabase:^(FMDatabase *db) {
        ret = [db executeUpdate:sql];
    }];
    return ret;
}

- (BOOL)deleteFromTable:(NSString *)tableName
{
    if (![self.class checkTableName:tableName]) {
        return NO;
    }
    
    NSString * sql = [self constructSQLForDelete:tableName];
    
    __block BOOL ret = NO;
    [_databaseQueue inDatabase:^(FMDatabase *db) {
        ret = [db executeUpdate:sql];
    }];
    return ret;
}

- (void)close
{
    [_databaseQueue close];
}

#pragma mark - Common

- (NSString *)applicationDocumentsDirectory
{
    NSArray *directories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                               NSUserDomainMask,
                                                               YES);
    return [directories firstObject];
}

- (NSString *)databasePathWithName:(NSString *)dbName
{
    return [[self applicationDocumentsDirectory] stringByAppendingFormat:@"/%@", dbName];
}

#pragma mark - SQL

- (NSString *)constructSQLForCreateTable:(NSString *)tableName
{
    NSString * sql = [NSString stringWithFormat:
                      @"CREATE TABLE IF NOT EXISTS %@ ( \
                      %@ TEXT NOT NULL, \
                      %@ TEXT NOT NULL, \
                      %@ TEXT NOT NULL, \
                      PRIMARY KEY(%@))",
                      tableName,
                      SCKeyValueStoreKeyID,
                      SCKeyValueStoreKeyJSON,
                      SCKeyValueStoreKeyCreatedTime,
                      SCKeyValueStoreKeyID];
    return sql;
}

- (NSString *)constructSQLForDropTable:(NSString *)tableName
{
    NSString * sql = [NSString stringWithFormat:
                      @"DROP TABLE %@",
                      tableName];
    return sql;
}

- (NSString *)constructSQLForQuery:(NSString *)tableName
{
    NSString * sql = [NSString stringWithFormat:
                      @"SELECT * FROM %@",
                      tableName];
    return sql;
}

- (NSString *)constructSQLForQueryItem:(NSString *)tableName
{
    NSString * sql = [NSString stringWithFormat:
                      @"SELECT * FROM %@ WHERE %@ = ? LIMIT 1",
                      tableName,
                      SCKeyValueStoreKeyID];
    return sql;
}

- (NSString *)constructSQLForQuery:(NSString *)tableName forKeyContainPrefix:(NSString *)keyPrefix
{
    NSString * sql = [NSString stringWithFormat:
                      @"SELECT * FROM %@ WHERE %@ LIKE %@",
                      tableName,
                      SCKeyValueStoreKeyID,
                      [self optimizeSQLArgumentPrefix:keyPrefix]];
    return sql;
}

- (NSString *)constructSQLForInsert:(NSString *)tableName
{
    NSString * sql = [NSString stringWithFormat:
                      @"REPLACE INTO %@ \
                      (%@, %@, %@) \
                      VALUES \
                      (?, ?, ?)",
                      tableName,
                      SCKeyValueStoreKeyID,
                      SCKeyValueStoreKeyJSON,
                      SCKeyValueStoreKeyCreatedTime];
    return sql;
}

- (NSString *)constructSQLForDelete:(NSString *)tableName
{
    NSString * sql = [NSString stringWithFormat:
                      @"DELETE FROM %@",
                      tableName];
    return sql;
}

- (NSString *)constructSQLForDeleteItem:(NSString *)tableName
{
    NSString * sql = [NSString stringWithFormat:
                      @"DELETE FROM %@ WHERE %@ = ?",
                      tableName,
                      SCKeyValueStoreKeyID];
    return sql;
}

- (NSString *)constructSQLForDelete:(NSString *)tableName forKeys:(NSArray *)keys
{
    NSMutableArray *optimizedKeys = [NSMutableArray array];
    for ( NSString * key in keys ) {
        NSString *optimizedKey = [self optimizeSQLKey:key];
        [optimizedKeys addObject:optimizedKey];
    }
    
    NSString * sql = [NSString stringWithFormat:
                      @"DELETE FROM %@ WHERE %@ IN (%@)",
                      tableName,
                      SCKeyValueStoreKeyID,
                      [optimizedKeys componentsJoinedByString:@", "]];
    return sql;
}

- (NSString *)constructSQLForDelete:(NSString *)tableName forKeyContainPrefix:(NSString *)keyPrefix
{
    NSString * sql = [NSString stringWithFormat:
                      @"DELETE FROM %@ WHERE %@ LIKE %@",
                      tableName,
                      SCKeyValueStoreKeyID,
                      [self optimizeSQLArgumentPrefix:keyPrefix]];
    return sql;
}

#pragma mark - Parse

- (NSArray *)parseResultSet:(FMResultSet *)rs
{
    NSMutableArray *items = [NSMutableArray array];
    while ( [rs next] ) {
        SCKeyValueItem *item = [[SCKeyValueItem alloc] init];
        item.key = [rs stringForColumn:SCKeyValueStoreKeyID];
        NSString *JSONString = [rs stringForColumn:SCKeyValueStoreKeyJSON];
        item.value = [SCNSJSONSerialization objectFromString:JSONString];
        item.createdTime = [rs dateForColumn:SCKeyValueStoreKeyCreatedTime];
        [items addObject:item];
    }
    return [NSArray arrayWithArray:items];
}

#pragma mark - Private Method

- (NSString *)optimizeSQLKey:(NSString *)key
{
    return [NSString stringWithFormat:@"'%@'", key];
}

- (NSString *)optimizeSQLArgumentPrefix:(NSString *)argument
{
    return [NSString stringWithFormat:@"'%@%%'", argument];
}

- (NSString *)optimizeSQLArgumentSuffix:(NSString *)argument
{
    return [NSString stringWithFormat:@"'%%%@'", argument];
}

- (NSString *)optimizeSQLArgumentLike:(NSString *)argument
{
    return [NSString stringWithFormat:@"'%%%@%%'", argument];
}

@end
