//
//  SCTextView.h
//  SCFramework
//
//  Created by Angzn on 3/6/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCTextView : UITextView

@property (nonatomic, assign) BOOL endEditingWhenSlide;

@property (nonatomic, copy  ) NSString *placeholder;
@property (nonatomic, strong) UIColor *placeholderColor;

@property (nonatomic, readonly) NSUInteger numberOfLines;

@end
