//
//  GWElementModel.h
//  TourNote
//
//  Created by 极客天地 on 17/1/16.
//  Copyright © 2017年 极客天地. All rights reserved.
//

#import "GWRootModel.h"

@interface GWElementModel : GWRootModel
@property(copy,nonatomic)NSString * elementWidth;
@property(copy,nonatomic)NSString * elementHeight;
@property(copy,nonatomic)NSString * elementCenterX;
@property(copy,nonatomic)NSString * elementCenterY;
@property(copy,nonatomic)NSString * elementRoateAngle;
@property(copy,nonatomic)NSString * elementLayerRank;
@property(copy,nonatomic)NSString * elementType;
@property(copy,nonatomic)NSString * elementTypeStr;
//文本
@property(copy,nonatomic)NSString * elementText;
@property(copy,nonatomic)NSString * elementTextHXColor;
@property(copy,nonatomic)NSString * elementTextFontID;
@property(copy,nonatomic)NSString * elementTextFontName;
//图片
@property(copy,nonatomic)NSString * elementImageUrl;
@property(copy,nonatomic)NSString * elementPicImageBase64String;
//贴图
@property(copy,nonatomic)NSString * elementPasterSetName;
@property(copy,nonatomic)NSString * elementPasterID;

@end
