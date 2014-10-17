//
//  SCToolbar.m
//  SCFramework
//
//  Created by Angzn on 9/23/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import "SCToolbar.h"

#import "UIBarButtonItem+SCAddition.h"

#import "SCAdaptedSystem.h"

@implementation SCToolbar

- (instancetype)initWithFrame:(CGRect)frame actionStyle:(SCToolbarActionStyle)actionStyle
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.actionStyle = actionStyle;
    }
    return self;
}

#pragma mark - Action Method

- (void)doneAction:(__unused id)sender
{
    if (_actionDelegate && [_actionDelegate respondsToSelector:@selector(toolbarDidDone:)]) {
        [_actionDelegate toolbarDidDone:self];
    }
}

- (void)cancelAction:(__unused id)sender
{
    if (_actionDelegate && [_actionDelegate respondsToSelector:@selector(toolbarDidCancel:)]) {
        [_actionDelegate toolbarDidCancel:self];
    }
}

#pragma mark - Public Method

- (void)setActionStyle:(SCToolbarActionStyle)actionStyle
{
    if (_actionStyle != actionStyle) {
        _actionStyle = actionStyle;
        [self __setActionStyle];
    }
}

#pragma mark - Private Method

- (void)__setActionStyle
{
    if (_actionStyle == SCToolbarActionStyleDoneAndCancel) {
        [self __setActionStyleDoneAndCancel];
    }
}

- (void)__setActionStyleDoneAndCancel
{
    UIBarButtonItem *leftSpaceItem = [[UIBarButtonItem alloc] initWithFixedSpaceWidth:10.0f];
    
    UIBarButtonItem *cancelBarItem = [[UIBarButtonItem alloc] initWithTarget:self
                                                                      action:@selector(cancelAction:)];
    cancelBarItem.title = NSLocalizedStringFromTable(@"SCFW_LS_Cancel", @"SCFWLocalizable", nil);
    cancelBarItem.style = UIBarButtonItemStyleDone;
    
    UIBarButtonItem *flexibleSpaceItem = [UIBarButtonItem flexibleSpaceSystemItem];
    
    UIBarButtonItem *doneBarItem = [[UIBarButtonItem alloc] initWithTarget:self
                                                                    action:@selector(doneAction:)];
    doneBarItem.title = NSLocalizedStringFromTable(@"SCFW_LS_Done", @"SCFWLocalizable", nil);
    doneBarItem.style = UIBarButtonItemStyleDone;
    
    UIBarButtonItem *rightSpaceItem = [[UIBarButtonItem alloc] initWithFixedSpaceWidth:10.0f];
    
    if ( SCiOS8OrLater() ) {
        self.items = @[leftSpaceItem, cancelBarItem, flexibleSpaceItem, doneBarItem, rightSpaceItem];
    } else {
        self.items = @[cancelBarItem, flexibleSpaceItem, doneBarItem];
    }
}

@end
