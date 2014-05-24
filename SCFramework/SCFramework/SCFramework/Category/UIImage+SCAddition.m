//
//  UIImage+SCAddition.m
//  SCFramework
//
//  Created by Angzn on 3/5/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import "UIImage+SCAddition.h"
#import "SCMath.h"

@interface UIImage(SCAdditionPrivate)
- (void)addCircleRectToPath:(CGRect)rect context:(CGContextRef)context;
@end


@implementation UIImage (SCAddition)

// Adds a rectangular path to the given context and rounds its corners by the given extents
// Original author: Björn Sållarp. Used with permission. See: http://blog.sallarp.com/iphone-uiimage-round-corners/
- (void)addCircleRectToPath:(CGRect)rect context:(CGContextRef)context
{
    CGContextSaveGState( context );
    CGContextTranslateCTM( context, CGRectGetMinX(rect), CGRectGetMinY(rect) );
	CGContextSetShouldAntialias( context, true );
	CGContextSetAllowsAntialiasing( context, true );
	CGContextAddEllipseInRect( context, rect );
    CGContextClosePath( context );
    CGContextRestoreGState( context );
}

#pragma mark - Public Method

/**
 *  @brief 图片方向调整
 */
- (UIImage *)fixOrientation
{
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp) {
        return self;
    }
	
    CGFloat thisWidth = self.size.width;
    CGFloat thisHeight = self.size.height;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
	
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, thisWidth, thisHeight);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
			
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, thisWidth, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
			
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, thisHeight);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
		default:
			break;
    }
	
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, thisWidth, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
			
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, thisHeight, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
		default:
			break;
    }
	
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL,
                                             thisWidth,
                                             thisHeight,
                                             CGImageGetBitsPerComponent(self.CGImage),
                                             0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx,
                               CGRectMake(0,0,thisHeight,thisWidth),
                               self.CGImage);
            break;
			
        default:
            CGContextDrawImage(ctx,
                               CGRectMake(0,0,thisWidth,thisHeight),
                               self.CGImage);
            break;
    }
	
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

/**
 *  @brief 图片不透明
 */
- (UIImage *)transparent
{
	CGImageAlphaInfo alpha = CGImageGetAlphaInfo( self.CGImage );
	
	if (kCGImageAlphaFirst == alpha ||
		kCGImageAlphaLast == alpha ||
		kCGImageAlphaPremultipliedFirst == alpha ||
		kCGImageAlphaPremultipliedLast == alpha) {
		return self;
	}
    
	CGImageRef	imageRef = self.CGImage;
	size_t		width = CGImageGetWidth(imageRef);
	size_t		height = CGImageGetHeight(imageRef);
    
	CGContextRef context = CGBitmapContextCreate(NULL,
                                                 width,
                                                 height,
                                                 8,
                                                 0,
                                                 CGImageGetColorSpace(imageRef),
                                                 (kCGBitmapByteOrderDefault |
                                                  kCGImageAlphaPremultipliedFirst));
	CGContextDrawImage( context, CGRectMake(0, 0, width, height), imageRef );
    
	CGImageRef	resultRef = CGBitmapContextCreateImage( context );
	UIImage *	result = [UIImage imageWithCGImage:resultRef];
    
	CGContextRelease( context );
	CGImageRelease( resultRef );
    
	return result;
}

/**
 *  @brief 图片大小调整
 */
