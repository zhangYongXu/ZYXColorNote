//
//  BmobHttpApiPost.m
//  RealMall
//
//  Created by 极客天地 on 2018/2/2.
//  Copyright © 2018年 极客天地. All rights reserved.
//

#import "BmobHttpApiPost.h"

@interface BmobHttpApiPost()

@end@implementation BmobHttpApiPost
/**
 *  添加数据
 *
 *  @param item         添加的对象
 *  @param show         是否显示加载提示
 *  @param sucessBlock  成功回调
 *  @param failedBlock  失败回调
 */
+ (void)addDataWithBmobHttpApiAddItem:(BmobHttpApiAddItem*)item showProgress:(BOOL)show sucess:(BmobDictionarySucessBlock)sucessBlock failed:(BmobStringFailedBlock)failedBlock {
    NSString * url = [NSString stringWithFormat:@"1/classes/%@",item.tableName];
    NSLog(@"addDataWithBmobHttpApiAddItem tableName:%@ dataDictJson:%@",item.tableName,[NSString jsonStringWithDictionary:item.addRequestDict]);
    [BmobNetWork postHttp:url parameters:item.addRequestDict showProgress:YES sucess:^(id responseObj) {
        NSLog(@"addDataWithBmobHttpApiAddItem responseObj:%@",responseObj);
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
@implementation BmobHttpApiAddItem
-(NSDictionary *)addRequestDict{
    NSMutableDictionary * reqeustDcit = [[NSMutableDictionary alloc] initWithDictionary:self.dataDict];
    for(BmobHttpApiAddItemPoint * point in self.pointArray){
        [reqeustDcit addEntriesFromDictionary:point.addRequestDict];
    }
    return reqeustDcit;
}
@end
@implementation BmobHttpApiAddItemPoint
-(NSDictionary *)addRequestDict{
    return @{
                 self.pointFeildName:@{
                     @"__type":@"Pointer",
                     @"className":self.tableName,
                     @"objectId":self.objectId
                 }
             };
}
@end

