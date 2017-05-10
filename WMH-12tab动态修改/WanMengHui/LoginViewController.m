//
//  LoginViewController.m
//  WanMengHui
//
//  Created by hannchen on 16/8/16.
//  Copyright © 2016年 qing. All rights reserved.
//

#import "LoginViewController.h"
#import "ForgetPassWordVC.h"

@interface LoginViewController ()

@property (nonatomic, strong) UITextField *accountField; // 账号文本框
@property (nonatomic, strong) UITextField *passwordField;// 密码文本框
@property (nonatomic, strong) UIButton *recordBtn;       // 记录以后是否免登陆
@property (nonatomic, strong) UIButton *loginBtn;        // 登陆按钮
@property (nonatomic, strong) UIButton *forgetPSW;       // 忘记密码
@property (nonatomic, assign) int recordInt;             // 判断是否登录

@end

#import "LoginRegisterView.h"
#import "UserViewController.h"
#import "AppDelegate.h"
#import "MainViewController.h"

@implementation LoginViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self settingUI];
    
}


- (void)settingUI {
    
    [self.view addSubview: self.accountField];
    [self.view addSubview: self.passwordField];
    [self.view addSubview: self.recordBtn];
    [self.view addSubview: self.loginBtn];
    [self.view addSubview: self.forgetPSW];
    
    _recordInt = 1;
    
    [_accountField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(kLoginViewMargin);
        make.right.mas_equalTo(-kLoginViewMargin);
        make.height.mas_equalTo(kLoginViewFieldHeight);
    }];
    
    [_passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_accountField.mas_bottom).offset(15);
        make.left.mas_equalTo(kLoginViewMargin);
        make.right.mas_equalTo(-kLoginViewMargin);
        make.height.mas_equalTo(kLoginViewFieldHeight);
    }];
    
    [_recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_passwordField.mas_bottom).offset(15);
        make.left.mas_equalTo(kLoginViewMargin);
    }];

    
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_recordBtn.mas_bottom).offset(15);
        make.left.mas_equalTo(kLoginViewMargin);
        make.right.mas_equalTo(-kLoginViewMargin);
        make.height.mas_equalTo(kLoginViewFieldHeight);
    }];
    
    [_forgetPSW mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_loginBtn.mas_bottom).offset(10);
        make.left.mas_equalTo(kLoginViewMargin + 20);
        make.height.mas_equalTo(kLoginViewFieldHeight);
    }];
    
}

#pragma mark - login method
- (void)onLogin {
    
    //先判断文本框内是否合理
    if (_accountField.text.length == 0) {
        [self showHint:USERNAME_NONENULL];
        return;
    }
    
    if (_passwordField.text.length == 0) {
        [self showHint:PASSWORD_NONENULL];
        return;
    }
    
    //判断手机号操作 （空闲，等数据库弄好再弄）
    [self loginNetwork];
}

#pragma mark - loginNetwork
- (void)loginNetwork {
    
    NSString *userName = _accountField.text;
    NSString *passWord = _passwordField.text;
    
    NSDictionary *mod = @{@"act":@"app_login",@"username":userName,@"password":passWord,@"code":@"WMH"};

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
//    NSDictionary *pramas = @{@"phone":@"15766228247"};
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:@"http://www.wmh18.com/mobile/user.php?act=app_zhmm_sms" parameters:mod progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"%@", dic);
        
        NSString *sta = dic[@"status"];
        NSString *cont = dic[@"content"];
        
        NSLog(@"——status:%@ —content:%@", sta, cont);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
