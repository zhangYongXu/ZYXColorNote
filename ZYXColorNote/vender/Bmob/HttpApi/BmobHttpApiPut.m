//
//  BmobHttpApiPut.m
//  ZYXColorNote
//
//  Created by 极客天地 on 2018/2/6.
//  Copyright © 2018年 极客天地. All rights reserved.
//

#import "BmobHttpApiPut.h"

@implementation BmobHttpApiPut
/**
 *  修改数据
 *
 *  @param item         修改的对象
 *  @param show         是否显示加载提示
 *  @param sucessBlock  成功回调
 *  @param failedBlock  失败回调
 */
+ (void)updateDataWithBmobHttpApiUpdateItem:(BmobHttpApiUpdateItem*)item showProgress:(BOOL)show sucess:(BmobDictionarySucessBlock)sucessBlock failed:(BmobStringFailedBlock)failedBlock {
    NSString * url = [NSString stringWithFormat:@"1/classes/%@/%@",item.tableName,item.objectId];
    NSLog(@"updateDataWithBmobHttpApiUpdateItem url:%@ dataDictJson:%@",url,[NSString jsonStringWithDictionary:item.updateDataDict]);
    [BmobNetWork putSystemHttp:url parameters:item.updateDataDict showProgress:show sucess:^(id responseObj) {
        NSLog(@"updateDataWithBmobHttpApiUpdateItem responseObj:%@",responseObj);
        if(sucessBlock){
            sucessBlock(responseObj);
        }
    } failed:^(NSString *errorMsg) {
        if(failedBlock){
            failedBlock(errorMsg);
        }
    }];
}
@end
@implementation BmobHttpApiUpdateItem

@end
