//
//  SCActionSheet.h
//  SCFramework
//
//  Created by Angzn on 14/12/8.
//  Copyright (c) 2014年 Richer VC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SCActionSheetClickedHandler)(UIActionSheet *actionSheet, NSInteger buttonIndex);
typedef void(^SCActionSheetCancelHandler)(UIActionSheet *actionSheet);
typedef void(^SCActionSheetWillPresentHandler)(UIActionSheet *actionSheet);
typedef void(^SCActionSheetDidPresentHandler)(UIActionSheet *actionSheet);
typedef void(^SCActionSheetWillDismissHandler)(UIActionSheet *actionSheet, NSInteger buttonIndex);
typedef void(^SCActionSheetDidDismissHandler)(UIActionSheet *actionSheet, NSInteger buttonIndex);

@interface SCActionSheet : UIActionSheet

- (void)setClickedHandler:(SCActionSheetClickedHandler)clickedHandler;
- (void)setCancelHandler:(SCActionSheetCancelHandler)cancelHandler;
- (void)setWillPresentHandler:(SCActionSheetWillPresentHandler)willPresentHandler;
- (void)setDidPresentHandler:(SCActionSheetDidPresentHandler)didPresentHandler;
- (void)setWillDismissHandler:(SCActionSheetWillDismissHandler)willDismissHandler;
- (void)setDidDismissHandler:(SCActionSheetDidDismissHandler)didDismissHandler;

@end
