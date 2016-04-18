//
//  SCDatabaseMetaModel.h
//  SCFramework
//
//  Created by Angzn on 16/4/15.
//  Copyright © 2016年 Richer VC. All rights reserved.
//

#import "SCModel.h"

@interface SCDatabaseMetaModel : SCModel

/**
 *  @brief 元项类型(如:'table'/'index')
 */
@property (nonatomic, copy  ) NSString  *type;
/**
 *  @brief 元项名称(如:表格名称、索引名称)
 */
@property (nonatomic, copy  ) NSString  *name;
/**
 *  @brief 元项对应表格名称(如:索引对应表格)
 */
@property (nonatomic, copy  ) NSString  *tableName;
/**
 *  @brief 创建SQL语句
 */
@property (nonatomic, copy  ) NSString  *sql;

@end
