//
//  BmobHttpApiGet.m
//  RealMall
//
//  Created by 极客天地 on 2018/2/2.
//  Copyright © 2018年 极客天地. All rights reserved.
//

#import "BmobHttpApiGet.h"


@interface BmobHttpApiGet()

@end@implementation BmobHttpApiGet

/**
 *  用bql语句查询bmob平台上数据 异步
 *
 *  @param bql          bql语句
 *  @param show         是否显示加载提示
 *  @param sucessBlock  成功回调
 *  @param failedBlock  失败回调
 */
+ (void)getDataWithBql:(NSString*)bql showProgress:(BOOL)show sucess:(BmobArraySucessBlock)sucessBlock failed:(BmobStringFailedBlock)failedBlock {
    NSString * url = [NSString stringWithFormat:@"1/cloudQuery?bql=%@",bql];
    NSString * encodeUrl = [url urlEncodeString];
    [BmobNetWork getHttp:encodeUrl parameters:nil showProgress:show sucess:^(NSDictionary* responseObj) {
        NSArray * resultsArray = responseObj[@"results"];
        if(sucessBlock){
            sucessBlock(resultsArray);
        }
    } failed:^(NSString *errorMsg) {
        if(failedBlock){
            failedBlock(errorMsg);
        }
    }];
}
/**
 *  用bql语句查询bmob平台上数据 同步
 *
 *  @param bql          bql语句
 */
+ (NSArray*)getDataWithBql:(NSString*)bql{
    NSString * urlStr = [NSString stringWithFormat:@"%@1/cloudQuery?bql=%@",BmobBaseUrl,bql];
    NSString * encodeUrl = [urlStr urlEncodeString];
    
    NSMutableURLRequest * request = [BmobNetWork getUrlRequestWithMethod:@"get" Path:encodeUrl NSTimeInterval:10];
    NSDictionary* responseObj = [BmobNetWork requestSystemHttpByURLRequest:request];
    NSArray * array = responseObj[@"results"];
    return array;
}

@end
