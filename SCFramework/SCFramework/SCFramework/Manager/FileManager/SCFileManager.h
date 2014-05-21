//
//  SCFileManager.h
//  SCFramework
//
//  Created by Angzn on 3/6/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCFileManager : NSObject

+ (SCFileManager *)sharedInstance;

- (BOOL)fileExistsAtPath:(NSString *)filePath;

- (BOOL)createFileAtPath:(NSString *)filePath;
- (BOOL)createDirectoryAtPath:(NSString *)path;
- (BOOL)removeFileAtPath:(NSString *)filePath;

- (NSData *)dataWithFilePath:(NSString *)filePath;
- (BOOL)saveData:(NSData *)data toFilePath:(NSString *)filePath;
- (NSDictionary *)dictionaryWithFilePath:(NSString *)filePath;
- (BOOL)saveDictionary:(NSDictionary *)data toFilePath:(NSString *)filePath;
- (NSArray *)arrayWithFilePath:(NSString *)filePath;
- (BOOL)saveArray:(NSArray *)data toFilePath:(NSString *)filePath;

@end
