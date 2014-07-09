//
//  NSString+SCAddition.m
//  SCFramework
//
//  Created by Angzn on 3/5/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import "NSString+SCAddition.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (SCAddition)

/**
 *  @brief 判断是否为空
 */
- (BOOL)isEmpty
{
    return !self
    || [(NSNull *)self isEqual:[NSNull null]]
    || ![self isKindOfClass:[NSString class]]
    || self.length == 0;
}

/**
 *  @brief 判断是否为空
 */
- (BOOL)isNotEmpty
{
    return self
    && ![(NSNull *)self isEqual:[NSNull null]]
    && [self isKindOfClass:[NSString class]]
    && self.length > 0;
}

/**
 *  @brief 去除字符串空格和回车字符
 */
- (NSString *)trimWhitespaceAndNewline
{
    return [self stringByTrimmingCharactersInSet:
            [NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

/**
 *  @brief 是否包含字符
 *
 *  @param set 字符集
 *
 *  @return YES, 包含; Otherwise
 */
- (BOOL)containsCharacterSet:(NSCharacterSet *)set
{
    NSRange rang = [self rangeOfCharacterFromSet:set];
    if (rang.location == NSNotFound) {
        return NO;
    } else {
        return YES;
    }
}

/**
 *  @brief 是否包含字符串
 *
 *  @param string 字符串
 *
 *  @return YES, 包含; Otherwise
 */
- (BOOL)containsString:(NSString *)string
{
    NSRange rang = [self rangeOfString:string];
    if (rang.location == NSNotFound) {
        return NO;
    } else {
        return YES;
    }
}

/**
 *  @brief 获取字符数量
 */
- (int)wordsCount
{
    NSInteger n = self.length;
    int i;
    int l = 0, a = 0, b = 0;
    unichar c;
    for (i = 0; i < n; i++)
    {
        c = [self characterAtIndex:i];
        if (isblank(c)) {
            b++;
        } else if (isascii(c)) {
            a++;
        } else {
            l++;
        }
    }
    if (a == 0 && l == 0) {
        return 0;
    }
    return l + (int)ceilf((float)(a + b) / 2.0);
}

/**
 *  @brief URL编码
 */
- (NSString *)URLEncodedString
{
    NSString *result = (NSString *)CFBridgingRelease
    (CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                             (CFStringRef)self,
                                             NULL,
                                             CFSTR("!*'();:@&=+$,/?%#[]"),
                                             kCFStringEncodingUTF8));
    return result;
}

/**
 *  @brief URL解码
 */
- (NSString *)URLDecodedString
{
    NSString *result = (NSString *)CFBridgingRelease
    (CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                             (CFStringRef)self,
                                                             CFSTR(""),
                                                             kCFStringEncodingUTF8));
    return result;
}

/**
 *  @brief URL
 */
- (NSURL *)URL
{
    return [NSURL URLWithString:self];
}

/**
 *  @brief 文件URL
 */
- (NSURL *)fileURL
{
    return [NSURL fileURLWithPath:self];
}

/**
 *  @brief MD5加密
 */
- (NSString *)MD5String
{
	const char *cStr = [self UTF8String];
	unsigned char digest[CC_MD5_DIGEST_LENGTH];
	CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
	char md5string[CC_MD5_DIGEST_LENGTH*2];
	int i;
	for (i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
		sprintf(md5string + i*2, "%02X", digest[i]);
	}
	return [NSString stringWithCString:md5string encoding:NSUTF8StringEncoding];
}

/**
 *  @brief 是否全是数字
 */
- (BOOL)isNumber
{
    NSString *regex = @"^[0-9]*$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

/**
 *  @brief 是否全是英文字母
 */
- (BOOL)isEnglishWords
{
    NSString *regex = @"^[A-Za-z]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

/**
 *  @brief 是否全是中文汉字
 */
- (BOOL)isChineseWords
{
    NSString *regex = @"^[\u4e00-\u9fa5],{0,}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

/**
 *  @brief 是否为邮箱
 */
- (BOOL)isEmail
{
    NSString *regex = @"\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

/**
 *  @brief 是否为网络链接
 */
- (BOOL)isURL
{
    NSString *regex = @"^[a-zA-z]+://(w+(-w+)*)(.(w+(-w+)*))*(?S*)?$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

/**
 *  @brief 是否为电话号码
 *
 *  @Description 3-4位区号, 7-8位直播号码
 */
- (BOOL)isPhoneNumber
{
    NSString *regex = @"^(\(\\d{3,4}\\)|\\d{3,4}-)?\\d{7,8}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

/**
 *  @brief 是否为手机号码
 *
 *  @Description 手机号必须1开头
 */
- (BOOL)isMobilePhoneNumber
{
    NSString *regex = @"^[1][3-8]+\\d{9}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

/**
 *  @brief 是否为身份证号码(15或18位)
 */
- (BOOL)isIdentifyCardNumber
{
    NSString *regex = @"^\\d{15}|\\d{}18$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

/**
 *  @brief 验证密码(6—16位, 只能包含字符、数字和下划线)
 */
- (BOOL)isValidPassword
{
    NSString *regex = @"^[\\w\\d_]{6,16}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

/**
 *  @brief 验证名称(只能由中英文、数字、下划线组成)
 */
- (BOOL)isValidName
{
    NSString *regex = @"\\w*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

/**
 *  @brief 字符串转时间
 *
 *  @param format 时间格式
 *
 *  @return 时间
 */
- (NSDate *)dateWithFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:format];
    NSDate *date = [dateFormatter dateFromString:self];
#if ! __has_feature(objc_arc)
    [dateFormatter release];
#endif
    return date;
}

/**
 *  @brief 参数键值对
 */
- (NSDictionary *)paramValue
{
    NSArray *pairs = [self componentsSeparatedByString:@"&"];
    
    if ([pairs isEmpty]) {
        return nil;
    }
    
    NSMutableDictionary *paramDictionary = [NSMutableDictionary dictionary];
    
    for (NSString *pair in pairs) {
        if ([pair containsString:@"="]) {
            NSArray *key_value = [pair componentsSeparatedByString:@"="];
            NSString *key = [key_value firstObject];
            NSString *value = [key_value lastObject];
            [paramDictionary setObject:[value URLDecodedString] forKey:key];
        }
    }
    
    return paramDictionary;
}

/**
 *  @brief 计算文字的高度
 *
 *  @param font  字体(默认为系统字体)
 *  @param width 约束宽度
 */
- (CGFloat)heightWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width
{
    UIFont *textFont = font ? font : [UIFont systemFontOfSize:[UIFont systemFontSize]];
    
    CGSize textSize;
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 70000
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                     NSParagraphStyleAttributeName: paragraph};
        textSize = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                      options:(NSStringDrawingUsesLineFragmentOrigin |
                                               NSStringDrawingTruncatesLastVisibleLine)
                                   attributes:attributes
                                      context:nil].size;
    } else {
        textSize = [self sizeWithFont:textFont
                    constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)
                        lineBreakMode:NSLineBreakByWordWrapping];
    }
#else
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                 NSParagraphStyleAttributeName: paragraph};
    textSize = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                  options:(NSStringDrawingUsesLineFragmentOrigin |
                                           NSStringDrawingTruncatesLastVisibleLine)
                               attributes:attributes
                                  context:nil].size;
#endif
    
    return ceil(textSize.height);
}

/**
 *  @brief 计算文字的宽度
 *
 *  @param font   字体(默认为系统字体)
 *  @param height 约束高度
 */
- (CGFloat)widthWithFont:(UIFont *)font constrainedToHeight:(CGFloat)height
{
    UIFont *textFont = font ? font : [UIFont systemFontOfSize:[UIFont systemFontSize]];
    
    CGSize textSize;
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 70000
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                     NSParagraphStyleAttributeName: paragraph};
        textSize = [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height)
                                      options:(NSStringDrawingUsesLineFragmentOrigin |
                                               NSStringDrawingTruncatesLastVisibleLine)
                                   attributes:attributes
                                      context:nil].size;
    } else {
        textSize = [self sizeWithFont:textFont
                    constrainedToSize:CGSizeMake(CGFLOAT_MAX, height)
                        lineBreakMode:NSLineBreakByWordWrapping];
    }
#else
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                 NSParagraphStyleAttributeName: paragraph};
    textSize = [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height)
                                  options:(NSStringDrawingUsesLineFragmentOrigin |
                                           NSStringDrawingTruncatesLastVisibleLine)
                               attributes:attributes
                                  context:nil].size;
#endif
    
    return ceil(textSize.width);
}

@end
