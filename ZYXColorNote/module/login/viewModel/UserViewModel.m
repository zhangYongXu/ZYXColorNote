//
//  UserViewModel.m
//  LuNengHotel
//
//  Created by 拓之林 on 16/3/28.
//  Copyright © 2016年 拓之林. All rights reserved.
//

#import "UserViewModel.h"

//#import "WeiXinLoginHandler.h"

#import "YXMaskProgressView.h"

#define localCacheUserModelKey @"localCacheUserModelKey"
#define userLoginStateKey @"userLoginStateKey"
#define socialLoginPlatformNameKey @"socialLoginPlatformNameKey"
@interface UserViewModel()
//@property(strong,nonatomic) YXMaskProgressView * progressViewMask;
@end
@implementation UserViewModel
@synthesize localCacheUserModel = _localCacheUserModel;
@synthesize userLoginState = _userLoginState;
@synthesize socialLoginPlatformName = _socialLoginPlatformName;

/**
 *  获取本地缓存的登录的用户信息
 *
 *  @return 用户信息
 */
-(UserModel *)localCacheUserModel{
    if(nil == _localCacheUserModel){
        NSUserDefaults * UD = [NSUserDefaults standardUserDefaults];
        NSDictionary * dict = [UD objectForKey:localCacheUserModelKey];
        _localCacheUserModel = [[UserModel alloc] init];
        [_localCacheUserModel setValuesForKeysWithDictionary:dict];
    }
    return _localCacheUserModel;
}
/**
 *  缓存登录的用户信息到本地
 *
 *  @param localCacheUserModel 登录用户信息
 */
-(void)setLocalCacheUserModel:(UserModel *)localCacheUserModel{
    _localCacheUserModel = localCacheUserModel;
    NSUserDefaults * UD = [NSUserDefaults standardUserDefaults];
    
    UserModel * model = [_localCacheUserModel copy];
    
    NSDictionary * dict = [model propertyList:YES];
    [UD setObject:dict forKey:localCacheUserModelKey];
    [UD synchronize];
}
/**
 *  获取用户是否登录
 *
 *  @return 登录状态
 */
-(UserViewModelLoginStates)userLoginState{
    NSUserDefaults * UD = [NSUserDefaults standardUserDefaults];
    NSString * strValue = [UD objectForKey:userLoginStateKey];
    _userLoginState = [strValue integerValue];
    return _userLoginState;
}
/**
 *  将登录状态写到本地
 *
 *  @param userLoginState 登录状态
 */
-(void)setUserLoginState:(UserViewModelLoginStates)userLoginState{
    _userLoginState = userLoginState;
    NSUserDefaults * UD = [NSUserDefaults standardUserDefaults];
    NSString * strValue = [NSString stringWithFormat:@"%@",@(_userLoginState)];
    [UD setObject:strValue forKey:userLoginStateKey];
    [UD synchronize];
}

-(void)setSocialLoginPlatformName:(NSString *)socialLoginPlatformName{
    _socialLoginPlatformName = socialLoginPlatformName;
    NSUserDefaults * UD = [NSUserDefaults standardUserDefaults];
    [UD setObject:_socialLoginPlatformName forKey:socialLoginPlatformNameKey];
    [UD synchronize];
}
-(NSString *)socialLoginPlatformName{
    NSUserDefaults * UD = [NSUserDefaults standardUserDefaults];
    _socialLoginPlatformName = [UD objectForKey:socialLoginPlatformNameKey];
    return _socialLoginPlatformName;
}





