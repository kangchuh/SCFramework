//
//  SCDaoManager.m
//  SCFramework
//
//  Created by Angzn on 5/5/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import "SCDaoManager.h"
#import "SCSingleton.h"

#import "SCDatabase.h"
#import "SCDatabaseModel.h"

#import <FMDB.h>

@interface SCDaoManager ()

@property (nonatomic, strong) FMDatabase *db;

@end

@implementation SCDaoManager

SCSINGLETON(SCDaoManager);

#pragma mark - Init Method

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString *dbName = [[SCApp bundleID] stringByAppendingString:@".sqlite"];
        NSString *dbPath = [self databasePathWithName:dbName];
        self.db = [FMDatabase databaseWithPath:dbPath];
    }
    return self;
}

- (instancetype)initWithName:(NSString *)dbName
{
    self = [super init];
    if (self) {
        NSString *dbPath = [self databasePathWithName:dbName];
        self.db = [FMDatabase databaseWithPath:dbPath];
    }
    return self;
}

- (instancetype)initWithPath:(NSString *)dbPath
{
    self = [super init];
    if (self) {
        self.db = [FMDatabase databaseWithPath:dbPath];
    }
    return self;
}

#pragma mark - Database

- (BOOL)existTable:(Class)modelCls
{
    BOOL flag = NO;
    
    if ( [self.db open] ) {
        NSAssert([modelCls respondsToSelector:@selector(tableName)],
                 @"Model must be implement <SCModelDatabase> protocol.");
        NSString *tableName = [modelCls tableName];
        FMResultSet *rs = [self.db executeQuery:
                           @"select count(*) as 'count' from sqlite_master"
                           " where type ='table' and name = ?", tableName];
        while ( [rs next] ) {
            NSInteger count = [rs intForColumn:@"count"];
            if ( count > 0 ) {
                flag = YES;
            }
        }
    }
    [self.db close];
    
    return flag;
}

- (BOOL)createTable:(Class)modelCls
{
    BOOL flag = NO;
    
    if ( [self.db open] ) {
        NSAssert([modelCls respondsToSelector:@selector(tableName)],
                 @"Model must be implement <SCModelDatabase> protocol.");
        NSString *sql = [self constructSQLForCreateTableWithModel:modelCls];
        BOOL ret = [self.db executeUpdate:sql];
        if ( ret ) {
            flag = YES;
        }
    }
    [self.db close];
    
    return flag;
}

- (BOOL)dropTable:(Class)modelCls
{
    if ( ![self existTable:modelCls] ) {
        return YES;
    }
    
    BOOL flag = NO;
    
    if ( [self.db open] ) {
        NSString *sql = [self constructSQLForDropTableWithModel:modelCls];
        BOOL ret = [self.db executeUpdate:sql];
        if ( ret ) {
            flag = YES;
        }
    }
    [self.db close];
    
    return flag;
}

- (BOOL)insertModel:(SCModel <SCDatabaseModel> *)model
{
    if ( ![self existTable:[model class]] ) {
        if ( ![self createTable:[model class]] ) {
            return NO;
        }
    }
    
    BOOL flag = NO;
    
    if ( [self.db open] ) {
        NSArray *insertValues = nil;
        NSString *sql = [self constructSQLForInsertWithModel:model insertValues:&insertValues];
        BOOL ret = [self.db executeUpdate:sql withArgumentsInArray:insertValues];;
        if ( ret ) {
            flag = YES;
        }
    }
    [self.db close];
    
    return flag;
}

- (BOOL)deleteModel:(Class)modelCls
{
    if ( ![self existTable:modelCls] ) {
        return YES;
    }
    
    BOOL flag = NO;
    
    if ( [self.db open] ) {
        NSString *sql = [self constructSQLForDeleteWithModel:modelCls];
        BOOL ret = [self.db executeUpdate:sql];
        if ( ret ) {
            flag = YES;
        }
    }
    [self.db close];
    
    return flag;
}

