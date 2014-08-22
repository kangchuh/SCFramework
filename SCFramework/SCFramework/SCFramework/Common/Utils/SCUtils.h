//
//  SCUtils.h
//  SCFramework
//
//  Created by Angzn on 8/22/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  获取网络信息(Wi-Fi情况下)
 */
NSDictionary * SCGETCurrentNetworkInfo(void);

/**
 *  获取IP地址(Wi-Fi情况下)
 */
NSString * SCGETIPAddress(void);

@interface SCUtils : NSObject

@end
