//
//  SCActionSheet.m
//  SCFramework
//
//  Created by Angzn on 14/12/8.
//  Copyright (c) 2014年 Richer VC. All rights reserved.
//

#import "SCActionSheet.h"

@interface SCActionSheet ()
<
UIActionSheetDelegate
>

@property (nonatomic, copy) SCActionSheetClickedHandler      clickedHandler;
@property (nonatomic, copy) SCActionSheetCancelHandler       cancelHandler;
@property (nonatomic, copy) SCActionSheetWillPresentHandler  willPresentHandler;
@property (nonatomic, copy) SCActionSheetDidPresentHandler   didPresentHandler;
@property (nonatomic, copy) SCActionSheetWillDismissHandler  willDismissHandler;
@property (nonatomic, copy) SCActionSheetDidDismissHandler   didDismissHandler;

@end

@implementation SCActionSheet

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.clickedHandler) {
        self.clickedHandler(actionSheet, buttonIndex);
    }
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
    if (self.cancelHandler) {
        self.cancelHandler(actionSheet);
    }
}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    if (self.willPresentHandler) {
        self.willPresentHandler(actionSheet);
    }
}

- (void)didPresentActionSheet:(UIActionSheet *)actionSheet
{
    if (self.didPresentHandler) {
        self.didPresentHandler(actionSheet);
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (self.willDismissHandler) {
        self.willDismissHandler(actionSheet, buttonIndex);
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (self.didDismissHandler) {
        self.didDismissHandler(actionSheet, buttonIndex);
    }
}

#pragma mark - Public Method

- (void)setClickedHandler:(SCActionSheetClickedHandler)clickedHandler
{
    self.delegate = self;
    
    _clickedHandler = nil;
    _clickedHandler = [clickedHandler copy];
}

- (void)setCancelHandler:(SCActionSheetCancelHandler)cancelHandler
{
    self.delegate = self;
    
    _cancelHandler = nil;
    _cancelHandler = [cancelHandler copy];
}

- (void)setWillPresentHandler:(SCActionSheetWillPresentHandler)willPresentHandler
{
    self.delegate = self;
    
    _willPresentHandler = nil;
    _willPresentHandler = [willPresentHandler copy];
}

- (void)setDidPresentHandler:(SCActionSheetDidPresentHandler)didPresentHandler
{
    self.delegate = self;
    
    _didPresentHandler = nil;
    _didPresentHandler = [didPresentHandler copy];
}

- (void)setWillDismissHandler:(SCActionSheetWillDismissHandler)willDismissHandler
{
    self.delegate = self;
    
    _willDismissHandler = nil;
    _willDismissHandler = [willDismissHandler copy];
}

- (void)setDidDismissHandler:(SCActionSheetDidDismissHandler)didDismissHandler
{
    self.delegate = self;
    
    _didDismissHandler = nil;
    _didDismissHandler = [didDismissHandler copy];
}

@end
