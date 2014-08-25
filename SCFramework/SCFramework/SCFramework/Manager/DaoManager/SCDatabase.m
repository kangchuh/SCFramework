//
//  SCDatabase.m
//  SCFramework
//
//  Created by Angzn on 8/21/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import "SCDatabase.h"

inline NSString * SCSQLTypeFromObjcType(NSString * objcType)
{
    if ([objcType isEqualToString:SCObjcTypeChar]) {
        return SCSQLTypeInt;
    } else if ([objcType isEqualToString:SCObjcTypeInt]) {
        return SCSQLTypeInt;
    } else if ([objcType isEqualToString:SCObjcTypeShort]) {
        return SCSQLTypeInt;
    } else if ([objcType isEqualToString:SCObjcTypeInt32]) {
        return SCSQLTypeInt;
    } else if ([objcType isEqualToString:SCObjcTypeInt64]) {
        return SCSQLTypeInt;
    } else if ([objcType isEqualToString:SCObjcTypeUChar]) {
        return SCSQLTypeInt;
    } else if ([objcType isEqualToString:SCObjcTypeUInt]) {
        return SCSQLTypeInt;
    } else if ([objcType isEqualToString:SCObjcTypeUShort]) {
        return SCSQLTypeInt;
    } else if ([objcType isEqualToString:SCObjcTypeUInt32]) {
        return SCSQLTypeInt;
    } else if ([objcType isEqualToString:SCObjcTypeUInt64]) {
        return SCSQLTypeInt;
    } else if ([objcType isEqualToString:SCObjcTypeFloat]) {
        return SCSQLTypeDouble;
    } else if ([objcType isEqualToString:SCObjcTypeDouble]) {
        return SCSQLTypeDouble;
    } else if ([objcType isEqualToString:SCObjcTypeBool]) {
        return SCSQLTypeInt;
    } else if ([objcType isEqualToString:SCObjcTypeCGPoint]) {
        return SCSQLTypeText;
    } else if ([objcType isEqualToString:SCObjcTypeCGSize]) {
        return SCSQLTypeText;
    } else if ([objcType isEqualToString:SCObjcTypeCGRect]) {
        return SCSQLTypeText;
    } else if ([objcType isEqualToString:SCObjcTypeNSDate]) {
        return SCSQLTypeDouble;
    } else if ([objcType isEqualToString:SCObjcTypeNSData]) {
        return SCSQLTypeBlob;
    } else if ([objcType isEqualToString:SCObjcTypeNSString]) {
        return SCSQLTypeText;
    }
    return SCSQLTypeText;
}

@implementation SCDatabase

@end
