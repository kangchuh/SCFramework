//
//  SCLabel.h
//  SCFramework
//
//  Created by Angzn on 3/6/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSInteger, SCLabelVerticalAlignment) {
    SCLabelVerticalAlignmentCenter = 0,
    SCLabelVerticalAlignmentTop,
    SCLabelVerticalAlignmentBottom,
};

@interface SCLabel : UILabel

@property (nonatomic, assign) CGPoint textPoint;

@property (nonatomic, assign) NSUInteger textWidth;

@property (nonatomic, assign) SCLabelVerticalAlignment verticalAlignment;

- (void)setText:(NSString *)text adjustWidth:(BOOL)adjustWidth;
- (void)setText:(NSString *)text adjustHeight:(BOOL)adjustHeight;

@end
