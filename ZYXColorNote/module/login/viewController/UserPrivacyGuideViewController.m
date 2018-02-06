//
//  UserPrivacyGuideViewController.m
//  RealMall
//
//  Created by 极客天地 on 2017/12/15.
//  Copyright © 2017年 极客天地. All rights reserved.
//

#import "UserPrivacyGuideViewController.h"

@interface UserPrivacyGuideViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation UserPrivacyGuideViewController
+(UserPrivacyGuideViewController *)userPrivacyGuideViewController{
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"login" bundle:[NSBundle mainBundle]];
    UserPrivacyGuideViewController * upgvc = (UserPrivacyGuideViewController*)[storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([UserPrivacyGuideViewController class])];
    return upgvc;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString * path = [[NSBundle mainBundle] pathForResource:@"隐私保护指引" ofType:@"docx"];
    NSURL * url = [NSURL fileURLWithPath:path];
    NSURLRequest * request = [[NSURLRequest alloc] initWithURL:url];
    [SVProgressHUD showWithStatus:@"载入中..."];
    [self.webView loadRequest:request];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [SVProgressHUD dismiss];
}

@end
