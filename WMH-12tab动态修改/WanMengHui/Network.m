//
//  Network.m
//  WanMengHui
//
//  Created by hannchen on 16/8/16.
//  Copyright © 2016年 qing. All rights reserved.
//

#import "Network.h"
#import "MBProgressHUD.h"

@interface Network () <UIAlertViewDelegate>

@end

static NSString *networkBaseUrl = nil;

@implementation Network


#pragma mark -- 单例
static id _instance;
+ (instancetype)manager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}


#pragma mark -- private

+ (AFHTTPSessionManager *)managerrrr
{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.requestSerializer     = [AFHTTPRequestSerializer serializer];
    sessionManager.responseSerializer    = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableLeaves];
    sessionManager.securityPolicy        = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    sessionManager.securityPolicy.validatesDomainName = NO;
    sessionManager.securityPolicy.allowInvalidCertificates = YES;
    
    return sessionManager;
}

#pragma mark -- public

/*! @brief 监控网络连接 */
- (void)startMonitor {
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    // 网络状态改变后的处理
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
                // 未知网络
            case AFNetworkReachabilityStatusUnknown:
                
                break;
                // 手机自带网络
            case AFNetworkReachabilityStatusReachableViaWWAN:
                
                break;
                // WIFI
            case AFNetworkReachabilityStatusReachableViaWiFi:
                
                break;
                // 没有网络(断网)
            case AFNetworkReachabilityStatusNotReachable: {
                UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
                MBProgressHUD *hud  = [MBProgressHUD showHUDAddedTo:keyWindow animated:YES];
                hud.mode      = MBProgressHUDModeText;
                hud.labelText = @"网络连接失败\n请检查手机网络是否正常";
                hud.margin    = 15.f;
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:2.0];
                break;
            }
            default:
                break;
        }
    }];
    [manager startMonitoring];
}

//普通get方法获取数据
+ (void)GET:(NSString *)url params:(NSDictionary *)params success:(WQResponseSuccess)success fail:(WQResponseFail)fail {
    
    AFHTTPSessionManager *sessionManager = [Network managerrrr];
    [sessionManager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *content = responseObject[@"content"]?:@"";
        NSString *status = responseObject[@"status"]?:@"";
        success(responseObject, content, status);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(task,error);
    }];
}

//普通post方法获取数据
+ (void)POST:(NSString *)url params:(NSDictionary *)params success:(WQResponseSuccess)success fail:(WQResponseFail)fail {
    AFHTTPSessionManager *sessionManager = [Network managerrrr];
//    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [sessionManager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *content = responseObject[@"content"]?:@"";
        NSString *status = responseObject[@"status"]?:@"";
        success(responseObject, content, status);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(task,error);
    }];
}


+ (void)uploadImage:(UIImage *)image success:(WQResponseSuccess)success fail:(WQResponseFail)fail {

    NSData *imageData = [Network dataImage:image];
    NSString *imageString = [imageData base64EncodedStringWithOptions:kNilOptions];
    
    AFHTTPSessionManager *sessionManager = [Network managerrrr];
    
    [sessionManager POST:URL_UploadImage parameters:@{@"username":[defaults objectForKey:@"username"], @"image":imageString}  progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *content = responseObject[@"content"]?:@"";
        NSString *status = responseObject[@"status"]?:@"";
        success(responseObject, content, status);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(task,error);

    }];
    
}


+(id)responseConfiguration:(id)responseObject{
    
    NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    return dic;
}


// 序列化图片 （顺便压缩）
+ (NSData *)dataImage:(UIImage *)image {
    
    NSData *imageData = UIImageJPEGRepresentation(image , 1.0);
    NSInteger length = [imageData length]/1024;
    if (length >= 2048) {
        imageData = UIImageJPEGRepresentation(image, 0.15);
    }
    else if (length >= 1024 && length < 2048)
    {
        imageData = UIImageJPEGRepresentation(image , 0.25);
    }
    else if(length >= 512 && length < 1024)
    {
        imageData = UIImageJPEGRepresentation(image , 0.5);
    }
    else if(length >= 300 && length < 512)
    {
        imageData = UIImageJPEGRepresentation(image , 0.8);
    }
    return imageData;
    
}




@end
