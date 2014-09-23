//
//  SCDatePicker.m
//  SCFramework
//
//  Created by Angzn on 3/6/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import "SCDatePicker.h"

@interface SCDatePicker ()
<
SCToolbarActionDelegate
>

/// 工具条
@property (nonatomic, strong) SCToolbar *toolbar;

/// 时间选择器
@property (nonatomic, strong) UIDatePicker *datePicker;

/// 完成回调
@property (nonatomic, copy) SCDatePickerDoneHandler doneHandler;

/// 取消回调
@property (nonatomic, copy) SCDatePickerCancelHandler cancelHandler;

@end

@implementation SCDatePicker

#pragma mark - Init Method

- (id)initWithFrame:(CGRect)frame
{
    frame.size = CGSizeMake(kSC_MAIN_SCREEN_WIDTH,
                            kSCFW_TOOLBAR_HEIGHT
                            + kSCFW_DATEPICKER_HEIGHT);
    self = [super initWithFrame:frame];
    if ( self ) {
        self.backgroundColor = [UIColor whiteColor];
        self.actionAnimations = SCViewActionAnimationActionSheet;
        
        _toolbar = [[SCToolbar alloc] init];
        _toolbar.size = CGSizeMake(self.width, kSCFW_TOOLBAR_HEIGHT);
        _toolbar.barStyle = UIBarStyleBlackTranslucent;
        _toolbar.actionStyle = SCToolbarActionStyleDoneAndCancel;
        _toolbar.actionDelegate = self;
        [self addSubview:_toolbar];
        
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.top = _toolbar.bottom;
        _datePicker.datePickerMode = UIDatePickerModeDate;
        _datePicker.minimumDate = [NSDate dateWithTimeIntervalSince1970:0];
        _datePicker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:(kSCFW_SECOND_YEAR * 30)];
        [self addSubview:_datePicker];
    }
    return self;
}

/**
 *  @brief 初始化
 *
 *  @param date 选中的时间
 */
- (id)initWithDate:(NSDate *)date
{
    self = [self initWithFrame:CGRectZero];
    if (self) {
        _datePicker.date = date;
    }
    return self;
}

#pragma mark - SCToolbarActionDelegate

- (void)toolbarDidDone:(SCToolbar *)toolbar
{
    if (_doneHandler != nil) {
        _doneHandler(_datePicker.date);
    }
    [self dismiss];
}

- (void)toolbarDidCancel:(SCToolbar *)toolbar
{
    if (_cancelHandler != nil) {
        _cancelHandler();
    }
    [self dismiss];
}

#pragma mark - Public Method

/**
 *  显示日期选择器
 *
 *  @param doneHandler   完成回调
 *  @param cancelHandler 取消回调
 */
- (void)showInView:(UIView *)view
       doneHandler:(SCDatePickerDoneHandler)doneHandler
     cancelHandler:(SCDatePickerCancelHandler)cancelHandler
{
    self.doneHandler = doneHandler;
    self.cancelHandler = cancelHandler;
    
    [self datePicker].date = (_defaultDate ? _defaultDate : [NSDate date]);
    [self showInView:view];
}

@end
