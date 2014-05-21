//
//  SCFileManager.m
//  SCFramework
//
//  Created by Angzn on 3/6/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import "SCFileManager.h"
#import "SCSingleton.h"

@interface SCFileManager ()

@property (nonatomic, weak) NSFileManager *fileManager;

@end


@implementation SCFileManager

SCSINGLETON(SCFileManager);

- (id)init
{
    self = [super init];
    if (self) {
        _fileManager = [NSFileManager defaultManager];
    }
    return self;
}

#pragma mark - 判断文件是否存在

/**
 *  @brief 判断文件是否存在
 */
- (BOOL)fileExistsAtPath:(NSString *)filePath
{
	return [_fileManager fileExistsAtPath:filePath];
}

#pragma mark - 文件创建/移除

/**
 *  @brief 创建文件
 */
- (BOOL)createFileAtPath:(NSString *)filePath
{
    if ( [self fileExistsAtPath:filePath] ) {
        return YES;
    } else {
        return [_fileManager createFileAtPath:filePath
                                     contents:nil
                                   attributes:nil];
    }
}

/**
 *  @brief 创建文件夹
 */
- (BOOL)createDirectoryAtPath:(NSString *)path
{
    if ( [self fileExistsAtPath:path] ) {
        return YES;
    } else {
        return [_fileManager createDirectoryAtPath:path
                       withIntermediateDirectories:NO
                                        attributes:nil
                                             error:nil];
    }
}

/**
 *  @brief 移除文件
 */
- (BOOL)removeFileAtPath:(NSString *)filePath
{
    if ( [self fileExistsAtPath:filePath] ) {
        return [_fileManager removeItemAtPath:filePath
                                        error:nil];
    } else {
        return YES;
    }
}

#pragma mark - 文件读取/保存

/**
 *  @brief 读取文件数据
 */
- (NSData *)dataWithFilePath:(NSString *)filePath
{
    if ( [self fileExistsAtPath:filePath] ) {
        return [NSData dataWithContentsOfFile:filePath];
    } else {
        return nil;
    }
}

/**
 *  @brief 保存数据到文件
 */
- (BOOL)saveData:(NSData *)data toFilePath:(NSString *)filePath
{
    if ( [self fileExistsAtPath:filePath] ) {
        return [data writeToFile:filePath atomically:YES];
    } else {
        if ( [self createFileAtPath:filePath] ) {
            return [data writeToFile:filePath atomically:YES];
        } else {
            return NO;
        }
    }
}

/**
 *  @brief 从文件读取键值对
 */
- (NSDictionary *)dictionaryWithFilePath:(NSString *)filePath
{
    if ( [self fileExistsAtPath:filePath] ) {
        return [NSDictionary dictionaryWithContentsOfFile:filePath];
    } else {
        return nil;
    }
}

/**
 *  @brief 保存键值对到文件
 */
- (BOOL)saveDictionary:(NSDictionary *)data toFilePath:(NSString *)filePath
{
    if ( [self fileExistsAtPath:filePath] ) {
        return [data writeToFile:filePath atomically:YES];
    } else {
        if ( [self createFileAtPath:filePath] ) {
            return [data writeToFile:filePath atomically:YES];
        } else {
            return NO;
        }
    }
}

/**
 *  @brief 从文件读取数组数据
 */
- (NSArray *)arrayWithFilePath:(NSString *)filePath
{
    if ( [self fileExistsAtPath:filePath] ) {
        return [NSArray arrayWithContentsOfFile:filePath];
    } else {
        return nil;
    }
}

/**
 *  @brief 保存数组数据到文件
 */
- (BOOL)saveArray:(NSArray *)data toFilePath:(NSString *)filePath
{
    if ( [self fileExistsAtPath:filePath] ) {
        return [data writeToFile:filePath atomically:YES];
    } else {
        if ( [self createFileAtPath:filePath] ) {
            return [data writeToFile:filePath atomically:YES];
        } else {
            return NO;
        }
    }
}

@end
