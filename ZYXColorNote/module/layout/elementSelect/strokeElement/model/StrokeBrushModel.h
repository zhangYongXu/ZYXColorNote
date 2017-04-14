//
//  StrokeModel.h
//  TourNote
//
//  Created by 极客天地 on 2017/3/1.
//  Copyright © 2017年 极客天地. All rights reserved.
//

typedef NS_ENUM(NSInteger,StrokeBrushTypes) {
    StrokeBrushTypeColorBrush = 0,//颜色笔刷
    StrokeBrushTypeImageBrush = 1 //图案笔刷
};
@interface StrokeBrushModel : RootModel
@property(strong,nonatomic) NSString * strokeBrushID;
@property(strong,nonatomic) NSString * strokeBrushName;
@property(strong,nonatomic) NSString * showImagePath;
@property(assign,nonatomic) StrokeBrushTypes strokeBrushType;
@property(strong,nonatomic) NSString * strokeBrushTypeStr;
@property(assign,nonatomic) NSInteger StrokeBrushSize;
//颜色
@property(strong,nonatomic) UIColor * strokeBrushColor;
//图案
@property(strong,nonatomic) NSMutableArray<NSString*> * strokeImagePathArray;
@end
