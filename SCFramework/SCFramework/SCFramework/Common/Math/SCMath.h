//
//  SCMath.h
//  SCFramework
//
//  Created by Angzn on 5/4/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  是否等于零
 */
static inline BOOL SCMathEqualZero(double number) {
    const double EPSINON = 1.00e-07;//此处根据精度定
    return (number >= -EPSINON) && (number <= EPSINON);
}

/**
 *  四舍五入
 *
 *  @param number 数字
 *  @param digit  小数点位数
 */
static inline CGFloat SCMathRound(CGFloat number, NSInteger digit) {
    double powNum = pow(10, digit);
    return round(number * powNum) / powNum;
}

/**
 *  数字一半
 */
static inline CGFloat SCMathHalf(CGFloat number) {
    return number / 2.0;
};

/**
 *  数字两倍
 */
static inline CGFloat SCMathDouble(CGFloat number) {
    return number * 2.0;
};

/**
 *  角度转弧度
 */
static inline CGFloat SCMathDegreesToRadians(CGFloat degrees) {
    return degrees * (M_PI / 180);
};

/**
 *  弧度转角度
 */
static inline CGFloat SCMathRadiansToDegrees(CGFloat radians) {
    return radians * (180 / M_PI);
};

/**
 *  数字交换
 */
static inline void SCMathSWAP(CGFloat *a, CGFloat *b) {
    CGFloat t;
    t = *a;
    *a = *b;
    *b = t;
};

/**
 *  取整
 */
static inline CGFloat SCRectRound(CGFloat number) {
    return ceil(number);
}

/**
 *  上取整(不小于/大于等于)
 */
static inline CGFloat SCRectCeil(CGFloat number) {
    return ceil(number);
}

/**
 *  下取整(不大于/小于等于)
 */
static inline CGFloat SCRectFloor(CGFloat number) {
    return floor(number);
}

/**
 *  交换高度与宽度
 */
static inline CGSize SCSizeSWAP(CGSize size) {
    return CGSizeMake(size.height, size.width);
}

/**
 *  根据字体像素(px)大小获取字体磅(pt)大小
 */
//static inline CGFloat SCFontSizeFromPx(CGFloat px) {
//    return 0;
//}

@interface SCMath : NSObject

@end
