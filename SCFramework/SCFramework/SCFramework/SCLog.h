//
//  SCLog.h
//  SCFramework
//
//  Created by Angzn on 3/4/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#ifndef SCFramework_SCLog_h
#define SCFramework_SCLog_h

//*

#define DEBUG_LOG_PREFIX        @"< %@:[Line %d] %s >\n"
#define DEBUG_LOG_FILENAME      [[NSString stringWithUTF8String:__FILE__] lastPathComponent]

// Only display output when the DEBUG setting
#ifdef DEBUG
#define DLog(frmt, ...)         { NSLog(DEBUG_LOG_PREFIX frmt, \
                                        DEBUG_LOG_FILENAME, \
                                        __LINE__, __FUNCTION__, \
                                        ##__VA_ARGS__); }
#define DRedLog(frmt, ...)      { NSLog(DEBUG_LOG_PREFIX frmt, \
                                        DEBUG_LOG_FILENAME, \
                                        __LINE__, __FUNCTION__, \
                                        ##__VA_ARGS__); }
#define DBlueLog(frmt, ...)     { NSLog(DEBUG_LOG_PREFIX frmt, \
                                        DEBUG_LOG_FILENAME, \
                                        __LINE__, __FUNCTION__, \
                                        ##__VA_ARGS__); }
#define ELog(err)               { if (err) DRedLog(@"%@", err); }
#else
#define DLog(frmt, ...)
#define DRedLog(frmt, ...)
#define DBlueLog(frmt, ...)
#define ELog(err)
#endif

// ALog always displays output regardless of the DEBUG setting
#ifndef ALog
#define ALog(frmt, ...)         { NSLog(DEBUG_LOG_PREFIX frmt, \
                                        DEBUG_LOG_FILENAME, \
                                        __LINE__, __FUNCTION__, \
                                        ##__VA_ARGS__); }
#endif

/*/

//
// Plugin : MCLog
//
#define __DLOG_FILE__ [[NSString stringWithUTF8String:__FILE__] lastPathComponent]

#define __DLog(LEVEL, fmt, ...) NSLog((@"-\e[7m" LEVEL @" [\e[27;2;3;4m < %@:[Line %d] %s > \e[22;23;24m] " fmt), \
                                        __DLOG_FILE__, __LINE__, __PRETTY_FUNCTION__, ##__VA_ARGS__)

// Only display output when the DEBUG setting
#ifdef DEBUG
#define DLogV(fmt, ...) __DLog(@"[VERBOSE]", fmt, ##__VA_ARGS__)
#define DLogI(fmt, ...) __DLog(@"[INFO]", fmt, ##__VA_ARGS__)
#define DLogW(fmt, ...) __DLog(@"[WARN]", fmt, ##__VA_ARGS__)
#define DLogE(fmt, ...) __DLog(@"[ERROR]", fmt, ##__VA_ARGS__)

#define DLog(fmt, ...)      { DLogI(fmt, ##__VA_ARGS__); }
#define DRedLog(fmt, ...)   { DLogE(fmt, ##__VA_ARGS__); }
#define DBlueLog(fmt, ...)  { DLogV(fmt, ##__VA_ARGS__); }
#define ELog(err)           { if (err) DRedLog(@"%@", err); }
#else
#define DLogV(fmt, ...)
#define DLogI(fmt, ...)
#define DLogW(fmt, ...)
#define DLogE(fmt, ...)

#define DLog(fmt, ...)
#define DRedLog(fmt, ...)
#define DBlueLog(fmt, ...)
#define ELog(err)
#endif

// ALog always displays output regardless of the DEBUG setting
#ifndef ALog
#define ALog(fmt, ...) __DLog(@"[ALWAY]", fmt, ##__VA_ARGS__)
#endif

//*/

#endif
