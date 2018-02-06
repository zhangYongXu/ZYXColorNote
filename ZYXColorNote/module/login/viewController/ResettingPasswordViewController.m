//
//  ResettingPasswordViewController.m
//  AllPeopleReading
//
//  Created by 极客天地 on 16/10/26.
//  Copyright © 2016年 极客天地. All rights reserved.
//

#import "ResettingPasswordViewController.h"

@interface ResettingPasswordViewController ()
@property (weak, nonatomic) IBOutlet UIButton *getVerifyCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *comfirmBtn;

@property (weak, nonatomic) IBOutlet UITextField *mobileTextFeild;
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeTextFeild;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextFeild;

@property (copy,nonatomic) NSString * password;
@property (copy,nonatomic) NSString * phone;
@property (copy,nonatomic) NSString * verifyCode;
@end

@implementation ResettingPasswordViewController{
    dispatch_source_t _timer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)initData{
    
}

-(void)initUI{
    [self.mobileTextFeild addTarget:self  action:@selector(mobileTextFeildValueChanged:)  forControlEvents:UIControlEventAllEditingEvents];
    [self.verifyCodeTextFeild addTarget:self  action:@selector(verifyCodeTextFeildValueChanged:)  forControlEvents:UIControlEventAllEditingEvents];
    [self.passwordTextFeild addTarget:self  action:@selector(passwordTextFeildValueChanged:)  forControlEvents:UIControlEventAllEditingEvents];
    
    [self refreshLoginBtnState];
}
- (void)mobileTextFeildValueChanged:(UITextField*)textField{
    
    NSString * phone = textField.text;
    phone = STR_IS_NIL(phone)?@"":phone;
    if(phone.length<=11){
        self.phone = phone;
    }else{
        textField.text = self.phone;
    }
    
    [self refreshLoginBtnState];
}
- (void)verifyCodeTextFeildValueChanged:(UITextField*)textField{
    self.verifyCode = textField.text;
    [self refreshLoginBtnState];
}
- (void)passwordTextFeildValueChanged:(UITextField*)textField{
    self.password = textField.text;
    [self refreshLoginBtnState];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(BOOL)validateMobile{
    NSString * mobile = self.phone;
    if(STR_IS_NIL(mobile)){
        [SVProgressHUD showErrorWithStatus:@"请输入手机号"];
        return NO;
    }
    if(mobile.length != 11){
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
        return NO;
    }
    return YES;
}
- (void)refreshLoginBtnState{
    self.comfirmBtn.enabled = NO;
    self.getVerifyCodeBtn.enabled = NO;
    
    if(STR_IS_NIL(self.phone) || self.phone.length != 11){
        return;
    }
    
    self.getVerifyCodeBtn.enabled = YES;
    
    if(STR_IS_NIL(self.verifyCode)){
        return;
    }
    if(STR_IS_NIL(self.password)){
        return;
    }
    
    self.comfirmBtn.enabled = YES;
    
}
- (IBAction)getVerifyCodeBtn:(UIButton*)sender {
    if([sender.titleLabel.text isEqualToString:@"获取验证码"]){
        if(![self validateMobile]){
            return;
        }
        //请求验证码
        sender.enabled = NO;
        [self.getVerifyCodeBtn setTitle:@"获取中..." forState:UIControlStateNormal];
        
        
        __weak __typeof(self)weakSelf = self;
        
        NSString * mobile = self.mobileTextFeild.text;
   
        [APPDelegate.userViewModel requestGetVerifyCodeWithPhoneNumber:mobile SuccessBlock:^(id object) {
            //请求完成
            [weakSelf startTimer];
        } FaildBlock:^(id object) {
            [weakSelf.getVerifyCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            weakSelf.getVerifyCodeBtn.titleLabel.text = @"获取验证码";
            sender.enabled = YES;
        }];
    }
}

- (void)startTimer{
    NSTimeInterval period = 1.0; //设置时间间隔
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0); //每秒执行
    [self.getVerifyCodeBtn setTitle:@"60秒" forState:UIControlStateNormal];
    self.getVerifyCodeBtn.titleLabel.text = @"60秒";
    dispatch_source_set_event_handler(_timer, ^{
        //在这里执行事件
        
        NSInteger second = [[self.getVerifyCodeBtn.titleLabel.text stringByReplacingOccurrencesOfString:@"秒" withString:@""] integerValue];
        second = second - 1;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(0 >= second){
                [self endTimer];
            }else{
                NSString * str = [NSString stringWithFormat:@"   %ld秒",second];
                [self.getVerifyCodeBtn setTitle:str forState:UIControlStateNormal];
                self.getVerifyCodeBtn.titleLabel.text = str;
            }
        });
    });
    
    dispatch_resume(_timer);
}
- (void)endTimer{
    dispatch_source_cancel(_timer);
    dispatch_source_set_cancel_handler(_timer, ^{
        NSLog(@"取消定时器");
        _timer = nil;
    });
    [self.getVerifyCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    self.getVerifyCodeBtn.titleLabel.text = @"获取验证码";
    self.getVerifyCodeBtn.enabled = YES;
}
-(void)dealloc{
    if(_timer){
        [self endTimer];
    }
}

- (BOOL)validate{
    if(![self validateMobile]){
        return NO;
    }
    
    NSString * verfifyCode = self.verifyCode;
    NSString * password = self.password;
    if(STR_IS_NIL(verfifyCode)){
        [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
        return NO;
    }
    if(STR_IS_NIL(password)){
        [SVProgressHUD showErrorWithStatus:@"请输入密码"];
        return NO;
    }
    
    return YES;
}
- (IBAction)comfirmBtnClicked:(id)sender {
    if(![self validate]){
        return;
    }
    __weak typeof(self) weakSelf = self;
    [APPDelegate.userViewModel requestValidateVerifyCode:self.verifyCode SuccessBlock:^(id object) {
        UserModel * userModel = [[UserModel alloc] init];
        userModel.phone = weakSelf.phone;
        userModel.user_pwd = weakSelf.password;
        [APPDelegate.userViewModel requestGetBackPasswordWithUserModel:userModel SuccessBlock:^(id object) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } FaildBlock:^(id object) {
            
        }];
    } FaildBlock:^(id object) {
        
    }];
    
}
@end
