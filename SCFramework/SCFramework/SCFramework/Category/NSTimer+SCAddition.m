//
//  NSTimer+SCAddition.m
//  ZhongTouBang
//
//  Created by Angzn on 8/20/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import "NSTimer+SCAddition.h"

@implementation NSTimer (SCAddition)

- (void)pause
{
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate distantFuture]];
}

- (void)resume
{
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate date]];
}

- (void)resumeAfterTimeInterval:(NSTimeInterval)interval
{
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:interval]];
}

@end
