//
//  SCApp.m
//  ZhongTouBang
//
//  Created by Angzn on 6/11/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import "SCApp.h"
#import "SCUserDefaultManager.h"

static NSString * const SCAppStoreURL = @"https://itunes.apple.com/app/id";

/**
 *  App是否已经启动过
 */
static NSString * const SCAppEverLaunchedKey = @"SCAppEverLaunchedKey";
/**
 *  App是否第一次启动
 */
static NSString * const SCAppFirstLaunchKey  = @"SCAppFirstLaunchKey";

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

+ (void)configFirstLaunch
{
    NSString *everLaunchKey = [NSString stringWithFormat:@"%@_%@",
                               SCAppEverLaunchedKey, [SCApp bundleID]];
    NSString *firstLaunchKey = [NSString stringWithFormat:@"%@_%@",
                                SCAppFirstLaunchKey, [SCApp bundleID]];
    if ([[SCUserDefaultManager sharedInstance] getBoolForKey:everLaunchKey]) {
        [[SCUserDefaultManager sharedInstance] setBool:NO forKey:firstLaunchKey];
    } else {
        [[SCUserDefaultManager sharedInstance] setBool:YES forKey:everLaunchKey];
        [[SCUserDefaultManager sharedInstance] setBool:YES forKey:firstLaunchKey];
    }
}

+ (BOOL)firstLaunch
{
    NSString *firstLaunchKey = [NSString stringWithFormat:@"%@_%@",
                                SCAppFirstLaunchKey, [SCApp bundleID]];
    return [[SCUserDefaultManager sharedInstance] getBoolForKey:firstLaunchKey];
}

@end
