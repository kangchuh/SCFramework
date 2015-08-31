//
//  SCExpandTableViewCell.m
//  SCFramework
//
//  Created by Angzn on 4/29/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import "SCExpandTableViewCell.h"

@implementation SCExpandTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - Public Method

- (void)setExpandable:(BOOL)expandable
{
    if (_expanded != expandable) {
        _expanded = expandable;
        if (expandable) {
            self.accessoryView = [self expandableView];
        } else {
            self.accessoryView = nil;
        }
    }
}

#pragma mark - Private Method

- (UIView *)expandableView
{
    return nil;
}

@end
