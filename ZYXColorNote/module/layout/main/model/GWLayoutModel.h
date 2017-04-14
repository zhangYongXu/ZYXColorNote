//
//  GWLayoutModel.h
//  TourNote
//
//  Created by 极客天地 on 17/1/16.
//  Copyright © 2017年 极客天地. All rights reserved.
//

#import "GWRootModel.h"
#import "GWElementModel.h"
@interface GWLayoutModel : GWRootModel
@property(copy,nonatomic)NSString * layoutWidth;
@property(copy,nonatomic)NSString * layoutHeight;
@property(copy,nonatomic)NSString * backgroundID;
@property(copy,nonatomic)NSString * backgroundName;
@property(copy,nonatomic)NSString * strokeViewImageBase64String;

-(CGFloat)toCurrentScrrenPercent;

@property(strong,nonatomic)NSMutableArray<GWElementModel*>* elementArray;
@end
