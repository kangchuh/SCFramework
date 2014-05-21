//
//  SCPickerView.h
//  SCFramework
//
//  Created by Angzn on 3/6/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SCPickerViewDoneHandler)(id result);
typedef void (^SCPickerViewCancelHandler)(void);

@interface SCPickerView : UIActionSheet

/// 数据源(字符串/字典/数据对象)
@property (nonatomic, copy) NSArray *dataSources;

/// 数据值对应的键(在"字典/数据对象"中对应的键)
@property (nonatomic, copy) NSString *valueKey;

- (id)initWithDataSources:(NSArray *)aDataSources;

- (void)showInView:(UIView *)view
       doneHandler:(SCPickerViewDoneHandler)doneHandler
     cancelHandler:(SCPickerViewCancelHandler)cancelHandler;

@end
