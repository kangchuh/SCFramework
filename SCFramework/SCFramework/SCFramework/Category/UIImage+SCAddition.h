//
//  UIImage+SCAddition.h
//  SCFramework
//
//  Created by Angzn on 3/5/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (SCAddition)

- (UIImage *)fixOrientation;

- (UIImage *)transparent;

- (UIImage *)resize:(CGSize)newSize;

- (UIImage *)scaleTo:(CGSize)size;
- (UIImage *)scaleDown:(CGSize)maxSize;

- (UIImage *)stretched;
- (UIImage *)stretched:(UIEdgeInsets)capInsets;

- (UIImage *)rotate:(CGFloat)angle;
- (UIImage *)rotateCW90;
- (UIImage *)rotateCW180;
- (UIImage *)rotateCW270;

- (UIImage *)crop:(CGRect)rect;
- (UIImage *)cropSquare;

- (UIImage *)merge:(UIImage *)image;
+ (UIImage *)merge:(NSArray *)images;

- (NSData *)dataWithExt:(NSString *)ext;

- (UIColor *)patternColor;

- (CGFloat)width;
- (CGFloat)height;

@end
