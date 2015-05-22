//
//  SCLabel.h
//  SCFramework
//
//  Created by Angzn on 3/6/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCLabel : UILabel

- (void)setText:(NSString *)text adjustWidth:(BOOL)adjustWidth;
- (void)setText:(NSString *)text adjustHeight:(BOOL)adjustHeight;

@end
