//
//  SCDatePicker.m
//  SCFramework
//
//  Created by Angzn on 3/6/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import "SCDatePicker.h"

@interface SCDatePicker ()

/// 完成回调
@property (nonatomic, copy) SCDatePickerDoneHandler doneHandler;

/// 取消回调
@property (nonatomic, copy) SCDatePickerCancelHandler cancelHandler;

@end

@implementation SCDatePicker

#pragma mark - Init Method

- (id)init
{
    self = [super init];
    if ( self ) {
        self.title = @"\n\n\n\n\n\n\n\n\n\n\n\n\n";
        
        UIBarButtonItem *cancelBarItem
        = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"SCFW_LS_Cancel", @"SCFWLocalizable", nil)
                                           style:UIBarButtonItemStyleBordered
                                          target:self
                                          action:@selector(cancelButtonAction:)];
        UIBarButtonItem *fixedBarItem
        = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                        target:nil
                                                        action:nil];
        UIBarButtonItem *doneBarItem
        = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"SCFW_LS_Done", @"SCFWLocalizable", nil)
                                           style:UIBarButtonItemStyleBordered
                                          target:self
                                          action:@selector(doneButtonAction:)];
        
        NSArray *itemArray = [[NSArray alloc] initWithObjects:
                              cancelBarItem, fixedBarItem, doneBarItem, nil];
        
        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        toolBar.barStyle = UIBarStyleBlackTranslucent;
        toolBar.items = itemArray;
        [self addSubview:toolBar];
        
        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, 0, 0)];
        // 解决iOS7上UIActionSheet四周是透明
        _datePicker.backgroundColor = [UIColor whiteColor];
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
    self = [self init];
    if (self) {
        _datePicker.date = date;
    }
    return self;
}

#pragma mark - Action Method

- (void)cancelButtonAction:(id)sender
{
    if (_cancelHandler != nil) {
        _cancelHandler();
    }
    [self dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)doneButtonAction:(id)sender
{
    if (_doneHandler != nil) {
        _doneHandler(_datePicker.date);
    }
    [self dismissWithClickedButtonIndex:1 animated:YES];
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
