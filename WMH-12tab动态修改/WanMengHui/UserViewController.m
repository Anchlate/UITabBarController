//
//  MenberCenterViewController.m
//  WanMengHui
//
//  Created by hannchen on 16/8/16.
//  Copyright © 2016年 qing. All rights reserved.
//

#import "UserViewController.h"
#import "LoginViewController.h"
#import "LoginRegisteredViewController.h"
#import "userInfoViewController.h"

@interface UserViewController () <UIWebViewDelegate>

@property (nonatomic, copy) NSString *username;
@property (nonatomic, strong) UILabel *titleLb;            // 导航栏lb

@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    
    self.navigationItem.titleView = self.titleLb;
    //隐藏navBar
//    self.navigationController.navigationBarHidden = YES;
    [super viewWillAppear:animated];
    
    self.username = [defaults objectForKey:@"username"];

    [self pushLogin];

}

- (void)pushLogin {
    WQNSLog(@"username:%@", self.username);
    if ([self isBlankString:self.username]) {
        [self.navigationController pushViewController:[[LoginRegisteredViewController alloc] init] animated:NO];
    } else
        [self.navigationController pushViewController:[[userInfoViewController alloc]init] animated:NO];
}



- (UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
        _titleLb.font = [UIFont boldSystemFontOfSize:16];
        _titleLb.textColor = [UIColor whiteColor];
        _titleLb.textAlignment = NSTextAlignmentCenter;
        _titleLb.text = @"我的";
        _titleLb.backgroundColor = [UIColor yellowColor];
        
    }
    return _titleLb;
}



@end
