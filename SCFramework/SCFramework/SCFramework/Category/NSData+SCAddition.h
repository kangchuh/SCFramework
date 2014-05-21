//
//  NSData+SCAddition.h
//  SCFramework
//
//  Created by Angzn on 3/5/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (SCAddition)

/// 获取图片ContentType
- (NSString *)contentType;

/// 是否包含前缀
- (BOOL)hasPrefixBytes:(const void *)prefix length:(NSUInteger)length;

/// 是否包含后缀
- (BOOL)hasSuffixBytes:(const void *)suffix length:(NSUInteger)length;

#pragma mark - GZIP

/// GZIP压缩
- (NSData *)gzippedDataWithCompressionLevel:(float)level;

/// GZIP压缩
- (NSData *)gzippedData;

/// GZIP解压
- (NSData *)gunzippedData;

@end
