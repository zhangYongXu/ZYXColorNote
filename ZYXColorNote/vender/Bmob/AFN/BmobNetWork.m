//
//  BmobNetWork.m
//  RealMall
//
//  Created by 极客天地 on 2018/2/2.
//  Copyright © 2018年 极客天地. All rights reserved.
//

#import "BmobNetWork.h"
#import "BmobHttpSessionManager.h"
#import "BmobRequestOperationManager.h"
#import "Reachability.h"
@interface BmobNetWork()

@end@implementation BmobNetWork
+ (BOOL)isNetworkConnected
{
    
    Reachability* reachability = [Reachability reachabilityForInternetConnection];
    
    return [reachability currentReachabilityStatus] != NotReachable;
}
/**
 *  Post请求
 *
 *  @param path         请求路径
 *  @param par          请求参数
 *  @param show         是否显示加载提示
 *  @param sucessBlock  成功回调
 *  @param failedBlock  失败回调
 */
+ (void)postHttp:(NSString *)path parameters:(NSDictionary *)par showProgress:(BOOL)show sucess:(GGSucessBlock)sucessBlock failed:(GGFailedBlock)failedBlock{
    if(![self isNetworkConnected]){
        [SVProgressHUD showErrorWithStatus:@"网络未连接或网络连接异常"];
        return;
    }
    
    if (show) {
        [SVProgressHUD showWithStatus:nil];
    }
    [[BmobHttpSessionManager sessionManager] POST:path parameters:par success:^(NSURLSessionDataTask *task, id responseObject) {
        if(show){
            [SVProgressHUD dismiss];
        }
        
        if (responseObject) {
            if (sucessBlock) {
                sucessBlock(responseObject);
            }
        }else {
            if (failedBlock) {
                failedBlock(@"");
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (show) {
            [SVProgressHUD dismiss];
        }
        
        NSLog(@"BmobNetWork postHttp NSURLSessionDataTask is %@",task);
        if (failedBlock) {
            failedBlock(error.localizedDescription);
        }
    }];
}

/**
 *  get请求
 *
 *  @param path         请求路径
 *  @param par          请求参数
 *  @param show         是否显示加载提示
 *  @param sucessBlock  成功回调
 *  @param failedBlock  失败回调
 */
+ (void)getHttp:(NSString *)path parameters:(NSDictionary *)par showProgress:(BOOL)show sucess:(GGSucessBlock)sucessBlock failed:(GGFailedBlock)failedBlock {
    
    if(![self isNetworkConnected]){
        [SVProgressHUD showErrorWithStatus:@"网络未连接或网络连接异常"];
        return;
    }
    if (show) {
        [SVProgressHUD showWithStatus:nil];
    }
    [[BmobHttpSessionManager sessionManager] GET:path parameters:par success:^(NSURLSessionDataTask *task, id responseObject) {
        if(show){
            [SVProgressHUD dismiss];
        }
        if (responseObject) {
            if (sucessBlock) {
                sucessBlock(responseObject);
            }
        }else {
            if (failedBlock) {
                failedBlock(@" ");
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if(show){
            [SVProgressHUD dismiss];
        }
        NSDictionary *errorDict = nil;
        [SVProgressHUD showErrorWithStatus:@"无法连接到服务器"];
        NSLog(@"BmobNetWork getHttp NSURLSessionDataTask is %@",task);
        if (failedBlock) {
            failedBlock([NSString stringWithFormat:@"%@", [errorDict objectForKey:@"code"]]);
        }
    }];
}
/**
 *  创建request
 *
 *  @param method       请求方式
 *  @param path         请求路径
 *  @param param        请求参数
 */
+(NSMutableURLRequest *)getUrlRequestWithMethod:(NSString *)method Path:(NSString *)path DicParam:(NSDictionary *)param{
    AFHTTPRequestSerializer * requestSerializer = [[AFHTTPRequestSerializer alloc] init];
    NSError *serializationError = nil;
    NSMutableURLRequest * request = [requestSerializer requestWithMethod:method URLString:path parameters:param error:&serializationError];
    NSDictionary * header = [BmobRequestOperationManager bmobBaseHeader];
    for(NSString * key in header.allKeys){
        NSString * value = header[key];
        [request setValue:value forHTTPHeaderField:key];
    }
    return request;
}
/**
 *  创建request系统方法
 *
 *  @param method       请求方式
 *  @param path         请求路径
 *  @param timeInterval 请求超时
 */
+(NSMutableURLRequest *)getUrlRequestWithMethod:(NSString *)method Path:(NSString *)path NSTimeInterval:(NSTimeInterval)timeInterval{
    NSURL * url = [NSURL URLWithString:path];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:timeInterval];
    NSDictionary * header = [BmobRequestOperationManager bmobBaseHeader];
    for(NSString * key in header.allKeys){
        NSString * value = header[key];
        [request setValue:value forHTTPHeaderField:key];
    }
    return request;
}
/**
 *  发起数据请求
 *
 *  @param request      请求体request
 *  @param show         是否显示加载提示
 *  @param sucessBlock  成功回调
 *  @param failedBlock  失败回调
 */
+ (void)requestHttpByURLRequest:(NSURLRequest *)request showProgress:(BOOL)show sucess:(GGSucessBlock)sucessBlock failed:(GGFailedBlock)failedBlock {
    
    if(![self isNetworkConnected]){
        [SVProgressHUD showErrorWithStatus:@"网络未连接或网络连接异常"];
        return;
    }
    
    BmobRequestOperationManager * manager = [BmobRequestOperationManager operationManager];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    if (show) {
        [SVProgressHUD showWithStatus:nil];
    }
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * headerFields = operation.response.allHeaderFields;
        NSString * ContentType = headerFields[@"Content-Type"];
        id resultObject = nil;
        if([ContentType rangeOfString:@"application/json"].location != NSNotFound){//json数据
            if([responseObject isKindOfClass:[NSData class]]){
                NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                resultObject = dict;
            }else{
                resultObject = responseObject;
            }
        }else{
            resultObject = responseObject;
        }
        if(show){
            [SVProgressHUD dismiss];
        }
        if(sucessBlock){
            sucessBlock(resultObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(show){
            [SVProgressHUD dismiss];
        }
        [SVProgressHUD showErrorWithStatus:@"无法连接到服务器"];
        NSLog(@"BmobNetWork requestHttpByURLRequest operation is %@",operation);
        if(failedBlock){
            failedBlock(error.description);
        }
    }];
    [manager.operationQueue addOperation:operation];
    
}
/**
 *  发起同步数据请求
 *
 *  @param request      请求体request
 */
+ (id)requestSystemHttpByURLRequest:(NSURLRequest *)request{
    
    if(![self isNetworkConnected]){
        [SVProgressHUD showErrorWithStatus:@"网络未连接或网络连接异常"];
        return nil;
    }
 
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * responseObject = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    id resultObject = nil;
    if(!error && [response isKindOfClass:[NSHTTPURLResponse class]] && response){
        NSDictionary * headerFields = [(NSHTTPURLResponse*)response allHeaderFields];
        NSString * ContentType = headerFields[@"Content-Type"];
        if([ContentType rangeOfString:@"application/json"].location != NSNotFound){//json数据
            if([responseObject isKindOfClass:[NSData class]]){
                NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                resultObject = dict;
            }else{
                resultObject = responseObject;
            }
        }else{
            resultObject = responseObject;
        }
    }else{
        [SVProgressHUD showErrorWithStatus:@"无法连接到服务器"];
        NSLog(@"BmobNetWork requestSystemHttpByURLRequest error is %@",error.description);
    }
    return resultObject;
}

/**
 *  delete请求
 *
 *  @param path         请求路径
 *  @param par          请求参数
 *  @param show         是否显示加载提示
 *  @param sucessBlock  成功回调
 *  @param failedBlock  失败回调
 */
+ (void)deleteHttp:(NSString *)path parameters:(NSDictionary *)par showProgress:(BOOL)show sucess:(GGSucessBlock)sucessBlock failed:(GGFailedBlock)failedBlock {
    
    if(![self isNetworkConnected]){
        [SVProgressHUD showErrorWithStatus:@"网络未连接或网络连接异常"];
        return;
    }
    if (show) {
        [SVProgressHUD showWithStatus:nil];
    }
    [[BmobHttpSessionManager sessionManager] DELETE:path parameters:par success:^(NSURLSessionDataTask *task, id responseObject) {
        if(show){
            [SVProgressHUD dismiss];
        }
        if (responseObject) {
            if (sucessBlock) {
                sucessBlock(responseObject);
            }
        }else {
            if (failedBlock) {
                failedBlock(@" ");
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if(show){
            [SVProgressHUD dismiss];
        }
        NSDictionary *errorDict = nil;
        [SVProgressHUD showErrorWithStatus:@"无法连接到服务器"];
        NSLog(@"BmobNetWork getHttp NSURLSessionDataTask is %@",task);
        if (failedBlock) {
            failedBlock([NSString stringWithFormat:@"%@", [errorDict objectForKey:@"code"]]);
        }
    }];
}

/**
 *  delete请求
 *
 *  @param path         请求路径
 *  @param par          请求参数
 *  @param show         是否显示加载提示
 *  @param sucessBlock  成功回调
 *  @param failedBlock  失败回调
 */
+ (void)deleteSystemHttp:(NSString *)path parameters:(NSDictionary *)par showProgress:(BOOL)show sucess:(GGSucessBlock)sucessBlock failed:(GGFailedBlock)failedBlock {
    
    if(![self isNetworkConnected]){
        [SVProgressHUD showErrorWithStatus:@"网络未连接或网络连接异常"];
        return;
    }
    if (show) {
        [SVProgressHUD showWithStatus:nil];
    }
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",BmobBaseUrl,path];
    NSURL * url = [NSURL ZYXURLWithString:urlStr];
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"delete";
    NSData * data = [NSJSONSerialization dataWithJSONObject:par options:NSJSONWritingPrettyPrinted error:nil];
    NSLog(@"deleteSystemHttp paramsJsonString:%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    request.HTTPBody = data;
    NSDictionary * header = [BmobRequestOperationManager bmobBaseHeader];
    for(NSString * key in header.allKeys){
        NSString * value = header[key];
        [request setValue:value forHTTPHeaderField:key];
    }
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if(show){
            [SVProgressHUD dismiss];
        }
        if(!connectionError){
            [SVProgressHUD showErrorWithStatus:@"无法连接到服务器"];
            NSLog(@"BmobNetWork getHttp connectionError is %@",connectionError);
            if (failedBlock) {
                failedBlock(connectionError.description);
            }
        }else{
            NSDictionary * dataDict = nil;
            if(data){
                dataDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            }
            if (sucessBlock) {
                sucessBlock(dataDict);
            }
        }
    }];
}

/**
 *  delete请求
 *
 *  @param path         请求路径
 */
+ (NSDictionary*)deleteSystemHttp:(NSString *)path{
    
    if(![self isNetworkConnected]){
        [SVProgressHUD showErrorWithStatus:@"网络未连接或网络连接异常"];
        return nil;
    }
    
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",BmobBaseUrl,path];
    NSURL * url = [NSURL ZYXURLWithString:urlStr];
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"delete";
    NSDictionary * header = [BmobRequestOperationManager bmobBaseHeader];
    for(NSString * key in header.allKeys){
        NSString * value = header[key];
        [request setValue:value forHTTPHeaderField:key];
    }
    NSError * error;
    NSData * responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    NSLog(@"responseData String:%@",[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
    if(error){
        return @{@"code":@"-1",@"errorMsg":error.description};
    }else{
        NSDictionary * responseDataDict = @{};
        if(responseData){
            responseDataDict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        }
        return @{@"code":@"1",@"responseDataDict":responseDataDict};;
    }
    
}
@end
