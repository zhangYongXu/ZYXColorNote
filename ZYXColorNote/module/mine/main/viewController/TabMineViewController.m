//
//  TabMineViewController.m
//  AllPeopleReading
//
//  Created by 极客天地 on 16/8/3.
//  Copyright © 2016年 极客天地. All rights reserved.
//

#import "TabMineViewController.h"

#import "AccountLoginViewController.h"

@interface TabMineViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;

@end

@implementation TabMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshUI];
}
-(void)initData{
    
}

-(void)initUI{
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width, 902);
}
-(void)refreshUI{
    NSString * nick_name = APPDelegate.userViewModel.localCacheUserModel.user_name;
    NSString * image_url = APPDelegate.userViewModel.localCacheUserModel.img_url;
    if(APPDelegate.isUserHasLogin){
        self.nickNameLabel.text = nick_name;
        NSURL * url = [NSURL ZYXURLWithString:image_url];
        [self.headerImageView sd_setImageWithURL:url];
    }else{
        self.nickNameLabel.text = @"请登录";
        self.headerImageView.image = nil;
    }
}
- (IBAction)toLoginBtn:(id)sender {
    if(APPDelegate.isUserHasLogin){
        return;
    }
    
    AccountLoginViewController * avc = [AccountLoginViewController accountLoginViewController];
    [self.navigationController pushViewController:avc animated:YES];
    
}
- (IBAction)logoutBtnClicked:(id)sender {
    APPDelegate.userViewModel.userLoginState = UserViewModelLoginStatesLogout;
    [SVProgressHUD showSuccessWithStatus:@"退出成功"];
    [self refreshUI];
}
- (IBAction)draftBtnClicked:(id)sender {
    [self performSegueWithIdentifier:@"MineToDraftSegue" sender:nil];
}
- (IBAction)myNoteClicked:(id)sender {
    if(!APPDelegate.isUserHasLogin){
        [SVProgressHUD showSuccessWithStatus:@"请先登录"];
        return;
    }
    [self performSegueWithIdentifier:@"MineToMyNotesSegue" sender:nil];
}

@end
