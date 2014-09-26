//
//  UITableView+SCAddition.m
//  SCFramework
//
//  Created by Angzn on 9/26/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import "UITableView+SCAddition.h"

@implementation UITableView (SCAddition)

- (NSIndexPath *)indexPathForCellOfSubView:(UIView *)subview
{
    while (subview && !([subview isKindOfClass:[UITableViewCell class]] ||
                        [subview isMemberOfClass:[UITableViewCell class]])) {
        subview = subview.superview;
    }
    return [self indexPathForCell:(UITableViewCell *)subview];
}

@end
