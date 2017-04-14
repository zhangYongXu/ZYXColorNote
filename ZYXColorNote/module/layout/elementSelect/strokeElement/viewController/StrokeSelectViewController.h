//
//  StrokeSelectViewController.h
//  TourNote
//
//  Created by 极客天地 on 2017/3/1.
//  Copyright © 2017年 极客天地. All rights reserved.
//

#import "GWRootViewController.h"
#import "StrokeBrushViewModel.h"
typedef void (^StrokeBrushDidSelectedBlock)(StrokeBrushModel * strokeBrushModel);
@interface StrokeSelectViewController : GWRootViewController
@property(copy,nonatomic) StrokeBrushDidSelectedBlock strokeBrushDidSelectedBlock;
-(void)setStrokeBrushDidSelectedBlock:(StrokeBrushDidSelectedBlock)strokeBrushDidSelectedBlock;
@end