/**
 *  请求服务器获取验证码
 *
 *  @param phoneNumber  手机号
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */
-(void)requestGetVerifyCodeWithPhoneNumber:(NSString*)phoneNumber SuccessBlock:(YXSuccessBlock)successBlock FaildBlock:(YXFaildBlock)faildBlock{
    //测试
    ///*
    [SVProgressHUD showWithStatus:nil maskType:SVProgressHUDMaskTypeGradient];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if(successBlock){
                successBlock(@"");
            }
            [SVProgressHUD dismiss];
        });
    });
    //*/
    /*
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [params setValue:@"iOS" forKey:@"from"];
    [params setValue:phoneNumber forKey:@"user_name"];
    
    
    NSDictionary * singParmas = [YXNetWork globalSignParamsWithPrames:params];
    
    NSLog(@"requestGetVerifyCodeWithPhoneNumber jsonParmas:%@",[NSString jsonStringWithDictionary:singParmas]);
    
    [YXNetWork postHttp:user_sendPhoneMessage parameters:singParmas showProgress:YES sucess:^(id responseObj) {
        NSLog(@"requestGetVerifyCodeWithPhoneNumber responseObj Json:%@",[NSString jsonStringWithDictionary:responseObj]);
        NSDictionary * resultDict = [responseObj objectForKey:@"result"];
        NSDictionary * errorDict = resultDict[@"error"];
        NSString * msg_id = resultDict[@"msg_id"];
        self.verifyCode_msgID = msg_id;
        if(DICTIONARY_IS_EMPTY(errorDict) && msg_id){
            if(successBlock){
                successBlock(responseObj);
            }
        }else{
            NSString * message = [errorDict objectForKey:@"message"];
            if(faildBlock){
                faildBlock(message);
            }
            [SVProgressHUD showErrorWithStatus:message];
        }
    } failed:^(NSString *errorMsg) {
        NSLog(@"requestGetVerifyCodeWithPhoneNumber errorMsg:%@",errorMsg);
        if(faildBlock){
            faildBlock(errorMsg);
        }
    }];
     */
}

/**
 *  请求服务器验证短信验证码是否正确
 *
 *  @param verifyCode   验证码
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */
-(void)requestValidateVerifyCode:(NSString*)verifyCode SuccessBlock:(YXSuccessBlock)successBlock FaildBlock:(YXFaildBlock)faildBlock{
    if([self.verifyCode isEqualToString:verifyCode] && self.isHasVerfy){
        if(successBlock){
            successBlock(nil);
        }
        return;
    }
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [params setValue:@"iOS" forKey:@"from"];
    [params setValue:self.verifyCode_msgID forKey:@"msg_id"];
    [params setValue:verifyCode forKey:@"verifycode"];
    
    NSDictionary * singParmas = [YXNetWork globalSignParamsWithPrames:params];
    
    NSLog(@"requestValidateVerifyCodeWithPhoneNumber jsonParmas:%@",[NSString jsonStringWithDictionary:singParmas]);
    
    [YXNetWork postHttp:user_verificationPhone parameters:singParmas showProgress:YES sucess:^(id responseObj) {
        NSLog(@"requestValidateVerifyCodeWithPhoneNumber responseObj Json:%@",[NSString jsonStringWithDictionary:responseObj]);
        NSDictionary * resultDict = [responseObj objectForKey:@"result"];
        NSDictionary * errorDict = resultDict[@"error"];
        BOOL is_valid = resultDict[@"is_valid"];
        
        if(is_valid && DICTIONARY_IS_EMPTY(errorDict)){
            if(successBlock){
                successBlock(responseObj);
            }
            self.verifyCode = verifyCode;
            self.isHasVerfy = YES;
        }else{
            NSString * message = @"验证码验证失败";
            if(faildBlock){
                faildBlock(message);
            }
            [SVProgressHUD showErrorWithStatus:message];
        }
    } failed:^(NSString *errorMsg) {
        NSLog(@"requestValidateVerifyCodeWithPhoneNumber errorMsg:%@",errorMsg);
        if(faildBlock){
            faildBlock(errorMsg);
        }
    }];
}

/**
 *  请求服务器用户注册
 *
 *  @param userModel    用户模型
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */

