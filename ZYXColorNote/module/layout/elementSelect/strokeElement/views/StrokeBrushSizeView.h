//
//  StrokeBrushSizeView.h
//  TourNote
//
//  Created by 极客天地 on 2017/3/1.
//  Copyright © 2017年 极客天地. All rights reserved.
//

#import "GWRootCustomView.h"
@class StrokeBrushSizeView;
typedef void (^StrokeBrushSizeDidSelectedBlock)(void);
typedef void (^StrokeBrushSizeStyleClickedBlock)(void);
typedef void (^StrokeBrushSizeUpOrDownClickedBlock)(StrokeBrushSizeView *view,UIButton * button);
@interface StrokeBrushSizeView : GWRootCustomView
@property(assign,nonatomic)NSInteger strokeBrushSize;

@property(copy,nonatomic)StrokeBrushSizeDidSelectedBlock strokeBrushSizeDidSelectedBlock;
-(void)setStrokeBrushSizeDidSelectedBlock:(StrokeBrushSizeDidSelectedBlock)strokeBrushSizeDidSelectedBlock;

@property(copy,nonatomic)StrokeBrushSizeStyleClickedBlock strokeBrushSizeStyleClickedBlock;
-(void)setStrokeBrushSizeStyleClickedBlock:(StrokeBrushSizeStyleClickedBlock)strokeBrushSizeStyleClickedBlock;

@property(copy,nonatomic)StrokeBrushSizeUpOrDownClickedBlock strokeBrushSizeUpOrDownClickedBlock;
-(void)setStrokeBrushSizeUpOrDownClickedBlock:(StrokeBrushSizeUpOrDownClickedBlock)strokeBrushSizeUpOrDownClickedBlock;
@end
