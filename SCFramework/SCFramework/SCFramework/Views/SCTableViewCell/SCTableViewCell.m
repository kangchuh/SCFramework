//
//  SCTableViewCell.m
//  SCFramework
//
//  Created by Angzn on 3/11/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import "SCTableViewCell.h"

@implementation SCTableViewCell

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

@end
