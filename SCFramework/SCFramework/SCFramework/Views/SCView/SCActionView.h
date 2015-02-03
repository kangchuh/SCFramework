//
//  SCActionView.h
//  SCFramework
//
//  Created by Angzn on 9/19/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import "SCView.h"

typedef NS_ENUM(NSUInteger, SCViewActionAnimations) {
    SCViewActionAnimationActionSheet,
    SCViewActionAnimationAlert,
};

@interface SCActionView : SCView

@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) NSTimeInterval delay;
@property (nonatomic, assign) UIViewAnimationOptions animationOptions;
@property (nonatomic, assign) SCViewActionAnimations actionAnimations;

@property (nonatomic, readonly, getter=isVisible) BOOL visible;

- (void)showInView:(UIView *)view;
- (void)dismiss;

@end
