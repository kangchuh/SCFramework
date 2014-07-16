//
//  UIScreen+SCAddition.m
//  ZhongTouBang
//
//  Created by Angzn on 7/16/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import "UIScreen+SCAddition.h"

@implementation UIScreen (SCAddition)

+ (CGFloat)width
{
    return [[UIScreen mainScreen] bounds].size.width;
}

+ (CGFloat)height
{
    return [[UIScreen mainScreen] bounds].size.height;
}

+ (BOOL)isFourInch
{
    return ([UIDevice iPhone] && [UIScreen height] == 568.0);
}

+ (BOOL)isThreePointFiveInch
{
    return ([UIDevice iPhone] && [UIScreen height] == 480.0);
}

@end
