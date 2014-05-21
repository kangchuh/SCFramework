//
//  SCMath.h
//  SCFramework
//
//  Created by Angzn on 5/4/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import <Foundation/Foundation.h>

static inline CGFloat SCMathDegreesToRadians(CGFloat degrees) { return degrees * (M_PI / 180); };
static inline CGFloat SCMathRadiansToDegrees(CGFloat radians) { return radians * (180 / M_PI); };

static inline void SCMathSWAP(CGFloat *a, CGFloat *b) {
    CGFloat t;
    t = *a;
    *a = *b;
    *b = t;
};

@interface SCMath : NSObject

@end
