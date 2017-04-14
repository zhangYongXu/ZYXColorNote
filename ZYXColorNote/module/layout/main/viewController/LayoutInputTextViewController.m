//
//  LayoutInputTextViewController.m
//  TourNote
//
//  Created by 极客天地 on 17/1/16.
//  Copyright © 2017年 极客天地. All rights reserved.
//

#import "LayoutInputTextViewController.h"

#import "ZYXRGBColorSelectView.h"
#import "ZYXCustomFontSelectView.h"

@interface LayoutInputTextViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIView *tipView;

@property (strong, nonatomic) IBOutlet UIView *bottomView;

@property(strong,nonatomic)ZYXFontModel* fontModel;


@end

@implementation LayoutInputTextViewController


- (IBAction)completeBtnClicked:(id)sender {
    if(self.layoutInputCompleteBlock){
        self.layoutInputCompleteBlock(self,self.textView.text,self.color,self.font,self.fontModel);
    }
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (IBAction)colorBtnClicked:(id)sender {
    [self.view endEditing:YES];
    [ZYXRGBColorSelectView popViewConfirmSelectedBlock:^(ZYXRGBColorSelectView *view, UIColor *color) {
        self.color = color;
        self.textView.textColor = self.color;
    }];
}
- (IBAction)fontBtnClicked:(id)sender {
    [self.view endEditing:YES];
    [ZYXCustomFontSelectView popViewConfirmSelectedBlock:^(ZYXCustomFontSelectView *view, ZYXFontModel *fontModel) {
        self.fontModel = fontModel;
        self.font = [fontModel fontWithFontSize:500];
        self.textView.font = [fontModel fontWithFontSize:self.textView.font.pointSize];
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.textView becomeFirstResponder];
}
- (void)initData{
    [self.bottomView removeFromSuperview];
}
- (void)initUI{
    
    self.textView.text = self.text;
    self.textView.textColor = self.color;
    self.textView.font = [self.font fontWithSize:self.textView.font.pointSize];
    [self textViewDidChange:self.textView];
    
    self.textView.textColor = self.color;
    self.textView.inputAccessoryView = self.bottomView;
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)textViewDidChange:(UITextView *)textView{
    self.tipView.hidden = !STR_IS_NIL(textView.text);
}
@end
