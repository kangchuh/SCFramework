//
//  SCConfig.h
//  SCFramework
//
//  Created by Angzn on 3/4/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#ifndef SCFramework_SCConfig_h
#define SCFramework_SCConfig_h

// iPhone Device
#if TARGET_OS_IPHONE
#endif

// iPhone Simulator
#if TARGET_IPHONE_SIMULATOR
#endif

// ARC
#if __has_feature(objc_arc)
#endif

// MRC
#if ! __has_feature(objc_arc)
#endif

// 64-bit
#if __LP64__
#endif

// -------------------------- 编译器 -------------------------- //
#if !__has_feature(objc_arc)
#error SCFramework is ARC only. Either turn on ARC for the project or use -fobjc-arc flag
#endif

#if __LP64__
#define NSI "%ld"
#define NSU "%lu"
#define CGF "%lf"
#else
#define NSI "%d"
#define NSU "%u"
#define CGF "%f"
#endif

// -------------------------- 内存管理 -------------------------- //
#if __has_feature(objc_arc)
#if DEBUG
#define SCRelease(obj)
#else
#define SCRelease(obj)          obj = nil
#endif
#define SCSafeRelease(obj)      obj = nil
#else
#if DEBUG
#define SCRelease(obj)          [obj release]
#else
#define SCRelease(obj)          [obj release], obj = nil
#endif
#define SCSafeRelease(obj)      [obj release], obj = nil
#endif

#endif
