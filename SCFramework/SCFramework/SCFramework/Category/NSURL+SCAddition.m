//
//  NSURL+SCAddition.m
//  ZhongTouBang
//
//  Created by Angzn on 6/11/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import "NSURL+SCAddition.h"

@implementation NSURL (SCAddition)

- (NSURL *)serializeParams:(NSDictionary *)params
{
    NSString *baseURLString = [self absoluteString];
	NSString *queryPrefix = [[self query] isNotEmpty] ? @"&" : @"?";
	NSString *query = [params paramString];
	NSString *URLString = [NSString stringWithFormat:@"%@%@%@",
                           baseURLString, queryPrefix, query];
	return [NSURL URLWithString:URLString];
}

@end
