//
//  UIColor+SCAddition.h
//  SCFramework
//
//  Created by Angzn on 3/5/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (SCAddition)

+ (UIColor *)colorWithWholeRed:(CGFloat)red
                         green:(CGFloat)green
                          blue:(CGFloat)blue
                         alpha:(CGFloat)alpha;

+ (UIColor *)colorWithWholeRed:(CGFloat)red
                         green:(CGFloat)green
                          blue:(CGFloat)blue;

+ (UIColor *)colorWithHex:(NSInteger)hexColor
                    alpha:(CGFloat)alpha;

+ (UIColor *)colorWithHex:(NSInteger)hexColor;

- (NSArray *)RGBComponents;

@end
