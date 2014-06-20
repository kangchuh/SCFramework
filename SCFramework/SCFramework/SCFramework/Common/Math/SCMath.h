//
//  SCMath.h
//  SCFramework
//
//  Created by Angzn on 5/4/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import <Foundation/Foundation.h>

static inline BOOL SCMathEqualZero(double digit) {
    const double EPSINON = 1.00e-07;//此处根据精度定
    return (digit >= -EPSINON) && (digit <= EPSINON);
}

static inline CGFloat SCMathHalf(CGFloat digit) {
    return digit / 2.0;
};

static inline CGFloat SCMathDouble(CGFloat digit) {
    return digit * 2.0;
};

static inline CGFloat SCMathDegreesToRadians(CGFloat degrees) {
    return degrees * (M_PI / 180);
};

static inline CGFloat SCMathRadiansToDegrees(CGFloat radians) {
    return radians * (180 / M_PI);
};

static inline void SCMathSWAP(CGFloat *a, CGFloat *b) {
    CGFloat t;
    t = *a;
    *a = *b;
    *b = t;
};

/**
 *  取整
 */
static inline CGFloat SCRectRound(CGFloat digit) {
    return ceil(digit);
}

/**
 *  上取整(不小于/大于等于)
 */
static inline CGFloat SCRectCeil(CGFloat digit) {
    return ceil(digit);
}

/**
 *  下取整(不大于/小于等于)
 */
static inline CGFloat SCRectFloor(CGFloat digit) {
    return floor(digit);
}

/**
 *  根据字体像素(px)大小获取字体磅(pt)大小
 */
//static inline CGFloat SCFontSizeFromPx(CGFloat px) {
//    return 0;
//}

@interface SCMath : NSObject

@end