-(void)requestUserRegisterWithUserModel:(UserModel *)userModel SuccessBlock:(YXSuccessBlock)successBlock FaildBlock:(YXFaildBlock)faildBlock{

    NSString * user_name = STR_IS_NIL(userModel.user_name)?@"":userModel.user_name;
    NSString * phone = STR_IS_NIL(userModel.phone)?@"":userModel.phone;
    if(STR_IS_NIL(phone)){
        phone = user_name;
    }
    NSString * user_pwd = STR_IS_NIL(userModel.user_pwd)?@"":userModel.user_pwd;
    
    NSString * bql = [NSString stringWithFormat:@"select * from LayoutUserModel where user_name = '%@' or phone = '%@'",user_name,phone];
    
    [BmobHttpApiGet getDataWithBql:bql showProgress:YES sucess:^(NSArray *array) {
        if(!ARRAY_IS_EMPTY(array)){
            NSString * message =@"用户已注册过，请直接登录";
            [SVProgressHUD showSuccessWithStatus:message];
        }else{
            BmobHttpApiAddItem * item = [[BmobHttpApiAddItem alloc] init];
            item.tableName = @"LayoutUserModel";
            item.dataDict = @{@"user_name":user_name,@"phone":phone,@"user_pwd":user_pwd};
            [BmobHttpApiPost addDataWithBmobHttpApiAddItem:item showProgress:YES sucess:^(NSDictionary *dictionary) {
                NSLog(@"requestUserRegisterWithUserModel dictionary:%@",dictionary);
                if(successBlock){
                    successBlock(dictionary);
                }
            } failed:^(NSString *errorMsg) {
                NSLog(@"requestUserRegisterWithUserModel errorMsg:%@",errorMsg);
                if(faildBlock){
                    faildBlock(errorMsg);
                }
            }];
        }
        
    } failed:^(NSString *errorMsg) {
        NSLog(@"requestUserRegisterWithUserModel errorMsg:%@",errorMsg);
        if(faildBlock){
            faildBlock(errorMsg);
        }
    }];
}


/**
 *  请求服务器用户登录
 *
 *  @param userModel    用户模型
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */
-(void)requestUserLoginWithUserModel:(UserModel *)userModel SuccessBlock:(YXSuccessBlock)successBlock FaildBlock:(YXFaildBlock)faildBlock{
    
    NSString * user_name = STR_IS_NIL(userModel.user_name)?@"":userModel.user_name;
    NSString * phone = STR_IS_NIL(userModel.phone)?@"":userModel.phone;
    NSString * user_pwd = STR_IS_NIL(userModel.user_pwd)?@"":userModel.user_pwd;
    
    NSString * bql = [NSString stringWithFormat:@"select * from LayoutUserModel where user_name = '%@' or phone = '%@'",user_name,phone];
    NSLog(@"requestUserLoginWithUserModel bql:%@",bql);
    [BmobHttpApiGet getDataWithBql:bql showProgress:YES sucess:^(NSArray *array) {
        NSString * message = nil;
        if(!ARRAY_IS_EMPTY(array)){
            NSDictionary * dataDict = array.firstObject;
            NSString * existPwd = dataDict[@"user_pwd"];
            if([existPwd isEqualToString:user_pwd]){
                message = @"登录成功";
                UserModel * loginUserModel = [[UserModel alloc] initWithDictionary:dataDict];
                loginUserModel.phone = userModel.phone;
                loginUserModel.user_pwd = userModel.user_pwd;
                APPDelegate.userViewModel.localCacheUserModel = loginUserModel;
                APPDelegate.userViewModel.userLoginState = UserViewModelLoginStatesLogin;
                if(successBlock){
                    successBlock(array);
                }
            }else{
                message = @"密码错误";
                if(faildBlock){
                    faildBlock(message);
                }
            }
            
        }else{
            message = @"用户名错误";
            if(faildBlock){
                faildBlock(message);
            }
        }
        NSLog(@"requestUserLoginWithUserModel %@ array:%@",message,array);
        [SVProgressHUD showSuccessWithStatus:message];
    } failed:^(NSString *errorMsg) {
        NSLog(@"requestUserLoginWithUserModel errorMsg:%@",errorMsg);
        if(faildBlock){
            faildBlock(errorMsg);
        }
    }];
}

