//
//  SCImagePickerManager.m
//  ZhongTouBang
//
//  Created by Angzn on 7/8/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import "SCImagePickerManager.h"
#import "SCSingleton.h"

#import "UIDevice+SCAddition.h"

#import <MobileCoreServices/MobileCoreServices.h>

@interface SCImagePickerManager ()
<
UIActionSheetDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate
>

@property (nonatomic, strong) UIImagePickerController                   *imagePicker;

@property (nonatomic, copy  ) SCImagePickerConfigHandler                configHandler;

@property (nonatomic, copy  ) SCImagePickerDidFinishPickingMediaHandler pickingMediaHandler;

@property (nonatomic, copy  ) SCImagePickerDidCancelHandler             cancelHandler;

@property (nonatomic, weak  ) UIViewController                          *parentViewController;

@end

@implementation SCImagePickerManager

SCSINGLETON(SCImagePickerManager);

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.firstOtherButtonIndex) {
        [self __goToCamera:_parentViewController];
    } else if (buttonIndex == actionSheet.firstOtherButtonIndex + 1) {
        [self __goToPhotoLibrary:_parentViewController];
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    DLog(@"Pick Info : %@", info);
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    if (CFStringCompare((CFStringRef)mediaType, kUTTypeImage, 0) == kCFCompareEqualTo) {
        UIImage *originalImage = (UIImage *)info[UIImagePickerControllerOriginalImage];
        UIImage *editedImage = (UIImage *)info[UIImagePickerControllerEditedImage];
        UIImage *image = editedImage ? editedImage : originalImage;
        image = [image fixOrientation];
        
        if ( _pickingMediaHandler ) {
            _pickingMediaHandler(picker, image, info);
        }
        
        if ( _allowStore && picker.sourceType == UIImagePickerControllerSourceTypeCamera ) {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        }
    }
    
    if (CFStringCompare((CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
        NSString *moviePath = [(NSURL *)info[UIImagePickerControllerMediaURL] path];
        
        if ( _pickingMediaHandler ) {
            _pickingMediaHandler(picker, moviePath, info);
        }
        
        if ( _allowStore && picker.sourceType == UIImagePickerControllerSourceTypeCamera ) {
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(moviePath)) {
                UISaveVideoAtPathToSavedPhotosAlbum(moviePath, nil, nil, nil);
            }
        }
    }
    
    [[picker presentingViewController] dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if ( _cancelHandler ) {
        _cancelHandler(picker);
    }
    
    [[picker presentingViewController] dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Public Method

- (void)startPickFromViewController:(UIViewController *)viewController
                       configPicker:(SCImagePickerConfigHandler)configHandler
              didFinishPickingMedia:(SCImagePickerDidFinishPickingMediaHandler)pickingHandler
                          didCancel:(SCImagePickerDidCancelHandler)cancelHandler
{
    self.parentViewController = viewController;
    self.configHandler = configHandler;
    self.pickingMediaHandler = pickingHandler;
    self.cancelHandler = cancelHandler;
    
    if ( [UIDevice hasCamera] ) {
        NSString *cancelTitle = NSLocalizedStringFromTable(@"SCFW_LS_Cancel", @"SCFWLocalizable", nil);
        NSString *takeTitle = NSLocalizedStringFromTable(@"SCFW_LS_Take a picture", @"SCFWLocalizable", nil);
        NSString *chooseTitle = NSLocalizedStringFromTable(@"SCFW_LS_Choose from album", @"SCFWLocalizable", nil);
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:cancelTitle
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:takeTitle, chooseTitle, nil];
        
        [actionSheet showInView:viewController.view];
    } else {
        [self __goToPhotoLibrary:_parentViewController];
    }
}

#pragma mark - Private Method

- (void)__goToCamera:(UIViewController *)viewController
{
    if ( !_imagePicker ) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
    }
    if ( _configHandler ) {
        _configHandler(_imagePicker);
    }
    _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [viewController presentViewController:_imagePicker animated:YES completion:NULL];
}

- (void)__goToPhotoLibrary:(UIViewController *)viewController
{
    if ( !_imagePicker ) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
    }
    if ( _configHandler ) {
        _configHandler(_imagePicker);
    }
    _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [viewController presentViewController:_imagePicker animated:YES completion:NULL];
}

@end
