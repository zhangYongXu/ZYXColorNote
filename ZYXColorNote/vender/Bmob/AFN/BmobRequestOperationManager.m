//
//  BmobRequestOperationManager.m
//  RealMall
//
//  Created by 极客天地 on 2018/2/2.
//  Copyright © 2018年 极客天地. All rights reserved.
//

#import "BmobRequestOperationManager.h"

#import "BmobNetWorkConfig.h"

@implementation BmobRequestOperationManager
+ (instancetype)operationManager {
    static BmobRequestOperationManager *myManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        myManager = [[BmobRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:BmobBaseUrl]];
    });
    return myManager;
}
+(NSDictionary*)bmobBaseHeader{
    NSLog(@"BmobBaseRequestHeaderJsonString:%@",BmobBaseRequestHeaderJsonString);
    NSData *jsonData = [BmobBaseRequestHeaderJsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    return dict;
}
@end
