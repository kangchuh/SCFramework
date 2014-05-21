//
//  SCCircleView.m
//  SCFramework
//
//  Created by Angzn on 3/10/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import "SCCircleView.h"

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
    self.trackColor = [UIColor colorWithWholeRed:240.0
                                           green:240.0
                                            blue:240.0];
    self.progressColor = [UIColor orangeColor];
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
    
    //CGContextSetShouldAntialias(context, YES);
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

@end

/*
@implementation SCCircleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _trackLayer = [CAShapeLayer new];
        _trackLayer.fillColor = nil;
        _trackLayer.lineJoin = kCALineJoinRound;
        _trackLayer.lineCap = kCALineCapRound;
        _trackLayer.frame = self.bounds;
        [self.layer addSublayer:_trackLayer];
        
        _progressLayer = [CAShapeLayer new];
        _progressLayer.fillColor = nil;
        _progressLayer.lineJoin = kCALineJoinRound;
        _progressLayer.lineCap = kCALineCapRound;
        _progressLayer.frame = self.bounds;
        [self.layer addSublayer:_progressLayer];
        
        [self defaultInit];
    }
    return self;
}

- (void)defaultInit
{
    self.backgroundColor = [UIColor clearColor];
    // 默认颜色
    self.trackColor = [UIColor colorWithWholeRed:240.0
                                           green:240.0
                                            blue:240.0];
    self.progressColor = [UIColor orangeColor];
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
    
    _trackLayer.lineWidth = _progressWidth;
    _progressLayer.lineWidth = _progressWidth;
    
    [self setTrack];
    [self setProgress];
}

#pragma mark - Public Method

- (void)setProgress:(CGFloat)progress
{
    if (_progress != progress) {
        _progress = progress;
        [self setProgress];
    }
}

#pragma mark - Private Method

- (void)setTrack
{
    CGFloat radius = floor((CGRectGetWidth(self.bounds) - _progressWidth) / 2.0);
    _trackPath = [UIBezierPath bezierPathWithArcCenter:self.middle
                                                radius:radius
                                            startAngle:0
                                              endAngle:M_PI * 2
                                             clockwise:YES];
    _trackLayer.path = _trackPath.CGPath;
}

- (void)setProgress
{
    CGFloat radius = floor((CGRectGetWidth(self.bounds) - _progressWidth) / 2.0);
    CGFloat startAngle = - M_PI_2;
    _progressPath = [UIBezierPath bezierPathWithArcCenter:self.middle
                                                   radius:radius
                                               startAngle:startAngle
                                                 endAngle:startAngle + (M_PI * 2) * _progress
                                                clockwise:YES];
    _progressLayer.path = _progressPath.CGPath;
}

@end
*/