//
//  SCTableMetaModel.h
//  SCFramework
//
//  Created by Angzn on 16/4/15.
//  Copyright © 2016年 Richer VC. All rights reserved.
//

#import "SCModel.h"

@interface SCTableMetaModel : SCModel

/**
 *  @brief 表格列ID
 */
@property (nonatomic, assign) NSInteger columnID;
/**
 *  @brief 列名称
 */
@property (nonatomic, copy  ) NSString  *name;
/**
 *  @brief 数据类型
 */
@property (nonatomic, copy  ) NSString  *type;
/**
 *  @brief 是否不为空
 */
@property (nonatomic, assign) BOOL      isNotNull;
/**
 *  @brief 是否为主键
 */
@property (nonatomic, assign) BOOL      isPrimaryKey;
/**
 *  @brief 默认值
 */
@property (nonatomic, strong) id        defaultValue;

@end
