//
//  UIView+Extend.m
//  WenLou
//
//  Created by Steven on 16/3/16.
//  Copyright © 2016年 Steven. All rights reserved.
//

#import "UIView+Extend.h"

@implementation UIView (Extend)

- (CGFloat)get_left {
    return self.frame.origin.x;
}

- (void)setGet_left:(CGFloat)x {
    CGRect frame   = self.frame;
    frame.origin.x = x;
    self.frame     = frame;
}

- (CGFloat)get_top {
    return self.frame.origin.y;
}

- (void)setGet_top:(CGFloat)y {
    CGRect frame   = self.frame;
    frame.origin.y = y;
    self.frame     = frame;
}

- (CGFloat)get_right {
    return CGRectGetMaxX(self.frame);
}

- (void)setGet_right:(CGFloat)right {
    CGRect frame   = self.frame;
    frame.origin.x = right-frame.size.width;
    self.frame     = frame;
}

- (CGFloat)get_bottom {
    return CGRectGetMaxY(self.frame);
}

- (void)setGet_bottom:(CGFloat)bottom {
    CGRect frame   = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame     = frame;
}

- (CGFloat)get_width {
    return CGRectGetWidth(self.frame);
}

- (void)setGet_width:(CGFloat)width {
    CGRect frame     = self.frame;
    frame.size.width = width;
    self.frame       = frame;
}

- (CGFloat)get_height {
    return CGRectGetHeight(self.frame);
}

- (void)setGet_height:(CGFloat)height {
    CGRect frame      = self.frame;
    frame.size.height = height;
    self.frame        = frame;
}

- (CGFloat)get_centerX {
    return self.center.x;
}

- (void)setGet_centerX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)get_centerY {
    return self.center.y;
}

- (void)setGet_centerY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGPoint)get_origin {
    return self.frame.origin;
}

- (void)setGet_origin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame   = frame;
}

- (CGSize)get_size {
    return self.frame.size;
}

- (void)setGet_size:(CGSize)size {
    CGRect frame = self.frame;
    frame.size   = size;
    self.frame   = frame;
}



#pragma mark ///////////////////////////////////////////////////////////////////////////////

+ (instancetype)view {
    UIView *view = [[self alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

/*! @brief 设置边框 */
- (void)setBorderWithColor:(UIColor *)color andWidth:(CGFloat)width {
    self.layer.borderWidth = width;
    self.layer.borderColor = color.CGColor;
}

/*! @brief 设置圆角 */
- (void)setLayerCorner:(CGFloat)radius masksToBounds:(BOOL)masksToBounds {
    self.layer.cornerRadius  = radius;
    self.layer.masksToBounds = masksToBounds;
}

// 获取当前view所在的viewController
- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

/*! @brief 跳转到某个视图控制器 */
- (void)pushToViewController:(UIViewController *)viewController {
    UIViewController *currentVC = [self viewController];
    if (currentVC) {
        if (currentVC.navigationController) {
            [currentVC.navigationController pushViewController:viewController animated:YES];
        } else {
            [currentVC presentViewController:viewController animated:YES completion:nil];
        }
    }
}

- (instancetype)copySelf {
    NSData *archivedViewData = [NSKeyedArchiver archivedDataWithRootObject:self];
    UILabel *copyView = [NSKeyedUnarchiver unarchiveObjectWithData:archivedViewData];
    return copyView;
}

@end
