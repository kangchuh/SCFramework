//
//  SCDBNavigationController.m
//  SCFramework
//
//  Created by Angzn on 5/14/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import "SCDBNavigationController.h"
#import "UINavigationController+SCAddition.h"
#import "UIView+SCAddition.h"

#import "SCMacro.h"

// 拖动完成距离
static const CGFloat kSCDragCompleteDistance = 50.0;

// 返回动画持续时间
static const CGFloat kSCBackAnimationDuration = 0.3;

// 最后截屏初始缩放比例
static const CGFloat kSCLastScreenshotViewStartScale = 0.95;
// 最后截屏初始左边距离
static const CGFloat kSCLastScreenshotViewStartLeft = -180.0;
// 截屏蒙板初始透明度
static const CGFloat kSCScreenshotMaskStartAlpha = 0.4;

@interface SCDBNavigationController ()
<
UIGestureRecognizerDelegate
>
{
    /// 开始触摸位置
    CGPoint     _startTouchPoint;
    
    /// 最后截屏视图
    UIImageView *_lastScreenshotView;
    
    /// 截屏蒙板视图
    UIView      *_screenshotMask;
}

/// 交互拖动返回手势
@property (strong, nonatomic) UIPanGestureRecognizer *interactiveGestureRecognizer;

/// 交互拖动背景视图
@property (strong, nonatomic) UIView *interactiveBackgroundView;

/// 屏幕截图数组
@property (strong, nonatomic) NSMutableArray *screenshots;

@end

@implementation SCDBNavigationController

- (void)dealloc
{
    _interactiveGestureRecognizer.delegate = nil;
    
    [_interactiveBackgroundView removeFromSuperview];
}

#pragma mark - View LifeCycle

- (void)defaultInit
{
    _canDragBack = YES;
    
    _interactiveMode = SCDBNavigationControllerInteractiveDragModeFadeOut;
    
    _screenshots = [[NSMutableArray alloc] init];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Disable the default interactive pop gesture
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = nil;
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    // Custom interactive gesture recognizer
    _interactiveGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:
                                     @selector(handleTransitionGesture:)];
    _interactiveGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:_interactiveGestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Override Method

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    UIImage *capturedImage = [self capture];
    if (capturedImage) {
        [_screenshots addObject:capturedImage];
    }
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    [_screenshots removeLastObject];
    return [super popViewControllerAnimated:animated];
}

#pragma mark - UIGestureRecognizer Action

- (void)handleTransitionGesture:(UIPanGestureRecognizer *)recognizer
{
    if ([self isOnlyContainRootViewController] || !_canDragBack) {
        return;
    }
    
    CGPoint touchPoint = [recognizer locationInView:kSC_KEY_WINDOW];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        _startTouchPoint = touchPoint;
        [self beginInteractiveDrag];
    } else if (recognizer.state == UIGestureRecognizerStateEnded ||
               recognizer.state == UIGestureRecognizerStateCancelled) {
        if (touchPoint.x - _startTouchPoint.x > kSCDragCompleteDistance) {
            [self finishInteractiveDrag];
        } else {
            [self cancelInteractiveDrag];
        }
    } else {
        [self updateInteractiveDrag:touchPoint.x - _startTouchPoint.x];
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([self isOnlyContainRootViewController] || !_canDragBack) {
        if ([gestureRecognizer isEqual:_interactiveGestureRecognizer]) {
            return NO;
        }
    }
    return YES;
}
/*
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([self isOnlyContainRootViewController] || !_canDragBack) {
        if ([gestureRecognizer isEqual:_interactiveGestureRecognizer]) {
            return NO;
        }
    }
    return YES;
}
//*/
#pragma mark - Private Method

/**
 *  @brief 截屏
 */
- (UIImage *)capture
{
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size,
                                           self.view.opaque,
                                           0.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

/**
 *  @brief 移动视图
 *
 *  @param x 视图x坐标
 */
- (void)moveToX:(CGFloat)x
{
    CGFloat minX = 0;
    CGFloat maxX = kSC_MAIN_SCREEN_WIDTH;
    
    x = x < minX ? minX : x;
    x = x > maxX ? maxX : x;
    
    self.view.left = x;
    
    CGAffineTransform transform = self.view.transform;
    if (_interactiveMode == SCDBNavigationControllerInteractiveDragModeComeUp) {
        CGFloat startScale = kSCLastScreenshotViewStartScale;
        CGFloat scale = (x / (maxX / (1-startScale))) + startScale;
        transform = CGAffineTransformMakeScale(scale, scale);
    } else {
        CGFloat startLeft = kSCLastScreenshotViewStartLeft;
        CGFloat left = startLeft + (x / (maxX / fabs(startLeft)));
        transform.tx = left;
    }
    CGFloat startAlpha = kSCScreenshotMaskStartAlpha;
    CGFloat alpha = startAlpha - (x / (maxX / startAlpha));
    
    _lastScreenshotView.transform = transform;
    _screenshotMask.alpha = alpha;
}

/**
 *  @brief 开始交互拖动
 */
- (void)beginInteractiveDrag
{
    if (!_interactiveBackgroundView) {
        _interactiveBackgroundView = [[UIView alloc] initWithFrame:
                                      CGRectMake(0, 0, self.view.width , self.view.height)];
        [self.view.superview insertSubview:_interactiveBackgroundView
                              belowSubview:self.view];
        
        _lastScreenshotView = [[UIImageView alloc] initWithFrame:_interactiveBackgroundView.bounds];
        [_interactiveBackgroundView addSubview:_lastScreenshotView];
        
        _screenshotMask = [[UIView alloc] initWithFrame:_interactiveBackgroundView.bounds];
        _screenshotMask.backgroundColor = [UIColor blackColor];
        [_interactiveBackgroundView addSubview:_screenshotMask];
    }
    
    _interactiveBackgroundView.hidden = NO;
    _lastScreenshotView.image = [_screenshots lastObject];
}

/**
 *  @brief 更新交互拖动
 *
 *  @param x 视图x坐标
 */
- (void)updateInteractiveDrag:(CGFloat)x
{
    [self moveToX:x];
}

/**
 *  @brief 完成交互拖动返回
 */
- (void)finishInteractiveDrag
{
    [UIView animateWithDuration:kSCBackAnimationDuration animations:^{
        [self moveToX:kSC_MAIN_SCREEN_WIDTH];
    } completion:^(BOOL finished) {
        // 导航顶部视图推出栈
        [self popViewControllerAnimated:NO];
        // 导航视图恢复起始位置
        self.view.left = 0;
        self.interactiveBackgroundView.hidden = YES;
    }];
}

/**
 *  @brief 取消交互拖动返回
 */
- (void)cancelInteractiveDrag
{
    [UIView animateWithDuration:kSCBackAnimationDuration animations:^{
        [self moveToX:0];
    } completion:^(BOOL finished) {
        self.interactiveBackgroundView.hidden = YES;
    }];
}

@end
