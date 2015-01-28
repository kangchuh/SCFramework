//
//  SCPullLoadView.m
//  SCFramework
//
//  Created by Angzn on 3/6/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import "SCPullLoadView.h"
#import "UIDevice+SCAddition.h"

const CGFloat kSCPullLoadViewHeight = 40.f;

const CGFloat kSCPullUpDistance = 0.f;

@implementation SCPullLoadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        CGFloat thisWidth = CGRectGetWidth(frame);
        
		_statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f,
                                                                 10.0f,
                                                                 thisWidth,
                                                                 20.0f)];
		_statusLabel.backgroundColor = [UIColor clearColor];
		_statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _statusLabel.font = [UIFont boldSystemFontOfSize:[UIDevice iPad] ? 15.0f : 13.0f];
		_statusLabel.textColor = [UIColor darkGrayColor];
		_statusLabel.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		_statusLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
		_statusLabel.textAlignment = NSTextAlignmentCenter;
		[self addSubview:_statusLabel];
        
		_activityView = [[UIActivityIndicatorView alloc]
                         initWithActivityIndicatorStyle:
                         UIActivityIndicatorViewStyleGray];
        _activityView.backgroundColor = [UIColor clearColor];
		_activityView.frame = CGRectMake(40.0f,
                                         10.0f,
                                         20.0f,
                                         20.0f);
		[self addSubview:_activityView];
        
        [self setState:SCPullUpStateNormal];
    }
    return self;
}

#pragma mark - Public Methods

- (void)setState:(SCPullUpState)state
{
    if (_state != state) {
        
        NSString *statusText = nil;
        switch (state) {
            case SCPullUpStatePulling:
                statusText = NSLocalizedStringFromTable(@"SCFW_LS_Release to load", @"SCFWLocalizable", nil);
                break;
            case SCPullUpStateNormal:
                statusText = NSLocalizedStringFromTable(@"SCFW_LS_Pull up to load", @"SCFWLocalizable", nil);
                [_activityView stopAnimating];
                break;
            case SCPullUpStateLoading:
                statusText = NSLocalizedStringFromTable(@"SCFW_LS_Loading", @"SCFWLocalizable", nil);
                [_activityView startAnimating];
                break;
            default:
                break;
        }
        _statusLabel.text = statusText;
        
        _state = state;
    }
}

@end
