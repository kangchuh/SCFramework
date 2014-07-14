//
//  SCApp.m
//  ZhongTouBang
//
//  Created by Angzn on 6/11/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import "SCApp.h"

static NSString * const SCAppStoreURL = @"https://itunes.apple.com/app/id";

@implementation SCApp

+ (NSString *)name
{
    return [[NSBundle mainBundle] infoDictionary][(NSString*)kCFBundleExecutableKey];;
}

+ (NSString *)bundleID
{
    return [[NSBundle mainBundle] infoDictionary][(NSString*)kCFBundleIdentifierKey];
}

+ (NSString *)version
{
    return [[NSBundle mainBundle] infoDictionary][(NSString*)kCFBundleVersionKey];
}

+ (void)lock
{
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
}

+ (void)unlock
{
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

+ (void)launchAppStore:(NSString *)appID
{
    NSString *downloadURLString = [NSString stringWithFormat:@"%@%@", SCAppStoreURL, appID];
    NSURL *downloadURL = [NSURL URLWithString:downloadURLString];
    [[UIApplication sharedApplication] openURL:downloadURL];
}

@end
