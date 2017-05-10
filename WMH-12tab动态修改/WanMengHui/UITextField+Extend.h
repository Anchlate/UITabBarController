//
//  UITextField+Extend.h
//  WenLou
//
//  Created by Steven on 16/3/22.
//  Copyright © 2016年 Steven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Extend)

@property (nonatomic, assign) CGFloat fontSize;///< 字体大小

/*!
 *  @author lifution
 *
 *  @brief 便利构造器
 *  @param returnType      return键类型
 *  @param fontSize        字体大小
 *  @param keyboardType    键盘样式
 *  @param clearButtonMode 清楚按钮类型
 *  @param placeHolder     placeHolder
 *  @param target          代理对象
 *  @return 初始化后的当前对象
 */
+ (instancetype)fieldWithReturnType:(UIReturnKeyType)returnType fontSize:(CGFloat)fontSize keyboardType:(UIKeyboardType)keyboardType clearButtonMode:(UITextFieldViewMode)clearButtonMode placeHolder:(NSString *)placeHolder delegate:(id)target;

@end
