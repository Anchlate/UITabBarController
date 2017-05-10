//
//  Network.h
//  WanMengHui
//
//  Created by hannchen on 16/8/16.
//  Copyright © 2016年 qing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
/**
 *  宏定义请求成功的block
 *
 *  @param response 请求成功返回的数据
 */
typedef void (^WQResponseSuccess)(id data, NSString *content, NSString *status);
//typedef void (^LHResponseSuccess)(NSURLSessionDataTask * task,id responseObject);


/**
 *  宏定义请求失败的block
 *
 *  @param error 报错信息
 */
typedef void (^WQResponseFail)(NSURLSessionDataTask * task, NSError * error);

/**
 *  上传或者下载的进度
 *
 *  @param progress 进度
 */
typedef void (^WQProgress)(NSProgress *progress);

@interface Network : NSObject


// 单例
+ (instancetype)manager;

/*! @author Steven
 *  @brief 监控网络连接
 */
- (void)startMonitor;


/**
 *  普通get方法请求网络数据
 */
+(void)GET:(NSString *)url params:(NSDictionary *)params success:(WQResponseSuccess)success fail:(WQResponseFail)fail;

/**
 *  普通post方法请求网络数据
 */
+(void)POST:(NSString *)url params:(NSDictionary *)params success:(WQResponseSuccess)success fail:(WQResponseFail)fail;

/**
 * 上传图片
 */
+(void)uploadImage:(UIImage *)image success:(WQResponseSuccess)success fail:(WQResponseFail)fail;


@end
