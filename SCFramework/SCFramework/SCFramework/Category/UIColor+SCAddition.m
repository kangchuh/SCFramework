//
//  UIColor+SCAddition.m
//  SCFramework
//
//  Created by Angzn on 3/5/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import "UIColor+SCAddition.h"

@implementation UIColor (SCAddition)

+ (UIColor *)colorWithWholeRed:(CGFloat)red
                         green:(CGFloat)green
                          blue:(CGFloat)blue
                         alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:red/255.f
                           green:green/255.f
                            blue:blue/255.f
                           alpha:alpha];
}

+ (UIColor *)colorWithWholeRed:(CGFloat)red
                         green:(CGFloat)green
                          blue:(CGFloat)blue
{
    return [self colorWithWholeRed:red
                             green:green
                              blue:blue
                             alpha:1.0];
}

+ (UIColor *)colorWithHex:(NSInteger)hexColor
                    alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:((float) ((hexColor & 0xFF0000) >> 16)) / 0xFF
                           green:((float) ((hexColor & 0xFF00)   >> 8))  / 0xFF
                            blue:((float)  (hexColor & 0xFF))            / 0xFF
                           alpha:alpha];
}

+ (UIColor *)colorWithHex:(NSInteger)hexColor
{
    return [self colorWithHex:hexColor alpha:1.0];
}

- (NSArray *)RGBComponents
{
    CGColorRef colorRef  = [self CGColor];
    size_t colorComponents = CGColorGetNumberOfComponents(colorRef);
    if (colorComponents == 4) {
        int rValue, gValue, bValue;
        const CGFloat *components = CGColorGetComponents(colorRef);
        rValue = (int)(components[0] * 255.0f);
        gValue = (int)(components[1] * 255.0f);
        bValue = (int)(components[2] * 255.0f);
        return [NSArray arrayWithObjects:
                [NSNumber numberWithInt:rValue],
                [NSNumber numberWithInt:gValue],
                [NSNumber numberWithInt:bValue], nil];
    }
    return nil;
}

@end
