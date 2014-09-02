//
//  UIScreen+SCAddition.h
//  ZhongTouBang
//
//  Created by Angzn on 7/16/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScreen (SCAddition)

+ (CGFloat)width;
+ (CGFloat)height;
+ (BOOL)isFourInch;
+ (BOOL)isThreePointFiveInch;
+ (CGSize)size;
+ (CGSize)DPISize;

@end
