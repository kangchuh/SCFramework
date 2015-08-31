//
//  SCLabel.m
//  SCFramework
//
//  Created by Angzn on 3/6/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import "SCLabel.h"
#import "UIView+SCAddition.h"
#import "NSString+SCAddition.h"

@implementation SCLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark - Public Method

- (void)setText:(NSString *)text adjustWidth:(BOOL)adjustWidth
{
    if (adjustWidth) {
        CGFloat width = [text widthWithFont:self.font
                        constrainedToHeight:self.height];
        self.width = width;
        self.text = text;
    } else {
        self.text = text;
    }
}

- (void)setText:(NSString *)text adjustHeight:(BOOL)adjustHeight
{
    if (adjustHeight) {
        CGFloat height = [text heightWithFont:self.font
                           constrainedToWidth:self.width];
        self.height = height;
        self.text = text;
    } else {
        self.text = text;
    }
}

@end
