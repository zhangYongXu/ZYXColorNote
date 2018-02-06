//
//  ZYXRGBColorSelectView.m
//  TourNote
//
//  Created by 极客天地 on 17/1/20.
//  Copyright © 2017年 极客天地. All rights reserved.
//

#import "ZYXRGBColorSelectView.h"

#import "HRColorPickerView.h"
#import "HRColorMapView.h"
#import "HRColorInfoView.h"

static ZYXRGBColorSelectView * shareIntance = nil;
@interface ZYXRGBColorSelectView()
@property (weak, nonatomic) IBOutlet UIView *customBackgroundView;
@property (weak, nonatomic) IBOutlet HRColorPickerView *colorPickerView;
@property(copy,nonatomic) ConfirmSelectedBlock confirmSelectedBlock;
@end
@implementation ZYXRGBColorSelectView
-(void)initData{
    
}
- (IBAction)confirmBtnClicked:(id)sender {
    if(self.confirmSelectedBlock){
        self.confirmSelectedBlock(self,self.colorPickerView.color);
    }
    [self closeView];
}

-(void)initUI{
    self.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
    self.frame = [[UIScreen mainScreen] bounds];
    
    [self.customBackgroundView addSingleTapGetureWithBlock:^(UITapGestureRecognizer *tapGeture) {
        [self closeView];
    }];
    
    [self.colorPickerView addTarget:self
                             action:@selector(colorDidChanged:)
                   forControlEvents:UIControlEventValueChanged];
}
- (void)colorDidChanged:(HRColorPickerView *)pickerView {
    
}

-(void)popView{
    GWRootNavigationViewController * lastNvc = [[GWRootNavigationViewController navitionVCArray] lastObject];
    UIView * superView = [lastNvc.viewControllers.lastObject view];
    self.centerY = superView.height/2.0;
    [superView addSubview:self];
}
-(void)closeView{
    [self removeFromSuperview];
}
+(ZYXRGBColorSelectView *)shareInstance{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareIntance = [ZYXRGBColorSelectView loadFromXib];
    });
    return shareIntance;
}
+(void)closeView{
    ZYXRGBColorSelectView * view = [ZYXRGBColorSelectView shareInstance];
    [view closeView];
}
+(void)popViewConfirmSelectedBlock:(ConfirmSelectedBlock)confirmSelectedBlock{
    ZYXRGBColorSelectView * view = [ZYXRGBColorSelectView shareInstance];
    [view setConfirmSelectedBlock:confirmSelectedBlock];
    [view popView];
}

@end
