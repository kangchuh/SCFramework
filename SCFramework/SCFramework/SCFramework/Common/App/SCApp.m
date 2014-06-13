//
//  SCApp.m
//  ZhongTouBang
//
//  Created by Angzn on 6/11/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import "SCApp.h"

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

@end
