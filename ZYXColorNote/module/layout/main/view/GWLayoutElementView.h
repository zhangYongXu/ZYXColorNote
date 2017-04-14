//
//  GWLayoutElementView.h
//  TourNote
//
//  Created by 极客天地 on 17/1/13.
//  Copyright © 2017年 极客天地. All rights reserved.
//

#import "GWRootCustomView.h"
#import "GWElementModel.h"
#import "GWLayoutModel.h"
#define GWLayoutElementViewHandleAddWidth 30
typedef NS_ENUM(NSInteger,GWLayoutElementViewTypes) {
    GWLayoutElementViewTypeDefault = 0,
    GWLayoutElementViewTypeLabel = 1,
    GWLayoutElementViewTypeImage = 2,
    GWLayoutElementViewTypePaster = 3
};
@class GWLayoutElementView;
typedef void (^CloseBtnClickedBlock)(GWLayoutElementView * elementView,UIButton*button);
typedef void (^SingleTapGestureBlock)(GWLayoutElementView * elementView,UITapGestureRecognizer* singleTapGesture);
typedef void (^DoubleTapGestureBlock)(GWLayoutElementView * elementView,UITapGestureRecognizer* doubleTapGesture);
@interface GWLayoutElementView : GWRootCustomView
@property(assign,nonatomic) BOOL isFocusing;
@property(assign,nonatomic) BOOL enableEditing;
@property(assign,nonatomic) NSString * tipString;
@property(assign,nonatomic,readonly)GWLayoutElementViewTypes elementViewType;
@property(strong,nonatomic,readonly)GWElementModel * elementModel;

-(void)refreshWithElementModel:(GWElementModel*)elementModel LyoutModel:(GWLayoutModel*)layoutModel;

@property(copy,nonatomic)CloseBtnClickedBlock closeBtnClickedBlock;
-(void)setCloseBtnClickedBlock:(CloseBtnClickedBlock)closeBtnClickedBlock;

@property(copy,nonatomic)SingleTapGestureBlock singleTapGestureBlock;
-(void)setSingleTapGestureBlock:(SingleTapGestureBlock)singleTapGestureBlock;

@property(copy,nonatomic)DoubleTapGestureBlock doubleTapGestureBlock;
-(void)setDoubleTapGestureBlock:(DoubleTapGestureBlock)doubleTapGestureBlock;

-(void)contentViewDoubleTap:(UITapGestureRecognizer*)doubleTapGesure;

@property(strong,nonatomic,readonly) UIView * contentView;

//关闭UIView的userInteractionEnabled
-(void)handleUserInteractionEnabled:(BOOL)enabled;
@end
