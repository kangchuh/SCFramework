//
//  UIScreen+SCAddition.h
//  ZhongTouBang
//
//  Created by Angzn on 7/16/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScreen (SCAddition)

+ (CGSize)size;
+ (CGFloat)width;
+ (CGFloat)height;
+ (BOOL)isFivePointFiveInch;
+ (BOOL)isFourPointSevenInch;
+ (BOOL)isFourInch;
+ (BOOL)isThreePointFiveInch;
+ (CGSize)DPISize;

@end
