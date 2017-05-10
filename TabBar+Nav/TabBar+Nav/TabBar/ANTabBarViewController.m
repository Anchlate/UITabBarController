
//
//  ANTabBarViewController.m
//  TabBar+Nav
//
//  Created by Qianrun on 17/4/6.
//  Copyright © 2017年 qianrun. All rights reserved.
//

#import "ANTabBarViewController.h"

@interface ANTabBarViewController ()

@end

@implementation ANTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 设置tabBar的背景颜色
//    self.tabBar.barStyle = UIBarStyleBlack;
    //self.tabBar.barStyle = UIBarStyleBlackOpaque;
    
//    self.tabBar.barStyle = UIBarStyleBlackTranslucent;
    
    
    self.tabBar.unselectedItemTintColor = [UIColor redColor];
    self.tabBar.tintColor = [UIColor blackColor];
    
    //self.tabBar.selectionIndicatorImage = [UIImage imageNamed:@"b"];
    self.tabBar.shadowImage = [UIImage imageNamed:@"b"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
