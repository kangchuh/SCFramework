//
//  NSAttributedString+SCAddition.h
//  SCFramework
//
//  Created by Angzn on 16/5/9.
//  Copyright © 2016年 Richer VC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (SCAddition)

- (CGFloat)heightForConstrainedToWidth:(CGFloat)width;
- (CGFloat)widthForConstrainedToHeight:(CGFloat)height;

- (CGSize)sizeForConstrainedToWidth:(CGFloat)width;
- (CGSize)sizeForConstrainedToHeight:(CGFloat)height;

@end
