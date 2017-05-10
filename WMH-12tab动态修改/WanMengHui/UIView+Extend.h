//
//  UIView+Extend.h
//  WenLou
//
//  Created by Steven on 16/3/16.
//  Copyright © 2016年 Steven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extend)

@property (nonatomic, assign) CGFloat get_left;        ///< Shortcut for frame.origin.x.
@property (nonatomic, assign) CGFloat get_top;         ///< Shortcut for frame.origin.y
@property (nonatomic, assign) CGFloat get_right;       ///< Shortcut for frame.origin.x + frame.size.width
@property (nonatomic, assign) CGFloat get_bottom;      ///< Shortcut for frame.origin.y + frame.size.height
@property (nonatomic, assign) CGFloat get_width;       ///< Shortcut for frame.size.width.
@property (nonatomic, assign) CGFloat get_height;      ///< Shortcut for frame.size.height.
@property (nonatomic, assign) CGFloat get_centerX;     ///< Shortcut for center.x
@property (nonatomic, assign) CGFloat get_centerY;     ///< Shortcut for center.y
@property (nonatomic, assign) CGPoint get_origin;      ///< Shortcut for frame.origin.
@property (nonatomic, assign) CGSize  get_size;        ///< Shortcut for frame.size.

+ (instancetype)view;

/*! @brief 获取当前view所在的viewController */
- (UIViewController *)viewController;

/*!
 *  @author Steven
 *
 *  @brief 跳转到某个视图控制器
 *  @param viewController 视图控制器
 */
- (void)pushToViewController:(UIViewController *)viewController;

/*!
 *  @author Steven
 *  @brief 设置边框
 *  @param color 边框颜色
 *  @param width 边框宽度
 */
- (void)setBorderWithColor:(UIColor *)color andWidth:(CGFloat)width;

/*!
 *  @author Steven
 *  @brief 设置圆角
 *  @param radius        圆角半径
 *  @param masksToBounds 是否剪切圆角
 */
- (void)setLayerCorner:(CGFloat)radius masksToBounds:(BOOL)masksToBounds;

// 复制当前view
- (instancetype)copySelf;

@end
