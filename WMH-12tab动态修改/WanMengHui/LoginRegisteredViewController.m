//
//  LoginRegisteredViewController.m
//  WanMengHui
//
//  Created by hannchen on 16/8/17.
//  Copyright © 2016年 qing. All rights reserved.
//

#import "LoginRegisteredViewController.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "LoginRegisterView.h"



@interface LoginRegisteredViewController ()

@property (nonatomic, strong) UILabel *titleLb;          // 导航栏lb
@property (nonatomic, strong) UILabel *showLb;           // 提示lb
@property (nonatomic, strong) UIView *contentview;       // 放置注册和登陆的空间
@property (nonatomic, strong) UIButton *loginButton;     // 登陆切换按钮
@property (nonatomic, strong) UIButton *registerButton;  // 注册切换按钮


@property (nonatomic, strong) LoginViewController *loginVc;

@property (nonatomic, strong) RegisterViewController *registerVc;

@property (nonatomic, strong) UIViewController *currentVc;




@end

@implementation LoginRegisteredViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self settingUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationItem setHidesBackButton:YES];
    self.navigationItem.titleView = self.titleLb;
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barTintColor = UIColorWithHex(0xdc3023);

}

- (void)settingUI {
    
    [self.view addSubview:self.showLb];
    [self.view addSubview:self.contentview];
    [self.view addSubview:self.loginButton];
    [self.view addSubview:self.registerButton];
    [_showLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(70);
        make.left.mas_equalTo(kLoginViewMargin);
        make.height.mas_equalTo(kLoginViewFieldHeight);
    }];
    
    [_registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(70);
        make.right.mas_equalTo(-kLoginViewMargin);
        make.height.mas_equalTo(kLoginViewFieldHeight);
        make.width.mas_equalTo(60);
    }];

    [_loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(70);
        make.right.equalTo(_registerButton.mas_left);
        make.height.mas_equalTo(kLoginViewFieldHeight);
        make.width.mas_equalTo(60);

    }];
    
    [_contentview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(120, 0, 60, 0));
    }];
    
    _loginVc = [[LoginViewController alloc]init];
    [self addChildViewController:_loginVc];
    
    _registerVc = [[RegisterViewController alloc]init];
    [self addChildViewController:_registerVc];
    
    //调整frame
    [self fitFrameforChildViewController:_loginVc];
    [self fitFrameforChildViewController:_registerVc];
    
    [self.contentview addSubview:_loginVc.view];
    
    _currentVc = _loginVc;

}


// 调整控制器的frame
- (void)fitFrameforChildViewController:(UIViewController *)childViewController{
    CGRect frame = self.contentview.frame;
    frame.origin.y = 0;
    childViewController.view.frame = frame;
}

//转换子视图控制器
- (void)transitionFromOldViewController:(UIViewController *)oldViewController toNewViewController:(UIViewController *)newViewController{
    [self transitionFromViewController:oldViewController toViewController:newViewController duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
        if (finished) {
            [newViewController didMoveToParentViewController:self];
            _currentVc = newViewController;
        }else{
            _currentVc = oldViewController;
        }
    }];
}



// 判断并切换loginView到Contentview中
- (void)loginButtonOnClick {
    WQNSLog(@"sdsdsdsd");
    if (_currentVc == _loginVc) return;
    [self fitFrameforChildViewController:_loginVc];
    [self transitionFromOldViewController:_currentVc toNewViewController:_loginVc];
    [_loginButton setBackgroundColor:UIColorWithHex(0xdc3023)];
    [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_registerButton setBackgroundColor:[UIColor clearColor]];
    [_registerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

}

// 判断并切换registerView到Contentview中
- (void)registerButtonOnClick {
    WQNSLog(@"注册注册");
    if (_currentVc == _registerVc) return;
    [self fitFrameforChildViewController:_registerVc];
    [self transitionFromOldViewController:_currentVc toNewViewController:_registerVc];
    [_registerButton setBackgroundColor:UIColorWithHex(0xdc3023)];
    [_registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_loginButton setBackgroundColor:[UIColor clearColor]];
    [_loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
}


#pragma mark -GetterMethod

- (UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
//        _titleLb.backgroundColor = UIColorWithHex(0x8fff0000);
        _titleLb.font = [UIFont boldSystemFontOfSize:20];
        _titleLb.textColor = [UIColor whiteColor];
        _titleLb.textAlignment = NSTextAlignmentCenter;
        _titleLb.text = @"登陆/注册";
        
    }
    return _titleLb;
}

- (UILabel *)showLb {
    if (!_showLb) {
        _showLb = [LoginRegisterView initLabeWithTitle:LOGINPROMPT andfont:14 ];
    }
    return _showLb;
}

- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [LoginRegisterView initButtonWithTitle:@"登陆" andTitleColor:[UIColor whiteColor]];
        [_loginButton setBackgroundColor:UIColorWithHex(0xdc3023)];
        [_loginButton addTarget:self action:@selector(loginButtonOnClick) forControlEvents:UIControlEventTouchDown];
    }
    return _loginButton;
}

- (UIView *)contentview {
    if (!_contentview) {
        _contentview = [[UIView alloc]init];
    }
    return _contentview;
}


- (UIButton *)registerButton {
    if (!_registerButton) {
        _registerButton = [LoginRegisterView initButtonWithTitle:@"注册" andTitleColor:[UIColor blackColor]];
        [_registerButton addTarget:self action:@selector(registerButtonOnClick) forControlEvents:UIControlEventTouchDown];
    }
    return _registerButton;
}

@end