/**
 *  请求头像地址 根据手机号
 *
 *  @param phoneNumber  手机号
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */
-(void)requestHeaderImageUrlWithPhoneNumber:(NSString*)phoneNumber SuccessBlock:(YXSuccessBlock)successBlock FaildBlock:(YXFaildBlock)faildBlock{

    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [params setValue:@"iOS" forKey:@"from"];
    [params setValue:phoneNumber forKey:@"user_name"];
    
    
    NSDictionary * singParmas = [YXNetWork globalSignParamsWithPrames:params];
    
    NSLog(@"requestHeaderImageUrlWithPhoneNumber jsonParmas:%@",[NSString jsonStringWithDictionary:singParmas]);
    
    [YXNetWork postHttp:user_showUserPortrait parameters:singParmas showProgress:YES sucess:^(id responseObj) {
        NSLog(@"requestHeaderImageUrlWithPhoneNumber responseObj Json:%@",[NSString jsonStringWithDictionary:responseObj]);
        NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
        NSString * message = [responseObj objectForKey:@"message"];
        NSDictionary * resultDict = [responseObj objectForKey:@"result"];
       
        if(1 == code){
            NSString *  img_url = resultDict[@"img_url"];
            if(successBlock){
                successBlock(img_url);
            }
        }else{
            if(faildBlock){
                faildBlock(message);
            }
            [SVProgressHUD showErrorWithStatus:message];
        }
    } failed:^(NSString *errorMsg) {
        NSLog(@"requestHeaderImageUrlWithPhoneNumber errorMsg:%@",errorMsg);
        if(faildBlock){
            faildBlock(errorMsg);
        }
    }];
}
/**
 *  请求用户信息
 *
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */
-(void)requestGetUserInfoWithSuccessBlock:(YXSuccessBlock)successBlock FaildBlock:(YXFaildBlock)faildBlock{
    
    if(!APPDelegate.isUserHasLogin){
        return;
    }
    
    NSString * userObjectId = APPDelegate.userViewModel.localCacheUserModel.objectId;
    NSString * bql = [NSString stringWithFormat:@"select * from LayoutUserModel where objectId = '%@'",userObjectId];
    [BmobHttpApiGet getDataWithBql:bql showProgress:NO sucess:^(NSArray *array) {
        NSLog(@"requestGetUserInfoWithSuccessBlock array:%@",array);
        if(!ARRAY_IS_EMPTY(array)){
            NSDictionary * dataDict = array.firstObject;
            UserModel * userModel = APPDelegate.userViewModel.localCacheUserModel;
            [userModel setValuesForKeysWithDictionary:dataDict];
            APPDelegate.userViewModel.localCacheUserModel = userModel;
            
            if(successBlock){
                successBlock(dataDict);
            }
        }else{
            if(faildBlock){
                NSString * message = @"查询用户信息失败";
                faildBlock(message);
            }
        }
    } failed:^(NSString *errorMsg) {
        NSLog(@"requestGetUserInfoWithSuccessBlock errorMsg:%@",errorMsg);
        if(faildBlock){
            faildBlock(errorMsg);
        }
    }];
}
/**
 *  修改用户信息
 *
 *  @param userModel    用户模型
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */

-(void)requestUpdateUserInfoWithUserModel:(UserModel*)userModel SuccessBlock:(YXSuccessBlock)successBlock FaildBlock:(YXFaildBlock)faildBlock{

    NSString * nick_name = userModel.nick_name;
    NSNumber * sex = @(userModel.sex);
    NSString * birthDay = userModel.birthday;
    NSNumber * education = @(userModel.education);
    NSString * trade = STR_IS_NIL(userModel.trade)?@"":userModel.trade;
    NSString * interest = STR_IS_NIL(userModel.interest)?@"":userModel.interest;;
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];

    [params setValue:nick_name forKey:@"nick_name"];
    [params setValue:sex forKey:@"sex"];
    [params setValue:birthDay forKey:@"birthday"];
    [params setValue:education forKey:@"education"];
    [params setValue:trade forKey:@"trade"];
    [params setValue:interest forKey:@"interest"];

    NSString * userObjectId = APPDelegate.userViewModel.localCacheUserModel.objectId;
    BmobHttpApiUpdateItem * item = [[BmobHttpApiUpdateItem alloc] init];
    item.tableName = @"LayoutUserModel";
    item.objectId = userObjectId;
    item.updateDataDict = params;
    
    [BmobHttpApiPut updateDataWithBmobHttpApiUpdateItem:item showProgress:YES sucess:^(NSDictionary *dictionary) {
        APPDelegate.userViewModel.localCacheUserModel = userModel;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Name_UserChangeBaseInfo object:nil];
        if(successBlock){
            successBlock(userModel);
        }
        [SVProgressHUD showSuccessWithStatus:@"修改成功"];
    } failed:^(NSString *errorMsg) {
        NSLog(@"requestUpdateUserInfoWithUserModel errorMsg:%@",errorMsg);
        if(faildBlock){
            faildBlock(errorMsg);
        }
    }];
    
   
}


