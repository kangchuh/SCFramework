//
//  NSObject+SCAddition.h
//  SCFramework
//
//  Created by Angzn on 3/28/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const SCObjcTypeChar;
extern NSString * const SCObjcTypeInt;
extern NSString * const SCObjcTypeShort;
extern NSString * const SCObjcTypeInt32;
extern NSString * const SCObjcTypeInt64;

extern NSString * const SCObjcTypeUChar;
extern NSString * const SCObjcTypeUInt;
extern NSString * const SCObjcTypeUShort;
extern NSString * const SCObjcTypeUInt32;
extern NSString * const SCObjcTypeUInt64;

extern NSString * const SCObjcTypeFloat;
extern NSString * const SCObjcTypeDouble;

extern NSString * const SCObjcTypeBool;

extern NSString * const SCObjcTypeCGPoint;
extern NSString * const SCObjcTypeCGSize;
extern NSString * const SCObjcTypeCGRect;

extern NSString * const SCObjcTypeNSNumber;
extern NSString * const SCObjcTypeNSValue;

extern NSString * const SCObjcTypeNSDate;

extern NSString * const SCObjcTypeNSData;
extern NSString * const SCObjcTypeUIImage;

extern NSString * const SCObjcTypeNSString;

@interface NSObject (SCAddition)

+ (NSDictionary *)codableProperties;
- (NSDictionary *)codableProperties;

+ (NSDictionary *)storableProperties;
- (NSDictionary *)storableProperties;

@end
