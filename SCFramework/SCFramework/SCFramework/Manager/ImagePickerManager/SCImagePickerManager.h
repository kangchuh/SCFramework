//
//  SCImagePickerManager.h
//  ZhongTouBang
//
//  Created by Angzn on 7/8/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  图片选择完成操作
 *
 *  @param picker 图片选择器
 *  @param result 图片/视频路径
 *  @param info   Media信息
 */
typedef void(^SCImagePickerDidFinishPickingMediaHandler)(UIImagePickerController *picker,
                                                         id result,
                                                         NSDictionary *info);
/**
 *  图片选择取消操作
 *
 *  @param picker 图片选择器
 */
typedef void(^SCImagePickerDidCancelHandler)(UIImagePickerController *picker);
/**
 *  图片选择器配置操作
 *
 *  @param picker 图片选择器
 */
typedef void(^SCImagePickerConfigHandler)(UIImagePickerController *picker);

@interface SCImagePickerManager : NSObject

@property (nonatomic, assign) BOOL allowStore;

+ (SCImagePickerManager *)sharedInstance;

- (void)startPickFromViewController:(UIViewController *)viewController
                       configPicker:(SCImagePickerConfigHandler)configHandler
              didFinishPickingMedia:(SCImagePickerDidFinishPickingMediaHandler)pickingMediaHandler
                          didCancel:(SCImagePickerDidCancelHandler)cancelHandler;

@end
