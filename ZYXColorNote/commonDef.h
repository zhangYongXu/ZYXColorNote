//
//  commonDef.h
//  ZYXColorNote
//
//  Created by 极客天地 on 2018/2/5.
//  Copyright © 2018年 极客天地. All rights reserved.
//

#ifndef commonDef_h
#define commonDef_h


#endif /* commonDef_h */


#define SystemStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height //状态栏高度

#define SystemTabBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49) //底部tabbar高度
#define SystemNavBarHeight (SystemStatusBarHeight + 44.0) //整个导航栏高度

/**
 *  登录
 *
 */
/*
 userpwd   2323
 username  15801347041
 */
#define user_login @"login"

/**
 *  请求 头像地址根据手机号
 */
#define user_showUserPortrait @"showUserPortrait"
/**
 *  请求验证码
 * phone
 */
#define user_sendPhoneMessage @"sendPhoneVerifyCode"
/**
 *  验证手机验证码
 * phone,verificationcode
 */
#define user_verificationPhone @"verificationCode"
/**
 *  查询个人信息
 *  id
 */
#define user_displayUserDetails @"displayUserDetails"
/**
 *  修改用户信息
 *
 */

#define user_completeUserDetails @"completeUserDetails"
/**
 *  修改用户头像
 *
 */

#define user_completeUserHeadImg @"completeUserHeadImg"


/**
 *  修改密码
 *
 */
#define member_modifypwd @"member/modifypwd"

/**
 *  找回密码
 *
 */
#define user_forgetPwd @"forgetPwd"
