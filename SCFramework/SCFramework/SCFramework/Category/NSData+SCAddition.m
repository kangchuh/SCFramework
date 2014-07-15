//
//  NSData+SCAddition.m
//  SCFramework
//
//  Created by Angzn on 3/5/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import "NSData+SCAddition.h"
#import <zlib.h>

@implementation NSData (SCAddition)

- (BOOL)isNotEmpty
{
    return (![(NSNull *)self isEqual:[NSNull null]]
            && [self isKindOfClass:[NSData class]]
            && self.length > 0);
}

/**
 *  @brief 获取图片的ContentType
 */
- (NSString *)contentType
{
    uint8_t c;
    [self getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return @"image/jpeg";
        case 0x89:
            return @"image/png";
        case 0x47:
            return @"image/gif";
        case 0x49:
        case 0x4D:
            return @"image/tiff";
        case 0x52:
            // R as RIFF for WEBP
            if ([self length] < 12) {
                return nil;
            }
            NSString *testString = [[NSString alloc] initWithData:[self subdataWithRange:NSMakeRange(0, 12)]
                                                         encoding:NSASCIIStringEncoding];
            if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) {
                return @"image/webp";
            }
            return nil;
    }
    return nil;
}

/**
 *  @brief 是否包含前缀
 *
 *  @param prefix 前缀字符
 *  @param length 前缀字符长度
 */
- (BOOL)hasPrefixBytes:(const void *)prefix length:(NSUInteger)length
{
    if ( ! prefix || ! length || self.length < length ) {
        return NO;
    }
    return ( memcmp( [self bytes], prefix, length ) == 0 );
}

/**
 *  @brief 是否包含后缀
 *
 *  @param suffix 后缀字符
 *  @param length 后缀字符长度
 */
- (BOOL)hasSuffixBytes:(const void *)suffix length:(NSUInteger)length
{
    if ( ! suffix || ! length || self.length < length ) {
        return NO;
    }
    return ( memcmp( ((const char *)[self bytes] + (self.length - length)), suffix, length ) == 0 );
}

#pragma mark - GZIP

#define SCFW_CHUNK_SIZE 16384

/**
 *  @brief GZIP压缩
 *
 *  @param level 压缩等级
 */
- (NSData *)gzippedDataWithCompressionLevel:(float)level
{
    if ([self length])
    {
        z_stream stream;
        stream.zalloc = Z_NULL;
        stream.zfree = Z_NULL;
        stream.opaque = Z_NULL;
        stream.avail_in = (uint)[self length];
        stream.next_in = (Bytef *)[self bytes];
        stream.total_out = 0;
        stream.avail_out = 0;
        
        int compression = (level < 0.0f) ? Z_DEFAULT_COMPRESSION : (int)roundf(level * 9);
        if (deflateInit2(&stream, compression, Z_DEFLATED, 31, 8, Z_DEFAULT_STRATEGY) == Z_OK)
        {
            NSMutableData *data = [NSMutableData dataWithLength:SCFW_CHUNK_SIZE];
            while (stream.avail_out == 0)
            {
                if (stream.total_out >= [data length])
                {
                    data.length += SCFW_CHUNK_SIZE;
                }
                stream.next_out = [data mutableBytes] + stream.total_out;
                stream.avail_out = (uint)([data length] - stream.total_out);
                deflate(&stream, Z_FINISH);
            }
            deflateEnd(&stream);
            data.length = stream.total_out;
            return data;
        }
    }
    return nil;
}

/**
 *  @brief GZIP压缩, 压缩等级默认-1
 */
- (NSData *)gzippedData
{
    return [self gzippedDataWithCompressionLevel:-1.0f];
}

/**
 *  @brief GZIP解压
 */
- (NSData *)gunzippedData
{
    if ([self length])
    {
        z_stream stream;
        stream.zalloc = Z_NULL;
        stream.zfree = Z_NULL;
        stream.avail_in = (uint)[self length];
        stream.next_in = (Bytef *)[self bytes];
        stream.total_out = 0;
        stream.avail_out = 0;
        
        NSMutableData *data = [NSMutableData dataWithLength: [self length] * 1.5];
        if (inflateInit2(&stream, 47) == Z_OK)
        {
            int status = Z_OK;
            while (status == Z_OK)
            {
                if (stream.total_out >= [data length])
                {
                    data.length += [self length] * 0.5;
                }
                stream.next_out = [data mutableBytes] + stream.total_out;
                stream.avail_out = (uint)([data length] - stream.total_out);
                status = inflate (&stream, Z_SYNC_FLUSH);
            }
            if (inflateEnd(&stream) == Z_OK)
            {
                if (status == Z_STREAM_END)
                {
                    data.length = stream.total_out;
                    return data;
                }
            }
        }
    }
    return nil;
}

@end
