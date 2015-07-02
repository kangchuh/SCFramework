//
//  SCCircleView.m
//  SCFramework
//
//  Created by Angzn on 3/10/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import "SCCircleView.h"
#import "UIColor+SCAddition.h"

static NSString * const kSCCircleViewRotationAnimationKey = @"kSCCircleViewRotationAnimationKey";

@implementation SCCircleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self defaultInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self defaultInit];
    }
    return self;
}

- (void)defaultInit
{
    self.backgroundColor = [UIColor clearColor];
    // 默认颜色
    //self.trackColor = [UIColor colorWithWholeRed:240.0
    //                                       green:240.0
    //                                        blue:240.0];
    //self.progressColor = [UIColor orangeColor];
    self.trackColor = [UIColor colorWithHex:0xdedede];
    self.progressColor = [UIColor colorWithHex:0xd21a1b];
    // 默认宽度
    self.progressWidth = 3.0;
}

#pragma mark - Draw Methods

- (void)drawRect:(CGRect)rect
{
    CGFloat thisWidth  = CGRectGetWidth(self.frame);
    CGFloat thisHeight = CGRectGetHeight(self.frame);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat lineWidth = _progressWidth;
    
    CGFloat centerX = thisWidth / 2.0;
    CGFloat centerY = thisHeight / 2.0;
    
    CGFloat radius = centerX - lineWidth;
    
    CGFloat startAngle = - M_PI_2;
    CGFloat endAngle   = startAngle + 2 * M_PI * _progress;
    
    //CGContextSetAllowsAntialiasing(context, true);
    //CGContextSetShouldAntialias(context, true);
    CGContextSetLineWidth(context, lineWidth);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetStrokeColorWithColor(context, _trackColor.CGColor);
    CGContextAddArc(context,
                    centerX,
                    centerY,
                    radius,
                    0,
                    2 * M_PI,
                    0);
    CGContextDrawPath(context, kCGPathStroke);//CGContextStrokePath(context);
    CGContextSetStrokeColorWithColor(context, _progressColor.CGColor);
    CGContextAddArc(context,
                    centerX,
                    centerY,
                    radius,
                    startAngle,
                    endAngle,
                    0);
    CGContextDrawPath(context, kCGPathStroke);//CGContextStrokePath(context);
}

#pragma mark - Public Methods

- (void)setTrackColor:(UIColor *)trackColor
{
    if (_trackColor != trackColor) {
        _trackColor = trackColor;
        [self setNeedsDisplay];
    }
}

- (void)setProgressColor:(UIColor *)progressColor
{
    if (_progressColor != progressColor) {
        _progressColor = progressColor;
        [self setNeedsDisplay];
    }
}

- (void)setProgressWidth:(CGFloat)progressWidth
{
    if (_progressWidth != progressWidth) {
        _progressWidth = progressWidth;
        [self setNeedsDisplay];
    }
}

- (void)setProgress:(CGFloat)progress
{
    if (_progress != progress) {
        _progress = progress;
        [self setNeedsDisplay];
    }
}

- (void)startRotating
{
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:
                                           @"transform.rotation.z"];
    rotationAnimation.toValue = @(M_PI * 2.0);
    rotationAnimation.duration = 1.0;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE_VALF;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:
                                        kCAMediaTimingFunctionLinear];
    [self.layer addAnimation:rotationAnimation forKey:kSCCircleViewRotationAnimationKey];
}

- (void)stopRotating
{
    [self.layer removeAnimationForKey:kSCCircleViewRotationAnimationKey];
}

@end

/*
@implementation SCCircleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self defaultInit];
        
        UIBezierPath *path = [self createBarPath];
        
        _trackLayer = [CAShapeLayer layer];
        _trackLayer.fillColor = [UIColor clearColor].CGColor;
        _trackLayer.lineCap = kCALineCapRound;
        _trackLayer.strokeColor = _trackColor.CGColor;
        _trackLayer.lineWidth = _progressWidth;
        _trackLayer.path = path.CGPath;
        _trackLayer.strokeEnd = 1.0;
        [self.layer addSublayer:_trackLayer];
        
        _progressLayer = [CAShapeLayer layer];
        _progressLayer.fillColor = [UIColor clearColor].CGColor;
        _progressLayer.lineCap = kCALineCapRound;
        _progressLayer.strokeColor = _progressColor.CGColor;
        _progressLayer.lineWidth = _progressWidth;
        _progressLayer.path = path.CGPath;
        _progressLayer.strokeEnd = 0.0;
        [self.layer addSublayer:_progressLayer];
    }
    return self;
}

- (void)defaultInit
{
    self.backgroundColor = [UIColor clearColor];
    // 默认颜色
    //self.trackColor = [UIColor colorWithWholeRed:240.0
    //                                       green:240.0
    //                                        blue:240.0];
    //self.progressColor = [UIColor orangeColor];
    self.trackColor = [UIColor colorWithHex:0xdedede];
    self.progressColor = [UIColor colorWithHex:0xd21a1b];
    // 默认宽度
    self.progressWidth = 3.0;
}

#pragma mark - Override Method

- (void)setTrackColor:(UIColor *)trackColor
{
    _trackColor = trackColor;
    
    _trackLayer.strokeColor = trackColor.CGColor;
}

- (void)setProgressColor:(UIColor *)progressColor
{
    _progressColor = progressColor;
    
    _progressLayer.strokeColor = progressColor.CGColor;
}

- (void)setProgressWidth:(CGFloat)progressWidth
{
    _progressWidth = progressWidth;
    
    _trackLayer.lineWidth = progressWidth;
    _progressLayer.lineWidth = progressWidth;
}

#pragma mark - Public Method

- (void)setProgress:(CGFloat)progress
{
    if (_progress != progress) {
        _progress = progress;
        [self setProgress];
    }
}

- (void)startRotating
{
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:
                                           @"transform.rotation.z"];
    rotationAnimation.toValue = @(M_PI * 2.0);
    rotationAnimation.duration = 1.0;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE_VALF;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:
                                        kCAMediaTimingFunctionLinear];
    [self.layer addAnimation:rotationAnimation forKey:kSCCircleViewRotationAnimationKey];
}

- (void)stopRotating
{
    [self.layer removeAnimationForKey:kSCCircleViewRotationAnimationKey];
}

#pragma mark - Private Method

- (UIBezierPath *)createBarPath
{
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    CGFloat radius = floor((fmin(width, height) - _progressWidth) / 2.0);
    CGFloat startAngle = - M_PI_2;
    CGFloat endAngle = startAngle + M_PI * 2;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.middle
                                                        radius:radius
                                                    startAngle:startAngle
                                                      endAngle:endAngle
                                                     clockwise:YES];
    return path;
}

- (void)setProgress
{
    _progressLayer.strokeEnd = _progress;
}

@end
*/
