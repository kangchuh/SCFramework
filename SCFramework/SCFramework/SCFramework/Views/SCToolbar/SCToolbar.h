//
//  SCToolbar.h
//  SCFramework
//
//  Created by Angzn on 9/23/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SCToolbarActionStyle) {
    SCToolbarActionStyleNone,
    SCToolbarActionStyleDoneAndCancel,
};

@protocol SCToolbarActionDelegate;

@interface SCToolbar : UIToolbar

@property (nonatomic, weak) id <SCToolbarActionDelegate> actionDelegate;

@property (nonatomic, assign) SCToolbarActionStyle actionStyle;

- (instancetype)initWithFrame:(CGRect)frame actionStyle:(SCToolbarActionStyle)actionStyle;

@end

@protocol SCToolbarActionDelegate <NSObject>

- (void)toolbarDidDone:(SCToolbar *)toolbar;
- (void)toolbarDidCancel:(SCToolbar *)toolbar;

@end
