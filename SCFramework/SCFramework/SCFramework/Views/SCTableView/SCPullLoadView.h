//
//  SCPullLoadView.h
//  SCFramework
//
//  Created by Angzn on 3/6/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import "SCView.h"

extern const CGFloat kSCPullLoadViewHeight;

extern const CGFloat kSCPullUpDistance;

typedef NS_ENUM(NSInteger, SCPullUpState) {
    SCPullUpStateNormal = 1,// 正常
    SCPullUpStatePulling,// 上拉中
    SCPullUpStateLoading,// 加载中
};

@interface SCPullLoadView : SCView

@property (nonatomic, strong, readonly) UILabel *statusLabel;

@property (nonatomic, strong, readonly) UIActivityIndicatorView *activityView;

@property (nonatomic, assign) SCPullUpState state;

@end
