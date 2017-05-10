//
//  URLConstant.h
//  WanMengHui
//
//  Created by hannchen on 16/8/19.
//  Copyright © 2016年 qing. All rights reserved.
//

#define URL_BASE @"http://www.wmh18.com/"

// 登录
#define URL_Login          URL_BASE@"/mobile/user.php?"


//美容院系统
#define URL_xitong         URL_BASE@"/mobile/user_mrzx.php"
// 忘记密码
//#define URL_ForgetPassword URL_BASE@"/mobile/user/mi.html"
// 注册
#define URL_Register     URL_BASE@"/api/checkreg.php"
// 登出   type:1(iOS) 2(Android)
#define URL_Exit         URL_BASE@"/api/logout.php?type=1"
//首页(未登录)
#define URL_Page         URL_BASE@"/mobile/app.php?type=1&objective=1"
//测试
#define URL_ceshi        URL_BASE@"/mobile/app.php?"
//上传图片
#define URL_UploadImage  URL_BASE@"/api/appimg.php?act=imageupload"
//关于我们(未登录)
#define URL_ABOUTUS      URL_BASE@"/mobile/app.php?type=1&objective=6"
//我的(未登录)
#define URL_User         URL_BASE@"/mobile/app.php?type=1&objective=5"
//获取验证码
#define URL_Code         URL_BASE@"/mobile/user.php?act=app_zhmm_sms"  //带参数：phone
//匹配验证码
#define URL_CheckCode    URL_BASE@"/mobile/user.php?act=app_checkcode" //参数：phone,code
//重置密码
#define URL_SetPassword  URL_BASE@"/mobile/user.php?act=app_setmm"    //带参数：phone，passwd
