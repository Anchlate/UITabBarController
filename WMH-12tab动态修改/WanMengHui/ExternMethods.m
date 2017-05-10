//
//  ExternMethods.m
//  WanMengHui
//
//  Created by hannchen on 16/8/16.
//  Copyright © 2016年 qing. All rights reserved.
//

#import "ExternMethods.h"
#import "UIImage+Helper.h"

@implementation ExternMethods

UIImage *ImageForName(NSString *imageName) { ///< 获取图片
    return [UIImage imageNamed:imageName];
}
UIImage *PngWithFileName(NSString *fileName) { ///< 获取png图片
    return [UIImage pngWithFileName:fileName];
}
UIImage *JpgWithFileName(NSString *fileName) { ///< 获取jpg图片
    return [UIImage JpgWithFileName:fileName];
}

CGFloat iOS_VERSION() { ///< iOS系统版本
    return  [[[UIDevice currentDevice] systemVersion] floatValue];
}
UIColor *UIColorWithHex(uint64_t hexValue) { ///< 十六进制颜色转换
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:1.0];
}
NSString *Localize(NSString *key) { ///< 国际化
    return NSLocalizedString(key, nil);
}

UIFont *FontForSize(CGFloat fontsize) { ///< 系统普通字体
    return [UIFont systemFontOfSize:fontsize];
}
UIFont *BoldFontForSize(CGFloat fontsize) { ///< 系统粗体字体
    return [UIFont boldSystemFontOfSize:fontsize];
}


/*! @brief 将uint64_t转化为字符串 */
NSString *NSStringFromInteger(uint64_t integer) {
    return [NSString stringWithFormat:@"%llu", (unsigned long long)integer];
}

//
//NSString *AvatarURLStringWithPath(NSString *pathString) {
//    return [URL_BASE stringByAppendingString:pathString];
//}

/*! @brief 时间戳转成时间字符串 */
NSString *NSStringFromTimestamp(uint64_t timestamp) {
    if (timestamp <= 0 || timestamp == NSNotFound) return @"";
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle  = NSDateFormatterMediumStyle;
    formatter.timeStyle  = NSDateFormatterShortStyle;
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}

@end
