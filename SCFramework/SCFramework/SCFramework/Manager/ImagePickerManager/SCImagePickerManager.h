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

/**
 *  @brief  保存图片到相册完成回调
 */
typedef void(^SCImageDidSavedCompletionHandler)(NSError *error);

/**
 *  @brief  保存视频到相册完成回调
 */
typedef void(^SCVideoDidSavedCompletionHandler)(NSError *error);

@interface SCImagePickerManager : NSObject

@property (nonatomic, assign) BOOL allowStore;

@property (nonatomic, assign) BOOL onlyPhotoLibrary;

+ (SCImagePickerManager *)sharedInstance;

+ (void)checkAccessForAssetsLibrary:(void (^)(BOOL granted))completionHandler;

+ (void)checkAccessForCaptureDevice:(NSString *)mediaType completionHandler:(void (^)(BOOL granted))completionHandler;

- (void)startPickFromViewController:(UIViewController *)viewController
                       configPicker:(SCImagePickerConfigHandler)configHandler
              didFinishPickingMedia:(SCImagePickerDidFinishPickingMediaHandler)pickingMediaHandler
                          didCancel:(SCImagePickerDidCancelHandler)cancelHandler;

- (void)saveImageToPhotosAlbum:(UIImage *)image
                    completion:(SCImageDidSavedCompletionHandler)completion;

- (void)saveVideoToPhotosAlbum:(NSString *)videoPath
                    completion:(SCVideoDidSavedCompletionHandler)completion;

@end
