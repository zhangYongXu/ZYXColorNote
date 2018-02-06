//
//  UserViewModel.h
//  LuNengHotel
//
//  Created by 极客天地 on 16/10/24.
//  Copyright © 2016年 极客天地. All rights reserved.
//
typedef NS_ENUM(NSInteger,UserViewModelLoginStates){
    UserViewModelLoginStatesLogout = 0,
    UserViewModelLoginStatesLogin = 1
};

#import "UserModel.h"

#import "GWRootViewModel.h"

//#import "UMSocialSnsPlatformManager.h"
//#import "UMSocialAccountManager.h"

@interface UserViewModel : GWRootViewModel
@property (strong,nonatomic) UserModel * localCacheUserModel;
@property (assign,nonatomic) UserViewModelLoginStates userLoginState;
@property (nonatomic, copy) NSString *socialLoginPlatformName;

@property (nonatomic, copy) NSString *verifyCode;//当前验证码
@property (nonatomic, copy) NSString *verifyCode_msgID;//验证验证码msgid
@property (nonatomic, assign) BOOL isHasVerfy;//是否已经验证过


/**
 *  请求服务器获取验证码
 *
 *  @param phoneNumber  手机号
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */
-(void)requestGetVerifyCodeWithPhoneNumber:(NSString*)phoneNumber SuccessBlock:(YXSuccessBlock)successBlock FaildBlock:(YXFaildBlock)faildBlock;
/**
 *  请求服务器验证短信验证码是否正确
 *
 *  @param verifyCode   验证码
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */
-(void)requestValidateVerifyCode:(NSString*)verifyCode SuccessBlock:(YXSuccessBlock)successBlock FaildBlock:(YXFaildBlock)faildBlock;
/**
 *  请求服务器用户注册
 *
 *  @param userModel    用户模型
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */

-(void)requestUserRegisterWithUserModel:(UserModel *)userModel SuccessBlock:(YXSuccessBlock)successBlock FaildBlock:(YXFaildBlock)faildBlock;

/**
 *  请求服务器用户登录
 *
 *  @param userModel    用户模型
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */
-(void)requestUserLoginWithUserModel:(UserModel *)userModel SuccessBlock:(YXSuccessBlock)successBlock FaildBlock:(YXFaildBlock)faildBlock;
/**
 *  请求头像地址 根据手机号
 *
 *  @param phoneNumber  手机号
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */
-(void)requestHeaderImageUrlWithPhoneNumber:(NSString*)phoneNumber SuccessBlock:(YXSuccessBlock)successBlock FaildBlock:(YXFaildBlock)faildBlock;
/**
 *  请求用户信息
 *
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */
-(void)requestGetUserInfoWithSuccessBlock:(YXSuccessBlock)successBlock FaildBlock:(YXFaildBlock)faildBlock;
/**
 *  修改用户信息
 *
 *  @param userModel    用户模型
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */

-(void)requestUpdateUserInfoWithUserModel:(UserModel*)userModel SuccessBlock:(YXSuccessBlock)successBlock FaildBlock:(YXFaildBlock)faildBlock;

/**
 *  修改头像
 *
 *  @param image        头像图片
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */
-(void)requestUpdateUserHeadWithImage:(UIImage*)image SuccessBlock:(YXSuccessBlock)successBlock FaildBlock:(YXFaildBlock)faildBlock;

/**
 *  请求服务器找回密码
 *
 *  @param userModel    用户模型
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */

-(void)requestGetBackPasswordWithUserModel:(UserModel *)userModel SuccessBlock:(YXSuccessBlock)successBlock FaildBlock:(YXFaildBlock)faildBlock;

/**
 *  第三方登录
 *
 *  @param vc           控制器
 *  @param platformType 第三方登录类型
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */
-(void)socialLoginInVC:(UIViewController*)vc PlatformType:(NSString*)platformType  SuccessBlock:(YXSuccessBlock)successBlock FaildBlock:(YXFaildBlock)faildBlock;

/**
 *  判断第三方登录是否有效
 */
//-(void)judgeSocialLoginAndTip;


/**
 *  请求 上传推送clientID
 *
 *  @param clientID     推送clientID
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */
+(void)requestUploadUserClientID:(NSString*)clientID SuccessBlock:(YXSuccessBlock)successBlock FaildBlock:(YXFaildBlock)faildBlock;
/**
 *  请求 移除推送clientID
 *
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */
+(void)requestRemoveUserClientIDWithSuccessBlock:(YXSuccessBlock)successBlock FaildBlock:(YXFaildBlock)faildBlock;

/**
 *  请求手机号判断该手机号是否已经注册过
 *
 *  @param phoneNumber  手机号
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */
-(void)requestJudgeHasRegisteredWithPhoneNumber:(NSString*)phoneNumber SuccessBlock:(YXSuccessBlock)successBlock FaildBlock:(YXFaildBlock)faildBlock;
/**
 *  请求根据微信OpenID和手机号、密码绑定第三方微信登录
 *
 *  @param openId       第三方微信OpenID
 *  @param accessToken  第三方微信accessToken
 *  @param phoneNumber  手机号
 *  @param password     密码,如果手机号已经注册过就传空
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */
-(void)requestWeiXinBoundLoginWithOpenID:(NSString*)openId AccessToken:(NSString*)accessToken PhoneNumber:(NSString*)phoneNumber Password:(NSString * )password SuccessBlock:(YXSuccessBlock)successBlock FaildBlock:(YXFaildBlock)faildBlock;
/**
 *  请求根据微信code判断是否已经存在系统中
 *
 *  @param code       第三方微信code
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */
-(void)requestJudgeWeiXinLoginWithCode:(NSString*)code SuccessBlock:(YXSuccessBlock)successBlock FaildBlock:(YXFaildBlock)faildBlock;
@end
