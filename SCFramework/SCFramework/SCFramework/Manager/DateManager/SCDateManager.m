//
//  SCDateManager.m
//  SCFramework
//
//  Created by Angzn on 3/6/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import "SCDateManager.h"
#import "SCSingleton.h"

@interface SCDateManager ()

@property (nonatomic, strong) NSDateFormatter *dateForrmatter;

@end


@implementation SCDateManager

SCSINGLETON(SCDateManager);

- (id)init
{
    self = [super init];
    if (self) {
        _dateForrmatter = [[NSDateFormatter alloc] init];
        [_dateForrmatter setLocale:[NSLocale currentLocale]];
        [_dateForrmatter setTimeZone:[NSTimeZone localTimeZone]];
    }
    return self;
}

- (NSString *)stringByConvertFromDate:(NSDate *)date format:(NSString *)format
{
    [_dateForrmatter setDateFormat:format];
    NSString *dateString = [_dateForrmatter stringFromDate:date];
    return dateString;
}

- (NSDate *)dateByConvertFromString:(NSString *)string format:(NSString *)format
{
    [_dateForrmatter setDateFormat:format];
    NSDate *date = [_dateForrmatter dateFromString:string];
    return date;
}

@end
