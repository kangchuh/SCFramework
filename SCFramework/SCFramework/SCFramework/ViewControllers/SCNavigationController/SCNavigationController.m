//
//  SCNavigationController.m
//  SCFramework
//
//  Created by Angzn on 3/10/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import "SCNavigationController.h"
#import "UINavigationController+SCAddition.h"

@interface SCNavigationController ()
<
UINavigationControllerDelegate,
UIGestureRecognizerDelegate
>
@end

@implementation SCNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.interactivePopEnabled = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Override Method

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // Hijack the push method to disable the gesture
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    [super pushViewController:viewController animated:animated];
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animate
{
    if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        if ([navigationController isOnlyContainRootViewController]) {
            // Disable the interactive pop gesture in the rootViewController of navigationController
            navigationController.interactivePopGestureRecognizer.enabled = NO;
        } else {
            // Enable the interactive pop gesture
            navigationController.interactivePopGestureRecognizer.enabled = YES;
        }
    }
}

#pragma mark - Public Method

- (BOOL)interactivePopEnabled
{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        return self.interactivePopGestureRecognizer.enabled;
    } else {
        return NO;
    }
}

- (void)setInteractivePopEnabled:(BOOL)interactivePopEnabled
{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        if (interactivePopEnabled) {
            self.interactivePopGestureRecognizer.delegate = self;
            self.delegate = self;
        } else {
            self.interactivePopGestureRecognizer.delegate = nil;
            self.delegate = nil;
        }
        self.interactivePopGestureRecognizer.enabled = interactivePopEnabled;
    }
}

@end
