//
//  SCPullRefreshView.h
//  SCFramework
//
//  Created by Angzn on 3/6/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import "SCView.h"
#import "SCCircleView.h"

extern const CGFloat kSCPullRefreshViewHeight;

extern const CGFloat kSCPullDownDistance;

typedef NS_ENUM(NSInteger, SCPullDownState) {
    SCPullDownStateNormal = 1,// 正常
    SCPullDownStatePulling,// 下拉中
    SCPullDownStateRefreshing,// 刷新中
};

@interface SCPullRefreshView : SCView

@property (nonatomic, strong, readonly) UILabel *statusLabel;

@property (nonatomic, strong, readonly) UILabel *dateLabel;

@property (nonatomic, strong, readonly) SCCircleView            *circleView;
@property (nonatomic, strong, readonly) UIActivityIndicatorView *activityView;

@property (nonatomic, assign) SCPullDownState state;
@property (nonatomic, assign) CGFloat         pullScale;

- (void)refreshLastUpdatedDate:(NSDate *)date;

@end