//    [Network POST:URL_Login params:mod success:^(id data, NSString *content, NSString *status) {
//        
//        WQNSLog(@"login请求成功");
//        WQNSLog(@"data:%@",data);
//        WQNSLog(@"content:%@",content);
//        WQNSLog(@"status:%@",status);
//        
//        if([status isEqualToString:@"400"]){
//            
//            [defaults setObject:userName forKey:@"username"];
//            [defaults setObject:passWord forKey:@"password"];
//            [defaults setObject:@"1" forKey:@"login"];
//            if(_recordInt == 1){
//                [defaults setObject:userName forKey:@"recordusername"];
//                [defaults setObject:passWord forKey:@"recordpassword"];
//            } else {
//                [defaults setObject:@"" forKey:@"recordusername"];
//                [defaults setObject:@"" forKey:@"recordpassword"];
//            }
//            [defaults synchronize];
//            
//            [UIView animateWithDuration:3.0 animations:^{
//                [self showHint:content];
//            }completion:^(BOOL finished) {
//                //重新进入页面
//                [self.navigationController popViewControllerAnimated:NO];
//                self.navigationController.tabBarController.hidesBottomBarWhenPushed = NO;
//                self.navigationController.tabBarController.selectedIndex = 2;
//            }];
//        }
//        else {
//            [self showHint:[NSString stringWithFormat:@"%@请检查账号密码是否输入正确",content]];
//            [defaults setObject:@"" forKey:@"recordpassword"];
//        }
//        
//
//    } fail:^(NSURLSessionDataTask *task, NSError *error) {
//        [self hideHud];
//        WQNSLog(@"error:%@",error);
//    }];
}

- (void)onRecord {
    
    WQNSLog(@"点击记录");
    if (_recordInt == 1) {
        _recordInt = 2;
        [_recordBtn setImage:[UIImage imageNamed:@"select_on"] forState:UIControlStateNormal];
    } else if (_recordInt == 2) {
        _recordInt = 1;
        [_recordBtn setImage:[UIImage imageNamed:@"select_off"] forState:UIControlStateNormal];
    } else _recordInt = 1;
    
}

- (void)onForget {
    WQNSLog(@"密码忘记咯，死咯死咯");
    [self.navigationController pushViewController:[[ForgetPassWordVC alloc]init] animated:NO];
}



#pragma mark -GetterMethod

- (UITextField *)accountField {
    if (!_accountField) {
        _accountField = [UITextField fieldWithReturnType:UIReturnKeyNext fontSize:15 keyboardType:UIKeyboardTypePhonePad clearButtonMode:UITextFieldViewModeWhileEditing placeHolder:@"手机号" delegate:self];
        _accountField.text = [defaults objectForKey:@"recordusername"];
    }
    
    return _accountField;
}

- (UITextField *)passwordField {
    if (!_passwordField) {
        _passwordField = [UITextField fieldWithReturnType:UIReturnKeyNext fontSize:15 keyboardType:UIKeyboardTypeAlphabet clearButtonMode:UITextFieldViewModeWhileEditing placeHolder:@"密码" delegate:self];
        _passwordField.secureTextEntry = YES;
        _passwordField.text = [defaults objectForKey:@"recordpassword"];

    }
    return _passwordField;
}

- (UIButton *)recordBtn {
    if (!_recordBtn) {
        _recordBtn = [LoginRegisterView initButtonWithTitle:@"记住密码" andTitleColor:[UIColor blackColor]];
        _recordBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_recordBtn addTarget:self action:@selector(onRecord) forControlEvents:UIControlEventTouchDown];
        [_recordBtn setImage:[UIImage imageNamed:@"select_off"] forState:UIControlStateNormal];
        
    }
    
    return _recordBtn;
}

- (UIButton *)loginBtn {
    
    if (!_loginBtn) {
        _loginBtn = [LoginRegisterView initButtonWithTitle:@"立即登录" andTitleColor:[UIColor whiteColor]];
        _loginBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        _loginBtn.backgroundColor = UIColorWithHex(0xdc3023);
        [_loginBtn addTarget:self action:@selector(onLogin) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _loginBtn;
    
}

- (UIButton *)forgetPSW {
    if (!_forgetPSW) {
        _forgetPSW = [LoginRegisterView initButtonWithTitle:@"忘记密码" andTitleColor:[UIColor blueColor]];
        _forgetPSW.titleLabel.font = [UIFont systemFontOfSize:16];
        [_forgetPSW addTarget:self action:@selector(onForget) forControlEvents:UIControlEventTouchUpInside];
        _forgetPSW.backgroundColor = [UIColor clearColor];
        [_forgetPSW setAlpha:0.5];
        
    }
    return _forgetPSW;
}


@end
