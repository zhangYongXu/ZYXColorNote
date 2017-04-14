//
//  GWLayoutModel.m
//  TourNote
//
//  Created by 极客天地 on 17/1/16.
//  Copyright © 2017年 极客天地. All rights reserved.
//

#import "GWLayoutModel.h"
@interface GWLayoutModel()
@property(copy,nonatomic) NSString * percent;
@end
@implementation GWLayoutModel
@synthesize elementArray = _elementArray;
-(NSMutableArray<GWElementModel *> *)elementArray{
    if(nil == _elementArray){
        _elementArray = [[NSMutableArray alloc] init];
    }
    return _elementArray;
}
-(void)setElementArray:(NSMutableArray<GWElementModel *> *)elementArray{
    if([elementArray.lastObject isKindOfClass:[NSDictionary class]]){
        _elementArray = [GWElementModel modelArrayFromDictArray:elementArray];
    }else{
        _elementArray = elementArray;
    }
}
-(CGFloat)toCurrentScrrenPercent{
    if(nil == _percent){
        CGFloat width = [self.layoutWidth floatValue];
        CGFloat cPercent = (SCREEN_WIDTH_PX/width);
        _percent = [NSString stringWithFormat:@"%@",@(cPercent)];
    }
    return [self.percent floatValue];
}
@end
