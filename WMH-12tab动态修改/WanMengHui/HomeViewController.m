//
//  HomeViewController.m
//  WanMengHui
//
//  Created by hannchen on 16/8/19.
//  Copyright © 2016年 qing. All rights reserved.
//

#import "HomeViewController.h"
#import "CustomURLCache.h"

@interface HomeViewController ()<UIWebViewDelegate>


@property (nonatomic, strong) UILabel   *titleLb;            // 导航栏lb

@property (nonatomic, strong) UIWebView *webview;

@property (nonatomic, copy)   NSString  *login;  //判断是否登陆


@end

@implementation HomeViewController


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        CustomURLCache *urlCache = [[CustomURLCache alloc]initWithMemoryCapacity:20 * 1024 *1024 diskCapacity:200 * 1024 *1024 diskPath:nil cacheTime:0];
        [CustomURLCache setSharedURLCache:urlCache];
    }
    return self;
}


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
    
    WQNSLog(@"login forkey:-->%@",[defaults objectForKey:@"login"]);
    
    //为o表示第一次打开页面，将default里面的值赋值进去，以后有不同，即表示登陆状态改变，则会进行刷新和重新赋值
    if ([self.login isEqualToString:@"0"]) {
        self.login = [defaults objectForKey:@"login"];
        WQNSLog(@"0000--->%@",self.login);
    } else if (![self.login isEqualToString:[defaults objectForKey:@"login"]]) {
        WQNSLog(@"1111--->%@",self.login);
        self.login = [defaults objectForKey:@"login"];
        [self.webview reload];
    } else WQNSLog(@"2222--->%@",self.login);
}


//可用内存低得时候，调用此方法，释放缓存

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    CustomURLCache *urlCache = (CustomURLCache *)[NSURLCache sharedURLCache];
    [urlCache removeAllCachedResponses];
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
    
    return  YES;
}


#pragma mark -- 网页跳转的时候，显示动画

- (void)webViewDidFinishLoad:(UIWebView *)webView {

    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    self.titleLb.text = title;
    WQNSLog(@"title--->%@",title);
    
    [self hideHud];

    
    [self.webview.scrollView.mj_header endRefreshing];
    
    if (![self.webview canGoBack]){
        self.navigationItem.leftBarButtonItem = [UINavigationBar itemWithImageName:@"button_background" andTarget:self andHighImageName:@"button_background" andAction:@selector(testBtn)];
    }
    else self.navigationItem.leftBarButtonItem = [UINavigationBar itemWithImageName:@"back_arrow" andTarget:self andHighImageName:@"back_arrow" andAction:@selector(backNav)];

}
//
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self hideHud];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self showLoadingHud];
}


#pragma mark - GetterMethod
- (NSString *)login {
    if (!_login) {
        _login = @"0";
    }
    return _login;
}

- (UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
        _titleLb.font = [UIFont boldSystemFontOfSize:16];
        _titleLb.textColor = [UIColor whiteColor];
        _titleLb.textAlignment = NSTextAlignmentCenter;
        _titleLb.text = @"万盟汇创富平台";
        
        
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