- (UIImage *)resize:(CGSize)newSize
{
    CGImageRef imgRef = self.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGRect bounds = CGRectMake(0, 0, width, height);
    if ( width > newSize.width || height > newSize.height ) {
        CGFloat ratio = width / height;
        if ( ratio > 1 ) {
            bounds.size.width = newSize.width;
            bounds.size.height = bounds.size.width / ratio;
        } else {
            bounds.size.height = newSize.height;
            bounds.size.width = bounds.size.height * ratio;
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGAffineTransform transform = CGAffineTransformIdentity;
    UIImageOrientation orientation = self.imageOrientation;
    switch(orientation) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(width, height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            SCMathSWAP(&bounds.size.width, &bounds.size.height);
            transform = CGAffineTransformMakeTranslation(height, width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            SCMathSWAP(&bounds.size.width, &bounds.size.height);
            transform = CGAffineTransformMakeTranslation(0.0, width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            SCMathSWAP(&bounds.size.width, &bounds.size.height);
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            SCMathSWAP(&bounds.size.width, &bounds.size.height);
            transform = CGAffineTransformMakeTranslation(height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException
                        format:@"Invalid image orientation"];
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orientation == UIImageOrientationRight ||
        orientation == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    } else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(context,
                       CGRectMake(0, 0, width, height),
                       imgRef);
    UIImage * result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

/**
 *  @brief 图片缩放
 *
 *  @param size 指定大小
 */
- (UIImage *)scaleTo:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage * result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

/**
 *  @brief 图片等比例缩小
 *
 *  @param maxSize 指定最大大小
 */
- (UIImage *)scaleDown:(CGSize)maxSize
{
    CGFloat thisWidth = self.size.width;
    CGFloat thisHeight = self.size.height;
    
    CGFloat widthRatio = maxSize.width / thisWidth;
    CGFloat heightRatio = maxSize.height / thisHeight;
    
    if ( widthRatio > 1.0 && heightRatio > 1.0 ) {
        return self;
    }
    
    CGFloat ratio = MIN(widthRatio, heightRatio);
    CGSize scaledSize = CGSizeZero;
    scaledSize.width  = thisWidth * ratio;
    scaledSize.height = thisHeight * ratio;
    
    return [self scaleTo:scaledSize];
}

/**
 *  @brief 图片拉伸
 */
- (UIImage *)stretched
{
	CGFloat leftCap = floorf(self.size.width / 2.0f);
	CGFloat topCap = floorf(self.size.height / 2.0f);
	return [self stretchableImageWithLeftCapWidth:leftCap topCapHeight:topCap];
}

/**
 *  @brief 图片拉伸
 *
 *  @param capInsets 指定拉伸区域位置
 */
- (UIImage *)stretched:(UIEdgeInsets)capInsets
{
    return [self resizableImageWithCapInsets:capInsets];
}

/**
 *  @brief 图片旋转
 *
 *  @param angle 指定旋转角度
 */
- (UIImage *)rotate:(CGFloat)angle
{
	CGSize imageSize = self.size;
	CGSize canvasSize = CGSizeZero;
	
	angle = fmod( fmod(angle, 360) + 360, 360 );
    
	if ( 90 == angle || 270 == angle ) {
		canvasSize.width = self.size.height;
		canvasSize.height = self.size.width;
	} else if ( 0 == angle || 180 == angle ) {
		canvasSize.width = self.size.width;
		canvasSize.height = self.size.height;
	} else {
        CGFloat internalAngle = fmod( angle, 90 );
        double sinValue = sin(SCMathDegreesToRadians(internalAngle));
        double cosValue = cos(SCMathDegreesToRadians(internalAngle));
        
        CGFloat thisWidth = self.size.width;
        CGFloat thisHeight = self.size.height;
        
        if ( (0 < angle && angle < 90) || (180 < angle && angle < 270) ) {
            canvasSize.width = cosValue * thisWidth + sinValue * thisHeight;
            canvasSize.height = sinValue * thisWidth + cosValue * thisHeight;
        } else if ( (90 < angle && angle < 180) || (270 < angle && angle < 360) ) {
            canvasSize.width = sinValue * thisWidth + cosValue * thisHeight;
            canvasSize.height = cosValue * thisWidth + sinValue * thisHeight;
        }
    }
    
    UIGraphicsBeginImageContext( canvasSize );
	
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM( bitmap, canvasSize.width / 2, canvasSize.height / 2 );
    CGContextRotateCTM( bitmap, M_PI / 180 * angle );
    
    CGContextScaleCTM( bitmap, 1.0, -1.0 );
    CGContextDrawImage(bitmap,
                       CGRectMake(-(imageSize.width / 2),
                                  -(imageSize.height / 2),
                                  imageSize.width,
                                  imageSize.height),
                       self.CGImage );
    
    UIImage * result = UIGraphicsGetImageFromCurrentImageContext();
	
    UIGraphicsEndImageContext();
	
    return result;
}

/**
 *  @brief 图片顺时针旋转90度
 */
- (UIImage *)rotateCW90
{
	return [self rotate:90];
}

/**
 *  @brief 图片顺时针旋转180度
 */
- (UIImage *)rotateCW180
{
	return [self rotate:180];
}

/**
 *  @brief 图片顺时针旋转270度
 */
- (UIImage *)rotateCW270
{
	return [self rotate:270];
}

/**
 *  @brief 图片裁剪
 *
 *  @param rect 指定裁剪区域
 */
- (UIImage *)crop:(CGRect)rect
{
    CGImageRef imageRef = self.CGImage;
    CGImageRef newImageRef = CGImageCreateWithImageInRect(imageRef, rect);
	
    UIGraphicsBeginImageContext(rect.size);
	
    CGContextRef context = UIGraphicsGetCurrentContext();
	
    CGContextDrawImage(context, rect, newImageRef);
	
    UIImage * result = [UIImage imageWithCGImage:newImageRef];
	
    UIGraphicsEndImageContext();
	
    CGImageRelease(newImageRef);
	
    return result;
}

/**
 *  @brief 裁剪正方形
 */
- (UIImage *)cropSquare
{
    CGFloat thisWidth = self.size.width;
    CGFloat thisHeight = self.size.height;
    
    CGFloat length = MIN(thisWidth, thisHeight);
    
    CGFloat origionX = (thisWidth - length) / 2;
    CGFloat origionY = (thisHeight - length) / 2;
    
    CGRect rect = CGRectMake(origionX, origionY, length, length);
    
    return [self crop:rect];
}

/**
 *  @brief 两张图片合并
 */
- (UIImage *)merge:(UIImage *)image
{
    if ( !image ) {
        return self;
    }
    
	CGSize canvasSize;
	canvasSize.width = fmaxf( self.size.width, image.size.width );
	canvasSize.height = fmaxf( self.size.height, image.size.height );
	
    //UIGraphicsBeginImageContext( canvasSize );
	UIGraphicsBeginImageContextWithOptions( canvasSize, NO, self.scale );
    
	CGPoint offset1;
	offset1.x = (canvasSize.width - self.size.width) / 2.0f;
	offset1.y = (canvasSize.height - self.size.height) / 2.0f;
    
	CGPoint offset2;
	offset2.x = (canvasSize.width - image.size.width) / 2.0f;
	offset2.y = (canvasSize.height - image.size.height) / 2.0f;
    
	[self drawAtPoint:offset1 blendMode:kCGBlendModeNormal alpha:1.0f];
	[image drawAtPoint:offset2 blendMode:kCGBlendModeNormal alpha:1.0f];
    
    UIImage * result = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return result;
}

/**
 *  @brief 多张图片合并
 */
+ (UIImage *)merge:(NSArray *)images
{
	UIImage * result = nil;
	
	for ( UIImage * otherImage in images ) {
		if ( nil == result ) {
			result = otherImage;
		} else {
			result = [result merge:otherImage];
		}
	}
	
	return result;
}

/**
 *  @brief 图片数据
 */
- (NSData *)dataWithExt:(NSString *)ext
{
    if ([ext compare:@"png" options:NSCaseInsensitiveSearch]) {
        return UIImagePNGRepresentation(self);
    } else if ([ext compare:@"jpg" options:NSCaseInsensitiveSearch] ||
               [ext compare:@"jpeg" options:NSCaseInsensitiveSearch]) {
        return UIImageJPEGRepresentation(self, 0);
    } else {
        return nil;
    }
}

/**
 *  @brief 图片样式颜色
 */
- (UIColor *)patternColor
{
	return [UIColor colorWithPatternImage:self];
}

/**
 *  宽度
 */
- (CGFloat)width
{
    return self.size.width;
}

/**
 *  高度
 */
- (CGFloat)height
{
    return self.size.height;
}

@end
