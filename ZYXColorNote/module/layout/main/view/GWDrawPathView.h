//
//  ZYXCutPathView.h
//  TourNote
//
//  Created by 极客天地 on 2017/2/22.
//  Copyright © 2017年 极客天地. All rights reserved.
//

#import "GWPathLine.h"
#import "GWImageLine.h"
#import "StrokeBrushModel.h"
@interface GWDrawPathView : RootCustomView

@property (strong,nonatomic)UIImage * backgroundImage;

@property (strong,nonatomic)StrokeBrushModel * strokeBrushModel;
//撤销
-(void)revoke;
//恢复
-(void)recovery;
//清除所有
-(void)clearAllStroke;
@end
