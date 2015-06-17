//
//  SCVersionManager.m
//  SCFramework
//
//  Created by Angzn on 7/15/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import "SCVersionManager.h"
#import "SCSingleton.h"

#import "SCUserDefaultManager.h"

#import "NSString+SCAddition.h"
#import "NSData+SCAddition.h"
#import "NSDate+SCAddition.h"
#import "NSArray+SCAddition.h"

#import "SCNSJSONSerialization.h"

#import "SCApp.h"

NSString * const SCVersionManagerLanguageEnglish = @"en";
NSString * const SCVersionManagerLanguageChineseSimplified = @"zh-Hans";
NSString * const SCVersionManagerLanguageChineseTraditional = @"zh-Hant";

/**
 *  最后版本检查日期
 */
static NSString * const SCVersionManagerCheckDateKey = @"Version Last Check Date";
/**
 *  用户是否跳过版本
 */
static NSString * const SCVersionManagerShouldSkipVersionKey = @"User Skip Version Update";
/**
 *  用户跳过版本号
 */
static NSString * const SCVersionManagerDidSkippedVersionKey = @"User Skipped Version Number";

/**
 *  查找版本信息URL
 */
#define SCFW_LOOKUP_VERSION_URL_UNIVERSAL   @"http://itunes.apple.com/lookup?id=%@"
/**
 *  查找版本信息URL(指定国家)
 */
#define SCFW_LOOKUP_VERSION_URL_SPECIFIC    @"http://itunes.apple.com/lookup?id=%@&country=%@"

@interface SCVersionManager ()
<
UIAlertViewDelegate
>

/// 版本信息
@property (strong, nonatomic) NSDictionary *versionInfo;

/// 最后检查日期
@property (strong, nonatomic) NSDate       *lastCheckDate;

@end

@implementation SCVersionManager

SCSINGLETON(SCVersionManager);

#pragma mark - Init Method

- (instancetype)init
{
    self = [super init];
    if (self) {
        _alertType = SCVersionAlertTypeDefault;
        
        _lastCheckDate = [[SCUserDefaultManager sharedInstance]
                          getObjectForKey:SCVersionManagerCheckDateKey];
    }
    return self;
}

#pragma mark - UIAlertViewDelegate

- (void)didPresentAlertView:(UIAlertView *)alertView
{
    if (_delegate && [_delegate respondsToSelector:@selector(versionManagerDidPresentAlert)]) {
        [_delegate versionManagerDidPresentAlert];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch (_alertType) {
        case SCVersionAlertTypeDefault: {
            if (1 == buttonIndex) {
                [SCApp launchAppStore:_appID];
                if (_delegate && [_delegate respondsToSelector:@selector(versionManagerDidLaunchAppStore)]){
                    [_delegate versionManagerDidLaunchAppStore];
                }
            } else {
                if (_delegate && [_delegate respondsToSelector:@selector(versionManagerDidCancel)]){
                    [_delegate versionManagerDidCancel];
                }
            }
            break;
        }
        case SCVersionAlertTypeSkip: {
            if (1 == buttonIndex) {
                [SCApp launchAppStore:_appID];
                if (_delegate && [_delegate respondsToSelector:@selector(versionManagerDidLaunchAppStore)]){
                    [_delegate versionManagerDidLaunchAppStore];
                }
            } else if (2 == buttonIndex) {
                if (_delegate && [_delegate respondsToSelector:@selector(versionManagerDidCancel)]){
                    [_delegate versionManagerDidCancel];
                }
            } else {
                [[SCUserDefaultManager sharedInstance] setBool:YES
                                                        forKey:SCVersionManagerShouldSkipVersionKey];
                [[SCUserDefaultManager sharedInstance] setObject:_versionInfo[@"version"]
                                                          forKey:SCVersionManagerDidSkippedVersionKey];
                if (_delegate && [_delegate respondsToSelector:@selector(versionManagerDidSkipVersion)]){
                    [_delegate versionManagerDidSkipVersion];
                }
            }
            break;
        }
        case SCVersionAlertTypeForce: {
            [SCApp launchAppStore:_appID];
            if (_delegate && [_delegate respondsToSelector:@selector(versionManagerDidLaunchAppStore)]){
                [_delegate versionManagerDidLaunchAppStore];
            }
            break;
        }
    }
}

#pragma mark - Public Method

- (void)checkVersion
{
    NSAssert(_appID, @"AppID must not be nil.");
    
    NSString *lookupURLString = nil;
    if ([_countryCode isNotEmpty]) {
        lookupURLString = [NSString stringWithFormat:SCFW_LOOKUP_VERSION_URL_SPECIFIC, _appID, _countryCode];
    } else {
        lookupURLString = [NSString stringWithFormat:SCFW_LOOKUP_VERSION_URL_UNIVERSAL, _appID];
    }
    
    NSURL *lookupURL = [NSURL URLWithString:lookupURLString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:lookupURL];
    [request setHTTPMethod:@"GET"];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:
     ^(NSURLResponse *response, NSData *data, NSError *error) {
         if (!error && [data isNotEmpty]) {
             NSDictionary *dictionary = [SCNSJSONSerialization objectFromData:data];
             dispatch_async(dispatch_get_main_queue(), ^{
                 self.lastCheckDate = [NSDate date];
                 [[SCUserDefaultManager sharedInstance] setObject:_lastCheckDate
                                                           forKey:SCVersionManagerCheckDateKey];
                 
                 DLog(@"Version : %@", dictionary);
                 NSArray *versions = [dictionary arrayForKey:@"results"];
                 if ([versions isNotEmpty]) {
                     self.versionInfo = [versions firstObject];
                     NSString *currentVersion = [_versionInfo stringForKey:@"version"];
                     [self __checkIfUpdateAvailable:currentVersion];
                 }
             });
         }
     }];
}

