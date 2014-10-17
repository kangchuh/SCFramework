//
//  SCPickerView.m
//  SCFramework
//
//  Created by Angzn on 3/6/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import "SCPickerView.h"
#import "SCToolbar.h"

#import "SCMacro.h"
#import "SCConstant.h"

#import "NSArray+SCAddition.h"

@interface SCPickerView ()
<
UIPickerViewDelegate,
UIPickerViewDataSource,
SCToolbarActionDelegate
>

/// 工具条
@property (nonatomic, strong) SCToolbar *toolbar;

/// 选择器
@property (nonatomic, strong) UIPickerView *pickerView;

/// 完成回调
@property (nonatomic, copy) SCPickerViewDoneHandler doneHandler;

/// 取消回调
@property (nonatomic, copy) SCPickerViewCancelHandler cancelHandler;

@end


@implementation SCPickerView

#pragma mark - Init Method

- (id)initWithFrame:(CGRect)frame
{
    frame.size = CGSizeMake(kSC_MAIN_SCREEN_WIDTH,
                            kSCFW_TOOLBAR_HEIGHT
                            + kSCFW_PICKERVIEW_HEIGHT);
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
        
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.top = _toolbar.bottom;
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.showsSelectionIndicator = YES;
        [self addSubview:_pickerView];
    }
    return self;
}

- (id)initWithDataSources:(NSArray *)aDataSources
{
    self = [self initWithFrame:CGRectZero];
    if (self) {
        self.dataSources = aDataSources;
    }
    return self;
}

#pragma mark - Setter Method

- (void)setDataSources:(NSArray *)dataSources
{
    _dataSources = [dataSources copy];
    
    [_pickerView reloadAllComponents];
}

#pragma mark - SCToolbarActionDelegate

- (void)toolbarDidDone:(SCToolbar *)toolbar
{
    if (_doneHandler != nil) {
        NSInteger selectedRow = [_pickerView selectedRowInComponent:0];
        id result = nil;
        if ([_dataSources isNotEmpty] && [_dataSources count] > selectedRow) {
            result = [_dataSources objectAtIndex:selectedRow];
        }
        _doneHandler(result);
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

#pragma mark - UIPickerViewDelegate & DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return _dataSources.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    return [self titleForRow:row];
}

#pragma mark - Public Method

/**
 *  显示选择器
 *
 *  @param doneHandler   完成回调
 *  @param cancelHandler 取消回调
 */
- (void)showInView:(UIView *)view
       doneHandler:(SCPickerViewDoneHandler)doneHandler
     cancelHandler:(SCPickerViewCancelHandler)cancelHandler
{
    self.doneHandler = doneHandler;
    self.cancelHandler = cancelHandler;
    
    [self.pickerView selectRow:0 inComponent:0 animated:NO];
    [self showInView:view];
}

#pragma mark - Private Method

- (NSString *)titleForRow:(NSInteger)row
{
    NSString *rowTitle = @"";
    if (!_dataSources.isNotEmpty || _dataSources.count <= row) {
        return rowTitle;
    }
    id anyObject = [_dataSources objectAtIndex:row];
    if ([anyObject isKindOfClass:[NSString class]]) {
        rowTitle = [_dataSources objectAtIndex:row];
    } else if ([anyObject isKindOfClass:[NSDictionary class]]) {
        rowTitle = [(NSDictionary *)anyObject objectForKey:_valueKey];
    } else if ([anyObject isKindOfClass:[NSObject class]]) {
        rowTitle = [anyObject valueForKey:_valueKey];
    }
    return rowTitle;
}

@end
