//
//  SCCoreDataManager.h
//  SCFramework
//
//  Created by Angzn on 3/5/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface SCCoreDataManager : NSObject
{
@private
	NSManagedObjectModel            *_managedObjectModel;
    NSManagedObjectContext          *_managedObjectContext;
    NSPersistentStoreCoordinator    *_persistentStoreCoordinator;
}

@property (nonatomic, strong, readonly) NSManagedObjectModel         *managedObjectModel;
@property (nonatomic, strong, readonly) NSManagedObjectContext       *managedObjectContext;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (SCCoreDataManager *)sharedInstance;

- (NSURL *)applicationDocumentsDirectory;

#pragma mark - 配置

- (void)setupDataMomdFile:(NSString *)momdFileName
             databaseFile:(NSString *)dbFileName;

- (void)setupDataMomdFile:(NSString *)momdFileName
             databaseFile:(NSString *)dbFileName
              databaseExt:(NSString *)dbFileExt;

#pragma mark - 创建对象

- (NSManagedObject *)newObjectWithEntityName:(NSString *)name;
- (NSManagedObject *)newObject:(Class)objClass
                    entityName:(NSString *)name;

#pragma mark - 数据操作

- (BOOL)save;

- (BOOL)insertObject:(NSManagedObject *)obj;
- (BOOL)deleteObject:(NSManagedObject *)obj;
- (BOOL)refreshObject:(NSManagedObject *)obj
         mergeChanges:(BOOL)flag;

- (BOOL)insertObject:(NSManagedObject *)obj
          saveChange:(BOOL)saveChange;
- (BOOL)deleteObject:(NSManagedObject *)obj
          saveChange:(BOOL)saveChange;
- (BOOL)refreshObject:(NSManagedObject *)obj
         mergeChanges:(BOOL)flag
           saveChange:(BOOL)saveChange;

@end
