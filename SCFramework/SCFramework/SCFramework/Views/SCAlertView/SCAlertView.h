//
//  SCAlertView.h
//  SCFramework
//
//  Created by Angzn on 14/12/8.
//  Copyright (c) 2014年 Richer VC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SCAlertViewClickedHandler)(UIAlertView *alertView, NSInteger buttonIndex);
typedef void(^SCAlertViewCancelHandler)(UIAlertView *alertView);
typedef void(^SCAlertViewWillPresentHandler)(UIAlertView *alertView);
typedef void(^SCAlertViewDidPresentHandler)(UIAlertView *alertView);
typedef void(^SCAlertViewWillDismissHandler)(UIAlertView *alertView, NSInteger buttonIndex);
typedef void(^SCAlertViewDidDismissHandler)(UIAlertView *alertView, NSInteger buttonIndex);
typedef BOOL(^SCAlertViewShouldEnableHandler)(UIAlertView *alertView);

@interface SCAlertView : UIAlertView

- (void)setClickedHandler:(SCAlertViewClickedHandler)clickedHandler;
- (void)setCancelHandler:(SCAlertViewCancelHandler)cancelHandler;
- (void)setWillPresentHandler:(SCAlertViewWillPresentHandler)willPresentHandler;
- (void)setDidPresentHandler:(SCAlertViewDidPresentHandler)didPresentHandler;
- (void)setWillDismissHandler:(SCAlertViewWillDismissHandler)willDismissHandler;
- (void)setDidDismissHandler:(SCAlertViewDidDismissHandler)didDismissHandler;
- (void)setShouldEnableHandler:(SCAlertViewShouldEnableHandler)shouldEnableHandler;

@end
