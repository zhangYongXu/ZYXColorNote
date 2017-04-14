//
//  LayoutInputTextViewController.h
//  TourNote
//
//  Created by 极客天地 on 17/1/16.
//  Copyright © 2017年 极客天地. All rights reserved.
//

#import "GWRootViewController.h"
@class LayoutInputTextViewController;
typedef void (^LayoutInputCompleteBlock)(LayoutInputTextViewController* inputVc, NSString* text,UIColor * color,UIFont * font,ZYXFontModel * fontModel);
@interface LayoutInputTextViewController : GWRootViewController
@property(strong,nonatomic)NSString* text;
@property(strong,nonatomic)UIColor* color;
@property(strong,nonatomic)UIFont* font;


@property(copy,nonatomic)LayoutInputCompleteBlock layoutInputCompleteBlock;
-(void)setLayoutInputCompleteBlock:(LayoutInputCompleteBlock)layoutInputCompleteBlock;
@end
