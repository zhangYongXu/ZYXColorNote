//
//  StrokeBrushViewModel.h
//  TourNote
//
//  Created by 极客天地 on 2017/3/1.
//  Copyright © 2017年 极客天地. All rights reserved.
//

#import "StrokeBrushModel.h"

@interface StrokeBrushViewModel : RootViewModel
@property(strong,nonatomic) NSMutableArray<StrokeBrushModel*> * colorBrushModelArray;
@property(strong,nonatomic) NSMutableArray<StrokeBrushModel*> * imageBrushModelArray;
@end
