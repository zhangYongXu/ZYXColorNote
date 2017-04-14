//
//  GWLayoutScorllView.h
//  TourNote
//
//  Created by 极客天地 on 17/1/13.
//  Copyright © 2017年 极客天地. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GWLayoutViewModel.h"
#import "BackgroundViewModel.h"
#import "StrokeBrushViewModel.h"
#import "GWLayoutElementView.h"

#import "GWDrawPathView.h"
@interface GWLayoutScorllView : UIScrollView
@property(assign,nonatomic,readonly)CGFloat maxLayoutHeight;//最大高度
//画笔视图
@property(strong,nonatomic,readonly)GWDrawPathView * strokeView;
//背景视图
@property(strong,nonatomic,readonly)UIView * backgroundView;

@property (strong,nonatomic)GWLayoutViewModel * layoutViewModel;


@property (strong,nonatomic)BackgroundModel * backgroundModel;
@property (strong,nonatomic)StrokeBrushModel * strokeBrushModel;

//撤销路径
-(void)strokeRevoke;
//恢复路径
-(void)strokeRecovery;

//元素 到底层
-(void)sendToBottomLayerWithElementView:(GWLayoutElementView*)elementView;
//元素 到顶层
-(void)sendToTopLayerWithElementView:(GWLayoutElementView*)elementView;
//元素 到上一层
-(void)sendToUpLayerWithElementView:(GWLayoutElementView*)elementView;
//元素 到下一层
-(void)sendToDownLayerWithElementView:(GWLayoutElementView*)elementView;
//清除所有布局元素
-(void)clearAllElementViews;
@end
