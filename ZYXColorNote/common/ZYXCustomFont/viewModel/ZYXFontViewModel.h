//
//  ZYXFontViewModel.h
//  TourNote
//
//  Created by 极客天地 on 2017/2/6.
//  Copyright © 2017年 极客天地. All rights reserved.
//

#import "GWRootViewModel.h"
#import "ZYXFontModel.h"
@interface ZYXFontViewModel : GWRootViewModel


@property(strong,nonatomic)NSMutableArray<ZYXFontModel*> * modelArray;
/**
 *  请求所有自定义字体数据
 *
 *  @param successBlokc 成功回调
 *  @param faildBlock   失败回调
 */
-(void)requestAllCustomFontDataWithSuccessBlock:(YXSuccessBlock)successBlokc FaildBlock:(YXFaildBlock)faildBlock;
/**
 *  请求自定义字体文件
 *
 *  @param fontModel    字体模型
 *  @param successBlokc 成功回调
 *  @param faildBlock   失败回调
 */
-(void)downloadFontFileDataWithFontModel:(ZYXFontModel*)fontModel SuccessBlock:(YXSuccessBlock)successBlokc FaildBlock:(YXFaildBlock)faildBlock;

+(ZYXFontViewModel *)shareInstance;
+(UIFont*)fontWithFontID:(NSString*)fontID fontSize:(NSInteger)fontSize;
+(ZYXFontModel *)fontModelWithFontID:(NSString *)fontID;
@end
