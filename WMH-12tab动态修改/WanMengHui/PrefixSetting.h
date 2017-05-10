//
//  PrefixSetting.h
//  WanMengHui
//
//  Created by hannchen on 16/8/16.
//  Copyright © 2016年 qing. All rights reserved.
//

#ifndef PrefixSetting_h
#define PrefixSetting_h


#endif /* PrefixSetting_h */


//是否为iOS7及以上版本
#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)

#define ScreenWidth             [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight            [[UIScreen mainScreen] bounds].size.height
#define NavHeight               44
#define statusBarHeight         20
#define BarHeight               64
#define TabBarHeight            49
#define tableViewNormalHeight   (ScreenHeight-BarHeight)


#define kLoginViewMargin            10 ///< 边距
#define kLoginViewFieldHeight       40 ///< 输入框高度




#define isiPhone4  (ScreenHeight == 480)
#define isiPhone5  (ScreenHeight == 568)
#define isiPhone6  (ScreenHeight == 667)
#define isiPhone6P (ScreenHeight == 736)

#define autoSizeScaleX (ScreenHeight>480?ScreenWidth/320:1.0)
#define autoSizeScaleY (ScreenHeight>480?ScreenHeight/568:1.0)

// weakself
#define WEAK(variable) __weak __typeof(variable)W##variable = variable;

// 获取安全主线程
#define dispatch_get_main_async_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}

// 自定义输出
#ifdef DEBUG
#define WQNSLog(...) NSLog(@"%s-%d行: %@\n", __PRETTY_FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__])
#else
#define WQNSLog(...)
#endif

#define defaults [NSUserDefaults standardUserDefaults]

#import "BaseNavigationViewController.h"
#import "BaseViewController.h"
#import "Masonry/Masonry/Masonry.h"
#import "HUD/MBProgressHUD.h"
#import "UIViewController+HUD.h"
#import "MJRefresh.h"
#import "Network.h"

#import "UIImage+Helper.h"
#import "UITextField+Extend.h"
#import "UINavigationBar+Extension.h"
#import "UIView+Extend.h"
#import "NSData+StanderData.h"


#import "ExternMethods.h"
#import "GlobalSymbolTable.h"


