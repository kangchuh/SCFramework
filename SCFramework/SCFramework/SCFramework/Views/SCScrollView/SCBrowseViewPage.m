//
//  SCBrowseViewPage.m
//  ZhongTouBang
//
//  Created by Angzn on 8/13/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import "SCBrowseViewPage.h"

@interface SCBrowseViewPage ()

@property (nonatomic, strong) SCView *contentView;

@property (nonatomic, copy) NSString *reuseIdentifier;

@end

@implementation SCBrowseViewPage

#pragma mark - Init Method

- (void)initialize
{
    _contentView = [[SCView alloc] initWithFrame:self.bounds];
    _contentView.autoresizingMask = (UIViewAutoresizingFlexibleWidth |
                                     UIViewAutoresizingFlexibleHeight);
    [self addSubview:_contentView];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initialize];
    }
    return self;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [self initWithFrame:CGRectZero];
    if (self) {
        // Initialization code
        self.reuseIdentifier = reuseIdentifier;
    }
    return self;
}

@end
