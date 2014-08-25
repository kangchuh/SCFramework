//
//  SCDatabase.h
//  SCFramework
//
//  Created by Angzn on 8/21/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const SCSQLTypeText   = @"text";
static NSString * const SCSQLTypeInt    = @"integer";
static NSString * const SCSQLTypeDouble = @"double";
static NSString * const SCSQLTypeBlob   = @"blob";

static NSString * const SCSQLAttributeNotNull    = @"NOT NULL";
static NSString * const SCSQLAttributePrimaryKey = @"PRIMARY KEY";
static NSString * const SCSQLAttributeDefault    = @"DEFAULT";
static NSString * const SCSQLAttributeUnique     = @"UNIQUE";
static NSString * const SCSQLAttributeCheck      = @"CHECK";
static NSString * const SCSQLAttributeForeignKey = @"FOREIGN KEY";

static NSString * const SCSQLAttributeAutoIncremnt = @"AUTOINCREMENT";

/**
 *  Object-c type converted to SQLite type (把Objective-C类型转换为SQL类型)
 *
 *  @param objcType Objective-C类型
 *
 *  @return SQL类型
 */
extern NSString * SCSQLTypeFromObjcType(NSString * objcType);

@interface SCDatabase : NSObject

@end
