//
//  GWLayoutElementViewTextField.m
//  TourNote
//
//  Created by 极客天地 on 17/1/13.
//  Copyright © 2017年 极客天地. All rights reserved.
//

#import "GWLayoutElementViewLabel.h"
#import "GWLabel.h"
#import "LayoutInputTextViewController.h"
@interface GWLayoutElementViewLabel()
@property (weak, nonatomic) IBOutlet GWLabel *label;
@property (strong,nonatomic) ZYXFontModel * fontModel;

@end
@implementation GWLayoutElementViewLabel
-(GWLayoutElementViewTypes)elementViewType{
    return GWLayoutElementViewTypeLabel;
}
-(NSString *)text{
    return self.label.text;
}
-(void)setText:(NSString *)text{
    self.label.text = text;
}
-(void)initUI{
    [super initUI];
    self.label.frame = self.contentView.bounds;
    [self.contentView addSubview:self.label];
    self.tipString = @"双击编辑文本";
    self.label.text = self.tipString;
}
-(GWElementModel *)elementModel{
    GWElementModel * elementModel = [super elementModel];
    
    elementModel.elementText = self.text;
    elementModel.elementTextHXColor = [UIColor changeToHexStringWithUIColor: self.label.textColor];
    elementModel.elementTextFontName = self.label.font.fontName;
    elementModel.elementTextFontID = self.fontModel.fontID;
    
    return elementModel;
}
-(void)refreshWithElementModel:(GWElementModel *)elementModel LyoutModel:(GWLayoutModel *)layoutModel{
    [super refreshWithElementModel:elementModel LyoutModel:layoutModel];
    self.text = elementModel.elementText;
    self.label.textColor = [UIColor colorWithHexString:elementModel.elementTextHXColor];
    NSString * fontID = elementModel.elementTextFontID;
    if(!STR_IS_NIL(fontID)){
        self.label.font = [ZYXFontViewModel fontWithFontID:elementModel.elementTextFontID fontSize:500];
        self.fontModel = [ZYXFontViewModel fontModelWithFontID:fontID];
    }
}
-(void)contentViewDoubleTap:(UITapGestureRecognizer *)doubleTapGesure{
    [super contentViewDoubleTap:doubleTapGesure];
    [self showInputText];
    
}
-(void)showInputText{
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"TabLayout" bundle:[NSBundle mainBundle]];
    GWRootNavigationViewController * nvc = [storyboard instantiateViewControllerWithIdentifier:@"LayoutInputTextViewController_SBID"];
    LayoutInputTextViewController * lvc = nvc.viewControllers.lastObject;
    if(![self.label.text isEqualToString:self.tipString]){
        lvc.text = self.label.text;
    }
    lvc.color = self.label.textColor;
    lvc.font = self.label.font;
    [lvc setLayoutInputCompleteBlock:^(LayoutInputTextViewController *inputVc, NSString *text, UIColor *color,UIFont * font,ZYXFontModel * fontModel) {
        if(!STR_IS_NIL(text)){
            self.text = text;
        }
        self.label.textColor = color;
        self.label.font = font;
        self.fontModel = fontModel;
        
        [self elementModel];
        if(!STR_IS_NIL(text)){
            if(self.elementViewDidEditedTextBlock){
                self.elementViewDidEditedTextBlock(self);
            }
        }
        
    }];
    [APPDelegate.window.rootViewController presentViewController:nvc animated:YES completion:^{
        
    }];
}
@end
