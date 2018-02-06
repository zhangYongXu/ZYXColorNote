//
//  AccountLoginViewController.m
//  AllPeopleReading
//
//  Created by 极客天地 on 16/10/24.
//  Copyright © 2016年 极客天地. All rights reserved.
//

#import "AccountLoginViewController.h"
//#import "AppDelegate+Umeng.h"
//#import "AppDelegate+huanxin.h"

//#import "WeiXinLoginHandler.h"
#import "PhoneNumberRelationViewController.h"
@interface AccountLoginViewController ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (copy,nonatomic) NSString * userName;
@property (copy,nonatomic) NSString * password;

@property (weak, nonatomic) IBOutlet UIButton *wxLoginBtn;
@property (weak, nonatomic) IBOutlet UIButton *qqLoginBtn;
@property (weak, nonatomic) IBOutlet UIButton *sinaLoginBtn;
@property (weak, nonatomic) IBOutlet UIButton *dbLoginBtn;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@end

@implementation AccountLoginViewController
+(AccountLoginViewController *)accountLoginViewController{
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"login" bundle:[NSBundle mainBundle]];
    AccountLoginViewController * alvc = (AccountLoginViewController*)[storyboard instantiateInitialViewController];
    return alvc;
}
- (void)viewDidLoad {
    [super viewDidLoad];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)initData{
    self.userName = APPDelegate.userViewModel.localCacheUserModel.phone;
    self.password = APPDelegate.userViewModel.localCacheUserModel.user_pwd;
}

-(void)initUI{
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width, 603);
    self.contentView.height = 603;
    
    [self.accountTextField setValue:[UIColor colorWithHex:0xc4c4c4] forKeyPath:@"_placeholderLabel.textColor"];
    [self.passwordTextField setValue:[UIColor colorWithHex:0xc4c4c4] forKeyPath:@"_placeholderLabel.textColor"];
    
    [self adjustThirdPartBtnPostion];
    
    
    [self.accountTextField addTarget:self  action:@selector(userNmaeTextFieldValueChanged:)  forControlEvents:UIControlEventAllEditingEvents];
    [self.passwordTextField addTarget:self  action:@selector(passwordTextFieldValueChanged:)  forControlEvents:UIControlEventAllEditingEvents];
    
    self.accountTextField.text = self.userName;
    self.passwordTextField.text = self.password;
}

- (void)userNmaeTextFieldValueChanged:(UITextField*)textField{
    self.userName = textField.text;
    if(self.userName.length == 11){
        [APPDelegate.userViewModel requestHeaderImageUrlWithPhoneNumber:self.userName SuccessBlock:^(NSString * img_url) {
            if(STR_IS_NIL(img_url)){
                img_url = @"";
            }
            NSURL * url = [NSURL ZYXURLWithString:img_url];
            [self.headerImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"头像"]];
        } FaildBlock:^(id object) {
            
        }];
    }
}
- (void)passwordTextFieldValueChanged:(UITextField*)textField{
    self.password = textField.text;
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self validate];
    return YES;
}
- (BOOL)validate{
    if(STR_IS_NIL(self.userName)){
        [SVProgressHUD showErrorWithStatus:@"请输入用户名"];
        return NO;
    }
    if(STR_IS_NIL(self.password)){
        [SVProgressHUD showErrorWithStatus:@"请输入密码"];
        return NO;
    }
    return YES;
}
-(void)adjustThirdPartBtnPostion{
    NSMutableArray * array = [[NSMutableArray alloc] init];
//    if([WXApi isWXAppInstalled]){//是否安装微信
//        [array addObject:self.wxLoginBtn];
//    }else{
//        self.wxLoginBtn.hidden = YES;
//    }
    
    /*
    if([QQApiInterface isQQInstalled]){//是否安装qq
        [array addObject:self.qqLoginBtn];
    }else{
        self.qqLoginBtn.hidden = YES;
    }
    if([WeiboSDK isWeiboAppInstalled]){//是否安装新浪微博
        [array addObject:self.sinaLoginBtn];
    }else{
        self.sinaLoginBtn.hidden = YES;
    }
    
    [array addObject:self.dbLoginBtn];
     */
    
    self.qqLoginBtn.hidden = YES;
    self.sinaLoginBtn.hidden = YES;
    self.dbLoginBtn.hidden = YES;
    
    CGFloat btnWidth = 30;
    CGFloat space = (SCREEN_WIDTH-array.count*btnWidth)/(array.count+1);
    for(NSInteger i = 0;i<array.count;i++){
        CGFloat x = space + (btnWidth+space)*i;
        UIButton * btn = array[i];
        btn.left = x;
    }
}

