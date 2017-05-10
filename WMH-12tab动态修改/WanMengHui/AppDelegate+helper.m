//
//  AppDelegate+helper.m
//  WanMengHui
//
//  Created by hannchen on 16/8/16.
//  Copyright © 2016年 qing. All rights reserved.
//

#import "AppDelegate+helper.h"
#import "IQKeyboardManager.h"



@implementation AppDelegate (helper)

- (void)basicSetting {

    //设置启动页面时间
    [NSThread sleepForTimeInterval:1.5];

    // 监控网络连接
    [[Network manager] startMonitor];
    
    [Network GET:@"http://threelevel.yun.dodi.cn/mobile/img_update.php" params:nil success:^(id data, NSString *content, NSString *status) {
        WQNSLog(@"sss");
              
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        WQNSLog(@"qqq");
    }];

    // 键盘管理,点击文本框输入时若遮挡住了文本框，则使文本框自动上移
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
    keyboardManager.enable = YES;
    keyboardManager.keyboardDistanceFromTextField = 10;
    keyboardManager.shouldResignOnTouchOutside = YES;
}



@end
