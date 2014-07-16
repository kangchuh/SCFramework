//
//  SCScrollView.h
//  SCFramework
//
//  Created by Angzn on 3/6/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  Page方向
 */
typedef NS_ENUM(NSUInteger, SCScrollViewPageDirection) {
    /**
     *  水平
     */
    SCScrollViewPageDirectionHorizontal,
    /**
     *  垂直
     */
    SCScrollViewPageDirectionVertical,
};

@protocol SCScrollViewTouchDelegate;

@interface SCScrollView : UIScrollView

@property (nonatomic, weak) id <SCScrollViewTouchDelegate> touchDelegate;

@property (nonatomic, assign) BOOL endEditingWhenTouch;

@property (nonatomic, assign) NSInteger numberOfPages;

@property (nonatomic, assign) SCScrollViewPageDirection pageDirection;

- (NSInteger)currentPage;

@end


@protocol SCScrollViewTouchDelegate <NSObject>

@optional
- (void)scrollView:(SCScrollView *)scrollView
        touchEnded:(NSSet *)touches
         withEvent:(UIEvent *)event;
- (void)scrollView:(SCScrollView *)scrollView
  touchShouldBegin:(NSSet *)touches
         withEvent:(UIEvent *)event
     inContentView:(id)view;

@end
