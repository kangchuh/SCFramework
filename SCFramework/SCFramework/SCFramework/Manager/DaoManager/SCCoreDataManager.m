//
//  SCCoreDataManager.m
//  SCFramework
//
//  Created by Angzn on 3/5/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import "SCCoreDataManager.h"
#import "SCSingleton.h"

#import "NSString+SCAddition.h"
#import "SCLog.h"

// Momd文件后缀
static NSString * const kSCFW_MOMD_FILE_EXT = @"momd";

// 数据库文件默认后缀
static NSString * const kSCFW_DB_FILE_EXT_DEFAULT = @"sqlite";

@interface SCCoreDataManager ()

/// Momd文件名
@property (nonatomic, strong) NSString *momdFileName;

/// 数据库文件名
@property (nonatomic, strong) NSString *dbFileName;

/// 数据库文件后缀
@property (nonatomic, strong) NSString *dbFileExt;

@end

@implementation SCCoreDataManager

SCSINGLETON(SCCoreDataManager);

#pragma mark - Core Data Stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *persistentStoreCoordinator = self.persistentStoreCoordinator;
    if (persistentStoreCoordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:persistentStoreCoordinator];
    }
    return _managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel
{
	if (_managedObjectModel != nil) {
		return _managedObjectModel;
	}
    NSURL *modelURL = [self momdDirectory];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
	return _managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
	
    NSURL *storeUrl = [self databaseDirectory];
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:
                                   self.managedObjectModel];
	NSError *error = nil;
    NSPersistentStore *persistentStore = nil;
    persistentStore = [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                                configuration:nil
                                                                          URL:storeUrl
                                                                      options:nil
                                                                        error:&error];
	if (!persistentStore || error) {
		// Update to handle the error appropriately.
		DLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();  // Fail
    }
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                   inDomains:NSUserDomainMask]
            lastObject];
}

#pragma mark - Momd Directory

/**
 Returns the URL to the Momd file directory.
 */
- (NSURL *)momdDirectory
{
    return [[NSBundle mainBundle] URLForResource:_momdFileName
                                   withExtension:kSCFW_MOMD_FILE_EXT];
}

#pragma mark - Database Directory

/**
 Returns the URL to the Database file directory.
 */
- (NSURL *)databaseDirectory
{
    NSString *dbExt = !_dbFileExt.isNotEmpty ? kSCFW_DB_FILE_EXT_DEFAULT : _dbFileExt;
    NSString *dbFullName = [NSString stringWithFormat:@"%@.%@", _dbFileName, dbExt];
    return [[self applicationDocumentsDirectory] URLByAppendingPathComponent:dbFullName];
}

#pragma mark - 配置文件名(数据库文件/Momd文件)

- (void)setupDataMomdFile:(NSString *)momdFileName
             databaseFile:(NSString *)dbFileName
{
    [self setupDataMomdFile:momdFileName
               databaseFile:dbFileName
                databaseExt:nil];
}

- (void)setupDataMomdFile:(NSString *)momdFileName
             databaseFile:(NSString *)dbFileName
              databaseExt:(NSString *)dbFileExt
{
    self.momdFileName = momdFileName;
    self.dbFileName   = dbFileName;
    self.dbFileExt    = dbFileExt;
}

#pragma mark - 创建对象

- (NSManagedObject *)newObjectWithEntityName:(NSString *)name
{
    NSManagedObjectContext *context = self.managedObjectContext;
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:name
                                                  inManagedObjectContext:context];
    NSManagedObject *obj = [[NSManagedObject alloc] initWithEntity:entityDesc
                                    insertIntoManagedObjectContext:nil];
    return obj;
}

- (NSManagedObject *)newObject:(Class)objClass entityName:(NSString *)name
{
    NSManagedObjectContext *context = self.managedObjectContext;
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:name
                                                  inManagedObjectContext:context];
    NSManagedObject *obj = [[objClass alloc] initWithEntity:entityDesc
                             insertIntoManagedObjectContext:nil];
    return obj;
}

#pragma mark - 数据操作

/**
 *  @brief 保存操作 < 增、删、改, 须保存 >
 */
- (BOOL)save
{
	NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            DLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
	return (nil == error);
}

/**
 *  @brief 插入操作
 */
- (BOOL)insertObject:(NSManagedObject *)obj
{
	return [self insertObject:obj
                   saveChange:YES];
}

/**
 *  @brief 删除操作
 */
- (BOOL)deleteObject:(NSManagedObject *)obj
{
	return [self deleteObject:obj
                   saveChange:YES];
}

/**
 *  @brief 更新操作
 */
- (BOOL)refreshObject:(NSManagedObject *)obj
         mergeChanges:(BOOL)flag
{
    return [self refreshObject:obj
                  mergeChanges:flag
                    saveChange:YES];
}

/**
 *  @brief 插入操作
 *
 *  @param obj        要插入的对象
 *  @param saveChange 是否立即保存修改
 *
 *  @return YES, 成功; 反之
 */
- (BOOL)insertObject:(NSManagedObject *)obj
          saveChange:(BOOL)saveChange
{
	[self.managedObjectContext insertObject:obj];
    
    return saveChange ? [self save] : YES;
}

/**
 *  @brief 删除操作
 *
 *  @param obj        要删除的对象
 *  @param saveChange 是否立即保存修改
 *
 *  @return YES, 成功; 反之
 */
- (BOOL)deleteObject:(NSManagedObject *)obj
          saveChange:(BOOL)saveChange
{
	[self.managedObjectContext deleteObject:obj];
    
    return saveChange ? [self save] : YES;
}

/**
 *  @brief 更新操作
 *
 *  @param obj        要修改的对象
 *  @param flag       是否合并
 *  @param saveChange 是否立即保存修改
 *
 *  @return YES, 成功; 反之
 */
- (BOOL)refreshObject:(NSManagedObject *)obj
         mergeChanges:(BOOL)flag
           saveChange:(BOOL)saveChange
{
    [self.managedObjectContext refreshObject:obj
                                mergeChanges:flag];
    
    return saveChange ? [self save] : YES;
}

@end
