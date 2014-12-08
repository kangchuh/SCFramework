//
//  SCAlertView.m
//  SCFramework
//
//  Created by Angzn on 14/12/8.
//  Copyright (c) 2014年 Richer VC. All rights reserved.
//

#import "SCAlertView.h"

@interface SCAlertView ()
<
UIAlertViewDelegate
>

@property (nonatomic, copy) SCAlertViewClickedHandler      clickedHandler;
@property (nonatomic, copy) SCAlertViewCancelHandler       cancelHandler;
@property (nonatomic, copy) SCAlertViewWillPresentHandler  willPresentHandler;
@property (nonatomic, copy) SCAlertViewDidPresentHandler   didPresentHandler;
@property (nonatomic, copy) SCAlertViewWillDismissHandler  willDismissHandler;
@property (nonatomic, copy) SCAlertViewDidDismissHandler   didDismissHandler;
@property (nonatomic, copy) SCAlertViewShouldEnableHandler shouldEnableHandler;

@end

@implementation SCAlertView

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.clickedHandler) {
        self.clickedHandler(alertView, buttonIndex);
    }
}

- (void)alertViewCancel:(UIAlertView *)alertView
{
    if (self.cancelHandler) {
        self.cancelHandler(alertView);
    }
}

- (void)willPresentAlertView:(UIAlertView *)alertView
{
    if (self.willPresentHandler) {
        self.willPresentHandler(alertView);
    }
}

- (void)didPresentAlertView:(UIAlertView *)alertView
{
    if (self.didPresentHandler) {
        self.didPresentHandler(alertView);
    }
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (self.willDismissHandler) {
        self.willDismissHandler(alertView, buttonIndex);
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (self.didDismissHandler) {
        self.didDismissHandler(alertView, buttonIndex);
    }
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    if (self.shouldEnableHandler) {
        self.shouldEnableHandler(alertView);
    }
    return YES;
}

#pragma mark - Public Method

- (void)setClickedHandler:(SCAlertViewClickedHandler)clickedHandler
{
    self.delegate = self;
    
    _clickedHandler = nil;
    _clickedHandler = [clickedHandler copy];
}

- (void)setCancelHandler:(SCAlertViewCancelHandler)cancelHandler
{
    self.delegate = self;
    
    _cancelHandler = nil;
    _cancelHandler = [cancelHandler copy];
}

- (void)setWillPresentHandler:(SCAlertViewWillPresentHandler)willPresentHandler
{
    self.delegate = self;
    
    _willPresentHandler = nil;
    _willPresentHandler = [willPresentHandler copy];
}

- (void)setDidPresentHandler:(SCAlertViewDidPresentHandler)didPresentHandler
{
    self.delegate = self;
    
    _didPresentHandler = nil;
    _didPresentHandler = [didPresentHandler copy];
}

- (void)setWillDismissHandler:(SCAlertViewWillDismissHandler)willDismissHandler
{
    self.delegate = self;
    
    _willDismissHandler = nil;
    _willDismissHandler = [willDismissHandler copy];
}

- (void)setDidDismissHandler:(SCAlertViewDidDismissHandler)didDismissHandler
{
    self.delegate = self;
    
    _didDismissHandler = nil;
    _didDismissHandler = [didDismissHandler copy];
}

- (void)setShouldEnableHandler:(SCAlertViewShouldEnableHandler)shouldEnableHandler
{
    self.delegate = self;
    
    _shouldEnableHandler = nil;
    _shouldEnableHandler = [shouldEnableHandler copy];
}

@end
