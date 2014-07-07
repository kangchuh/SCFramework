//
//  SCPullRefreshView.m
//  SCFramework
//
//  Created by Angzn on 3/6/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import "SCPullRefreshView.h"
#import "NSDate+SCAddition.h"
#import "SCUserDefaultManager.h"

const CGFloat kSCPullRefreshViewHeight = 60.f;

const CGFloat kSCPullDownDistance = 60.f;

static NSString * const kSCUpdatedDateFormatterMMddHHmm = @"MM-dd HH:mm";
static NSString * const kSCUpdatedDateFormatterHHmm     = @"HH:mm";

static NSString * const kSCLastUpdatedDateKey = @"SCLastUpdatedDateKey";

@interface SCPullRefreshView ()

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end


@implementation SCPullRefreshView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        CGFloat thisWidth = CGRectGetWidth(frame);
        CGFloat thisHeight = CGRectGetHeight(frame);
        
		_statusLabel = [[UILabel alloc] initWithFrame:
                        CGRectMake(0.0f,
                                   thisHeight - 50.0f,
                                   thisWidth,
                                   20.0f)];
		_statusLabel.backgroundColor = [UIColor clearColor];
		_statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		_statusLabel.font = [UIFont boldSystemFontOfSize:13.0f];
		_statusLabel.textColor = [UIColor darkGrayColor];
		_statusLabel.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		_statusLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
		_statusLabel.textAlignment = NSTextAlignmentCenter;
		[self addSubview:_statusLabel];
        
		_dateLabel = [[UILabel alloc] initWithFrame:
                      CGRectMake(0.0f,
                                 thisHeight - 30.0f,
                                 thisWidth,
                                 20.0f)];
		_dateLabel.backgroundColor = [UIColor clearColor];
		_dateLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		_dateLabel.font = [UIFont systemFontOfSize:12.0f];
		_dateLabel.textColor = [UIColor darkGrayColor];
		_dateLabel.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		_dateLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
		_dateLabel.textAlignment = NSTextAlignmentCenter;
		[self addSubview:_dateLabel];
        
		_circleView = [[SCCircleView alloc] initWithFrame:
                       CGRectMake(35.0f,
                                  thisHeight - 45.0f,
                                  30.0f,
                                  30.0f)];
        [self addSubview:_circleView];
        /*
		_activityView = [[UIActivityIndicatorView alloc]
                         initWithActivityIndicatorStyle:
                         UIActivityIndicatorViewStyleGray];
		_activityView.frame = CGRectMake(40.0f,
                                         thisHeight - 40.0f,
                                         20.0f,
                                         20.0f);
        _activityView.backgroundColor = [UIColor clearColor];
        _activityView.color = _circleView.progressColor;
		[self addSubview:_activityView];
        */
        [self setState:SCPullDownStateNormal];
        
        NSDate *updatedDate = [[SCUserDefaultManager sharedInstance]
                               getObjectForKey:kSCLastUpdatedDateKey];
        [self refreshLastUpdatedDate:updatedDate];
    }
    return self;
}

#pragma mark - Public Methods

- (void)setState:(SCPullDownState)state
{
    if (_state != state) {
        
        NSString *statusText = nil;
        switch (state) {
            case SCPullDownStatePulling:
                statusText = NSLocalizedStringFromTable(@"SCFW_LS_Release to refresh", @"SCFWLocalizable", nil);
                _circleView.progress = 1.0;
                break;
            case SCPullDownStateNormal:
                statusText = NSLocalizedStringFromTable(@"SCFW_LS_Pull down to refresh", @"SCFWLocalizable", nil);
                //[_activityView stopAnimating];
                //_circleView.hidden = NO;
                [_circleView stopRotating];
                break;
            case SCPullDownStateRefreshing:
                statusText = NSLocalizedStringFromTable(@"SCFW_LS_Refreshing", @"SCFWLocalizable", nil);
                //[_activityView startAnimating];
                //_circleView.hidden = YES;
                //_circleView.progress = 0.0;
                [_circleView startRotating];
                _circleView.progress = 0.75;
                break;
            default:
                break;
        }
        _statusLabel.text = statusText;
        
        _state = state;
    }
}

- (void)setPullScale:(CGFloat)pullScale
{
    if (_pullScale != pullScale) {
        _pullScale = pullScale;
        _circleView.progress = pullScale;
    }
}

- (void)refreshLastUpdatedDate:(NSDate *)date
{
    NSDate *lastUpdatedDate = date;
    if (!lastUpdatedDate) {
        lastUpdatedDate = [NSDate date];
    }
    
    NSInteger days = [lastUpdatedDate daysSinceDate:[NSDate date]];
    NSString *dateFormat = nil;
    if (days == 0) {
        NSString *today = NSLocalizedStringFromTable(@"SCFW_LS_Last updated today", @"SCFWLocalizable", nil);
        dateFormat = [NSString stringWithFormat:@"%@ %@", today, kSCUpdatedDateFormatterHHmm];
    } else if (days == 1) {
        NSString *yesterday = NSLocalizedStringFromTable(@"SCFW_LS_Last updated yesterday", @"SCFWLocalizable", nil);
        dateFormat = [NSString stringWithFormat:@"%@ %@", yesterday, kSCUpdatedDateFormatterHHmm];
    } else if (days == 2) {
        NSString *before = NSLocalizedStringFromTable(@"SCFW_LS_Last updated before yesterday", @"SCFWLocalizable", nil);
        dateFormat = [NSString stringWithFormat:@"%@ %@", before, kSCUpdatedDateFormatterHHmm];
    } else {
        dateFormat = kSCUpdatedDateFormatterMMddHHmm;
    }
    NSString *dateString = [lastUpdatedDate stringWithFormat:dateFormat];
    
    NSString *updated = NSLocalizedStringFromTable(@"SCFW_LS_Last updated time", @"SCFWLocalizable", nil);
    _dateLabel.text = [NSString stringWithFormat:@"%@ : %@", updated, dateString];
    
    [[SCUserDefaultManager sharedInstance] setObject:lastUpdatedDate
                                              forKey:kSCLastUpdatedDateKey];
}

@end