/**
 *  修改头像
 *
 *  @param image        头像图片
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */
-(void)requestUpdateUserHeadWithImage:(UIImage*)image SuccessBlock:(YXSuccessBlock)successBlock FaildBlock:(YXFaildBlock)faildBlock{
    
    
    [SVProgressHUD showWithStatus:@"上传中..."];
    NSString * name = [NSString stringWithFormat:@"layoutUserHeaderImage_%@.png",@([[NSDate date] timeIntervalSince1970])];
    [BmobHttpApiFile uploadImage:image imageFileName:name showProgress:NO ProgressBlock:^(CGFloat progress) {
        NSLog(@"requestUpdateUserHeadWithImage:%.2f",progress);
    } sucess:^(BmobFile *bmobFile) {
        NSString * userObjectId = APPDelegate.userViewModel.localCacheUserModel.objectId;
        BmobHttpApiUpdateItem *item = [[BmobHttpApiUpdateItem alloc] init];
        item.tableName = @"LayoutUserModel";
        item.objectId = userObjectId;
        item.updateDataDict = @{
                                    @"headerImageUrl":@{
                                            @"__type":@"File",
                                            @"filename":bmobFile.name,
                                            @"url":bmobFile.url
                                    }
                                };
        [BmobHttpApiPut updateDataWithBmobHttpApiUpdateItem:item showProgress:NO sucess:^(NSDictionary *dictionary) {
            NSString * img_url = bmobFile.url;
            UserModel * userModel = APPDelegate.userViewModel.localCacheUserModel;
            userModel.img_url = img_url;
            APPDelegate.userViewModel.localCacheUserModel = userModel;
            
            if(successBlock){
                successBlock(dictionary);
            }
            [SVProgressHUD showSuccessWithStatus:@"上传头像成功"];
        } failed:^(NSString *errorMsg) {
            NSLog(@"requestUpdateUserHeadWithImage errorMsg:%@",errorMsg);
            [SVProgressHUD showErrorWithStatus:@"上传头像更新数据失败,请检查网络"];
        }];
    } failed:^(NSString *errorMsg) {
        NSLog(@"requestUpdateUserHeadWithImage errorMsg:%@",errorMsg);
        [SVProgressHUD showErrorWithStatus:@"上传头像失败,请检查网络"];
    }];
}


/**
 *  请求服务器找回密码
 *
 *  @param userModel    用户模型
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */

-(void)requestGetBackPasswordWithUserModel:(UserModel *)userModel SuccessBlock:(YXSuccessBlock)successBlock FaildBlock:(YXFaildBlock)faildBlock{
    
   
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [params setValue:userModel.phone forKey:@"user_name"];
    [params setValue:userModel.user_pwd forKey:@"user_pwd"];
    
    NSDictionary * singParmas = [YXNetWork globalSignParamsWithPrames:params];
    
    NSLog(@"requestGetBackPasswordWithUserModel jsonParmas:%@",[NSString jsonStringWithDictionary:singParmas]);
    
    [YXNetWork postHttp:user_forgetPwd parameters:singParmas showProgress:YES sucess:^(id responseObj) {
        NSLog(@"requestGetBackPasswordWithUserModel responseObj Json:%@",[NSString jsonStringWithDictionary:responseObj]);
        NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
        NSString * message = [responseObj objectForKey:@"message"];
        message = STR_IS_NIL(message)?@"设置密码成功":message;
        if(1 == code){
            if(successBlock){
                successBlock(responseObj);
            }
            [SVProgressHUD showSuccessWithStatus:message];
        }else{
            if(faildBlock){
                faildBlock(message);
            }
            [SVProgressHUD showErrorWithStatus:message];
        }
        
    } failed:^(NSString *errorMsg) {
        NSLog(@"requestGetBackPasswordWithUserModel errorMsg:%@",errorMsg);
        if(faildBlock){
            faildBlock(errorMsg);
        }
    }];
    
}

