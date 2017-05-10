//
//  userInfoViewController.m
//  WanMengHui
//
//  Created by hannchen on 16/8/26.
//  Copyright © 2016年 qing. All rights reserved.
//

#import "userInfoViewController.h"
#import "AppDelegate.h"
#import "MainViewController.h"
#import "ImagePickerHelper.h"
//#import "CustomURLCache.h"

@interface userInfoViewController () <UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webview;
@property (nonatomic, strong) UILabel *titleLb;            // 导航栏lb
@property (nonatomic, strong) NSURLRequest *request;

@property (nonatomic, strong) ImagePickerHelper *imagePicker;
@property (nonatomic, strong) JSContext *context;  //js交互



@end

@implementation userInfoViewController


/**
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        CustomURLCache *urlCache = [[CustomURLCache alloc]initWithMemoryCapacity:20 * 1024 *1024 diskCapacity:200 * 1024 *1024 diskPath:nil cacheTime:0];
        [CustomURLCache setSharedURLCache:urlCache];
    }
    return self;
}
*/

- (void)viewWillAppear:(BOOL)animated {
    
    self.navigationItem.titleView = self.titleLb;
    self.navigationController.navigationBar.barTintColor = UIColorWithHex(0xdc3023);

    self.navigationItem.leftBarButtonItem = [UINavigationBar itemWithImageName:@"back_arrow" andTarget:self andHighImageName:@"back_arrow" andAction:@selector(backNav)];

    WQNSLog(@"cangoback-----%@",[self.webview canGoBack]?@"Yes":@"No");
    
    [self hideHud];
    [self.view addSubview:self.webview];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self addRefresh];

    self.context[@"goLoginnew"] = self;
    
}

/**
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    CustomURLCache *urlCache = (CustomURLCache *)[NSURLCache sharedURLCache];
    [urlCache removeAllCachedResponses];
}
*/

//刷新模块
- (void)addRefresh {
    
    __weak UIWebView *webview = self.webview;
    webview.delegate = self;
    
    __weak UIScrollView *scrollView = self.webview.scrollView;
    
    //添加下拉刷新
    scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [webview reload];
        WQNSLog(@"1111");
    }];
}


- (void)testBtn {
    WQNSLog(@"好像成功了");
}

- (void)backNav {
    
    WQNSLog(@"返回返回返回");
    [self showLoadingHud];
    if ([self.webview canGoBack]) {
        [self.webview goBack];
    }
    else {
        [self.navigationController popViewControllerAnimated:NO];
        self.navigationController.tabBarController.hidesBottomBarWhenPushed = NO;
        self.navigationController.tabBarController.selectedIndex = 2;
    }

}

- (void)showAlert {
    __weak typeof(self)weakSELF = self;
    //显示弹框alert
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"修改成功" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSELF.webview reload];
        NSLog(@"真他妈神奇，我是天才");
    }]];
    
    dispatch_after(0.2, dispatch_get_main_queue(), ^{
        [weakSELF presentViewController:alert animated:YES completion:nil];
    });
}

- (void)showAlertandNSString:(NSString *)string{
    __weak typeof(self)weakSELF = self;
    //显示弹框alert
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:string preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSELF.webview reload];
        NSLog(@"真他妈神奇，我是天才");
    }]];
    
    dispatch_after(0.2, dispatch_get_main_queue(), ^{
        [weakSELF presentViewController:alert animated:YES completion:nil];
    });

}


#pragma mark - webViewDelegate方法

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    [self viewWillAppear:YES];

    WQNSLog(@"request:%@",request.mainDocumentURL.relativePath);
    
    if ([request.mainDocumentURL.relativePath isEqualToString:@"/mobile/iosym.php"]) {

        [self onclickPick];
        return NO;
    }
    
    
    return YES;
}



#pragma mark -- 网页跳转的时候，显示动画

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    __weak typeof(self)weakSELF = self;

    //下拉结束
    [self.webview.scrollView.mj_header endRefreshing];
    
    [self hideHud];
    
    self.context.exceptionHandler = ^(JSContext *context, JSValue *value){
        context.exception = value;
        WQNSLog(@"value-->%@",value);
    };
    
    //显示alert，确认修改
    self.context[@"showAlertForChange"] = ^(void){
        [weakSELF showAlert];
    };
    
    self.context[@"showMessage"] = ^(NSString *string){
        [weakSELF showAlertandNSString:string];
    };
    
    
    
    //退出登录
    self.context[@"signOut"] = ^(void){
        [defaults setObject:@"2" forKey:@"login"];
        [defaults setObject:@"" forKey:@"username"];
        [defaults setObject:@"" forKey:@"password"];
        
        
        [UIView animateWithDuration:1.5 animations:^{
            [weakSELF showHint:@"已退出登录"];
        }completion:^(BOOL finished) {
            [weakSELF.navigationController popViewControllerAnimated:NO];
            weakSELF.navigationController.tabBarController.hidesBottomBarWhenPushed = NO;
            weakSELF.navigationController.tabBarController.selectedIndex = 2;
        }];
    };
    
    

}


- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self showLoadingHud];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self hideHud];

}

// 跳至登陆页面
- (void)goLogin
{
    [defaults setObject:@"2" forKey:@"login"];
    [defaults setObject:@"" forKey:@"username"];
    [defaults setObject:@"" forKey:@"password"];
    
    [self.navigationController popViewControllerAnimated:NO];
    self.navigationController.tabBarController.hidesBottomBarWhenPushed = NO;
    self.navigationController.tabBarController.selectedIndex = 2;
}

#pragma mark - GetterMethod

- (UIWebView *)webview {
    if (!_webview) {
        _webview = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        
        _webview.opaque = NO;
        _webview.backgroundColor = [UIColor whiteColor];
        NSURL *url;
        
        NSString *username = [defaults objectForKey:@"username"];
        //拼接url请求链接
        NSString *urll = [NSString stringWithFormat:@"%@username=%@&login=1&type=1&objective=5",URL_ceshi, username];
            url = [NSURL URLWithString:urll];
            WQNSLog(@"username%@",[defaults objectForKey:@"username"]);
        
        self.request = [NSURLRequest requestWithURL:url];
        [_webview loadRequest:_request];
        _webview.delegate = self;
        self.context = [self.webview valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    }
    return _webview;
}

- (UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 44)];
        _titleLb.font = [UIFont boldSystemFontOfSize:18];
        _titleLb.textColor = [UIColor whiteColor];
        _titleLb.textAlignment = NSTextAlignmentCenter;
        _titleLb.text = @"我的";
        
    }
    return _titleLb;
}


- (void)onclickPick {
    
    self.imagePicker = [ImagePickerHelper helper];
    [_imagePicker showInViewController:self pickerCompletion:^(UIImage *image) {
        [Network uploadImage:image success:^(id data, NSString *content, NSString *status) {
            
            WQNSLog(@"id-->%@;content-->%@;status-->%@",data,content,status);

            [UIView animateWithDuration:1.5 animations:^{
                [self showHint:content];
            }completion:^(BOOL finished) {
                [self.webview reload];
            }];

        } fail:^(NSURLSessionDataTask *task, NSError *error) {
            [self showHint:@"网络错误"];
        }];
    }];
    
}

@end
