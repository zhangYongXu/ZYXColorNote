//
//  MineInfoViewController.m
//  ZYXColorNote
//
//  Created by 极客天地 on 2018/2/6.
//  Copyright © 2018年 极客天地. All rights reserved.
//

#import "MineInfoViewController.h"
#import "YXDateSelectView.h"
@interface MineInfoViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *itemViewArray;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *divideLineViewArray;


@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UITextField *nickNameTextFeild;
@property (weak, nonatomic) IBOutlet UITextField *sexTextFeild;
@property (weak, nonatomic) IBOutlet UITextField *birthdayTextFeild;
@property (weak, nonatomic) IBOutlet UITextField *educationTextFeild;
@property (weak, nonatomic) IBOutlet UITextField *tradeTextFeild;
@property (weak, nonatomic) IBOutlet UITextField *interestTextFeild;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@property (strong,nonatomic) YXDateSelectView * dateSelectView;
@property (strong,nonatomic) UIActionSheet * headerActionSheet;
@property (strong,nonatomic) UIActionSheet * sexActionSheet;

@end

@implementation MineInfoViewController

-(YXDateSelectView *)dateSelectView{
    if(nil == _dateSelectView){
        _dateSelectView = [YXDateSelectView loadFromXib];
        [APPDelegate.window.rootViewController.view addSubview:_dateSelectView];
        [_dateSelectView initViewWithDateSelectConfirmBlock:^(YXDateSelectView *dateSelectView, NSDate *date) {
            self.birthdayTextFeild.text = [date stringWithFormat:@"yyyy-MM-dd"];
        }];
    }
    return _dateSelectView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerNotification];
    [self refreshUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)registerNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)KeyBoardWillShow:(NSNotification*)note{
    UIView * firstResponderView = [UIView findFirstResponderInView:self.scrollView];
    if(!firstResponderView){
        return;
    }
    UIView * targetView = [firstResponderView superview];
    
    if(targetView){
        CGRect keyboardFrame = [[note.userInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
        
        CGPoint originForSelfView = [UIView converPointWithSuperView:APPDelegate.window view:targetView point:targetView.origin];
        CGFloat cellBottomForSelfView = originForSelfView.y + targetView.height;
        CGFloat offy = cellBottomForSelfView - keyboardFrame.origin.y;
        if(offy>0){
            self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x, self.scrollView.contentOffset.y + offy);
        }
        
    }
    
}
- (void)KeyBoardWillHide:(NSNotification*)note{
    self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x, 0);
}
-(void)initData{
    [APPDelegate.userViewModel requestGetUserInfoWithSuccessBlock:^(id object) {
        [self refreshUI];
    } FaildBlock:^(id object) {
        
    }];
}

-(void)initUI{
    self.headerImageView.layer.masksToBounds = YES;
    self.headerImageView.layer.cornerRadius = self.headerImageView.height/2.0;
    [self.scrollView addSingleTapGetureWithBlock:^(UITapGestureRecognizer *tapGeture) {
        [self.view endEditing:YES];
    }];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width, 603);
    
    for(UIView * view in self.divideLineViewArray){
        [view drawBorderSolidLineWithPosition:BorderLinePositionBottom Color:[UIColor colorWithHex:AppViewBottomLineColor] Width:AppViewBottomLineWidth];
    }
}

