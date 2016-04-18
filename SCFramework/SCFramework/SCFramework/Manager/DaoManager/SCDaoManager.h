//
//  SCDaoManager.h
//  SCFramework
//
//  Created by Angzn on 5/5/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FMDB.h"

@class SCModel;

@protocol SCDatabaseModel;

@interface SCDaoManager : NSObject

@property (nonatomic, readonly) FMDatabase *db;

+ (SCDaoManager *)sharedInstance;

- (instancetype)initWithName:(NSString *)dbName;
- (instancetype)initWithPath:(NSString *)dbPath;

- (NSArray *)datebaseMetas;

- (NSArray *)tableMetas:(Class)modelCls;

- (BOOL)checkTableAndAlertIfNeed:(Class)modelCls;

- (BOOL)existTable:(Class)modelCls;

- (BOOL)createTable:(Class)modelCls;

- (BOOL)dropTable:(Class)modelCls;

- (BOOL)insertModel:(SCModel<SCDatabaseModel> *)model;

- (BOOL)insertModels:(NSArray<SCModel<SCDatabaseModel> *> *)models;

- (BOOL)deleteModel:(Class)modelCls;

- (BOOL)deleteModel:(Class)modelCls forSQL:(NSString *)SQL;

- (BOOL)updateModel:(SCModel<SCDatabaseModel> *)model forSQL:(NSString *)SQL;

- (NSArray *)query:(Class)modelCls;
- (NSArray *)query:(Class)modelCls where:(id)where;
- (NSArray *)query:(Class)modelCls forSQL:(NSString *)SQL;

- (NSInteger)count:(Class)modelCls forSQL:(NSString *)SQL;

- (BOOL)executeUpdate:(NSString *)SQL;

- (FMResultSet *)executeQuery:(NSString *)SQL;

@end
