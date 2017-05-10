//
//  ExternMethods.h
//  WanMengHui
//
//  Created by hannchen on 16/8/16.
//  Copyright © 2016年 qing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExternMethods : NSObject

UIKIT_EXTERN UIImage *ImageForName(NSString *imageName); ///< 获取图片
UIKIT_EXTERN UIImage *PngWithFileName(NSString *fileName); ///< 获取png图片
UIKIT_EXTERN UIImage *JpgWithFileName(NSString *fileName); ///< 获取jpg图片

UIKIT_EXTERN CGFloat iOS_VERSION(); ///< iOS系统版本
UIKIT_EXTERN UIColor *UIColorWithHex(uint64_t hexValue); ///< 十六进制颜色转换
UIKIT_EXTERN NSString *Localize(NSString *key); ///< 国际化

UIKIT_EXTERN UIFont *FontForSize(CGFloat fontsize); ///< 系统普通字体
UIKIT_EXTERN UIFont *BoldFontForSize(CGFloat fontsize); ///< 系统粗体字体

/*! @author Steven
 *  @brief 将uint64_t转化为字符串
 */
UIKIT_EXTERN NSString *NSStringFromInteger(uint64_t integer);

//UIKIT_EXTERN NSString *AvatarURLStringWithPath(NSString *pathString);

/*! @author Steven
 *  @brief 时间戳转成时间字符串
 *  @param timestamp 时间戳
 */
UIKIT_EXTERN NSString *NSStringFromTimestamp(uint64_t timestamp);


@end
