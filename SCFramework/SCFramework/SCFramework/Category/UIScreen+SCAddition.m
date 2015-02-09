//
//  UIScreen+SCAddition.m
//  ZhongTouBang
//
//  Created by Angzn on 7/16/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import "UIScreen+SCAddition.h"
#import "UIDevice+SCAddition.h"
#import "SCAdaptedSystem.h"
#import "SCMath.h"
#import "SCApp.h"

@implementation UIScreen (SCAddition)

+ (CGSize)size
{
    return [[UIScreen mainScreen] bounds].size;
}

+ (CGFloat)width
{
    return [[UIScreen mainScreen] bounds].size.width;
}

+ (CGFloat)height
{
    return [[UIScreen mainScreen] bounds].size.height;
}

+ (CGSize)orientationSize
{
    BOOL swap = !SCiOS8OrLater() && [SCApp landscape];
    return swap ? SCSizeSWAP([UIScreen size]) : [UIScreen size];
}

+ (CGFloat)orientationWidth
{
    return [UIScreen orientationSize].width;
}

+ (CGFloat)orientationHeight
{
    return [UIScreen orientationSize].height;
}

+ (BOOL)isFivePointFiveInch
{
    return ([UIDevice iPhone] && ([UIScreen height] == 736.0 || [UIScreen width] == 736.0));
}

+ (BOOL)isFourPointSevenInch
{
    return ([UIDevice iPhone] && ([UIScreen height] == 667.0 || [UIScreen width] == 667.0));
}

+ (BOOL)isFourInch
{
    return ([UIDevice iPhone] && ([UIScreen height] == 568.0 || [UIScreen width] == 568.0));
}

+ (BOOL)isThreePointFiveInch
{
    return ([UIDevice iPhone] && ([UIScreen height] == 480.0 || [UIScreen width] == 480.0));
}

+ (CGSize)DPISize
{
    CGSize size = [[UIScreen mainScreen] bounds].size;
    CGFloat scale = [[UIScreen mainScreen] scale];
    return CGSizeMake(size.width * scale, size.height * scale);
}

@end