/**
 *  第三方登录
 *
 *  @param vc           控制器
 *  @param platformType 第三方登录类型
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */
-(void)socialLoginInVC:(UIViewController*)vc PlatformType:(NSString*)platformType  SuccessBlock:(YXSuccessBlock)successBlock FaildBlock:(YXFaildBlock)faildBlock{

//    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:platformType];
//
//    snsPlatform.loginClickHandler(vc,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
//
//        if (response.responseCode == UMSResponseCodeSuccess) {
//
//            //NSDictionary *dict = [UMSocialAccountManager socialAccountDictionary];
//            UMSocialAccountEntity *accountEntity = [[UMSocialAccountManager socialAccountDictionary] valueForKey:platformType];
//            //            NSString * accessToken = accountEntity.accessToken;
//            //            NSString * refreshToken = accountEntity.refreshToken;
//            //            NSString * userName = accountEntity.userName;
//            //            NSString * usid = accountEntity.usid;
//            NSString * platformName = accountEntity.platformName;
//
//            APPDelegate.userViewModel.socialLoginPlatformName = platformName;
//
//            if(successBlock){
//                successBlock(accountEntity);
//            }
//        }else{
//            if(faildBlock){
//                faildBlock(response.message);
//            }
//        }
//
//    });
    
}


/**
 *  获取第三方登录是否过期
 *
 *  @return 是否过期
 */

-(BOOL)isOauthAndTokenNotExpiredWithPlatformName:(NSString*)platformName{
//    BOOL isAvailible = [UMSocialAccountManager isOauthAndTokenNotExpired:platformName];
//    return isAvailible;
    return YES;
}

/**
 *  判断第三方登录是否有效
 */
-(void)judgeSocialLoginAndTip{
    
//    NSString * platformName = APPDelegate.userViewModel.socialLoginPlatformName;
//    if(STR_IS_NIL(platformName)){
//        return;
//    }
//
//    NSString * tipType = nil;
//    if([platformName isEqualToString:UMShareToWechatSession]){
//        tipType = @"微信";
//    }else if([platformName isEqualToString:UMShareToQQ]){
//        tipType = @"QQ";
//    }else if([platformName isEqualToString:UMShareToSina]){
//        tipType = @"新浪";
//    }else if([platformName isEqualToString:UMShareToDouban]){
//        tipType = @"豆瓣";
//    }else{
//        return;
//    }
//
//    if(![self isOauthAndTokenNotExpiredWithPlatformName:platformName]){
//        __weak typeof(self) weakSelf = self;
//        NSString * msg = [NSString stringWithFormat:@"你的%@第三方授权登录已过期，请重新授权登录",tipType];
//        UIAlertView * alertView = [UIAlertView alertViewWithTitle:@"温馨提示" message:msg cancelButtonTitle:@"确认" handleBlock:^{
//            [weakSelf socialLoginInVC:APPDelegate.window.rootViewController PlatformType:platformName SuccessBlock:^(id object) {
//
//            } FaildBlock:^(id object) {
//
//            }];
//        }];
//        [alertView addButtonWithTitle:@"取消" handleBlock:^{
//
//        }];
//        [alertView show];
//    }
}


