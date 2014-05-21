//
//  SCExpandTableViewCell.h
//  SCFramework
//
//  Created by Angzn on 4/29/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import "SCTableViewCell.h"

@interface SCExpandTableViewCell : SCTableViewCell

/**
 * The boolean value showing the receiver is expandable or not.
 * The default value of this property is NO.
 */
@property (nonatomic, assign, getter = isExpandable) BOOL expandable;

/**
 * The boolean value showing the receiver is expanded or not.
 * The default value of this property is NO.
 */
@property (nonatomic, assign, getter = isExpanded) BOOL expanded;

@end
