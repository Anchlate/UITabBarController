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

#import "UIViewController+HUD.h"
#import "MBProgressHUD.h"
#import <objc/runtime.h>

static const void *HttpRequestHUDKey = &HttpRequestHUDKey;

@implementation UIViewController (HUD)

- (MBProgressHUD *)HUD{
    return objc_getAssociatedObject(self, HttpRequestHUDKey);
}

- (void)setHUD:(MBProgressHUD *)HUD{
    objc_setAssociatedObject(self, HttpRequestHUDKey, HUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)showLoadingHud {
    if ([self HUD]) {
        [self HUD].labelText = NSLocalizedString(@"请稍后", nil);
    } else {
        UIView *backView;
        if ([self isKindOfClass:[UITableViewController class]]) {
            backView = [UIApplication sharedApplication].keyWindow;
        } else {
            backView = self.view;
        }
        MBProgressHUD *HUD = [self HUD]?:[MBProgressHUD showHUDAddedTo:backView animated:YES];
        HUD.labelText = NSLocalizedString(@"请稍后", nil);
        HUD.removeFromSuperViewOnHide = YES;
        [HUD show:YES];
        [self setHUD:HUD];
    }
}

- (void)showHudWithHint:(NSString *)hint {
    if ([self HUD]) {
        [self HUD].labelText = hint;
    } else {
        UIView *backView;
        if ([self isKindOfClass:[UITableViewController class]]) {
            backView = [UIApplication sharedApplication].keyWindow;
        } else {
            backView = self.view;
        }
        MBProgressHUD *HUD = [self HUD]?:[MBProgressHUD showHUDAddedTo:backView animated:YES];
        HUD.labelText = hint;
        HUD.removeFromSuperViewOnHide = YES;
        [HUD show:YES];
        [self setHUD:HUD];
    }
}

- (void)showHint:(NSString *)hint {
    UIView *backView;
    if ([self isKindOfClass:[UITableViewController class]]) {
        backView = [UIApplication sharedApplication].keyWindow;
    } else {
        backView = self.view;
    }
    MBProgressHUD *hud = [self HUD]?:[MBProgressHUD showHUDAddedTo:backView animated:YES];
    // Configure for text only and offset down
    hud.mode      = MBProgressHUDModeText;
    hud.labelText = hint;
    hud.margin    = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:0.95];
}

- (void)showViewCompletedHudWithHint:(NSString *)hintString {
    if (![self HUD]) {
        UIView *backView;
        if ([self isKindOfClass:[UITableViewController class]]) {
            backView = [UIApplication sharedApplication].keyWindow;
        } else {
            backView = self.view;
        }
        MBProgressHUD *HUD = [self HUD]?:[MBProgressHUD showHUDAddedTo:backView animated:YES];
        HUD.removeFromSuperViewOnHide = YES;
        [self setHUD:HUD];
    }
    [self HUD].customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
    [self HUD].mode       = MBProgressHUDModeCustomView;
    [self HUD].labelText  = hintString;
    [[self HUD] show:YES];
    [[self HUD] hide:YES afterDelay:1.0];
}

- (void)showViewCompletedHudWithHint:(NSString *) hintString hide:(void (^)())hide {
    if (![self HUD]) {
        UIView *backView;
        if ([self isKindOfClass:[UITableViewController class]]) {
            backView = [UIApplication sharedApplication].keyWindow;
        } else {
            backView = self.view;
        }
        MBProgressHUD *HUD = [self HUD]?:[MBProgressHUD showHUDAddedTo:backView animated:YES];
        HUD.removeFromSuperViewOnHide = YES;
        [self setHUD:HUD];
    }
    [self HUD].customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
    [self HUD].mode       = MBProgressHUDModeCustomView;
    [self HUD].labelText  = hintString;
    [self HUD].removeFromSuperViewOnHide = YES;
    [[self HUD] show:YES];
    [[self HUD] hide:YES afterDelay:.65];
    [self setHUD:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.6*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (hide) {
            hide();
        }
    });
}

- (void)hideHud{
    if ([self HUD]) {
        [[self HUD] hide:YES];
        [self setHUD:nil];
    }
}

@end