- (IBAction)WXLoginBtnClicked:(id)sender {
    /*
    __weak typeof(self) weakSelf  = self;
    [APPDelegate.userViewModel socialLoginInVC:self PlatformType:UMShareToWechatSession SuccessBlock:^(UMSocialAccountEntity* accountEntity) {
        [weakSelf socialLoginHandleWithAccountEntity:accountEntity PlatformType:UMShareToWechatSession];
    } FaildBlock:^(NSString * msg) {
        
    }];
     */
//    [[WeiXinLoginHandler sharedInstance] intoWeiXinLoginWithBlock:^(NSDictionary *userInfoDict) {
//        NSLog(@"weiXinLoginBtnClicked:%@",userInfoDict);
//
//        NSString * code = userInfoDict[WX_TEMP_CODE_KEY];
//        [APPDelegate.userViewModel requestJudgeWeiXinLoginWithCode:code SuccessBlock:^(NSDictionary* resultDict) {
//
//            NSInteger u_id = 0;
//            NSString * isexist = @"";
//            if(resultDict){
//                u_id = [resultDict[@"u_id"] integerValue];
//                isexist = resultDict[@"isexist"];
//            }
//            if(![isexist boolValue]){//该微信第三方账号在系统没绑定过
//                [self performSegueWithIdentifier:@"ThirdLoginToBandPhoneSegue" sender:resultDict];
//            }else{//该微信第三方账号登录成功
//                UserModel * userModel = [APPDelegate.userViewModel.localCacheUserModel copy];
//                userModel.u_id = u_id;
//                APPDelegate.userViewModel.localCacheUserModel = userModel;
//                APPDelegate.userViewModel.userLoginState = UserViewModelLoginStatesLogin;
//                [APPDelegate.userViewModel requestGetUserInfoWithSuccessBlock:^(id object) {
//                    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Name_UserLogin object:nil];
//                    [self.navigationController popViewControllerAnimated:YES];
//                    [SVProgressHUD showSuccessWithStatus:@"登录成功"];
//                    [APPDelegate submitDeviceIDToSever];
//                } FaildBlock:^(NSString * msg) {
//                    APPDelegate.userViewModel.userLoginState = UserViewModelLoginStatesLogout;
//                    NSString * errorMsg = @"登录失败";
//                    if(!STR_IS_NIL(msg)){
//                        errorMsg = [errorMsg stringByAppendingFormat:@":%@",msg];
//                    }
//                    [SVProgressHUD showSuccessWithStatus:errorMsg];
//                }];
//            }
//        } FaildBlock:^(NSString * msg) {
//            NSString * errorMsg = @"登录失败";
//            if(!STR_IS_NIL(msg)){
//                errorMsg = [errorMsg stringByAppendingFormat:@":%@",msg];
//            }
//            [SVProgressHUD showSuccessWithStatus:errorMsg];
//        }];
//
//    }];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    UIViewController * vc = segue.destinationViewController;
//    if([vc isKindOfClass:[PhoneNumberRelationViewController class]]){
//        PhoneNumberRelationViewController * pvc = (PhoneNumberRelationViewController*)vc;
//        NSDictionary * resultDict = sender;
//        pvc.openId = resultDict[WX_OPEN_ID_KEY];
//        pvc.accessToken = resultDict[WX_ACCESS_TOKEN_KEY];
//    }
}

- (IBAction)QQLoginBtnClicked:(id)sender {
//    __weak typeof(self) weakSelf  = self;
//    [APPDelegate.userViewModel socialLoginInVC:self PlatformType:UMShareToQQ SuccessBlock:^(UMSocialAccountEntity* accountEntity) {
//        [weakSelf socialLoginHandleWithAccountEntity:accountEntity PlatformType:UMShareToQQ];
//    } FaildBlock:^(NSString * msg) {
//
//    }];
}
- (IBAction)SinaLoginClicked:(id)sender {
//    __weak typeof(self) weakSelf  = self;
//    [APPDelegate.userViewModel socialLoginInVC:self PlatformType:UMShareToSina SuccessBlock:^(UMSocialAccountEntity* accountEntity) {
//        [weakSelf socialLoginHandleWithAccountEntity:accountEntity PlatformType:UMShareToSina];
//    } FaildBlock:^(NSString * msg) {
//
//    }];
}

- (IBAction)DBLoginClicked:(id)sender {
//    __weak typeof(self) weakSelf  = self;
//    [APPDelegate.userViewModel socialLoginInVC:self PlatformType:UMShareToDouban SuccessBlock:^(UMSocialAccountEntity* accountEntity) {
//        [weakSelf socialLoginHandleWithAccountEntity:accountEntity PlatformType:UMShareToSina];
//    } FaildBlock:^(NSString * msg) {
//
//    }];
}
- (IBAction)accountLoginBtnClicked:(id)sender {
    if(![self validate]){
        return;
    }
    
    UserModel * userModel = [[UserModel alloc] init];
    userModel.phone = self.userName;
    userModel.user_pwd = self.password;
    [APPDelegate.userViewModel requestUserLoginWithUserModel:userModel SuccessBlock:^(id object) {
        APPDelegate.userViewModel.userLoginState = UserViewModelLoginStatesLogin;
        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Name_UserLogin object:nil];
        [self.navigationController popViewControllerAnimated:YES];
        //[APPDelegate submitDeviceIDToSever];
        //        [UserViewModel requestUploadUserClientID:APPDelegate.geTuiPushClientId SuccessBlock:^(id object) {
        //
        //        } FaildBlock:^(id object) {
        //
        //        }];
        //        [APPDelegate loginHuanXin];
    } FaildBlock:^(id object) {
        
    }];
    
}

//- (void)socialLoginHandleWithAccountEntity:(UMSocialAccountEntity*)accountEntity PlatformType:(NSString *)platformType{
//    [self.navigationController popViewControllerAnimated:YES];
//
//
//
//}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end

