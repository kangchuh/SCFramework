//
//  NSAttributedString+SCAddition.m
//  SCFramework
//
//  Created by Angzn on 16/5/9.
//  Copyright © 2016年 Richer VC. All rights reserved.
//

#import "NSAttributedString+SCAddition.h"

@implementation NSAttributedString (SCAddition)

- (CGFloat)heightForConstrainedToWidth:(CGFloat)width
{
    return [self sizeForConstrainedToWidth:width].height;
}

- (CGFloat)widthForConstrainedToHeight:(CGFloat)height
{
    return [self sizeForConstrainedToHeight:height].width;
}

- (CGSize)sizeForConstrainedToWidth:(CGFloat)width
{
    CGSize textSize = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                         options:(NSStringDrawingUsesLineFragmentOrigin |
                                                  NSStringDrawingTruncatesLastVisibleLine)
                                         context:nil].size;
    return CGSizeMake(ceil(textSize.width), ceil(textSize.height));
}

- (CGSize)sizeForConstrainedToHeight:(CGFloat)height
{
    CGSize textSize = [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height)
                                         options:(NSStringDrawingUsesLineFragmentOrigin |
                                                  NSStringDrawingTruncatesLastVisibleLine)
                                         context:nil].size;
    return CGSizeMake(ceil(textSize.width), ceil(textSize.height));
}

@end
