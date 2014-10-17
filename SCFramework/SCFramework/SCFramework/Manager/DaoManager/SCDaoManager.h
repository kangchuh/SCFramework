//
//  SCDaoManager.h
//  SCFramework
//
//  Created by Angzn on 5/5/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SCModel;

@protocol SCDatabaseModel;

@interface SCDaoManager : NSObject

+ (SCDaoManager *)sharedInstance;

- (instancetype)initWithName:(NSString *)dbName;
- (instancetype)initWithPath:(NSString *)dbPath;

- (BOOL)dropTable:(Class)modelCls;

- (BOOL)insertModel:(SCModel <SCDatabaseModel> *)model;

- (BOOL)deleteModel:(Class)modelCls;

- (BOOL)updateModel:(SCModel <SCDatabaseModel> *)model forSQL:(NSString *)SQL;

- (NSArray *)query:(Class)modelCls;
- (NSArray *)query:(Class)modelCls where:(id)where;
- (NSArray *)query:(Class)modelCls forSQL:(NSString *)SQL;

- (NSInteger)count:(Class)modelCls forSQL:(NSString *)SQL;

@end
