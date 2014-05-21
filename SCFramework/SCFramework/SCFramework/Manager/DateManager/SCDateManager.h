//
//  SCDateManager.h
//  SCFramework
//
//  Created by Angzn on 3/6/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCDateManager : NSObject

+ (SCDateManager *)sharedInstance;

- (NSString *)stringByConvertFromDate:(NSDate *)date format:(NSString *)format;
- (NSDate *)dateByConvertFromString:(NSString *)string format:(NSString *)format;

@end
