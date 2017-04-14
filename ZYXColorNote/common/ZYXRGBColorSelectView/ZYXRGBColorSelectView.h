//
//  ZYXRGBColorSelectView.h
//  TourNote
//
//  Created by 极客天地 on 17/1/20.
//  Copyright © 2017年 极客天地. All rights reserved.
//

#import "GWRootCustomView.h"
@class ZYXRGBColorSelectView;
typedef void (^ConfirmSelectedBlock)(ZYXRGBColorSelectView * view,UIColor* color);
@interface ZYXRGBColorSelectView : GWRootCustomView
+(void)closeView;
+(void)popViewConfirmSelectedBlock:(ConfirmSelectedBlock)confirmSelectedBlock;
@end
