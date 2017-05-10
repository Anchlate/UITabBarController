//
//  SearchViewController.m
//  WanMengHui
//
//  Created by hannchen on 16/8/19.
//  Copyright © 2016年 qing. All rights reserved.
//

#import "ShopViewController.h"
#import "CustomURLCache.h"


@interface ShopViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UILabel   *titleLb;            // 导航栏lb
@property (nonatomic, strong) UIWebView *webview;
@property (nonatomic, copy)   NSString  *login;

@end

@implementation ShopViewController



- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        CustomURLCache *urlCache = [[CustomURLCache alloc]initWithMemoryCapacity:20 * 1024 *1024 diskCapacity:200 * 1024 *1024 diskPath:nil cacheTime:0];
        [CustomURLCache setSharedURLCache:urlCache];
        WQNSLog(@"12421134");
    }
    return self;
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.webview];
//    [self addRefresh];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.titleView = self.titleLb;
    self.navigationController.navigationBarHidden = NO;
        
    self.navigationController.navigationBar.barTintColor = UIColorWithHex(0xdc3023);
    
    WQNSLog(@"login forkey:-->%@",[defaults objectForKey:@"login"]);
    
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



#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    WQNSLog(@"request----》%@", request.mainDocumentURL.relativePath);
    
    if ([request.mainDocumentURL.relativePath isEqualToString:@"/mobile/flow.php"]) {
        
        self.tabBarController.selectedIndex = 1;
        return NO;
    }
    
//    if ([request.mainDocumentURL.relativePath isEqualToString:@"/mobile/index.php"]) {
//        self.tabBarController.selectedIndex = 0;
//        return NO;
//    }
//
    
    return  YES;
}

#pragma mark -- 网页跳转的时候，显示动画


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [self.webview.scrollView.mj_header endRefreshing];
    
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    self.titleLb.text = title;

    WQNSLog(@"title--->%@",title);
    [self hideHud];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self hideHud];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self showLoadingHud];
}




#pragma mark - GetterMethod
- (UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
        _titleLb.font = [UIFont boldSystemFontOfSize:16];
        _titleLb.textColor = [UIColor whiteColor];
        _titleLb.textAlignment = NSTextAlignmentCenter;
        _titleLb.text = @"关于我们";
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
            url = [NSURL URLWithString:URL_ABOUTUS];
            WQNSLog(@"nonono");
        } else{
            //拼接url请求链接
            NSString *string = [NSString stringWithFormat:@"%@username=%@&login=1&type=1&objective=6",URL_ceshi, [defaults objectForKey:@"username"]];
            WQNSLog(@"string:%@",string);
            url = [NSURL URLWithString:string];
        }
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [_webview loadRequest:request];
        _webview.delegate = self;
    }
    return _webview;
}


@end
