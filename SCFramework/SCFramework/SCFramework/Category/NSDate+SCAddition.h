//
//  NSDate+SCAddition.h
//  SCFramework
//
//  Created by Angzn on 3/5/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kSCFW_SECOND_MINUTE     60
#define kSCFW_SECOND_HOUR       3600
#define kSCFW_SECOND_DAY		86400
#define kSCFW_SECOND_WEEK       604800
#define kSCFW_SECOND_YEAR       31556926

@interface NSDate (SCAddition)

/// 时间戳
- (NSTimeInterval)timestamp;

- (NSInteger)year;
- (NSInteger)month;
- (NSInteger)day;
- (NSInteger)hour;
- (NSInteger)minute;
- (NSInteger)second;

/// 获取月份的天数
- (NSInteger)numberOfDaysInMonth;

/// 判断是否闰年
- (BOOL)isLeapYear;

/// 时间转字符串
- (NSString *)stringWithFormat:(NSString *)format;

/// 一天的开始时间
- (NSDate *)beginOfDay;
/// 一天的结束时间
- (NSDate *)endOfDay;

/// 是否是同一天
- (BOOL)isSameDay:(NSDate *)anotherDate;

/// 是否是今天
- (BOOL)isToday;

/// 日期相隔多少天
- (NSInteger)daysSinceDate:(NSDate *)anotherDate;

@end
