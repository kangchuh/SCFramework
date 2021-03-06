//
//  SCDatePicker.h
//  SCFramework
//
//  Created by Angzn on 3/6/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import "SCActionView.h"

typedef void (^SCDatePickerDoneHandler)(NSDate *date);
typedef void (^SCDatePickerCancelHandler)(void);

@interface SCDatePicker : SCActionView

/// 时间选择器
@property (nonatomic, strong, readonly) UIDatePicker *datePicker;

/// 默认显示日期
@property (nonatomic, strong) NSDate *defaultDate;

- (id)initWithDate:(NSDate *)date;

- (void)showInView:(UIView *)view
       doneHandler:(SCDatePickerDoneHandler)doneHandler
     cancelHandler:(SCDatePickerCancelHandler)cancelHandler;

@end
