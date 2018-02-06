//
//  BmobHttpApiDelete.m
//  ZYXColorNote
//
//  Created by 极客天地 on 2018/2/5.
//  Copyright © 2018年 极客天地. All rights reserved.
//

#import "BmobHttpApiDelete.h"

@implementation BmobHttpApiDelete

/*{
    "requests": [
                 {
                     "method": "DELETE",
                     "token": "tokenValue",
                     "path": "/1/classes/TableName/objectId"
                 },
                 {
                     "method": "DELETE",
                     "token": "tokenValue",
                     "path": "/1/classes/TableName/objectId"
                 }
    ]
}
 */
/**
 *  删除数据
 *
 *  @param array        删除的对象
 *  @param show         是否显示加载提示
 *  @param sucessBlock  成功回调
 *  @param failedBlock  失败回调
 */
+ (void)deleteDataWithArray:(NSArray<BmobHttpApiDeleteItem*>*)array showProgress:(BOOL)show sucess:(BmobDictionarySucessBlock)sucessBlock failed:(BmobStringFailedBlock)failedBlock {
    if(show){
        [SVProgressHUD showWithStatus:nil];
    }
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSMutableArray * resultArray = [[NSMutableArray alloc] init];
        NSString * errorMsg = nil;
        for(BmobHttpApiDeleteItem * item in array){
            NSString * url = [NSString stringWithFormat:@"1/classes/%@/%@",item.tableName,item.objectId];
            NSDictionary * dict = [BmobNetWork deleteSystemHttp:url];
            NSInteger code = [dict[@"code"] integerValue];
            if(code != 1){
                errorMsg = dict[@"errorMsg"];
            }else{
                [resultArray addObject:dict];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if(show){
                [SVProgressHUD dismiss];
            }
            NSLog(@"deleteDataWithArray responseObj:%@",resultArray);
            if(!ARRAY_IS_EMPTY(resultArray)){
                if(sucessBlock){
                    sucessBlock(@{@"resultArray":resultArray});
                }
            }else{
                if(failedBlock){
                    failedBlock(errorMsg);
                }
            }
        });
    });

}

/**
 *  删除数据
 *
 *  @param item         删除的对象
 *  @param show         是否显示加载提示
 *  @param sucessBlock  成功回调
 *  @param failedBlock  失败回调
 */
+ (void)deleteDataWithBmobHttpApiDeleteItem:(BmobHttpApiDeleteItem*)item showProgress:(BOOL)show sucess:(BmobDictionarySucessBlock)sucessBlock failed:(BmobStringFailedBlock)failedBlock {
    NSString * url = [NSString stringWithFormat:@"1/classes/%@/%@",item.tableName,item.objectId];
    NSLog(@"deleteDataWithBmobHttpApiDeleteItem url:%@",url);
    [BmobNetWork deleteHttp:url parameters:nil showProgress:show sucess:^(id responseObj) {
        NSLog(@"deleteDataWithBmobHttpApiDeleteItem responseObj:%@",responseObj);
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

@implementation BmobHttpApiDeleteItem

@end
