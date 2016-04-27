//
//  SCDatabaseManager.m
//  SCFramework
//
//  Created by Angzn on 16/4/21.
//  Copyright © 2016年 Richer VC. All rights reserved.
//

#import "SCDatabaseManager.h"
#import "SCSingleton.h"
#import "SCApp.h"

#import "SCModel.h"

#import "SCDatabase.h"
#import "SCDatabaseModel.h"

#import "SCDatabaseMetaModel.h"
#import "SCTableMetaModel.h"

#import "NSObject+SCAddition.h"
#import "NSString+SCAddition.h"
#import "NSArray+SCAddition.h"

@interface SCDatabaseManager ()

@property (nonatomic, strong) FMDatabaseQueue *dbQueue;

@end

@implementation SCDatabaseManager

SCSINGLETON(SCDatabaseManager);

- (void)dealloc
{
    [_dbQueue close];
}

#pragma mark - Init Method

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString *dbName = [[SCApp bundleID] stringByAppendingString:@".sqlite"];
        NSString *dbPath = [self databasePathWithName:dbName];
        self.dbQueue = [[FMDatabaseQueue alloc] initWithPath:dbPath];
    }
    return self;
}

- (instancetype)initWithName:(NSString *)dbName
{
    self = [super init];
    if (self) {
        NSString *dbPath = [self databasePathWithName:dbName];
        self.dbQueue = [[FMDatabaseQueue alloc] initWithPath:dbPath];
    }
    return self;
}

- (instancetype)initWithPath:(NSString *)dbPath
{
    self = [super init];
    if (self) {
        self.dbQueue = [[FMDatabaseQueue alloc] initWithPath:dbPath];
    }
    return self;
}

#pragma mark - Database

- (NSArray *)datebaseMetas
{
    __block NSMutableArray *metas = [NSMutableArray array];
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:
                           @"select * from sqlite_master"];
        while ( [rs next] ) {
            SCDatabaseMetaModel *meta = [[SCDatabaseMetaModel alloc] init];
            meta.type      = [rs stringForColumn:@"type"];
            meta.name      = [rs stringForColumn:@"name"];
            meta.tableName = [rs stringForColumn:@"tbl_name"];
            meta.sql       = [rs stringForColumn:@"sql"];
            [metas addObject:meta];
        }
        [rs close];
    }];
    [self.dbQueue close];
    
    return [NSArray arrayWithArray:metas];
}

- (NSArray *)tableMetas:(Class)modelCls
{
    if ( ![self existTable:modelCls] ) {
        return nil;
    }
    
    __block NSMutableArray *metas = [NSMutableArray array];
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *tableName = [modelCls tableName];
        NSString *sql = [NSString stringWithFormat:
                         @"PRAGMA table_info('%@')", tableName];
        FMResultSet *rs = [db executeQuery:sql];
        while ( [rs next] ) {
            SCTableMetaModel *meta = [[SCTableMetaModel alloc] init];
            meta.columnID     = [rs intForColumn:@"cid"];
            meta.type         = [rs stringForColumn:@"type"];
            meta.name         = [rs stringForColumn:@"name"];
            meta.isNotNull    = [rs boolForColumn:@"notnull"];
            meta.isPrimaryKey = [rs boolForColumn:@"pk"];
            meta.defaultValue = [rs objectForColumnName:@"dflt_value"];
            [metas addObject:meta];
        }
        [rs close];
    }];
    [self.dbQueue close];
    
    return [NSArray arrayWithArray:metas];
}

- (BOOL)checkTableAndAlertIfNeed:(Class)modelCls
{
    NSArray *columnMetas = [self tableMetas:modelCls];
    if (![columnMetas isNotEmpty]) {
        return YES;
    }
    
    __block BOOL flag = NO;
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *tableName = [modelCls tableName];
        NSDictionary *properties = [modelCls storableProperties];
        NSArray *propertyNames = [properties allKeys];
        for (NSString *propertyName in propertyNames) {
            BOOL columnForPropertyInTable = NO;
            for (SCTableMetaModel *columnMeta in columnMetas) {
                if ([propertyName isEqualToString:columnMeta.name]) {
                    columnForPropertyInTable = YES;
                    break;
                }
            }
            if (!columnForPropertyInTable) {
                id propertyType = [properties objectForKey:propertyName];
                NSString *sql = [NSString stringWithFormat:@"ALTER TABLE '%@' ADD '%@' %@",
                                 tableName, propertyName, SCSQLTypeFromObjcType(propertyType)];
                BOOL ret = [db executeUpdate:sql];
                if (ret) {
                    flag = YES;
                } else {
                    flag = NO;
                    break;
                }
            }
        }
    }];
    [self.dbQueue close];
    
    return flag;
}

