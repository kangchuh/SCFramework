//
//  SCUtils.m
//  SCFramework
//
//  Created by Angzn on 8/22/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import "SCUtils.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import <ifaddrs.h>
#import <arpa/inet.h>

NSDictionary * SCGETCurrentNetworkInfo(void)
{
    NSDictionary *networkInfo = nil;
    CFArrayRef interfaces = CNCopySupportedInterfaces();
    if (interfaces != NULL) {
        CFStringRef interfaceName = CFArrayGetValueAtIndex(interfaces, 0);
        CFDictionaryRef networkInfoRef = CNCopyCurrentNetworkInfo(interfaceName);
        if (networkInfoRef != NULL) {
            networkInfo = (__bridge NSDictionary *)(networkInfoRef);
            CFRelease(networkInfoRef);
        }
        CFRelease(interfaces);
    }
    return networkInfo;
}

NSString * SCGETIPAddress(void)
{
    NSString *address = nil;
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if (temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    char * cAddress = inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr);
                    address = [NSString stringWithUTF8String:cAddress];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

@implementation SCUtils

@end
