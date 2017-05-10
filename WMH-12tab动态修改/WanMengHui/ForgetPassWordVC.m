//
//  ForgetPassWordVC.m
//  WanMengHui
//
//  Created by hannchen on 2016/11/29.
//  Copyright © 2016年 qing. All rights reserved.
//

#import "ForgetPassWordVC.h"
#import "LoginRegisterView.h"

@interface ForgetPassWordVC ()

@property (nonatomic, strong) UILabel *showLb;
@property (nonatomic, strong) UITextField *phoneField; // 手机号文本框
@property (nonatomic, strong) UITextField *codeField;  // 验证码文本框
@property (nonatomic, strong) UIButton *codeBtn;       // 验证码按钮
@property (nonatomic, strong) UIButton *nextBtn;       // 下一步按钮
@property (nonatomic, strong) NSString *phoneStr;
@property (nonatomic, strong) NSString *codeStr;



@end

@implementation ForgetPassWordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.codeStr = @"";
    self.phoneStr = @"";
    [self settingUI];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItem = [UINavigationBar itemWithImageName:@"back_arrow" andTarget:self andHighImageName:@"back_arrow" andAction:@selector(backNav)];
    self.navigationItem.title =@"找回密码";
}

- (void)settingUI {
    [self.view addSubview:self.showLb];
    [self.view addSubview:self.phoneField];
    [self.view addSubview:self.codeField];
    [self.view addSubview:self.codeBtn];
    [self.view addSubview:self.nextBtn];

    [_showLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(70);
        make.left.mas_equalTo(kLoginViewMargin);
        make.height.mas_equalTo(kLoginViewFieldHeight);
    }];
    
    [_phoneField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_showLb.mas_bottom).offset(15);
        make.left.mas_equalTo(kLoginViewMargin);
        make.right.mas_equalTo(-kLoginViewMargin);
        make.height.mas_equalTo(kLoginViewFieldHeight);
    }];
    
    [_codeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_phoneField.mas_bottom).offset(15);
        make.left.mas_equalTo(@(kLoginViewMargin));
        make.right.mas_equalTo(-(kLoginViewMargin + 100));
        make.height.mas_equalTo(@(kLoginViewFieldHeight));
    }];
    
    
    [_codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_phoneField.mas_bottom).offset(15);
        make.left.equalTo(_codeField.mas_right).offset(0);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(kLoginViewFieldHeight);
    }];
    
    [_nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_codeField.mas_bottom).offset(15);
        make.left.mas_equalTo(kLoginViewMargin);
        make.right.mas_equalTo(-kLoginViewMargin);
        make.height.mas_equalTo(kLoginViewFieldHeight);
    }];
}

//按钮方法

- (void)clickNext {
    WQNSLog(@"213432");
    
}

- (void)clickCode {
    WQNSLog(@"1213");
    //判断文本框内信息是否符合要求
    
    if (_phoneField.text.length == 0) {
        [self showHint:PHONE_NONENULL];
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
    
    [self codeNetwork];
    
    }

//按钮倒计时
- (void)sentPhoneCodeTimeMethod {
    
    //倒计时时间 - 60S
    __block NSInteger timeOut = 59;
    //执行队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //计时器 -》 dispatch_source_set_timer自动生成
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        if (timeOut <= 0) {
            dispatch_source_cancel(timer);
            //主线程设置按钮样式
            dispatch_async(dispatch_get_main_queue(), ^{
                [_codeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
                _codeBtn.backgroundColor = UIColorWithHex(0xdc3023);
                [_codeBtn setUserInteractionEnabled:YES];
            });
        } else {
            //开始计时
            //剩余秒数 seconds
            NSInteger seconds = timeOut % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.1ld", seconds];
            //主线程设置按钮样式
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1.0];
                [_codeBtn setTitle:[NSString stringWithFormat:@"获取成功(%@)",strTime] forState:UIControlStateNormal];
                _codeBtn.backgroundColor = [UIColor grayColor];
                [UIView commitAnimations];
                //计时器件不允许点击
                [_codeBtn setUserInteractionEnabled:NO];
                
            });
            timeOut--;
            
        }
        
    });
    dispatch_resume(timer);
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    NSLog(@"%@",NSStringFromCGRect(self.codeField.frame));
}
#pragma mark - 网络相关
- (void)codeNetwork {
    _phoneStr = self.phoneField.text;
//    NSString *code        = _codeField.text;    // 验证码等待后台数据弄好

    [Network POST:URL_Code params:@{@"phone":_phoneStr} success:^(id data, NSString *content, NSString *status) {
        
        
        WQNSLog(@"%@",content);
        WQNSLog(@"%@",status);
        if ([status isEqualToString:@"1"]) {
            [self showHint:@"验证码发送成功"];
            self.nextBtn.backgroundColor = UIColorWithHex(0xdc3023);
            self.nextBtn.userInteractionEnabled = YES;
            [self sentPhoneCodeTimeMethod];

        } else [self showHint:content];
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self showHint:@"网络错误"];
//        WQNSLog(@"%@",error);
    }];
}

- (void)nextNetwork {
    
}


#pragma mark :  初始化对象

- (UIButton *)codeBtn {
    
    if (!_codeBtn) {
        _codeBtn = [LoginRegisterView initButtonWithTitle:@"发送验证码" andTitleColor:[UIColor whiteColor]];
        _codeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _codeBtn.backgroundColor = UIColorWithHex(0xdc3023);
        [_codeBtn addTarget:self action:@selector(clickCode) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _codeBtn;
    
}
- (UIButton *)nextBtn {
    
    if (!_nextBtn) {
        _nextBtn = [LoginRegisterView initButtonWithTitle:@"下一步" andTitleColor:[UIColor whiteColor]];
        _nextBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        _nextBtn.backgroundColor = [UIColor grayColor];
        _nextBtn.userInteractionEnabled = NO;

        [_nextBtn addTarget:self action:@selector(clickNext) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _nextBtn;
    
}
- (UITextField *)phoneField {
    if (!_phoneField) {
        _phoneField = [UITextField fieldWithReturnType:UIReturnKeyNext fontSize:15 keyboardType:UIKeyboardTypePhonePad clearButtonMode:UITextFieldViewModeWhileEditing placeHolder:@"手机号" delegate:self];
    }
    
    return _phoneField;
}

- (UITextField *)codeField {
    if (!_codeField) {
        _codeField = [UITextField fieldWithReturnType:UIReturnKeyNext fontSize:15 keyboardType:UIKeyboardTypeAlphabet clearButtonMode:UITextFieldViewModeWhileEditing placeHolder:@"验证码" delegate:self];
    }
    
    return _codeField;
}

- (UILabel *)showLb {
    if (!_showLb) {
        _showLb = [LoginRegisterView initLabeWithTitle:FORGET_PASSWORD_SHOW andfont:14 ];
    }
    return _showLb;
}

- (void)backNav {
    [self.navigationController popViewControllerAnimated:NO];
}

@end