- (BOOL)existTable:(Class)modelCls
{
    __block BOOL flag = NO;
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        NSAssert([modelCls respondsToSelector:@selector(tableName)],
                 @"Model must be implement <SCModelDatabase> protocol.");
        NSString *tableName = [modelCls tableName];
        FMResultSet *rs = [db executeQuery:
                           @"select count(*) as 'count' from sqlite_master"
                           " where type ='table' and name = ?", tableName];
        while ( [rs next] ) {
            NSInteger count = [rs intForColumn:@"count"];
            if ( count > 0 ) {
                flag = YES;
            }
        }
        [rs close];
    }];
    [self.dbQueue close];
    
    return flag;
}

- (BOOL)createTable:(Class)modelCls
{
    __block BOOL flag = NO;
    
    __weak __typeof(&*self)weakSelf = self;
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        NSAssert([modelCls respondsToSelector:@selector(tableName)],
                 @"Model must be implement <SCModelDatabase> protocol.");
        NSString *sql = [weakSelf constructSQLForCreateTableWithModel:modelCls];
        BOOL ret = [db executeUpdate:sql];
        if ( ret ) {
            flag = YES;
        }
    }];
    [self.dbQueue close];
    
    return flag;
}

- (BOOL)dropTable:(Class)modelCls
{
    if ( ![self existTable:modelCls] ) {
        return YES;
    }
    
    __block BOOL flag = NO;
    
    __weak __typeof(&*self)weakSelf = self;
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [weakSelf constructSQLForDropTableWithModel:modelCls];
        BOOL ret = [db executeUpdate:sql];
        if ( ret ) {
            flag = YES;
        }
    }];
    [self.dbQueue close];
    
    return flag;
}

- (BOOL)insertModel:(SCModel<SCDatabaseModel> *)model
{
    if ( ![self existTable:[model class]] ) {
        if ( ![self createTable:[model class]] ) {
            return NO;
        }
    }
    
    __block BOOL flag = NO;
    
    __weak __typeof(&*self)weakSelf = self;
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        NSArray *insertValues = nil;
        NSString *sql = [weakSelf constructSQLForInsertWithModel:model insertValues:&insertValues];
        BOOL ret = [db executeUpdate:sql withArgumentsInArray:insertValues];
        if ( ret ) {
            flag = YES;
        }
    }];
    [self.dbQueue close];
    
    return flag;
}

- (BOOL)insertModels:(NSArray<SCModel<SCDatabaseModel> *> *)models
{
    if (![models isNotEmpty]) {
        return YES;
    }
    
    Class modelClass = models.firstObject.class;
    if ( ![self existTable:modelClass] ) {
        if ( ![self createTable:modelClass] ) {
            return NO;
        }
    }
    
    __block BOOL flag = NO;
    
    __weak __typeof(&*self)weakSelf = self;
    
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (SCModel<SCDatabaseModel> *model in models) {
            NSArray *insertValues = nil;
            NSString *sql = [weakSelf constructSQLForInsertWithModel:model insertValues:&insertValues];
            BOOL ret = [db executeUpdate:sql withArgumentsInArray:insertValues];
            if ( ret ) {
                flag = YES;
            } else {
                flag = YES;
            }
        }
    }];
    [self.dbQueue close];
    
    return flag;
}

- (BOOL)insertModels:(NSArray<SCModel<SCDatabaseModel> *> *)models rollbackWhenError:(BOOL)rollbackWhenError
{
    if (![models isNotEmpty]) {
        return YES;
    }
    
    Class modelClass = models.firstObject.class;
    if ( ![self existTable:modelClass] ) {
        if ( ![self createTable:modelClass] ) {
            return NO;
        }
    }
    
    __block BOOL flag = NO;
    
    __weak __typeof(&*self)weakSelf = self;
    
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (SCModel<SCDatabaseModel> *model in models) {
            NSArray *insertValues = nil;
            NSString *sql = [weakSelf constructSQLForInsertWithModel:model insertValues:&insertValues];
            BOOL ret = [db executeUpdate:sql withArgumentsInArray:insertValues];
            if ( rollbackWhenError ) {
                if ( ret ) {
                    flag = YES;
                } else {
                    flag = NO;
                    *rollback = YES;
                    break;
                }
            } else {
                flag = YES;
            }
        }
    }];
    [self.dbQueue close];
    
    return flag;
}

