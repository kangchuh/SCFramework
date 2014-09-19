//
//  SCPickerView.m
//  SCFramework
//
//  Created by Angzn on 3/6/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import "SCPickerView.h"

@interface SCPickerView ()
<
UIPickerViewDelegate,
UIPickerViewDataSource
>

/// 选择器
@property (nonatomic, strong) UIPickerView *pickerView;

/// 完成回调
@property (nonatomic, copy) SCPickerViewDoneHandler doneHandler;

/// 取消回调
@property (nonatomic, copy) SCPickerViewCancelHandler cancelHandler;

@end


@implementation SCPickerView

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
        
        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, kSC_APP_FRAME_WIDTH, 44)];
        toolBar.barStyle = UIBarStyleBlackTranslucent;
        toolBar.items = itemArray;
        [self addSubview:toolBar];
        
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, 0, 0)];
        // 解决iOS7上UIActionSheet四周是透明
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.showsSelectionIndicator = YES;
        [self addSubview:_pickerView];
    }
    return self;
}

- (id)initWithDataSources:(NSArray *)aDataSources
{
    self = [self init];
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
        NSInteger selectedRow = [_pickerView selectedRowInComponent:0];
        id result = nil;
        if ([_dataSources isNotEmpty] && [_dataSources count] > selectedRow) {
            result = [_dataSources objectAtIndex:selectedRow];
        }
        _doneHandler(result);
    }
    [self dismissWithClickedButtonIndex:1 animated:YES];
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
