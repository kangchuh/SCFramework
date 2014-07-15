//
//  SCVersionManager.h
//  SCFramework
//
//  Created by Angzn on 7/15/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const SCVersionManagerLanguageEnglish;
extern NSString * const SCVersionManagerLanguageChineseSimplified;
extern NSString * const SCVersionManagerLanguageChineseTraditional;

typedef NS_ENUM(NSUInteger, SCVersionAlertType) {
    SCVersionAlertTypeDefault,
    SCVersionAlertTypeSkip,
    SCVersionAlertTypeForce,
};

@protocol SCVersionManagerDelegate <NSObject>

@optional
- (void)versionManagerDidPresentAlert;
- (void)versionManagerDidLaunchAppStore;
- (void)versionManagerDidSkipVersion;
- (void)versionManagerDidCancel;

@end

@interface SCVersionManager : NSObject

@property (nonatomic, weak  ) id <SCVersionManagerDelegate> delegate;

@property (nonatomic, copy  ) NSString *appID;

@property (nonatomic, copy  ) NSString *appName;

@property (nonatomic, copy  ) NSString *countryCode;

@property (nonatomic, assign) SCVersionAlertType alertType;

+ (SCVersionManager *)sharedInstance;

- (void)checkVersion;

- (void)checkVersionDaily;

- (void)checkVersionWeekly;

@end
