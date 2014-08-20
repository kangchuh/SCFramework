//
//  SCBrowseView.h
//  SCFramework
//
//  Created by Angzn on 8/5/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import "SCScrollView.h"
#import "SCBrowseViewPage.h"

@class SCBrowseView;

@protocol SCBrowseViewDataSource;
@protocol SCBrowseViewDelegate;

@interface SCBrowseView : SCScrollView

@property (nonatomic, weak) id <SCBrowseViewDataSource> browseDataSource;
@property (nonatomic, weak) id <SCBrowseViewDelegate> browseDelegate;

- (id)dequeueReusablePageWithIdentifier:(NSString *)identifier;

- (void)reloadData;

- (NSInteger)indexForPageAtPoint:(CGPoint)point;
- (NSInteger)indexForPage:(SCBrowseViewPage *)page;
- (SCBrowseViewPage *)pageForIndex:(NSInteger)index;

- (void)startPageing;
- (void)stopPageing;

@end


@protocol SCBrowseViewDataSource <NSObject>

@required
- (NSInteger)numberOfPagesInBrowseView:(SCBrowseView *)browseView;
- (SCBrowseViewPage *)browseView:(SCBrowseView *)browseView pageAtIndex:(NSInteger)index;

@end

@protocol SCBrowseViewDelegate <NSObject>

@optional
- (void)browseView:(SCBrowseView *)browseView willSelectPageAtIndex:(NSInteger)index;
- (void)browseView:(SCBrowseView *)browseView didSelectPageAtIndex:(NSInteger)index;
- (void)browseViewDidScroll:(SCBrowseView *)browseView;

@end
