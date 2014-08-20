//
//  SCBrowseViewPage.h
//  ZhongTouBang
//
//  Created by Angzn on 8/13/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import "SCView.h"

@class SCBrowseViewPage;

@interface SCBrowseViewPage : SCView

@property (nonatomic, readonly, strong) SCView *contentView;

@property (nonatomic, readonly, copy) NSString *reuseIdentifier;

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