- (void)checkVersionDaily
{
    if (!_lastCheckDate) {
        [self checkVersion];
    }
    
    if ([_lastCheckDate daysSinceDate:[NSDate date]] > 1) {
        [self checkVersion];
    }
}

- (void)checkVersionWeekly
{
    if (!_lastCheckDate) {
        [self checkVersion];
    }
    
    if ([_lastCheckDate daysSinceDate:[NSDate date]] > 7) {
        [self checkVersion];
    }
}

#pragma mark - Private Method

- (void)__checkIfUpdateAvailable:(NSString *)currentVersion
{
    if ([[SCApp shortVersion] compare:currentVersion options:NSNumericSearch] == NSOrderedAscending) {
        [self __showUpdateAlertIfNotSkipped:currentVersion];
    }
}

- (void)__showUpdateAlertIfNotSkipped:(NSString *)currentVersion
{
    BOOL shouldSkipVersion = [[SCUserDefaultManager sharedInstance] getBoolForKey:
                              SCVersionManagerShouldSkipVersionKey];
    NSString *skippedVersion = [[SCUserDefaultManager sharedInstance] getStringForKey:
                                SCVersionManagerDidSkippedVersionKey];
    
    if (!shouldSkipVersion) {
        [self __showUpdateAlertWithVersion:currentVersion];
    } else if (shouldSkipVersion && ![skippedVersion isEqualToString:currentVersion]) {
        [self __showUpdateAlertWithVersion:currentVersion];
    } else {
        // Don't show alert.
        return;
    }
}

- (void)__showUpdateAlertWithVersion:(NSString *)currentVersion
{
    NSString *appName = [_appName isNotEmpty] ? _appName : [SCApp displayName];
    
    NSString *title = NSLocalizedStringFromTable(@"SCFW_LS_Update Available", @"SCFWLocalizable", nil);
    NSString *message = [NSString stringWithFormat:NSLocalizedStringFromTable(@"SCFW_LS_A new version of %@ is available. Please update to version %@ now.", @"SCFWLocalizable", nil), appName, currentVersion];
    
    NSString *updateButtonTitle = NSLocalizedStringFromTable(@"SCFW_LS_Update", @"SCFWLocalizable", nil);
    NSString *nextTimeButtonTitle = NSLocalizedStringFromTable(@"SCFW_LS_Next time", @"SCFWLocalizable", nil);
    NSString *skipButtonTitle = NSLocalizedStringFromTable(@"SCFW_LS_Skip this version", @"SCFWLocalizable", nil);
    
    UIAlertView *alertView = nil;
    switch (_alertType) {
        case SCVersionAlertTypeDefault: {
            alertView = [[UIAlertView alloc] initWithTitle:title
                                                   message:message
                                                  delegate:self
                                         cancelButtonTitle:nextTimeButtonTitle
                                         otherButtonTitles:updateButtonTitle, nil];
            break;
        }
        case SCVersionAlertTypeSkip: {
            alertView = [[UIAlertView alloc] initWithTitle:title
                                                   message:message
                                                  delegate:self
                                         cancelButtonTitle:skipButtonTitle
                                         otherButtonTitles:updateButtonTitle, nextTimeButtonTitle, nil];
            break;
        }
        case SCVersionAlertTypeForce: {
            alertView = [[UIAlertView alloc] initWithTitle:title
                                                   message:message
                                                  delegate:self
                                         cancelButtonTitle:updateButtonTitle
                                         otherButtonTitles:nil];
            break;
        }
    }
    [alertView show];
}

@end
