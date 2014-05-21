//
//  UIAlertView+SCAddition.m
//  SCFramework
//
//  Created by Angzn on 3/5/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import "UIAlertView+SCAddition.h"

@implementation UIAlertView (SCAddition)

+ (void)showWithMessage:(NSString *)message
{
    NSString *cancelTitle = NSLocalizedStringFromTable(@"SCFW_LS_OK", @"SCFWLocalizable", nil);
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:cancelTitle
                                          otherButtonTitles:nil];
	[alert show];
#if ! __has_feature(objc_arc)
	[alert release];
#endif
}

+ (void)showWithTitle:(NSString *)title
              message:(NSString *)message
{
    NSString *cancelTitle = NSLocalizedStringFromTable(@"SCFW_LS_OK", @"SCFWLocalizable", nil);
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:cancelTitle
                                          otherButtonTitles:nil];
	[alert show];
#if ! __has_feature(objc_arc)
	[alert release];
#endif
}

+ (void)showWithTitle:(NSString *)title
              message:(NSString *)message
             delegate:(id /*<UIAlertViewDelegate>*/)delegate
{
    NSString *cancelTitle = NSLocalizedStringFromTable(@"SCFW_LS_OK", @"SCFWLocalizable", nil);
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:delegate
                                          cancelButtonTitle:cancelTitle
                                          otherButtonTitles:nil];
	[alert show];
#if ! __has_feature(objc_arc)
	[alert release];
#endif
}

+ (void)showWithTitle:(NSString *)title
              message:(NSString *)message
             delegate:(id /*<UIAlertViewDelegate>*/)delegate
    cancelButtonTitle:(NSString *)cancelButtonTitle
     otherButtonTitle:(NSString *)otherButtonTitle
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:delegate
                                          cancelButtonTitle:cancelButtonTitle
                                          otherButtonTitles:otherButtonTitle, nil];
	[alert show];
#if ! __has_feature(objc_arc)
	[alert release];
#endif
}

+ (void)showWithTitle:(NSString *)title
              message:(NSString *)message
             delegate:(id /*<UIAlertViewDelegate>*/)delegate
    cancelButtonTitle:(NSString *)cancelButtonTitle
     otherButtonTitle:(NSString *)otherButtonTitle
                  tag:(NSInteger)tag
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:delegate
                                          cancelButtonTitle:cancelButtonTitle
                                          otherButtonTitles:otherButtonTitle, nil];
    [alert setTag:tag];
	[alert show];
#if ! __has_feature(objc_arc)
	[alert release];
#endif
}

@end
