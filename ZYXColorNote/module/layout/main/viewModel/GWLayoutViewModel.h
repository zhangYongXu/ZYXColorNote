//
//  GWLayoutViewModel.h
//  TourNote
//
//  Created by 极客天地 on 17/1/16.
//  Copyright © 2017年 极客天地. All rights reserved.
//

#import "GWRootViewModel.h"
#import "GWLayoutModel.h"
#import "GWLayoutNetDataModel.h"
@interface GWLayoutViewModel : GWRootViewModel
@property(strong,nonatomic)GWLayoutModel * layoutModel;

@property(strong,nonatomic)NSMutableArray<GWLayoutNetDataModel*> * netLaoutDataArray;
@property(strong,nonatomic)NSMutableDictionary<NSString *,GWLayoutModel*>* layoutModelDict;

-(GWLayoutModel*)getLayoutModelWithLayoutNetDataModel:(GWLayoutNetDataModel*) netLayoutDataModel;

/**
 *  请求所有布局模板
 *
 *  @param successBlokc 成功回调
 *  @param faildBlock   失败回调
 */
-(void)requestAllLayoutDataWithSuccessBlock:(YXSuccessBlock)successBlokc FaildBlock:(YXFaildBlock)faildBlock;

/**
 *  请求网络布局模板文件
 *
 *  @param successBlokc 成功回调
 *  @param faildBlock   失败回调
 */
-(void)downloadNetLayoutDataWithLayoutNetDataModel:(GWLayoutNetDataModel*)layoutNetDataModel SuccessBlock:(YXSuccessBlock)successBlokc FaildBlock:(YXFaildBlock)faildBlock;
@end
