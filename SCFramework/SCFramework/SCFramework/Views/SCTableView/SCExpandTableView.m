//
//  SCExpandTableView.m
//  SCFramework
//
//  Created by Angzn on 4/29/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import "SCExpandTableView.h"
#import <objc/runtime.h>

#import "SCExpandTableViewCell.h"

#pragma mark - NSArray (SCExpandTableView)

@interface NSMutableArray (SCExpandTableView)

- (void)initiateObjectsForCapacity:(NSInteger)numItems;

@end

@implementation NSMutableArray (SKSTableView)

- (void)initiateObjectsForCapacity:(NSInteger)numItems
{
    for (NSInteger index = [self count]; index < numItems; index++) {
        NSMutableArray *array = [NSMutableArray array];
        [self addObject:array];
    }
}

@end


#pragma mark - SCExpandTableView

@interface SCExpandTableView ()
<
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic, strong) NSMutableArray *expandedIndexPaths;

@property (nonatomic, strong) NSMutableDictionary *expandableCells;

@end


@implementation SCExpandTableView

- (BOOL)isExpandedForCellAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL expanded = NO;
    return expanded;
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ExpandCell";
    SCExpandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[SCExpandTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                            reuseIdentifier:cellIdentifier];
    }
    return cell;
}

@end


#pragma mark - NSIndexPath (SCExpandTableView)

static void *SCFWNSIndexPathSubRowObjectKey;

@implementation NSIndexPath (SCExpandTableView)

@dynamic subRow;

- (NSInteger)subRow
{
    id subRowObj = objc_getAssociatedObject(self, SCFWNSIndexPathSubRowObjectKey);
    return [subRowObj integerValue];
}

- (void)setSubRow:(NSInteger)subRow
{
    id subRowObj = [NSNumber numberWithInteger:subRow];
    objc_setAssociatedObject(self, SCFWNSIndexPathSubRowObjectKey, subRowObj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (NSIndexPath *)indexPathForSubRow:(NSInteger)subrow inRow:(NSInteger)row inSection:(NSInteger)section
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    indexPath.subRow = subrow;
    return indexPath;
}

@end
