/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import <UIKit/UIKit.h>

@interface UIViewController (HUD)

- (void)showHudWithHint:(NSString *)hint;
- (void)showHint:(NSString *)hint;
- (void)showLoadingHud;

/*! 显示加载成功的提示  */
- (void)showViewCompletedHudWithHint:(NSString *) hintString;
/*! 显示加载成功的提示 */
- (void)showViewCompletedHudWithHint:(NSString *) hintString hide:(void (^)())hide;

- (void)hideHud;

@end
