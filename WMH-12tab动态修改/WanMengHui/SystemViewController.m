//
//  SystemViewController.m
//  WanMengHui
//
//  Created by hannchen on 16/8/30.
//  Copyright © 2016年 qing. All rights reserved.
//

#import "SystemViewController.h"

@interface SystemViewController ()<UIWebViewDelegate>


@property (nonatomic, strong) UILabel *titleLb;            // 导航栏lb

@property (nonatomic, strong) UIWebView *webview;


@end

@implementation SystemViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view = self.webview;
//    [self addRefresh];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.titleView = self.titleLb;
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barTintColor = UIColorWithHex(0xdc3023);
    self.navigationItem.leftBarButtonItem = [UINavigationBar itemWithImageName:@"button_background" andTarget:self andHighImageName:@"button_background" andAction:@selector(testBtn)];
}

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
    [self.webview goBack];
}



#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    WQNSLog(@"request----》%@", request.mainDocumentURL.relativePath);
    
    if ([request.mainDocumentURL.relativePath isEqualToString:@"/mobile/flow.php"]) {
        self.tabBarController.selectedIndex = 1;
        return NO;
    }
    
    //    if ([request.mainDocumentURL.relativePath isEqualToString:@"/mobile/category.php"]) {
    //        self.tabBarController.selectedIndex = 1;
    //        return NO;
    //    }
    
    
    return  YES;
}

#pragma mark -- 网页跳转的时候，显示动画

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    self.titleLb.text = title;
    WQNSLog(@"title--->%@",title);
    
    
    [self.webview.scrollView.mj_header endRefreshing];
    
    if (![self.webview canGoBack]){
        self.navigationItem.leftBarButtonItem = [UINavigationBar itemWithImageName:@"button_background" andTarget:self andHighImageName:@"button_background" andAction:@selector(testBtn)];
    }
    else self.navigationItem.leftBarButtonItem = [UINavigationBar itemWithImageName:@"back_arrow" andTarget:self andHighImageName:@"back_arrow" andAction:@selector(backNav)];
    
}



#pragma mark - GetterMethod
- (UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 180, 44)];
        _titleLb.font = [UIFont boldSystemFontOfSize:16];
        _titleLb.textColor = [UIColor whiteColor];
        _titleLb.textAlignment = NSTextAlignmentCenter;
        _titleLb.text = @"万盟汇创富平台";
//        _titleLb.backgroundColor = [UIColor yellowColor];
        
    }
    return _titleLb;
}


- (UIWebView *)webview {
    if (!_webview) {
        _webview = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        
        _webview.opaque = NO;
        _webview.backgroundColor = [UIColor whiteColor];
        NSURL *url;
        NSString *username = [defaults objectForKey:@"username"];
        if ([self isBlankString:username]) {
            url = [NSURL URLWithString:URL_Page];
            WQNSLog(@"nonono");
        } else{
            
            //拼接url请求链接
            NSString *urll = [NSString stringWithFormat:@"%@username=%@&login=1&type=1&objective=1",URL_ceshi, [defaults objectForKey:@"username"]];
            url = [NSURL URLWithString:urll];
            WQNSLog(@"username%@",[defaults objectForKey:@"username"]);
        }
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [_webview loadRequest:request];
        _webview.delegate = self;
    }
    return _webview;
}


@end
