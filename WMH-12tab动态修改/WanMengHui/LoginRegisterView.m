//
//  LoginRegisterView.m
//  WanMengHui
//
//  Created by hannchen on 16/8/18.
//  Copyright © 2016年 qing. All rights reserved.
//

#import "LoginRegisterView.h"

@implementation LoginRegisterView

+ (UILabel *)initLabeWithTitle:(NSString *)title andfont:(CGFloat)fontSize {
    UILabel *lb = [[UILabel alloc]init];
    lb.text = title;
    lb.font = [UIFont systemFontOfSize:fontSize];
    lb.textColor = [UIColor blackColor];

    return lb;
}

+ (UIButton *)initButtonWithTitle:(NSString *)title andTitleColor:(UIColor *)titleColor{
    
    UIButton *btn = [[UIButton alloc]init];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    [btn setAlpha:0.8];

    return btn;
}


@end
