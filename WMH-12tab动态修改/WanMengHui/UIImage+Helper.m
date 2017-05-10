//
//  UIImage+Helper.m
//  WanMengHui
//
//  Created by hannchen on 16/8/16.
//  Copyright © 2016年 qing. All rights reserved.
//

#import "UIImage+Helper.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>
#import <Accelerate/Accelerate.h>

@implementation UIImage (Helper)

// bundle中得图片
+ (UIImage *)imageNamedFromCustomBundle:(NSString *)imageName {
    NSBundle *bundle   = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"Library" ofType:@"bundle"]];
    NSString *img_path = [bundle pathForResource:imageName ofType:@"png"];
    return [UIImage imageWithContentsOfFile:img_path];
}

// 获取jpg图片
+ (UIImage *)JpgWithFileName:(NSString *)jpgFileName {
    if (isiPhone6P) {
        NSString *HDPngPath = [[NSBundle mainBundle] pathForResource:[jpgFileName stringByAppendingString:@"@3x"] ofType:@"jpg"];
        NSString *RPngPath  = [[NSBundle mainBundle] pathForResource:[jpgFileName stringByAppendingString:@"@2x"] ofType:@"jpg"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:HDPngPath]) {
            // 存在@3x的图片则直接使用@3x的图片
            return [UIImage imageWithContentsOfFile:HDPngPath];
        } else if ([[NSFileManager defaultManager] fileExistsAtPath:RPngPath]) {
            // 不存在@2x的图片则使用@2x的图片
            return [UIImage imageWithContentsOfFile:RPngPath];
        } else {
            WQNSLog(@"%@ 不存在这张图片", jpgFileName);
        }
    } else {
        NSString *RPngPath  = [[NSBundle mainBundle] pathForResource:[jpgFileName stringByAppendingString:@"@2x"] ofType:@"jpg"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:RPngPath]) {
            return [UIImage imageWithContentsOfFile:RPngPath];
        } else {
            WQNSLog(@"%@ 不存在这张图片", jpgFileName);
        }
    }
    
    // 找不到图片则返回空值
    return nil;
}

// 获取png图片
+ (UIImage *)pngWithFileName:(NSString *)pngFileName {
    if (isiPhone6P) {
        NSString *HDPngPath = [[NSBundle mainBundle] pathForResource:[pngFileName stringByAppendingString:@"@3x"] ofType:@"png"];
        NSString *RPngPath  = [[NSBundle mainBundle] pathForResource:[pngFileName stringByAppendingString:@"@2x"] ofType:@"png"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:HDPngPath]) {
            // 存在@3x的图片则直接使用@3x的图片
            return [UIImage imageWithContentsOfFile:HDPngPath];
        } else if ([[NSFileManager defaultManager] fileExistsAtPath:RPngPath]) {
            // 不存在@3x的图片则使用@2x的图片
            return [UIImage imageWithContentsOfFile:RPngPath];
        } else {
            WQNSLog(@"%@ 不存在这张图片", pngFileName);
        }
    } else {
        NSString *RPngPath  = [[NSBundle mainBundle] pathForResource:[pngFileName stringByAppendingString:@"@2x"] ofType:@"png"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:RPngPath]) {
            return [UIImage imageWithContentsOfFile:RPngPath];
        } else {
            WQNSLog(@"%@ 不存在这张图片", pngFileName);
        }
    }
    
    // 找不到图片则返回空值
    return nil;
}

#pragma mark - //////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/* 图片旋转处理 */
+ (UIImage *)fixOrientation:(UIImage *)aImage {
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
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
 *  序列化图片 (顺便压缩)
 *
 *  @param image 需要序列化的图片
 *
 *  @return 序列化和压缩后的二进制数据
 */
+ (NSData *)dataImage:(UIImage *)image {
    NSData *imageData = UIImageJPEGRepresentation(image , 1.0);
    NSInteger length = [imageData length]/1024;
    if (length >= 2048) {
        imageData = UIImageJPEGRepresentation(image , 0.15);
    }
    else if (length >= 1024 && length < 2048)
    {
        imageData = UIImageJPEGRepresentation(image , 0.25);
    }
    else if(length >= 512 && length < 1024)
    {
        imageData = UIImageJPEGRepresentation(image , 0.5);
    }
    else if(length >= 300 && length < 512)
    {
        imageData = UIImageJPEGRepresentation(image , 0.8);
    }
    return imageData;
}

/*! @brief 画一张指定颜色的图片(默认size为(1.f, 1.f)) */
+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 3.f, 3.f);
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(3.f, 3.f), NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [image stretched];
}

/*! @brief 画一张指定颜色和透明度的图片 */
+ (UIImage *)imageWithColor:(UIColor *)color alpha:(CGFloat)alpha {
    if (alpha < 0) alpha = 0;
    if (alpha > 1) alpha = 1;
    
    UIImage *image = [self imageWithColor:color];
    UIGraphicsBeginImageContextWithOptions(image.size, NO, [UIScreen mainScreen].scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    CGContextSetAlpha(ctx, alpha);
    CGContextDrawImage(ctx, area, image.CGImage);
    UIImage *alphaImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [alphaImage stretched];
}

/*! @brief 画一张指定颜色的图片, 指定size */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [image stretched];
}

/*! @brief 画带圆角的纯色图 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size radius:(CGFloat)radius {
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetShouldAntialias(context, true);
    CGContextSetFillColorWithColor(context, color.CGColor);
    // 画圆角
    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:(size.height<radius)?size.height/2:radius] addClip];
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [image stretched];
}

// 设置拉伸
- (UIImage *)stretched {
    CGSize size = self.size;
    UIEdgeInsets insets = UIEdgeInsetsMake(truncf(size.height-1)/2, truncf(size.width-1)/2, truncf(size.height-1)/2, truncf(size.width-1)/2);
    return [self resizableImageWithCapInsets:insets];
}

@end
