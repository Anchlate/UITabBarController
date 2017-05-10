//
//  RegisterViewController.m
//  WanMengHui
//
//  Created by hannchen on 16/8/18.
//  Copyright © 2016年 qing. All rights reserved.
//

#import "RegisterViewController.h"
#import "LoginRegisterView.h"
#import "ForgetPassWordVC.h"

@interface RegisterViewController ()

@property (nonatomic, strong) UIButton    *registerBtn;    // 注册按钮
@property (nonatomic, strong) UITextField *nameField;      // 姓名文本框
@property (nonatomic, strong) UITextField *passwordField;  // 密码文本框
@property (nonatomic, strong) UITextField *phoneField;     // 手机号文本框
@property (nonatomic, strong) UITextField *refereesField;  // 推荐人手机号
@property (nonatomic, strong) UIButton    *lawBtn;         // 法律
@property (nonatomic, assign) int          lawInt;         // 判断是否法律



@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingUI];
}

- (void)settingUI {
    
    _lawInt = 1;
    
    [self.view setBackgroundColor: UIColorWithHex(0xeeeeee)];
    [self.view addSubview: self.phoneField];
    [self.view addSubview: self.nameField];
    [self.view addSubview: self.passwordField];
    [self.view addSubview: self.registerBtn];
    [self.view addSubview: self.lawBtn];
    [self.view addSubview:self.refereesField];
    
    [_phoneField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(kLoginViewMargin);
        make.right.mas_equalTo(-kLoginViewMargin);
        make.height.mas_equalTo(kLoginViewFieldHeight);
    }];
    [_nameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_phoneField.mas_bottom).offset(15);
        make.left.mas_equalTo(kLoginViewMargin);
        make.right.mas_equalTo(-kLoginViewMargin);
        make.height.mas_equalTo(kLoginViewFieldHeight);
    }];
    [_passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameField.mas_bottom).offset(15);
        make.left.mas_equalTo(kLoginViewMargin);
        make.right.mas_equalTo(-kLoginViewMargin);
        make.height.mas_equalTo(kLoginViewFieldHeight);
    }];
    [_refereesField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_passwordField.mas_bottom).offset(15);
        make.left.mas_equalTo(kLoginViewMargin);
        make.right.mas_equalTo(-kLoginViewMargin);
        make.height.mas_equalTo(kLoginViewFieldHeight);
    }];
    [_lawBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_refereesField.mas_bottom).offset(10);
        make.left.mas_equalTo(kLoginViewMargin);
        make.height.mas_equalTo(kLoginViewFieldHeight);
    }];
    [_registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lawBtn.mas_bottom).offset(15);
        make.left.mas_equalTo(kLoginViewMargin);
        make.right.mas_equalTo(-kLoginViewMargin);
        make.height.mas_equalTo(kLoginViewFieldHeight);
    }];
}



- (void)registerBtnOnClick {
    //判断文本框内信息是否符合要求
    
    if (_phoneField.text.length == 0) {
        [self showHint:PHONE_NONENULL];
        return;
    }
    
    if (_nameField.text.length == 0) {
        [self showHint:USERNAME_NONENULL];
        return;
    }
    

    if (_passwordField.text.length == 0) {
        [self showHint:PASSWORD_NONENULL];
        return;
    }
    
    //检查手机号
    NSString *regex = @"^1[34578]\\d{9}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:self.phoneField.text];
    WQNSLog(@"phone:%@",self.phoneField.text);
    if ( self.phoneField.text.length == 0 || !isMatch) {
        [self showHint:PHONE_CHECK];
        return;
    }
    
    //检查验证码
    
    WQNSLog(@"提交注册");
    if (self.lawInt == 2) {
        [self showHint:@"请同意《用户协议》"];
    } else {
    [self registerNetwork];
    }
}

//注册成功后清除文本框内的内容
- (void)cleanFieldText {
    
    self.phoneField.text    = @"";
    self.passwordField.text = @"";
    self.nameField.text     = @"";
    self.refereesField.text = @"";
    
}

