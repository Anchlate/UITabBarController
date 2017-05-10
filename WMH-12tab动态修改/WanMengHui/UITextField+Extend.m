//
//  UITextField+Extend.m
//  WenLou
//
//  Created by Steven on 16/3/22.
//  Copyright © 2016年 Steven. All rights reserved.
//

#import "UITextField+Extend.h"

@implementation UITextField (Extend)

+ (instancetype)fieldWithReturnType:(UIReturnKeyType)returnType fontSize:(CGFloat)fontSize keyboardType:(UIKeyboardType)keyboardType clearButtonMode:(UITextFieldViewMode)clearButtonMode placeHolder:(NSString *)placeHolder delegate:(id)target {
    UITextField *field    = [[self alloc] init];
    field.backgroundColor = [UIColor whiteColor];
    field.returnKeyType   = returnType;
    field.font            = [UIFont systemFontOfSize:fontSize];
    field.keyboardType    = keyboardType;
    field.clearButtonMode = clearButtonMode;
    field.delegate        = target;
    field.placeholder     = placeHolder;
    field.leftViewMode    = UITextFieldViewModeAlways;
    field.leftView        = [[UIView alloc] initWithFrame:CGRectZero];
    field.leftView.get_width = 5;
    field.leftView.backgroundColor = field.backgroundColor;
    
    return field;
}

#pragma mark - getter
// 字体size
- (CGFloat)fontSize {
    return self.font.pointSize;
}

#pragma mark - setter
// 设置字体大小
- (void)setFontSize:(CGFloat)fontSize {
    NSString *fontName = self.font.fontName;
    self.font = [UIFont fontWithName:fontName size:fontSize];
}

@end
