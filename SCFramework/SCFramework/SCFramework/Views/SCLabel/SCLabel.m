//
//  SCLabel.m
//  SCFramework
//
//  Created by Angzn on 3/6/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import "SCLabel.h"
#import "NSString+SCAddition.h"

@implementation SCLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark - Override Method

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines
{
    CGRect textRect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    
    if ( CGPointEqualToPoint(_textPoint, CGPointZero) && 0 == _textWidth ) {
        switch (self.verticalAlignment) {
            case SCLabelVerticalAlignmentTop:
                textRect.origin.y = (bounds.origin.y);
                break;
            case SCLabelVerticalAlignmentBottom:
                textRect.origin.y = (bounds.origin.y
                                     + (bounds.size.height
                                        - textRect.size.height));
                break;
            case SCLabelVerticalAlignmentCenter:
                textRect.origin.y = (bounds.origin.y
                                     + (bounds.size.height
                                        - textRect.size.height) / 2.0);
                break;
            default:
                textRect.origin.y = (bounds.origin.y
                                     + (bounds.size.height
                                        - textRect.size.height) / 2.0);
                break;
        }
    } else if ( !CGPointEqualToPoint(_textPoint, CGPointZero) && 0 != _textWidth ) {
        NSString *textString = self.text;
        CGFloat textHeight = self.frame.size.height - _textPoint.y;
        CGSize constraint = CGSizeMake(_textWidth, textHeight);
        CGSize size = [self sizeForText:textString
                               withFont:self.font
                          lineBreakMode:self.lineBreakMode
                      constrainedToSize:constraint];
        
        textRect.origin = _textPoint;
        textRect.size = size;
    } else if ( !CGPointEqualToPoint(_textPoint, CGPointZero) && 0 == _textWidth ) {
        NSString *textString = self.text;
        CGFloat textHeight = self.frame.size.height - _textPoint.y;
        CGFloat textWidth = self.frame.size.width - _textPoint.x;
        CGSize constraint = CGSizeMake(textWidth, textHeight);
        CGSize size = [self sizeForText:textString
                               withFont:self.font
                          lineBreakMode:self.lineBreakMode
                      constrainedToSize:constraint];
        
        textRect.origin = _textPoint;
        textRect.size = size;
    } else if ( CGPointEqualToPoint(_textPoint, CGPointZero) && 0 != _textWidth ) {
        NSString *textString = self.text;
        CGSize constraint = CGSizeMake(_textWidth, self.frame.size.height);
        CGSize size = [self sizeForText:textString
                               withFont:self.font
                          lineBreakMode:self.lineBreakMode
                      constrainedToSize:constraint];
        
        textRect.size = size;
    }
    
    return textRect;
}

- (void)drawTextInRect:(CGRect)requestedRect
{
    CGRect actualRect = [self textRectForBounds:requestedRect
                         limitedToNumberOfLines:self.numberOfLines];
    [super drawTextInRect:actualRect];
}

#pragma mark - Public Method

- (void)setTextPoint:(CGPoint)textPoint
{
    if (!CGPointEqualToPoint(_textPoint, textPoint)) {
        _textPoint = textPoint;
        [self setNeedsDisplay];
    }
}

- (void)setTextWidth:(NSUInteger)textWidth
{
    if (_textWidth != textWidth) {
        _textWidth = textWidth;
        [self setNeedsDisplay];
    }
}

- (void)setVerticalAlignment:(SCLabelVerticalAlignment)verticalAlignment
{
    if (_verticalAlignment != verticalAlignment) {
        _verticalAlignment = verticalAlignment;
        [self setNeedsDisplay];
    }
}

- (void)setText:(NSString *)text adjustWidth:(BOOL)adjustWidth
{
    if (adjustWidth) {
        CGFloat width = [text widthWithFont:self.font
                        constrainedToHeight:self.height];
        self.width = width;
        self.text = text;
    } else {
        self.text = text;
    }
}

- (void)setText:(NSString *)text adjustHeight:(BOOL)adjustHeight
{
    if (adjustHeight) {
        CGFloat height = [text heightWithFont:self.font
                           constrainedToWidth:self.width];
        self.height = height;
        self.text = text;
    } else {
        self.text = text;
    }
}

#pragma mark - Private Method

- (CGSize)sizeForText:(NSString *)text withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode constrainedToSize:(CGSize)size
{
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = lineBreakMode;
    NSDictionary *attributes = @{NSFontAttributeName: font,
                                 NSParagraphStyleAttributeName: paragraph};
    return [text boundingRectWithSize:size
                              options:(NSStringDrawingUsesLineFragmentOrigin |
                                       NSStringDrawingTruncatesLastVisibleLine)
                           attributes:attributes
                              context:nil].size;
}

@end