/**
 *  请求 上传推送clientID
 *
 *  @param clientID     推送clientID
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */
+(void)requestUploadUserClientID:(NSString*)clientID SuccessBlock:(YXSuccessBlock)successBlock FaildBlock:(YXFaildBlock)faildBlock{
    NSNumber * u_id = @(APPDelegate.userViewModel.localCacheUserModel.u_id);
    if(!APPDelegate.isUserHasLogin){
        u_id = @(0);
    }

    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [params setValue:u_id forKey:@"u_id"];
    [params setValue:clientID forKey:@"clientid"];
    
    NSDictionary * singParmas = [YXNetWork globalSignParamsWithPrames:params];
    
    NSLog(@"requestUploadUserClientID jsonParmas:%@",[NSString jsonStringWithDictionary:singParmas]);
    
    [YXNetWork postHttp:push_addClientID parameters:singParmas showProgress:YES sucess:^(id responseObj) {
        NSLog(@"requestUploadUserClientID responseObj Json:%@",[NSString jsonStringWithDictionary:responseObj]);
        NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
        NSString * message = [responseObj objectForKey:@"message"];
        message = STR_IS_NIL(message)?@"":message;
        if(1 == code){
            if(successBlock){
                successBlock(responseObj);
            }
        }else{
            if(faildBlock){
                faildBlock(message);
            }
            //[SVProgressHUD showSuccessWithStatus:message];
        }
    } failed:^(NSString *errorMsg) {
        NSLog(@"requestUploadUserClientID errorMsg:%@",errorMsg);
        if(faildBlock){
            faildBlock(errorMsg);
        }
    }];
}
/**
 *  请求 移除推送clientID
 *
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */
+(void)requestRemoveUserClientIDWithSuccessBlock:(YXSuccessBlock)successBlock FaildBlock:(YXFaildBlock)faildBlock{
    NSNumber * u_id = @(APPDelegate.userViewModel.localCacheUserModel.u_id);
    if(!APPDelegate.isUserHasLogin){
        u_id = @(0);
    }
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [params setValue:u_id forKey:@"u_id"];
    
    NSDictionary * singParmas = [YXNetWork globalSignParamsWithPrames:params];
    
    NSLog(@"requestRemoveUserClientIDWithSuccessBlock jsonParmas:%@",[NSString jsonStringWithDictionary:singParmas]);
    
    [YXNetWork postHttp:push_removeClientID parameters:singParmas showProgress:YES sucess:^(id responseObj) {
        NSLog(@"requestRemoveUserClientIDWithSuccessBlock responseObj Json:%@",[NSString jsonStringWithDictionary:responseObj]);
        NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
        NSString * message = [responseObj objectForKey:@"message"];
        message = STR_IS_NIL(message)?@"":message;
        if(1 == code){
            if(successBlock){
                successBlock(responseObj);
            }
        }else{
            if(faildBlock){
                faildBlock(message);
            }
            [SVProgressHUD showSuccessWithStatus:message];
        }
    } failed:^(NSString *errorMsg) {
        NSLog(@"requestRemoveUserClientIDWithSuccessBlock errorMsg:%@",errorMsg);
        if(faildBlock){
            faildBlock(errorMsg);
        }
    }];
}

/**
 *  请求手机号判断该手机号是否已经注册过
 *
 *  @param phoneNumber  手机号
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */
-(void)requestJudgeHasRegisteredWithPhoneNumber:(NSString*)phoneNumber SuccessBlock:(YXSuccessBlock)successBlock FaildBlock:(YXFaildBlock)faildBlock{
    
    
//    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
//    [params setValue:@"iOS" forKey:@"from"];
//    [params setValue:phoneNumber forKey:@"user_name"];
//
//    NSDictionary * singParmas = [YXNetWork globalSignParamsWithPrames:params];
//
//    NSLog(@"requestJudgeHasRegisteredWithPhoneNumber jsonParmas:%@",[NSString jsonStringWithDictionary:singParmas]);
//
//    [YXNetWork postHttp:user_telephoneIsBound parameters:singParmas showProgress:YES sucess:^(id responseObj) {
//        NSLog(@"requestJudgeHasRegisteredWithPhoneNumber responseObj Json:%@",[NSString jsonStringWithDictionary:responseObj]);
//        NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
//        NSString * message = [responseObj objectForKey:@"message"];
//        message = STR_IS_NIL(message)?@"":message;
//        if(1 == code){
//            if(successBlock){
//                successBlock(responseObj);
//            }
//        }else{
//            if(faildBlock){
//                faildBlock(message);
//            }
//            [SVProgressHUD showSuccessWithStatus:message];
//        }
//
//    } failed:^(NSString *errorMsg) {
//        NSLog(@"requestJudgeHasRegisteredWithPhoneNumber errorMsg:%@",errorMsg);
//        if(faildBlock){
//            faildBlock(errorMsg);
//        }
//    }];
}
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
-(void)requestWeiXinBoundLoginWithOpenID:(NSString*)openId AccessToken:(NSString*)accessToken PhoneNumber:(NSString*)phoneNumber Password:(NSString * )password SuccessBlock:(YXSuccessBlock)successBlock FaildBlock:(YXFaildBlock)faildBlock{
    
//
//    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
//    [params setValue:@"iOS" forKey:@"from"];
//    [params setValue:openId forKey:@"openid"];
//    [params setValue:accessToken forKey:@"access_token"];
//    [params setValue:phoneNumber forKey:@"user_name"];
//    [params setValue:password forKey:@"user_pwd"];
//
//    NSDictionary * singParmas = [YXNetWork globalSignParamsWithPrames:params];
//
//    NSLog(@"requestWeiXinBoundLoginWithOpenID jsonParmas:%@",[NSString jsonStringWithDictionary:singParmas]);
//
//    [YXNetWork postHttp:user_weiXinBound parameters:singParmas showProgress:YES sucess:^(id responseObj) {
//        NSLog(@"requestWeiXinBoundLoginWithOpenID responseObj Json:%@",[NSString jsonStringWithDictionary:responseObj]);
//        NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
//        NSString * message = [responseObj objectForKey:@"message"];
//        message = STR_IS_NIL(message)?@"":message;
//        if(1 == code){
//            NSDictionary * resultDict = [responseObj objectForKey:@"result"];
//            if([resultDict isKindOfClass:[NSDictionary class]]){
//                BOOL islogin  = [resultDict objectForKey:@"islogin"];
//                NSInteger u_id = [[resultDict objectForKey:@"u_id"] integerValue];
//                UserModel * userModel = [APPDelegate.userViewModel.localCacheUserModel copy];
//                userModel.u_id = u_id;
//                APPDelegate.userViewModel.localCacheUserModel = userModel;
//                if(islogin){
//                    if(successBlock){
//                        successBlock(responseObj);
//                    }
//                }else{
//                    if(faildBlock){
//                        faildBlock(message);
//                    }
//                    [SVProgressHUD showSuccessWithStatus:message];
//                }
//            }else{
//                if(faildBlock){
//                    faildBlock(@"服务器数据错误");
//                }
//                [SVProgressHUD showSuccessWithStatus:message];
//            }
//        }else{
//            if(faildBlock){
//                faildBlock(message);
//            }
//            [SVProgressHUD showSuccessWithStatus:message];
//        }
//
//    } failed:^(NSString *errorMsg) {
//        NSLog(@"requestWeiXinBoundLoginWithOpenID errorMsg:%@",errorMsg);
//        if(faildBlock){
//            faildBlock(errorMsg);
//        }
//    }];
}


