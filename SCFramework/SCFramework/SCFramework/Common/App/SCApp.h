//
//  SCApp.h
//  ZhongTouBang
//
//  Created by Angzn on 6/11/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import <Foundation/Foundation.h>

static inline void SCApplicationLock(void) {
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
}

static inline void SCApplicationUnLock(void) {
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

@interface SCApp : NSObject

+ (NSString *)name;
+ (NSString *)bundleID;
+ (NSString *)version;
+ (NSString *)displayName;
+ (NSString *)shortVersion;

+ (UIInterfaceOrientation)orientation;

+ (BOOL)portrait;
+ (BOOL)landscape;

+ (CGSize)size;
+ (CGFloat)width;
+ (CGFloat)height;

+ (void)lock;
+ (void)unlock;

+ (NSString *)appStoreURL:(NSString *)appID;
+ (void)launchAppStore:(NSString *)appID;

+ (void)configFirstLaunch;
+ (BOOL)firstLaunch;

@end
