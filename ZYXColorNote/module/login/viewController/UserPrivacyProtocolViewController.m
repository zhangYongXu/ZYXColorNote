//
//  UserPrivacyProtocolViewController.m
//  LuNengHotel
//
//  Created by 拓之林 on 16/5/11.
//  Copyright © 2016年 拓之林. All rights reserved.
//

#import "UserPrivacyProtocolViewController.h"

@interface UserPrivacyProtocolViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation UserPrivacyProtocolViewController
+(UserPrivacyProtocolViewController *)userPrivacyProtocolViewController{
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"login" bundle:[NSBundle mainBundle]];
    UserPrivacyProtocolViewController * uppvc = (UserPrivacyProtocolViewController*)[storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([UserPrivacyProtocolViewController class])];
    return uppvc;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString * path = [[NSBundle mainBundle] pathForResource:@"用户使用协议" ofType:@"docx"];
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