- (BOOL)deleteModel:(Class)modelCls
{
    if ( ![self existTable:modelCls] ) {
        return YES;
    }
    
    __block BOOL flag = NO;
    
    __weak __typeof(&*self)weakSelf = self;
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [weakSelf constructSQLForDeleteWithModel:modelCls];
        BOOL ret = [db executeUpdate:sql];
        if ( ret ) {
            flag = YES;
        }
    }];
    [self.dbQueue close];
    
    return flag;
}

- (BOOL)deleteModel:(Class)modelCls forSQL:(NSString *)SQL
{
    if ( ![self existTable:modelCls] ) {
        return YES;
    }
    
    __block BOOL flag = NO;
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:SQL, [modelCls tableName]];
        BOOL ret = [db executeUpdate:sql];
        if ( ret ) {
            flag = YES;
        }
    }];
    [self.dbQueue close];
    
    return flag;
}

- (BOOL)updateModel:(Class)modelCls forSQL:(NSString *)SQL
{
    if ( ![self existTable:modelCls] ) {
        return NO;
    }
    
    __block BOOL flag = NO;
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:SQL, [modelCls tableName]];
        BOOL ret = [db executeUpdate:sql];
        if ( ret ) {
            flag = YES;
        }
    }];
    [self.dbQueue close];
    
    return flag;
}

- (NSArray *)query:(Class)modelCls
{
    if ( ![self existTable:modelCls] ) {
        return nil;
    }
    
    __block NSMutableArray *models = [NSMutableArray array];
    
    __weak __typeof(&*self)weakSelf = self;
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [weakSelf constructSQLForQueryWithModel:modelCls];
        FMResultSet *rs = [db executeQuery:sql];
        [models addObjectsFromArray:[weakSelf parseResultSet:rs forModel:modelCls]];
        [rs close];
    }];
    [self.dbQueue close];
    
    return [NSArray arrayWithArray:models];
}

- (NSArray *)query:(Class)modelCls where:(id)where
{
    if ( ![self existTable:modelCls] ) {
        return nil;
    }
    
    __block NSMutableArray *models = [NSMutableArray array];
    
    __weak __typeof(&*self)weakSelf = self;
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [weakSelf constructSQLForQueryWithModel:modelCls];
        FMResultSet *rs = nil;
        if ([where isKindOfClass:[NSDictionary class]]) {
            rs = [db executeQuery:sql withParameterDictionary:where];
        } else if ([where isKindOfClass:[NSArray class]]) {
            rs = [db executeQuery:sql withArgumentsInArray:where];
        } else {
            rs = [db executeQuery:sql];
        }
        [models addObjectsFromArray:[weakSelf parseResultSet:rs forModel:modelCls]];
        [rs close];
    }];
    [self.dbQueue close];
    
    return [NSArray arrayWithArray:models];
}

- (NSArray *)query:(Class)modelCls forSQL:(NSString *)SQL
{
    if ( ![self existTable:modelCls] ) {
        return nil;
    }
    
    __block NSMutableArray *models = [NSMutableArray array];
    
    __weak __typeof(&*self)weakSelf = self;
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:SQL, [modelCls tableName]];
        FMResultSet *rs = [db executeQuery:sql];
        [models addObjectsFromArray:[weakSelf parseResultSet:rs forModel:modelCls]];
        [rs close];
    }];
    [self.dbQueue close];
    
    return [NSArray arrayWithArray:models];
}

- (NSInteger)count:(Class)modelCls forSQL:(NSString *)SQL
{
    if ( ![self existTable:modelCls] ) {
        return 0;
    }
    
    __block NSInteger count = 0;
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:SQL, [modelCls tableName]];
        FMResultSet *rs = [db executeQuery:sql];
        if ( [rs next] ) {
            count = [[rs stringForColumnIndex:0] integerValue];
        }
        [rs close];
    }];
    [self.dbQueue close];
    
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
        /*
         // 单主键结构
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
         /*/
        // 多主键结构
        for (NSString *key in [properties keyEnumerator]) {
            id value = [properties objectForKey:key];
            [propertyPairs addObject:[NSString stringWithFormat:@"'%@' %@",
                                      key, SCSQLTypeFromObjcType(value)]];
        }
        [propertyPairs addObject:[NSString stringWithFormat:@"%@ (%@)",
                                  SCSQLAttributePrimaryKey,
                                  primaryKey]];
        //*/
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
    
    NSString *sql = [NSString stringWithFormat:@"REPLACE INTO '%@' (%@) VALUES (%@)",
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
