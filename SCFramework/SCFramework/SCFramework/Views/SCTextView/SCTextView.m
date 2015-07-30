//
//  SCTextView.m
//  SCFramework
//
//  Created by Angzn on 3/6/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import "SCTextView.h"
#import "NSString+SCAddition.h"

@interface SCTextView ()

@property (nonatomic, strong) UILabel *placeholderLabel;

@end

@implementation SCTextView

- (void)dealloc
{
    [self sc_unregisterNotification];
}

#pragma mark - Init Method

- (void)initialize
{
    [self sc_registerNotification];
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

#pragma mark - UIView Override

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.placeholderLabel.hidden = [self __shouldHidePlaceholder];
    
    if (!self.placeholderLabel.hidden) {
        [UIView performWithoutAnimation:^{
            self.placeholderLabel.frame = [self __placeholderRectThatFits:self.bounds];
            [self sendSubviewToBack:self.placeholderLabel];
        }];
    }
}

#pragma mark - UITextView Override

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    
    self.placeholderLabel.font = self.font;
}

- (void)setText:(NSString *)text
{
    [super setText:text];
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

#pragma mark - Getter Method

- (UILabel *)placeholderLabel
{
    if (!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc] init];
        _placeholderLabel.backgroundColor = [UIColor clearColor];
        _placeholderLabel.textColor = [UIColor lightGrayColor];
        _placeholderLabel.numberOfLines = 1;
        _placeholderLabel.hidden = YES;
        _placeholderLabel.font = self.font;
        [self addSubview:_placeholderLabel];
    }
    return _placeholderLabel;
}

- (NSString *)placeholder
{
    return self.placeholderLabel.text;
}

- (UIColor *)placeholderColor
{
    return self.placeholderLabel.textColor;
}

- (NSUInteger)numberOfLines
{
    return fabs(self.contentSize.height / self.font.lineHeight);
}

#pragma mark - Public Method

- (void)setPlaceholder:(NSString *)placeholder
{
    self.placeholderLabel.text = placeholder;
    
    [self setNeedsLayout];
}

- (void)setPlaceholderColor:(UIColor *)color
{
    self.placeholderLabel.textColor = color;
}

#pragma mark - Private Method

- (BOOL)__shouldHidePlaceholder
{
    if (![self.placeholder isNotEmpty] || [self.text isNotEmpty]) {
        return YES;
    }
    return NO;
}

- (CGRect)__placeholderRectThatFits:(CGRect)bounds
{
    CGRect rect = CGRectZero;
    
    rect.size = [self.placeholderLabel sizeThatFits:bounds.size];
    rect.origin = UIEdgeInsetsInsetRect(bounds, self.textContainerInset).origin;
    
    CGFloat padding = self.textContainer.lineFragmentPadding;
    rect.origin.x += padding;
    
    return rect;
}

#pragma mark - Notification Method

- (void)sc_registerNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sc_textViewDidChange:)
                                                 name:UITextViewTextDidChangeNotification
                                               object:nil];
}

- (void)sc_unregisterNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextViewTextDidChangeNotification
                                                  object:nil];
}

- (void)sc_textViewDidChange:(NSNotification *)notification
{
    if (![notification.object isEqual:self]) {
        return;
    }
    
    if (self.placeholderLabel.hidden != [self __shouldHidePlaceholder]) {
        [self setNeedsLayout];
    }
}

@end
