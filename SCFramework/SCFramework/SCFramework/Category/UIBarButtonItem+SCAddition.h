//
//  UIBarButtonItem+SCAddition.h
//  SCFramework
//
//  Created by Angzn on 9/23/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (SCAddition)

- (instancetype)initWithTarget:(id)target action:(SEL)action;
- (instancetype)initWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem;
- (instancetype)initWithFixedSpaceWidth:(CGFloat)spaceWidth;
+ (instancetype)flexibleSpaceSystemItem;

@end