- (void)judgeLaw {
    
    if (_lawInt == 1) {
        _lawInt = 2;
        [_lawBtn setImage:[UIImage imageNamed:@"select_on"] forState:UIControlStateNormal];
    } else if (_lawInt == 2) {
        _lawInt = 1;
        [_lawBtn setImage:[UIImage imageNamed:@"select_off"] forState:UIControlStateNormal];
    } else _lawInt = 1;
    
}
#pragma mark - 注册网络提交
- (void)registerNetwork {
    [self showLoadingHud];
    
    
    NSString *phoneNum    = _phoneField.text;
    NSString *userName    = _nameField.text;
    NSString *password    = _passwordField.text;
    NSString *referees    = _refereesField.text;
    
    NSDictionary *mob = @{@"mobile":phoneNum,@"password":password,@"real_name":userName,@"referral_phone":referees,@"code":@"WMH",@"agreement":@"1",@"type":@"1"};
    WQNSLog(@"mob:%@",mob);
    
    [Network POST:URL_Register params:mob success:^(id data, NSString *content, NSString *status) {
        [self hideHud];
        if ([status isEqualToString:@"400"]) {
            [self showHint:@"注册成功"];
            [self cleanFieldText];
        } else [self showHint:content];
        
        WQNSLog(@"login请求成功");
        WQNSLog(@"data111111:%@",data);
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideHud];
        WQNSLog(@"11111error:%@",error);
    }];
}


#pragma mark -GetterMethod

- (UITextField *)phoneField {
    if (!_phoneField) {
        _phoneField =  [UITextField fieldWithReturnType:UIReturnKeyNext fontSize:15 keyboardType:UIKeyboardTypePhonePad clearButtonMode:UITextFieldViewModeWhileEditing placeHolder:@"请输入手机号" delegate:self];
    }
    return _phoneField;
}

- (UITextField *)nameField {
    if (!_nameField) {
        _nameField =  [UITextField fieldWithReturnType:UIReturnKeyNext fontSize:15 keyboardType:UIKeyboardTypeDefault clearButtonMode:UITextFieldViewModeWhileEditing placeHolder:@"请输入姓名" delegate:self];
    }
    return _nameField;
}

- (UITextField *)refereesField {
    if (!_refereesField) {
        _refereesField =  [UITextField fieldWithReturnType:UIReturnKeyNext fontSize:15 keyboardType:UIKeyboardTypePhonePad clearButtonMode:UITextFieldViewModeWhileEditing placeHolder:@"请输入推荐人手机号" delegate:self];
//        _refereesField.text = @"15918585473";
    }
    return _refereesField;
}

- (UITextField *)passwordField {
    if (!_passwordField) {
        _passwordField =  [UITextField fieldWithReturnType:UIReturnKeyNext fontSize:15 keyboardType:UIKeyboardTypeAlphabet clearButtonMode:UITextFieldViewModeWhileEditing placeHolder:@"请输入密码" delegate:self];
        _passwordField.secureTextEntry = YES;
    }
    return _passwordField;
}



- (UIButton *)registerBtn {
    if (!_registerBtn) {
        _registerBtn = [LoginRegisterView initButtonWithTitle:@"注册" andTitleColor:[UIColor whiteColor]];
        _registerBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        _registerBtn.backgroundColor = UIColorWithHex(0xdc3023);
        [_registerBtn addTarget:self action:@selector(registerBtnOnClick) forControlEvents:UIControlEventTouchDown];
    }
    return _registerBtn;
}


- (UIButton *)lawBtn {
    if (!_lawBtn) {
        _lawBtn = [LoginRegisterView initButtonWithTitle:@"我已看过并同意《用户协议》" andTitleColor:[UIColor blackColor]];
        [_lawBtn setImage:[UIImage imageNamed:@"select_off"] forState:UIControlStateNormal];
        [_lawBtn addTarget:self action:@selector(judgeLaw) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _lawBtn;
}

@end