-(void)refreshUI{
    NSURL * url = [NSURL URLWithString:APPDelegate.userViewModel.localCacheUserModel.img_url];
    [self.headerImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"头像"]];
    self.nickNameTextFeild.text = APPDelegate.userViewModel.localCacheUserModel.nick_name;
    self.birthdayTextFeild.text = APPDelegate.userViewModel.localCacheUserModel.birthday;
    self.educationTextFeild.text = APPDelegate.userViewModel.localCacheUserModel.educationString;
    self.tradeTextFeild.text = APPDelegate.userViewModel.localCacheUserModel.trade;
    self.sexTextFeild.text = APPDelegate.userViewModel.localCacheUserModel.sexString;
    self.interestTextFeild.text = APPDelegate.userViewModel.localCacheUserModel.interest;
    self.userNameLabel.text = APPDelegate.userViewModel.localCacheUserModel.user_name;
}
- (IBAction)headerImageSelectBtnClicked:(id)sender {
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从手机相册选择",@"拍照", nil];
    self.headerActionSheet = actionSheet;
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (IBAction)sexSelectBtnClicked:(id)sender {
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:[UserModel stringSexWithType:SexTypeMale],[UserModel stringSexWithType:SexTypeFemale], nil];
    self.sexActionSheet = actionSheet;
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}
- (IBAction)dateSelectBtnClicked:(id)sender {
    if(self.dateSelectView.hidden){
        [self.view endEditing:YES];
        [self.dateSelectView showDateSelectViewAnimation:YES];
    }else{
        [self.dateSelectView hiddenDateSelectViewAnimation:YES];
    }
}
- (IBAction)educationSelectBtnClicked:(id)sender {
    NSArray * array = @[
                        [UserModel stringEducationWithType:EducationTypePrimarySchool],
                        [UserModel stringEducationWithType:EducationTypeMiddleSchool],
                        [UserModel stringEducationWithType:EducationTypeHighSchool],
                        [UserModel stringEducationWithType:EducationTypeUniversity],
                        [UserModel stringEducationWithType:EducationTypePostgraduate],
                        [UserModel stringEducationWithType:EducationTypeDoctor],
                        ];
    [YXSinglePickerView SinglePickerView].bottomViewBackgroundColor = [UIColor colorWithHex:0xDC3F31];
    
    [[YXSinglePickerView SinglePickerView] refreshDataWithArray:array TitleForRowBlock:^NSString *(NSArray *array, NSInteger index) {
        NSString *title = array[index];
        return title;
    } ConfirmBlock:^(NSArray *array, NSInteger index) {
        NSString *title = array[index];
        self.educationTextFeild.text = title;
    }];
    [[YXSinglePickerView SinglePickerView] showSinglePickerViewAnimation:YES];
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(actionSheet == self.headerActionSheet){
        if (buttonIndex==2) {
            return;
        }
        UIImagePickerControllerSourceType sourceType =UIImagePickerControllerSourceTypePhotoLibrary;
        if (buttonIndex ==0) {
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }else if (buttonIndex == 1){
            sourceType = UIImagePickerControllerSourceTypeCamera;
            if(![APPDelegate judgeCameraRight]){
                return;
            }
        }
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
        picker.allowsEditing = YES;//设置可编辑
        picker.delegate = self;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:^{}];
    }else if(actionSheet == self.sexActionSheet){
        NSLog(@"actionSheetButtonIndex:%ld",buttonIndex);
        if(0 == buttonIndex){
            self.sexTextFeild.text = @"男";
        }else{
            self.sexTextFeild.text = @"女";
        }
    }
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    
    __weak typeof(self) weakSelf = self;
    UIAlertView * alertView = [UIAlertView alertViewWithTitle:@"温馨提示" message:@"确认修改头像吗？" cancelButtonTitle:@"取消" handleBlock:^{}];
    [alertView addButtonWithTitle:@"确认" handleBlock:^{
        weakSelf.headerImageView.image = image;
        [APPDelegate.userViewModel requestUpdateUserHeadWithImage:image SuccessBlock:^(id object) {
            weakSelf.headerImageView.image = image;
        } FaildBlock:^(id object) {
            
        }];
    }];
    
    
    [alertView show];
    
}
- (BOOL)validate{
    NSString * nickName = self.nickNameTextFeild.text;
    NSString * sex = self.sexTextFeild.text;
    NSString * birthday = self.birthdayTextFeild.text;
    NSString * education = self.educationTextFeild.text;
    NSString * trade = self.tradeTextFeild.text;
    NSString * interest = self.interestTextFeild.text;
    if(STR_IS_NIL(nickName)){
        [SVProgressHUD showErrorWithStatus:@"请输入昵称"];
        return NO;
    }
    if(STR_IS_NIL(sex)){
        [SVProgressHUD showErrorWithStatus:@"请选择性别"];
        return NO;
    }
    if(STR_IS_NIL(birthday)){
        [SVProgressHUD showErrorWithStatus:@"请选择出生日期"];
        return NO;
    }
    /*
     if(STR_IS_NIL(education)){
     [SVProgressHUD showErrorWithStatus:@"请选择学历"];
     return NO;
     }
     if(STR_IS_NIL(trade)){
     [SVProgressHUD showErrorWithStatus:@"请输入行业"];
     return NO;
     }
     if(STR_IS_NIL(interest)){
     [SVProgressHUD showErrorWithStatus:@"请输入兴趣"];
     return NO;
     }
     */
    return YES;
}
- (IBAction)updateBtnClicked:(id)sender {
    if(![self validate]){
        return;
    }
    NSString * nickName = self.nickNameTextFeild.text;
    NSInteger sex = [UserModel sexWithString:self.sexTextFeild.text];
    NSString * birthday = self.birthdayTextFeild.text;
    NSInteger education = [UserModel educationWithString:self.educationTextFeild.text];
    NSString * trade = self.tradeTextFeild.text;
    NSString * interest = self.interestTextFeild.text;
    
    
    UserModel * userModel = [APPDelegate.userViewModel.localCacheUserModel copy];
    userModel.nick_name = nickName;
    userModel.sex = sex;
    userModel.birthday = birthday;
    userModel.education = education;
    userModel.trade = trade;
    userModel.interest = interest;
    
    [APPDelegate.userViewModel requestUpdateUserInfoWithUserModel:userModel SuccessBlock:^(id object) {
        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Name_UserChangeBaseInfo object:nil];
    } FaildBlock:^(id object) {
        
    }];
}


@end
