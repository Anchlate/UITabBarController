//
//  UIImage+Helper.h
//  WanMengHui
//
//  Created by hannchen on 16/8/16.
//  Copyright © 2016年 qing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Helper)

+ (UIImage *)imageNamedFromCustomBundle:(NSString *)imageName;

+ (UIImage *)JpgWithFileName:(NSString *)jpgFileName;

+ (UIImage *)pngWithFileName:(NSString *)pngFileName;

/**
 *  图片旋转处理
 *  @param aImage 需要旋转的图片
 *  @return 旋转后的图片
 */
+ (UIImage *)fixOrientation:(UIImage *)aImage;

/**
 *  序列化图片 (顺便压缩)
 *  @param image 需要序列化的图片
 *  @return 序列化和压缩后的二进制数据
 */
+ (NSData *)dataImage:(UIImage *)image;

/*!
 *  @author lifution
 *  @brief 画一张指定颜色的图片(默认size为(1.f, 1.f))
 *  @param color 图片颜色
 *  @return 画好的图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/*!
 *  @author lifution
 *  @brief 画一张指定颜色和透明度的图片
 *  @param color 图片颜色
 *  @param alpha 图片透明度
 *  @return 图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color alpha:(CGFloat)alpha;

/*!
 *  @author lifution
 *  @brief 画一张指定颜色和size的图片
 *  @param color 图片颜色
 *  @param size  图片size
 *  @return 画好的image
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

/*!
 *  @author lifution
 *  @brief 画带圆角的纯色图
 *  @param color  颜色
 *  @param size   大小
 *  @param radius 圆角半径
 *  @return 画完的图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size radius:(CGFloat)radius;

@end
