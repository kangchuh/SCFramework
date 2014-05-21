//
//  SCExpandTableView.h
//  SCFramework
//
//  Created by Angzn on 4/29/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import "SCTableView.h"

@protocol SCExpandTableViewDelegate;

@interface SCExpandTableView : SCTableView

@property (nonatomic, weak) id <SCExpandTableViewDelegate> expandDelegate;

@property (nonatomic, assign) BOOL shouldExpandOnlyOneCell;

- (BOOL)isExpandedForCellAtIndexPath:(NSIndexPath *)indexPath;

@end


#pragma mark - SCExpandTableViewDelegate

@protocol SCExpandTableViewDelegate <UITableViewDataSource, UITableViewDelegate>

@required
- (NSInteger)tableView:(SCExpandTableView *)tableView numberOfSubRowsAtIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)tableView:(SCExpandTableView *)tableView cellForSubRowAtIndexPath:(NSIndexPath *)indexPath;

@optional
- (CGFloat)tableView:(SCExpandTableView *)tableView heightForSubRowAtIndexPath:(NSIndexPath *)indexPath;

@end


#pragma mark - NSIndexPath (SCExpandTableView)

@interface NSIndexPath (SCExpandTableView)

@property (nonatomic, assign) NSInteger subRow;

+ (NSIndexPath *)indexPathForSubRow:(NSInteger)subrow inRow:(NSInteger)row inSection:(NSInteger)section;

@end
