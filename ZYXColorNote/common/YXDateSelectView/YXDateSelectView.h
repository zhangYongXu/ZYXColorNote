//
//  YXDateSelectView.h
//  JiaMen
//
//  Created by 拓之林 on 16/6/23.
//  Copyright © 2016年 拓之林. All rights reserved.
//

#import "GWRootCustomView.h"
@class YXDateSelectView;
typedef void (^YXDateSelectConfirmBlock)(YXDateSelectView * dateSelectView,NSDate * date);
@interface YXDateSelectView : GWRootCustomView<GWRootCustomViewProtocol>


-(void)initViewWithDateSelectConfirmBlock:(YXDateSelectConfirmBlock)dateSelectConfirmBlock;
-(void)showDateSelectViewAnimation:(BOOL)isAnimation;
-(void)hiddenDateSelectViewAnimation:(BOOL)isAnimation;
@end
