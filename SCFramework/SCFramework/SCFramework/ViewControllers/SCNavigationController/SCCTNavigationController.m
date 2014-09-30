//
//  SCCTNavigationController.m
//  SCFramework
//
//  Created by Angzn on 5/12/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import "SCCTNavigationController.h"

// 手势交互转场完成百分比值
static const CGFloat kSCInteractiveTransitionPercentComplete = 0.30;

@interface SCCTNavigationController ()
<
UIGestureRecognizerDelegate
>

/// 转场交互手势
@property (strong, nonatomic) UIPanGestureRecognizer *interactiveGestureRecognizer;

@end

@implementation SCCTNavigationController

- (void)dealloc
{
    self.delegate = nil;
    
    _interactiveGestureRecognizer.delegate = nil;
}

#pragma mark - View LifeCycle

- (void)defaultInit
{
    _interactiveEnabled = YES;
    
    _direction = SCViewControllerTransitionDirectionHorizontal;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self defaultInit];
    }
    return self;
}

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        [self defaultInit];
    }
    return self;
}

- (instancetype)initWithNavigationBarClass:(Class)navigationBarClass toolbarClass:(Class)toolbarClass
{
    self = [super initWithNavigationBarClass:navigationBarClass toolbarClass:toolbarClass];
    if (self) {
        [self defaultInit];
    }
    return self;
}

- (instancetype)initWithNavigationBarClass:(Class)navigationBarClass
{
    self = [self initWithNavigationBarClass:navigationBarClass toolbarClass:nil];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    // Disable the default interactive pop gesture
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = nil;
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    // Navigation controller delegate object
    _delegateManager = [[SCCTNavigationControllerDelegateManager alloc] init];
    self.delegate = _delegateManager;
    
    // Custom interactive gesture recognizer
    _interactiveGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:
                                     @selector(handleTransitionGesture:)];
    _interactiveGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:_interactiveGestureRecognizer];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIGestureRecognizer Action

- (void)handleTransitionGesture:(UIPanGestureRecognizer *)recognizer
{
    UIView *touchView = recognizer.view;
    
    CGFloat transitionPercent = 0.0;
    if (_direction == SCViewControllerTransitionDirectionHorizontal) {
        CGFloat transitionX = [recognizer translationInView:touchView].x;
        CGFloat transitionWidth = touchView.width;
        transitionPercent = transitionX / transitionWidth;
    } else if (_direction == SCViewControllerTransitionDirectionVertical) {
        CGFloat transitionY = [recognizer translationInView:touchView].y;
        CGFloat transitionHeight = touchView.height;
        transitionPercent = transitionY / transitionHeight;
    }
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan: {
            _delegateManager.interactiveAnimator = [[UIPercentDrivenInteractiveTransition alloc] init];
            [self popViewControllerAnimated:YES];
            break;
        }
        case UIGestureRecognizerStateChanged: {
            [_delegateManager.interactiveAnimator updateInteractiveTransition:transitionPercent];
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            if (transitionPercent > kSCInteractiveTransitionPercentComplete) {
                [_delegateManager.interactiveAnimator finishInteractiveTransition];
            } else {
                [_delegateManager.interactiveAnimator cancelInteractiveTransition];
            }
            _delegateManager.interactiveAnimator = nil;
            break;
        }
        default:
            break;
    }
}

#pragma mark - SCViewControllerTransitionAnimatorOption

- (SCViewControllerTransitionDirection)transitionDirection
{
    return _direction;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([[self transitionCoordinator] isAnimated]) {
        return NO;
    }
    if ([self isOnlyContainRootViewController] || !_interactiveEnabled) {
        if ([gestureRecognizer isEqual:_interactiveGestureRecognizer]) {
            return NO;
        }
    }
    return YES;
}
/*
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([[self transitionCoordinator] isAnimated]) {
        return NO;
    }
    if ([self isOnlyContainRootViewController]) {
        if ([gestureRecognizer isEqual:_interactiveGestureRecognizer]) {
            return NO;
        }
    }
    return YES;
}
//*/
@end
