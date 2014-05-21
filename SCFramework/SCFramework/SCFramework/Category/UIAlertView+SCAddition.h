//
//  UIAlertView+SCAddition.h
//  SCFramework
//
//  Created by Angzn on 3/5/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (SCAddition)

+ (void)showWithMessage:(NSString *)message;
+ (void)showWithTitle:(NSString *)title
              message:(NSString *)message;
+ (void)showWithTitle:(NSString *)title
              message:(NSString *)message
             delegate:(id)delegate;
+ (void)showWithTitle:(NSString *)title
              message:(NSString *)message
             delegate:(id)delegate
    cancelButtonTitle:(NSString *)cancelButtonTitle
     otherButtonTitle:(NSString *)otherButtonTitle;
+ (void)showWithTitle:(NSString *)title
              message:(NSString *)message
             delegate:(id)delegate
    cancelButtonTitle:(NSString *)cancelButtonTitle
     otherButtonTitle:(NSString *)otherButtonTitle
                  tag:(NSInteger)tag;

@end
