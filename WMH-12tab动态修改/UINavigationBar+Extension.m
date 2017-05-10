//
//  UINavigationBar+Extension.m
//  WanMengHui
//
//  Created by hannchen on 16/8/22.
//  Copyright © 2016年 qing. All rights reserved.
//

#import "UINavigationBar+Extension.h"

@implementation UINavigationBar (Extension)


+ (UIBarButtonItem *)itemWithImageName:(NSString *)imageName andTarget:(id)target andHighImageName:(NSString *)highImageName andAction:(SEL)action
{
    UIButton *button = [[UIButton alloc]init];
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:highImageName] forState:UIControlStateHighlighted];
    //设置按钮的尺寸为背景图片的尺寸。
    button.get_size = button.currentBackgroundImage.size;
    //监听按钮
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc]initWithCustomView:button];
}
@end
