//
//  ZYXRGBColorSelectView.h
//  TourNote
//
//  Created by 极客天地 on 17/1/20.
//  Copyright © 2017年 极客天地. All rights reserved.
//

#import "GWRootCustomView.h"
#import "ZYXFontViewModel.h"
@class ZYXCustomFontSelectView;
typedef void (^FontConfirmSelectedBlock)(ZYXCustomFontSelectView * view,ZYXFontModel* fontModel);
@interface ZYXCustomFontSelectView : GWRootCustomView
+(void)closeView;
+(void)popViewConfirmSelectedBlock:(FontConfirmSelectedBlock)confirmSelectedBlock;
@end
