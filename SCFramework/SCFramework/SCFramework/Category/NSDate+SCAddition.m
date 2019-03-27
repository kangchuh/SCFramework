//
//  NSDate+SCAddition.m
//  SCFramework
//
//  Created by Angzn on 3/5/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import "NSDate+SCAddition.h"

@implementation NSDate (SCAddition)

- (NSTimeInterval)timestamp
{
    return [self timeIntervalSince1970];
}

- (NSInteger)year
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned int uintFlags = NSCalendarUnitYear;
    NSDateComponents *dateComponents = [calendar components:uintFlags
                                                   fromDate:self];
    return [dateComponents year];
}

- (NSInteger)month
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned int uintFlags = NSCalendarUnitMonth;
    NSDateComponents *dateComponents = [calendar components:uintFlags
                                                   fromDate:self];
    return [dateComponents month];
}

- (NSInteger)day
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned int uintFlags = NSCalendarUnitDay;
    NSDateComponents *dateComponents = [calendar components:uintFlags
                                                   fromDate:self];
    return [dateComponents day];
}

- (NSInteger)hour
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned int uintFlags = NSCalendarUnitHour;
    NSDateComponents *dateComponents = [calendar components:uintFlags
                                                   fromDate:self];
    return [dateComponents hour];
}

- (NSInteger)minute
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned int uintFlags = NSCalendarUnitMinute;
    NSDateComponents *dateComponents = [calendar components:uintFlags
                                                   fromDate:self];
    return [dateComponents minute];
}

- (NSInteger)second
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned int uintFlags = NSCalendarUnitSecond;
    NSDateComponents *dateComponents = [calendar components:uintFlags
                                                   fromDate:self];
    return [dateComponents second];
}

#if __IPHONE_OS_VERSION_MIN_REQUIRED < 70000
- (NSInteger)week
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned int uintFlags = NSWeekCalendarUnit;
    NSDateComponents *dateComponents = [calendar components:uintFlags
                                                   fromDate:self];
    return [dateComponents week];
}
#else
- (NSInteger)weekOfMonth
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned int uintFlags = NSCalendarUnitWeekOfMonth;
    NSDateComponents *dateComponents = [calendar components:uintFlags
                                                   fromDate:self];
    return [dateComponents weekOfMonth];
}

- (NSInteger)weekOfYear
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned int uintFlags = NSCalendarUnitWeekOfYear;
    NSDateComponents *dateComponents = [calendar components:uintFlags
                                                   fromDate:self];
    return [dateComponents weekOfYear];
}
#endif

/**
 *  @brief 获取月份的天数
 */
- (NSInteger)numberOfDaysInMonth
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSRange daysRang = [calendar rangeOfUnit:NSCalendarUnitDay
                                      inUnit:NSCalendarUnitMonth
                                     forDate:self];
    return daysRang.length;
}

/**
 *  @brief 判断是否闰年
 *
 *  @return 返回YES 闰年; NO 平年
 */
- (BOOL)isLeapYear
{
    NSInteger year = self.year;
    if ((0 == year % 4 && 0 != year % 100) || (0 == year % 400)) {
        return YES;
    }
    return NO;
}

/**
 *  @brief 时间转字符串
 *
 *  @param format 时间格式
 *
 *  @return 时间字符串
 */
- (NSString *)stringWithFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:format];
    NSString *dateString = [dateFormatter stringFromDate:self];
#if ! __has_feature(objc_arc)
    [dateFormatter release];
#endif
    return dateString;
}

/**
 *  @brief 一天的开始时间
 */
- (NSDate *)beginOfDay
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned int flags = (NSCalendarUnitYear |
                          NSCalendarUnitMonth |
                          NSCalendarUnitDay |
                          NSCalendarUnitHour |
                          NSCalendarUnitMinute |
                          NSCalendarUnitSecond);
    NSDateComponents *dateComponents = [calendar components:flags
                                                   fromDate:self];
    [dateComponents setHour:0];
    [dateComponents setMinute:0];
    [dateComponents setSecond:0];
    return [calendar dateFromComponents:dateComponents];
}

/**
 *  @brief 一天的结束时间
 */
- (NSDate *)endOfDay
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned int flags = (NSCalendarUnitYear |
                          NSCalendarUnitMonth |
                          NSCalendarUnitDay |
                          NSCalendarUnitHour |
                          NSCalendarUnitMinute |
                          NSCalendarUnitSecond);
    NSDateComponents *dateComponents = [calendar components:flags
                                                   fromDate:self];
    [dateComponents setHour:23];
    [dateComponents setMinute:59];
    [dateComponents setSecond:59];
    return [calendar dateFromComponents:dateComponents];
}

/**
 *  @brief 是否是同一天
 */
- (BOOL)isSameDay:(NSDate *)anotherDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components1 = [calendar components:(NSCalendarUnitYear |
                                                          NSCalendarUnitMonth |
                                                          NSCalendarUnitDay)
                                                fromDate:self];
    NSDateComponents *components2 = [calendar components:(NSCalendarUnitYear |
                                                          NSCalendarUnitMonth |
                                                          NSCalendarUnitDay)
                                                fromDate:anotherDate];
    return ([components1 year] == [components2 year] &&
            [components1 month] == [components2 month] &&
            [components1 day] == [components2 day]);
}

/**
 *  @brief 是否是今天
 */
- (BOOL)isToday
{
    return [self isSameDay:[NSDate date]];
}

/**
 *  @brief 日期相隔多少天
 */
- (NSInteger)daysSinceDate:(NSDate *)anotherDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSCalendarUnitDay;
    NSDateComponents *dateComponents = [calendar components:unitFlags
                                                   fromDate:self
                                                     toDate:anotherDate
                                                    options:0];
    return [dateComponents day];
}

@end
