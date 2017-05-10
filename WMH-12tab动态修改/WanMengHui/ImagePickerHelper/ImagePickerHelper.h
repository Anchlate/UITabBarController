//
//  ImagePickerHelper.h
//  WenLou
//
//  Created by Steven on 16/3/23.
//  Copyright © 2016年 Steven. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ImagePickerHandle)(UIImage *image);

@interface ImagePickerHelper : NSObject

+ (instancetype)helper;

/*!
 *  @author Steven
 *  @brief 展示
 *  @param viewController 所在控制器
 *  @param completion     选择图片完成回调
 */
- (void)showInViewController:(UIViewController *)viewController pickerCompletion:(ImagePickerHandle)completion;

@end
