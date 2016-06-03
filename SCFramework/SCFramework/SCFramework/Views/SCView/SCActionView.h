//
//  SCActionView.h
//  SCFramework
//
//  Created by Angzn on 9/19/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import "SCView.h"

typedef BOOL(^SCActionViewWillTapCancelHandler)(void);
typedef void(^SCActionViewDidTapCancelHandler)(void);

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

@property (nonatomic, assign) BOOL tapCancelDisabled;

@property (nonatomic, copy) SCActionViewWillTapCancelHandler willTapCancelHandler;
@property (nonatomic, copy) SCActionViewDidTapCancelHandler  didTapCancelHandler;

- (void)showInView:(UIView *)view;
- (void)dismiss;

@end