- (BOOL)updateModel:(SCModel <SCDatabaseModel> *)model forSQL:(NSString *)SQL
{
    if ( ![self existTable:[model class]] ) {
        return NO;
    }
    
    BOOL flag = NO;
    
    if ( [self.db open] ) {
        NSString *sql = [NSString stringWithFormat:SQL, [[model class] tableName]];
        BOOL ret = [self.db executeUpdate:sql];
        if ( ret ) {
            flag = YES;
        }
    }
    [self.db close];
    
    return flag;
}

- (NSArray *)query:(Class)modelCls
{
    if ( ![self existTable:modelCls] ) {
        return nil;
    }
    
    NSMutableArray *models = [NSMutableArray array];
    
    if ( [self.db open] ) {
        NSString *sql = [self constructSQLForQueryWithModel:modelCls];
        FMResultSet *rs = [self.db executeQuery:sql];
        [models addObjectsFromArray:[self parseResultSet:rs forModel:modelCls]];
    }
    [self.db close];
    
    return [NSArray arrayWithArray:models];
}

- (NSArray *)query:(Class)modelCls where:(id)where
{
    if ( ![self existTable:modelCls] ) {
        return nil;
    }
    
    NSMutableArray *models = [NSMutableArray array];
    
    if ( [self.db open] ) {
        NSString *sql = [self constructSQLForQueryWithModel:modelCls];
        FMResultSet *rs = nil;
        if ([where isKindOfClass:[NSDictionary class]]) {
            rs = [self.db executeQuery:sql withParameterDictionary:where];
        } else if ([where isKindOfClass:[NSArray class]]) {
            rs = [self.db executeQuery:sql withArgumentsInArray:where];
        } else {
            rs = [self.db executeQuery:sql];
        }
        [models addObjectsFromArray:[self parseResultSet:rs forModel:modelCls]];
    }
    [self.db close];
    
    return [NSArray arrayWithArray:models];
}

- (NSArray *)query:(Class)modelCls forSQL:(NSString *)SQL
{
    if ( ![self existTable:modelCls] ) {
        return nil;
    }
    
    NSMutableArray *models = [NSMutableArray array];
    
    if ( [self.db open] ) {
        NSString *sql = [NSString stringWithFormat:SQL, [modelCls tableName]];
        FMResultSet *rs = [self.db executeQuery:sql];
        [models addObjectsFromArray:[self parseResultSet:rs forModel:modelCls]];
    }
    [self.db close];
    
    return [NSArray arrayWithArray:models];
}

- (NSInteger)count:(Class)modelCls forSQL:(NSString *)SQL
{
    if ( ![self existTable:modelCls] ) {
        return 0;
    }
    
    NSInteger count = 0;
    
    if ( [self.db open] ) {
        NSString *sql = [NSString stringWithFormat:SQL, [modelCls tableName]];
        FMResultSet *rs = [self.db executeQuery:sql];
        if ( [rs next] ) {
            count = [[rs stringForColumnIndex:0] integerValue];
        }
    }
    [self.db close];
    
    return count;
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

- (NSString *)constructSQLForCreateTableWithModel:(Class)modelCls
{
    NSMutableArray *propertyPairs = [NSMutableArray array];
    
    NSDictionary *properties = [modelCls storableProperties];
    
    NSString *primaryKey = nil;
    if ([modelCls respondsToSelector:@selector(primaryKey)]) {
        primaryKey = [modelCls primaryKey];
    }
    if ([primaryKey isNotEmpty]) {
        for (NSString *key in [properties keyEnumerator]) {
            id value = [properties objectForKey:key];
            if ([key isEqualToString:primaryKey]) {
                [propertyPairs addObject:[NSString stringWithFormat:@"'%@' %@ %@ %@",
                                          key, SCSQLTypeFromObjcType(value),
                                          SCSQLAttributePrimaryKey,
                                          SCSQLAttributeNotNull]];
            } else {
                [propertyPairs addObject:[NSString stringWithFormat:@"'%@' %@",
                                          key, SCSQLTypeFromObjcType(value)]];
            }
        }
    } else {
        [propertyPairs addObject:[NSString stringWithFormat:@"'id' %@ %@ %@",
                                  SCSQLTypeInt,
                                  SCSQLAttributePrimaryKey,
                                  SCSQLAttributeAutoIncremnt]];
        for (NSString *key in [properties keyEnumerator]) {
            id value = [properties objectForKey:key];
            [propertyPairs addObject:[NSString stringWithFormat:@"'%@' %@",
                                      key, SCSQLTypeFromObjcType(value)]];
        }
    }
    
	NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' (%@)",
                     [modelCls tableName], [propertyPairs componentsJoinedByString:@", "]];
	return sql;
}

