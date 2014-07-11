//
//  UIView+SCAddition.h
//  SCFramework
//
//  Created by Angzn on 3/4/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SCAddition)

#pragma mark - Frame

@property (nonatomic) CGPoint origin;
@property (nonatomic) CGSize size;

@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat right;

@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat bottom;

@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;

@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;

@property (nonatomic, readonly) CGPoint middle;

- (void)setWidth:(CGFloat)width rightAlignment:(BOOL)rightAlignment;
- (void)setHeight:(CGFloat)height bottomAlignment:(BOOL)bottomAlignment;

#pragma mark - Border radius

/**
 *  @brief 设置圆角
 */
- (void)rounded:(CGFloat)cornerRadius;

/**
 *  @brief 设置圆角和边框
 */
- (void)rounded:(CGFloat)cornerRadius width:(CGFloat)borderWidth color:(UIColor *)borderColor;

/**
 *  @brief 设置边框
 */
- (void)border:(CGFloat)borderWidth color:(UIColor *)borderColor;

#pragma mark - Load Nib

/**
 *  @brief 从Xib加载视图
 *
 *  @description Loads an instance from the Nib named like the class. 
 *               Returns the first root object of the Nib.
 */
+ (id)loadFromNib;

@end
