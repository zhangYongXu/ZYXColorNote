//
//  BmobHttpApiGet.h
//  RealMall
//
//  Created by 极客天地 on 2018/2/2.
//  Copyright © 2018年 极客天地. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BmobNetWork.h"

@interface BmobHttpApiGet : NSObject
/**
 *  用bql语句查询bmob平台上数据
 *
 *  @param bql          bql语句
 *  @param show         是否显示加载提示
 *  @param sucessBlock  成功回调
 *  @param failedBlock  失败回调
 */
+ (void)getDataWithBql:(NSString*)bql showProgress:(BOOL)show sucess:(BmobArraySucessBlock)sucessBlock failed:(BmobStringFailedBlock)failedBlock;

/**
 *  用bql语句查询bmob平台上数据 同步
 *
 *  @param bql          bql语句
 */
+ (NSArray*)getDataWithBql:(NSString*)bql;
@end
