//
//  UINavigationBar+Extension.h
//  WanMengHui
//
//  Created by hannchen on 16/8/22.
//  Copyright © 2016年 qing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (Extension)


+ (UIBarButtonItem *)itemWithImageName:(NSString *)imageName andTarget:(id)target andHighImageName:(NSString *)highImageName andAction:(SEL)action;
@end
