//
//  NSString+SCAddition.h
//  SCFramework
//
//  Created by Angzn on 3/5/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SCAddition)

- (BOOL)isEmpty;
- (BOOL)isNotEmpty;

- (NSString *)trimWhitespaceAndNewline;

- (BOOL)containsCharacterSet:(NSCharacterSet *)set;

- (BOOL)containsString:(NSString *)string;

- (int)wordsCount;

- (NSString *)URLDecodedString;
- (NSString *)URLEncodedString;

- (NSString *)MD5String;

- (BOOL)isNumber;
- (BOOL)isEnglishWords;
- (BOOL)isChineseWords;

- (BOOL)isEmail;
- (BOOL)isURL;
- (BOOL)isPhoneNumber;
- (BOOL)isMobilePhoneNumber;
- (BOOL)isIdentifyCardNumber;

- (BOOL)isValidPassword;
- (BOOL)isValidName;

/// 字符串转时间
- (NSDate *)dateWithFormat:(NSString *)format;

/// 参数键值对
- (NSDictionary *)paramValue;

@end
