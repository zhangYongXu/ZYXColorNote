//
//  BmobHttpSessionManager.m
//  RealMall
//
//  Created by 极客天地 on 2018/2/2.
//  Copyright © 2018年 极客天地. All rights reserved.
//

#import "BmobHttpSessionManager.h"

#import "BmobNetWorkConfig.h"

@implementation BmobHttpSessionManager
+ (instancetype)sessionManager {
    static BmobHttpSessionManager *mySessionManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mySessionManager = [[BmobHttpSessionManager alloc] initWithBaseURL:[NSURL URLWithString:BmobBaseUrl]];
        mySessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        [mySessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [mySessionManager.requestSerializer setValue:XBmobApplicationId forHTTPHeaderField:@"X-Bmob-Application-Id"];
        [mySessionManager.requestSerializer setValue:XBmobRESTAPIKey forHTTPHeaderField:@"X-Bmob-REST-API-Key"];
        //解决delete方式后台接受不到数据问题
        mySessionManager.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithObjects:@"GET", @"HEAD", nil];
    });
    return mySessionManager;
}
+(NSDictionary*)bmobBaseHeader{
    NSLog(@"BmobBaseRequestHeaderJsonString:%@",BmobBaseRequestHeaderJsonString);
    NSData *jsonData = [BmobBaseRequestHeaderJsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    return dict;
}

@end
