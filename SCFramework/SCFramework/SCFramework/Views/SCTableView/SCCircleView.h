//
//  SCCircleView.h
//  SCFramework
//
//  Created by Angzn on 3/10/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import "SCView.h"

@interface SCCircleView : SCView

@property (nonatomic, strong) UIColor *trackColor;
@property (nonatomic, strong) UIColor *progressColor;
@property (nonatomic, assign) CGFloat progressWidth;
@property (nonatomic, assign) CGFloat progress; //0~1之间的数

- (void)startRotating;
- (void)stopRotating;

@end

/*
@interface SCCircleView : SCView
{
    CAShapeLayer *_trackLayer;
    
    CAShapeLayer *_progressLayer;
}

@property (nonatomic, strong) UIColor *trackColor;
@property (nonatomic, strong) UIColor *progressColor;
@property (nonatomic, assign) CGFloat progressWidth;
@property (nonatomic, assign) CGFloat progress; //0~1之间的数

- (void)startRotating;
- (void)stopRotating;

@end
*/
