//
//  SCTextView.m
//  SCFramework
//
//  Created by Angzn on 3/6/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import "SCTextView.h"
#import "NSString+SCAddition.h"

static const CGFloat kSCTextViewInnerMargin = 8.0;

@interface SCTextView ()
{
@private
    UILabel *_placeholderLabel;
}

@end

@implementation SCTextView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextViewTextDidChangeNotification
                                                  object:nil];
}

#pragma mark - Init Method

- (void)initialize
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textDidChange:)
                                                 name:UITextViewTextDidChangeNotification
                                               object:nil];
    
    self.placeholderColor = [UIColor lightGrayColor];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initialize];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if ([self.placeholder isNotEmpty]) {
        if (!_placeholderLabel) {
            _placeholderLabel = [[UILabel alloc] initWithFrame:
                                 CGRectMake(kSCTextViewInnerMargin,
                                            kSCTextViewInnerMargin,
                                            0.0, 0.0)];
            _placeholderLabel.backgroundColor = [UIColor clearColor];
            _placeholderLabel.lineBreakMode = NSLineBreakByWordWrapping;
            _placeholderLabel.textColor = self.placeholderColor;
            _placeholderLabel.numberOfLines = 0;
            _placeholderLabel.font = self.font;
            [self addSubview:_placeholderLabel];
        }
        [self sendSubviewToBack:_placeholderLabel];
        
        _placeholderLabel.size = CGSizeZero;
        _placeholderLabel.text = self.placeholder;
        _placeholderLabel.hidden = [self.text isNotEmpty];
        [_placeholderLabel sizeToFit];
    }
}

#pragma mark - UIResponder Touch Methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    if ( _endEditingWhenSlide ) {
        [self resignFirstResponder];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
}

#pragma mark - Public Method

- (void)setPlaceholder:(NSString *)placeholder
{
    if (_placeholder != placeholder) {
        _placeholder = nil;
        _placeholder = [placeholder copy];
        [self setNeedsLayout];
    }
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    if (_placeholderColor != placeholderColor) {
        _placeholderColor = nil;
        _placeholderColor = placeholderColor;
        [self setNeedsLayout];
    }
}

- (void)reset
{
    self.text = nil;
    
    _placeholderLabel.hidden = NO;
}

#pragma mark - Notification Method

- (void)textDidChange:(NSNotification *)notification
{
    if (![self.placeholder isNotEmpty]) {
        return;
    }
    
    _placeholderLabel.hidden = [self.text isNotEmpty];
}

@end