- (NSString *)constructSQLForDropTableWithModel:(Class)modelCls
{
    NSString *sql = [NSString stringWithFormat:@"DROP TABLE '%@'",
                     [modelCls tableName]];
	return sql;
}

- (NSString *)constructSQLForInsertWithModel:(SCModel <SCDatabaseModel> *)model
                                insertValues:(NSArray **)insertValues
{
    NSMutableArray *keys = [NSMutableArray array];
    NSMutableArray *values = [NSMutableArray array];
    NSMutableArray *placeholders = [NSMutableArray array];
    
    NSDictionary *properties = [model storableProperties];
    for (NSString *key in [properties keyEnumerator]) {
        NSString *objcType = [properties objectForKey:key];
        id value = [model valueForKey:key];
        id obj = value ? [self convertToSQLValue:value forType:objcType] : [NSNull null];
        [keys addObject:key];
        [values addObject:obj];
        [placeholders addObject:@"?"];
    }
    *insertValues = [NSArray arrayWithArray:values];
    
	NSString *sql = [NSString stringWithFormat:@"INSERT INTO '%@' (%@) VALUES (%@)",
                     [[model class] tableName], [keys componentsJoinedByString:@", "],
                     [placeholders componentsJoinedByString:@", "]];
	return sql;
}

- (NSString *)constructSQLForDeleteWithModel:(Class)modelCls
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM '%@'",
                     [modelCls tableName]];
	return sql;
}

- (NSString *)constructSQLForQueryWithModel:(Class)modelCls
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM '%@'",
                     [modelCls tableName]];
	return sql;
}

#pragma mark - Convert & Parse

- (id)convertToSQLValue:(id)obj forType:(NSString *)objcType
{
    if ([objcType isEqualToString:SCObjcTypeCGPoint]) {
        return NSStringFromCGPoint([(NSValue *)obj CGPointValue]);
    } else if ([objcType isEqualToString:SCObjcTypeCGSize]) {
        return NSStringFromCGSize([(NSValue *)obj CGSizeValue]);
    } else if ([objcType isEqualToString:SCObjcTypeCGRect]) {
        return NSStringFromCGRect([(NSValue *)obj CGRectValue]);
    }
    return obj;
}

- (id)convertToObjcValue:(id)obj forType:(NSString *)objcType
{
    if ([objcType isEqualToString:SCObjcTypeCGPoint]) {
        return [NSValue valueWithCGPoint:CGPointFromString(obj)];
    } else if ([objcType isEqualToString:SCObjcTypeCGSize]) {
        return [NSValue valueWithCGSize:CGSizeFromString(obj)];
    } else if ([objcType isEqualToString:SCObjcTypeCGRect]) {
        return [NSValue valueWithCGRect:CGRectFromString(obj)];
    }
    return obj;
}

- (NSArray *)parseResultSet:(FMResultSet *)rs forModel:(Class)modelCls
{
    NSMutableArray *models = [NSMutableArray array];
    NSInteger columnCount = (NSInteger)[rs columnCount];
    NSDictionary *properties = [modelCls storableProperties];
    NSArray *propertyNames = [properties allKeys];
    while ( [rs next] ) {
        SCModel *model = [[modelCls alloc] init];
        for (int clm = 0; clm < columnCount; ++clm) {
            NSString *columnName = [rs columnNameForIndex:clm];
            if ([propertyNames containsObject:columnName]) {
                NSString *objcType = [properties objectForKey:columnName];
                id obj = [rs objectForColumnName:columnName];
                id value = [self convertToObjcValue:obj forType:objcType];
                [model setValue:value forKey:columnName];
            }
        }
        [models addObject:model];
    }
    return [NSArray arrayWithArray:models];
}

@end
