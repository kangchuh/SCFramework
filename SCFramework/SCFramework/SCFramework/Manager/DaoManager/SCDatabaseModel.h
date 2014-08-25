//
//  SCDatabaseModel.h
//  ZhongTouBang
//
//  Created by Angzn on 8/22/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SCDatabaseModel <NSObject>

@required
+ (NSString *)tableName;

@optional
+ (NSString *)primaryKey;

@end
