//
//  MainViewController.m
//  WanMengHui
//
//  Created by hannchen on 16/8/16.
//  Copyright © 2016年 qing. All rights reserved.
//

#import "MainViewController.h"
#import "UserViewController.h"
#import "HomeViewController.h"
#import "ShopViewController.h"
#import "SystemViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingViewController];

//    self.view.backgroundColor = [UIColor yellowColor];
}


- (void)settingViewController {
    UIViewController *page3 = [self addChildViewController:[[SystemViewController alloc]init] andTitle:TAB_ITEMNAME2 andImage:@"tab_two_normal" andSelectedImage:@"tab_two_press"];
    UIViewController *page1 = [self addChildViewController:[[HomeViewController alloc]init] andTitle:TAB_ITEMNAME0 andImage:@"tab_one_normal" andSelectedImage:@"tab_one_press"];
    UIViewController *page2 = [self addChildViewController:[[UserViewController alloc]init] andTitle:TAB_ITEMNAME1 andImage:@"tab_two_normal" andSelectedImage:@"tab_two_press"];
    UIViewController *page4 = [self addChildViewController:[[ShopViewController alloc]init] andTitle:TAB_ITEMNAME3 andImage:@"tab_three_normal" andSelectedImage:@"tab_three_press"];
    
    self.viewControllers = @[page1, page2, page4];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (UIViewController *)addChildViewController:(UIViewController *)childVC andTitle:(NSString *)title andImage:(NSString *)image andSelectedImage:(NSString *)selectedImage {
    
    childVC.title = title;
    
    childVC.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAutomatic];
    
    childVC.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    BaseNavigationViewController *navigationVC = [[BaseNavigationViewController alloc] initWithRootViewController:childVC];
    return navigationVC;
    WQNSLog(@"%@===%@++++%@",title,childVC.tabBarItem.image,childVC.tabBarItem.selectedImage);
}



@end
