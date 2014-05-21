//
//  SCLog.h
//  SCFramework
//
//  Created by Angzn on 3/4/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#ifndef SCFramework_SCLog_h
#define SCFramework_SCLog_h

#define XCODE_COLORS_ESCAPE     @"\033["

#define XCODE_COLORS_RESET_FG   XCODE_COLORS_ESCAPE @"fg;" // Clear any foreground color
#define XCODE_COLORS_RESET_BG   XCODE_COLORS_ESCAPE @"bg;" // Clear any background color
#define XCODE_COLORS_RESET      XCODE_COLORS_ESCAPE @";"   // Clear any foreground or background color

#define DEBUG_LOG_COLOR_PREFIX  @"fg0,160,255;"
#define DEBUG_LOG_COLOR_CONTENT @"fg65,205,69;"
#define DEBUG_LOG_COLOR_RED     @"fg255,0,0;"
#define DEBUG_LOG_COLOR_BLUE    @"fg0,0,255;"

#define DEBUG_LOG_PREFIX        @"< %@:[Line %d] %s >\n"
#define DEBUG_LOG_FILENAME      [[NSString stringWithUTF8String:__FILE__] lastPathComponent]

// Only display output when the DEBUG setting
#ifdef DEBUG
#define DLog(frmt, ...)     { NSLog((XCODE_COLORS_ESCAPE DEBUG_LOG_COLOR_PREFIX DEBUG_LOG_PREFIX XCODE_COLORS_RESET \
                                    XCODE_COLORS_ESCAPE DEBUG_LOG_COLOR_CONTENT frmt XCODE_COLORS_RESET), \
                                    DEBUG_LOG_FILENAME, __LINE__, __FUNCTION__, ##__VA_ARGS__); }
#define DRedLog(frmt, ...)  { NSLog((XCODE_COLORS_ESCAPE DEBUG_LOG_COLOR_RED DEBUG_LOG_PREFIX frmt XCODE_COLORS_RESET), \
                                    DEBUG_LOG_FILENAME, __LINE__, __FUNCTION__, ##__VA_ARGS__); }
#define DBlueLog(frmt, ...) { NSLog((XCODE_COLORS_ESCAPE DEBUG_LOG_COLOR_BLUE DEBUG_LOG_PREFIX frmt XCODE_COLORS_RESET), \
                                    DEBUG_LOG_FILENAME, __LINE__, __FUNCTION__, ##__VA_ARGS__); }
#define ELog(err)           { if (err) DRedLog(@"%@", err); }
#else
#define DLog(frmt, ...)
#define DRedLog(frmt, ...)
#define DBlueLog(frmt, ...)
#define ELog(err)
#endif

// ALog always displays output regardless of the DEBUG setting
#ifndef ALog
#define ALog(frmt, ...)     { NSLog((XCODE_COLORS_ESCAPE DEBUG_LOG_COLOR_PREFIX DEBUG_LOG_PREFIX XCODE_COLORS_RESET \
                                    XCODE_COLORS_ESCAPE DEBUG_LOG_COLOR_CONTENT frmt XCODE_COLORS_RESET), \
                                    DEBUG_LOG_FILENAME, __LINE__, __FUNCTION__, ##__VA_ARGS__); }
#endif

#endif