/**
 *  请求根据微信code判断是否已经存在系统中
 *
 *  @param code       第三方微信code
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */
-(void)requestJudgeWeiXinLoginWithCode:(NSString*)code SuccessBlock:(YXSuccessBlock)successBlock FaildBlock:(YXFaildBlock)faildBlock{
    
    
//    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
//    [params setValue:@"iOS" forKey:@"from"];
//    [params setValue:code forKey:@"code"];
//
//    NSDictionary * singParmas = [YXNetWork globalSignParamsWithPrames:params];
//
//    NSLog(@"requestJudgeWeiXinLoginWithCode jsonParmas:%@",[NSString jsonStringWithDictionary:singParmas]);
//
//    [YXNetWork postHttp:user_isWeiXinBound parameters:singParmas showProgress:YES sucess:^(id responseObj) {
//        NSLog(@"requestJudgeWeiXinLoginWithCode responseObj Json:%@",[NSString jsonStringWithDictionary:responseObj]);
//        NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
//        NSString * message = [responseObj objectForKey:@"message"];
//        message = STR_IS_NIL(message)?@"":message;
//
//        if(1 == code){
//
//            NSDictionary * resultDict = responseObj[@"result"];
//            NSString * access_token = resultDict[@"access_token"];
//            NSString * refresh_token = resultDict[@"refresh_token"];
//            NSString * openid = resultDict[@"openid"];
//            [[NSUserDefaults standardUserDefaults] setObject:refresh_token forKey:WX_REFRESH_TOKEN_KEY];
//            [[NSUserDefaults standardUserDefaults] setObject:access_token forKey:WX_ACCESS_TOKEN_KEY];
//            [[NSUserDefaults standardUserDefaults] setObject:openid forKey:WX_OPEN_ID_KEY];
//
//            [[NSUserDefaults standardUserDefaults] synchronize];
//
//            if(successBlock){
//                successBlock(resultDict);
//            }
//        }else{
//            if(faildBlock){
//                faildBlock(message);
//            }
//        }
//        //[SVProgressHUD showSuccessWithStatus:message];
//    } failed:^(NSString *errorMsg) {
//        NSLog(@"requestJudgeWeiXinLoginWithCode errorMsg:%@",errorMsg);
//        if(faildBlock){
//            faildBlock(errorMsg);
//        }
//    }];
}
@end
