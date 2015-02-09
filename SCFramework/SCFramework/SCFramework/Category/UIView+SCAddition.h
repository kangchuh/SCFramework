//
//  UIView+SCAddition.h
//  SCFramework
//
//  Created by Angzn on 3/4/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  锚点位置
 */
typedef NS_ENUM(NSUInteger, SCUIViewAnchorPosition){
    /**
     *  左上角
     */
    SCUIViewAnchorTopLeft,
    /**
     *  右上角
     */
    SCUIViewAnchorTopRight,
    /**
     *  左下角
     */
    SCUIViewAnchorBottomLeft,
    /**
     *  右下角
     */
    SCUIViewAnchorBottomRight,
    /**
     *  中心
     */
    SCUIViewAnchorCenter,
};

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

@property (nonatomic) CGPoint topLeft;
@property (nonatomic) CGPoint topRight;
@property (nonatomic) CGPoint bottomLeft;
@property (nonatomic) CGPoint bottomRight;

@property (nonatomic, readonly) CGPoint middle;

@property (nonatomic, readonly) CGSize orientationSize;
@property (nonatomic, readonly) CGFloat orientationWidth;
@property (nonatomic, readonly) CGFloat orientationHeight;
@property (nonatomic, readonly) CGPoint orientationMiddle;

- (void)setWidth:(CGFloat)width rightAlignment:(BOOL)rightAlignment;
- (void)setHeight:(CGFloat)height bottomAlignment:(BOOL)bottomAlignment;

- (void)setSize:(CGSize)size anchor:(SCUIViewAnchorPosition)anchor;

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

#pragma mark - Animation

+ (void)animateFollowKeyboard:(NSDictionary *)userInfo
                   animations:(void(^)(NSDictionary *userInfo))animations
                   completion:(void (^)(BOOL finished))completion;

#pragma mark - Public Method

- (UIView *)firstResponder;

@end
