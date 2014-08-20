//
//  NSTimer+SCAddition.h
//  ZhongTouBang
//
//  Created by Angzn on 8/20/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (SCAddition)

- (void)pause;
- (void)resume;
- (void)resumeAfterTimeInterval:(NSTimeInterval)interval;

@end
