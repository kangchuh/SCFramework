//
//  SCLocationManager.m
//  SCFramework
//
//  Created by Angzn on 14/10/20.
//  Copyright (c) 2014年 Richer VC. All rights reserved.
//

#import "SCLocationManager.h"
#import "SCSingleton.h"

#import "UIAlertView+SCAddition.h"

#import <objc/runtime.h>

static void *SCCLLocationManagerAuthorizationTypeKey = &SCCLLocationManagerAuthorizationTypeKey;

@implementation CLLocationManager (SCLocationManager)

@dynamic authorizationType;

- (CLLocationManagerAuthorizationType)authorizationType
{
    id authorizationTypeObject = objc_getAssociatedObject(self,
                                                          SCCLLocationManagerAuthorizationTypeKey);
    return [authorizationTypeObject integerValue];
}

- (void)setAuthorizationType:(CLLocationManagerAuthorizationType)authorizationType
{
    id authorizationTypeObject = @(authorizationType);
    objc_setAssociatedObject(self,
                             SCCLLocationManagerAuthorizationTypeKey,
                             authorizationTypeObject,
                             OBJC_ASSOCIATION_ASSIGN);
}

@end


@interface SCLocationManager ()
<
CLLocationManagerDelegate
>

@property (nonatomic, strong) CLLocationManager                 *locationManager;

@property (nonatomic, copy  ) SCLocationManagerDidUpdateHandler didUpdateHandler;

@property (nonatomic, copy  ) SCLocationManagerDidFailHandler   didFailHandler;

@property (nonatomic, copy  ) SCLocationManagerConfigHandler    configHandler;

@end

@implementation SCLocationManager

SCSINGLETON(SCLocationManager);

- (instancetype)init
{
    self = [super init];
    if (self) {
        _stopWhenDidUpdate = YES;
        _stopWhenDidFail = YES;
        _alertWhenDidFail = YES;
    }
    return self;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if (_stopWhenDidUpdate) {
        [manager stopUpdatingLocation];
    }
    
    if (_didUpdateHandler) {
        _didUpdateHandler(locations);
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if (_stopWhenDidFail) {
        [manager stopUpdatingLocation];
    }
    
    if (_didFailHandler) {
        _didFailHandler(error);
    }
    
    if (_alertWhenDidFail) {
        NSString *message = NSLocalizedStringFromTable(@"SCFW_LS_Locate Fail", @"SCFWLocalizable", nil);
        [UIAlertView showWithMessage:message];
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse ||
        status == kCLAuthorizationStatusAuthorizedAlways) {
        [manager startUpdatingLocation];
    }
#else
    if (status == kCLAuthorizationStatusAuthorized) {
        [manager startUpdatingLocation];
    }
#endif
}

#pragma mark - Public Method

- (void)startLocateWithConfig:(SCLocationManagerConfigHandler)configHandler
                    didUpdate:(SCLocationManagerDidUpdateHandler)didUpdateHandler
                      didFail:(SCLocationManagerDidFailHandler)didFailHandler
{
    self.configHandler = configHandler;
    self.didUpdateHandler = didUpdateHandler;
    self.didFailHandler = didFailHandler;
    
    [self __startLocating];
}

#pragma mark - Private Method

- (void)__startLocating
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
        if ([_locationManager respondsToSelector:@selector(setAuthorizationType:)]) {
            _locationManager.authorizationType = CLLocationManagerAuthorizationTypeWhenInUse;
        }
#endif
    }
    
    if (_configHandler) {
        _configHandler(_locationManager);
    }
    
    CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
    if (authorizationStatus == kCLAuthorizationStatusNotDetermined) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
        if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)] ||
            [_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            if (_locationManager.authorizationType == CLLocationManagerAuthorizationTypeAlways) {
                [_locationManager requestAlwaysAuthorization];
            } else {
                [_locationManager requestWhenInUseAuthorization];
            }
        } else {
            [_locationManager startUpdatingLocation];
        }
#else
        [_locationManager startUpdatingLocation];
#endif
    } else if (authorizationStatus == kCLAuthorizationStatusRestricted ||
               authorizationStatus == kCLAuthorizationStatusDenied) {
        NSString *message = NSLocalizedStringFromTable(@"SCFW_LS_Location Services Disenable", @"SCFWLocalizable", nil);
        [UIAlertView showWithMessage:message];
    } else {
        [_locationManager startUpdatingLocation];
    }
}

@end
