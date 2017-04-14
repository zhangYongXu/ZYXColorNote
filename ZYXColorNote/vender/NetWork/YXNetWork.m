//
//  YXNetWork.m
//  YXNetWorkEngineV1.0
//
//  Created by Static Ga on 13-11-14.
//  Copyright (c) 2013年 Static Ga. All rights reserved.
//


#import "YXHTTPSessionManager.h"
#import "AFHTTPRequestOperation.h"
#import <CommonCrypto/CommonHMAC.h>
#import "SVProgressHUD.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFURLRequestSerialization.h"
#import "YXHTTPOperationManager.h"
#import "Reachability.h"



@implementation YXNetWork
+ (BOOL)isNetworkConnected
{
    
    Reachability* reachability = [Reachability reachabilityForInternetConnection];
    
    return [reachability currentReachabilityStatus] != NotReachable;
}

+(NSURLRequest *)getUrlRequestWithMethod:(NSString *)method Path:(NSString *)path DicParam:(NSDictionary *)param{
    AFHTTPRequestSerializer * requestSerializer = [[AFHTTPRequestSerializer alloc] init];
     NSError *serializationError = nil;
    NSMutableURLRequest * request = [requestSerializer requestWithMethod:method URLString:path parameters:param error:&serializationError];
    return request;
}
+ (void)requestHttpByURLRequest:(NSURLRequest *)request  sucess:(GGSucessBlock)sucessBlock failed:(GGFailedBlock)failedBlock {

    if(![self isNetworkConnected]){
        [SVProgressHUD showErrorWithStatus:@"网络未连接或网络连接异常"];
        return;
    }
    
    YXHTTPOperationManager * manager = [YXHTTPOperationManager operationManager];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(sucessBlock){
            sucessBlock(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failedBlock){
            failedBlock(error.description);
        }
    }];
    [manager.operationQueue addOperation:operation];
    
}


+ (void)postHttpEx:(NSString *)path parameters:(NSDictionary *)par start:(GGWillStartBlock)startLoad sucess:(GGSucessBlock)sucessBlock failed:(GGFailedBlockWithCode)failedBlock {
}

+ (void)postHttp:(NSString *)path parameters:(NSDictionary *)par sucess:(GGSucessBlock)sucessBlock
          failed:(GGFailedBlock)failedBlock {
    if(![self isNetworkConnected]){
        [SVProgressHUD showErrorWithStatus:@"网络未连接或网络连接异常"];
        return;
    }
    
    [[YXHTTPSessionManager sessionManager] POST:path parameters:par success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
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
        [SVProgressHUD dismiss];
        NSLog(@"NSURLSessionDataTask is %@",task);
        if (failedBlock) {
            failedBlock(error.localizedDescription);
        }
    }];
    [SVProgressHUD showWithStatus:nil maskType:4];

    
}
+ (void)postCustomeHttp:(NSString *)path parameters:(NSDictionary *)par showProgress:(BOOL)show sucess:(GGSucessBlock)sucessBlock failed:(GGFailedBlock)failedBlock{
    if(![self isNetworkConnected]){
        [SVProgressHUD showErrorWithStatus:@"网络未连接或网络连接异常"];
        return;
    }
    
    if (show) {
        [SVProgressHUD showWithStatus:nil maskType:4];
    }
    
    NSString * urlStr = [APPBaseURL stringByAppendingString:path];
    NSString * postStr = [NSString jsonStringWithDictionary:par];
    NSData * data = [postStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr]];
    request.HTTPBody = data;
    request.HTTPMethod = @"post";
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if(show){
            [SVProgressHUD dismiss];
        }
        if(data){
            NSError * error ;
            
            //NSString * string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            
            
            if (responseObject) {
                if (sucessBlock) {
                    sucessBlock(responseObject);
                }
            }else {
                if (failedBlock) {
                    failedBlock(@"");
                }
            }
        }else{
            [SVProgressHUD dismiss];
            if (failedBlock) {
                failedBlock(connectionError.description);
            }
        }
        
    }];
    
}
+ (void)postHttp:(NSString *)path parameters:(NSDictionary *)par showProgress:(BOOL)show sucess:(GGSucessBlock)sucessBlock failed:(GGFailedBlock)failedBlock
{
    if(![self isNetworkConnected]){
        [SVProgressHUD showErrorWithStatus:@"网络未连接或网络连接异常"];
        return;
    }
    
    if (show) {
        [SVProgressHUD showWithStatus:nil maskType:4];
    }
    [[YXHTTPSessionManager sessionManager] POST:path parameters:par success:^(NSURLSessionDataTask *task, id responseObject) {
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
        [SVProgressHUD dismiss];
        NSLog(@"NSURLSessionDataTask is %@",task);
        if (failedBlock) {
            failedBlock(error.localizedDescription);
        }
    }];

    
}
+ (void)postHttpWithErrorCode:(NSString *)path parameters:(NSDictionary *)par sucess:(GGSucessBlock)sucessBlock
          failed:(GGFailedBlockWithCode)failedBlock {
    if(![self isNetworkConnected]){
        [SVProgressHUD showErrorWithStatus:@"网络未连接或网络连接异常"];
        return;
    }
    
    [SVProgressHUD showWithStatus:nil maskType:4];
    [[YXHTTPSessionManager sessionManager] POST:path parameters:par success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if (responseObject) {
            id error = [responseObject objectForKey:@"error"];
            if (error) {
                id message = [error objectForKey:@"message"];
                NSNumber* errorCode = [error objectForKey:@"code"];
                if (errorCode) {
            
                    failedBlock([errorCode longValue], message);
                }else{
                    [SVProgressHUD showErrorWithStatus:@"未知错误！"];
                }
            }else {
                
                if (sucessBlock) {
                    sucessBlock(responseObject);
                }
            }
        }else {
            if (failedBlock) {
                failedBlock(-2, @"");
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"NSURLSessionDataTask is %@",task);
        if (failedBlock) {
            failedBlock(-1, error.localizedDescription);
        }

    }];
}


+ (void)getHttpEx:(NSString *)path parameters:(NSDictionary *)par start:(GGWillStartBlock)startBlock sucess:(GGSucessBlock)sucessBlock failed:(GGFailedBlockWithCode)failedBlock
{
    if (startBlock) {
        if(!startBlock()){
            failedBlock(-10, @"network busy!");
            return;
        };
    }
    if(![self isNetworkConnected]){
        [SVProgressHUD showErrorWithStatus:@"网络未连接或网络连接异常"];
        return;
    }
    
    [[YXHTTPSessionManager sessionManager] GET:path parameters:par success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        //处理status
        NSLog(@"responseObject %@",responseObject);
        if (responseObject) {
            if (sucessBlock) {
                sucessBlock(responseObject);
            }
        }else {
            if (failedBlock) {
                failedBlock(-2,@" ");
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        NSDictionary *errorDict = nil;
        [SVProgressHUD showErrorWithStatus:@"无法连接到服务器"];
        
        if (failedBlock) {
            failedBlock(-2,[NSString stringWithFormat:@"%@", [errorDict objectForKey:@"code"]]);
        }
    }];
}

+ (void)getHttp:(NSString *)path parameters:(NSDictionary *)par sucess:(GGSucessBlock)sucessBlock failed:(GGFailedBlock)failedBlock {
    
    if(![self isNetworkConnected]){
        [SVProgressHUD showErrorWithStatus:@"网络未连接或网络连接异常"];
        return;
    }
   
    [SVProgressHUD showWithStatus:nil maskType:4];
    [[YXHTTPSessionManager sessionManager] GET:path parameters:par success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        //处理status
        NSLog(@"responseObject %@",responseObject);
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
        [SVProgressHUD dismiss];
        NSDictionary *errorDict = nil;
        [SVProgressHUD showErrorWithStatus:@"无法连接到服务器"];
        
        if (failedBlock) {
            failedBlock([NSString stringWithFormat:@"%@", [errorDict objectForKey:@"code"]]);
        }
    }];
}
     
+ (void)getHttp:(NSString *)path parameters:(NSDictionary *)par showProgress:(BOOL)show sucess:(GGSucessBlock)sucessBlock failed:(GGFailedBlock)failedBlock {
    
    if(![self isNetworkConnected]){
        [SVProgressHUD showErrorWithStatus:@"网络未连接或网络连接异常"];
        return;
    }
    if (show) {
        [SVProgressHUD showWithStatus:nil maskType:4];
    }
    [[YXHTTPSessionManager sessionManager] GET:path parameters:par success:^(NSURLSessionDataTask *task, id responseObject) {
        if(show){
            [SVProgressHUD dismiss];
        }
        //处理status
        NSLog(@"responseObject %@",responseObject);
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
        [SVProgressHUD dismiss];
        NSDictionary *errorDict = nil;
        [SVProgressHUD showErrorWithStatus:@"无法连接到服务器"];
        
        if (failedBlock) {
            failedBlock([NSString stringWithFormat:@"%@", [errorDict objectForKey:@"code"]]);
        }
    }];
}
+ (void)getHttpWithErrorCode:(NSString *)path parameters:(NSDictionary *)par sucess:(GGSucessBlock)sucessBlock failed:(GGFailedBlockWithCode)failedBlock {
    if(![self isNetworkConnected]){
        [SVProgressHUD showErrorWithStatus:@"网络未连接或网络连接异常"];
        return;
    }
    
    
    [[YXHTTPSessionManager sessionManager] GET:path parameters:par success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        //处理status
        NSLog(@"responseObject %@",responseObject);
        if (responseObject) {
            if (sucessBlock) {
                sucessBlock(responseObject);
            }
        }else {
            if (failedBlock) {
                failedBlock(-1,@" ");
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        NSDictionary *errorDict = nil;
        [SVProgressHUD showErrorWithStatus:@"无法连接到服务器"];
        
        if (failedBlock) {
            failedBlock(-1,[NSString stringWithFormat:@"%@", [errorDict objectForKey:@"code"]]);
        }
    }];
}

+ (void)postSystemHttp:(NSString *)path showProgress:(BOOL)show sucess:(GGSucessBlock)sucessBlock failed:(GGFailedBlock)failedBlock
{
    if(![self isNetworkConnected]){
        [SVProgressHUD showErrorWithStatus:@"网络未连接或网络连接异常"];
        return;
    }
    
    if (show) {
        [SVProgressHUD showWithStatus:nil maskType:4];
    }
    
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",APPBaseURL,path];
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if(show){
            [SVProgressHUD dismiss];
        }
        if(connectionError){
            if (failedBlock) {
                failedBlock(connectionError.description);
            }
        }else{
            if(data){
                NSError * error = nil;
                NSDictionary * responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                if(error || DICTIONARY_IS_EMPTY(responseObject)){
                    if (failedBlock) {
                        failedBlock(@"解析数据出错");
                    }
                }else{
                    if (responseObject) {
                        if (sucessBlock) {
                            sucessBlock(responseObject);
                        }
                    }else {
                        if (failedBlock) {
                            failedBlock(@"");
                        }
                    }
                }
            }
        }
    }];
    
}
+ (void)postSystemHttp:(NSString *)path parameters:(NSDictionary*)parameters showProgress:(BOOL)show sucess:(GGSucessBlock)sucessBlock failed:(GGFailedBlock)failedBlock
{
    if(![self isNetworkConnected]){
        [SVProgressHUD showErrorWithStatus:@"网络未连接或网络连接异常"];
        return;
    }
    
    if (show) {
        [SVProgressHUD showWithStatus:nil maskType:4];
    }
    
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",APPBaseURL,path];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.HTTPMethod = @"post";
    NSString * parametersJsonString = [NSString jsonStringWithDictionary:parameters];
    NSData * parametersJsonData = [parametersJsonString dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = parametersJsonData;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if(show){
            [SVProgressHUD dismiss];
        }
        if(connectionError){
            if (failedBlock) {
                failedBlock(connectionError.description);
            }
        }else{
            if(data){
                NSError * error = nil;
                NSDictionary * responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                if(error || DICTIONARY_IS_EMPTY(responseObject)){
                    if (failedBlock) {
                        failedBlock(@"解析数据出错");
                    }
                }else{
                    if (responseObject) {
                        if (sucessBlock) {
                            sucessBlock(responseObject);
                        }
                    }else {
                        if (failedBlock) {
                            failedBlock(@"");
                        }
                    }
                }
            }
        }
    }];
    
}
+ (void)uploadFileWithFileData:(NSData*)fileData FileName:(NSString*)fileName showProgress:(BOOL)show ProgressBlock:(GGProgressBlock)progressBlock sucess:(GGSucessBlock)sucessBlock failed:(GGFailedBlock)failedBlock{
    BmobFile *file = [[BmobFile alloc] initWithFileName:fileName withFileData:fileData];
    [file saveInBackground:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            NSLog(@"image file1 url %@",file.url);
            if(sucessBlock){
                sucessBlock(file);
            }
        }else{
            if(failedBlock){
                failedBlock(@"文件上传失败了");
            }
        }
    } withProgressBlock:^(CGFloat progress) {
        NSLog(@"文件上传进度%.2f",progress);
        if(progressBlock){
            progressBlock(progress);
        }
    }];
}
+ (void)uploadImage:(UIImage*)image showProgress:(BOOL)show ProgressBlock:(GGProgressBlock)progressBlock sucess:(GGSucessBlock)sucessBlock failed:(GGFailedBlock)failedBlock{
    
    NSData * data = UIImagePNGRepresentation(image);
    NSString * name = [NSString stringWithFormat:@"%@.png",@([[NSDate date] timeIntervalSince1970])];

    BmobFile *file1 = [[BmobFile alloc] initWithFileName:name withFileData:data];
    [file1 saveInBackground:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            NSLog(@"image file1 url %@",file1.url);
            if(sucessBlock){
                sucessBlock(file1);
            }
        }else{
            if(failedBlock){
                failedBlock(@"图片上传失败了");
            }
        }
    } withProgressBlock:^(CGFloat progress) {
        if(progressBlock){
            progressBlock(progress);
        }
        NSLog(@"图片上传进度%.2f",progress);
    }];
}

+ (void)downloadFileWithUrlString:(NSString*)urlString ProgressBlock:(DownloadProgressBolck)progressBlock sucess:(GGSucessBlock)sucessBlock failed:(GGFailedBlock)failedBlock{
    //初始化队列
    NSOperationQueue *queue = [[NSOperationQueue alloc ]init];
    //下载地址
    NSURL *url = [NSURL URLWithString:urlString];
    //保存路径
    NSString * fileName = [NSString stringWithFormat:@"%@.file",[urlString md5]];
    NSString * filePath= [APPDelegate.documentDir stringByAppendingPathComponent:fileName];
    NSFileManager * FM = [NSFileManager defaultManager];
    if([FM fileExistsAtPath:filePath]){
        if(sucessBlock){
            sucessBlock(filePath);
        }
        return;
    }
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc]initWithRequest:[NSURLRequest requestWithURL:url]];
    op.outputStream = [NSOutputStream outputStreamToFileAtPath:filePath append:NO];
    // 根据下载量设置进度条的百分比
    [op setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        //CGFloat precent = (CGFloat)totalBytesRead / totalBytesExpectedToRead;
        if(progressBlock){
            progressBlock(bytesRead,totalBytesRead,totalBytesExpectedToRead);
        }
    }];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"下载成功");
        if(sucessBlock){
            sucessBlock(filePath);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"下载失败");
        if(failedBlock){
            failedBlock(error.description);
        }
    }];
    //开始下载
    [queue addOperation:op];
}

+ (void)downloadFileWithUrlString:(NSString*)urlString LocalFileCachePath:(NSString*)localFileCachePath ProgressBlock:(DownloadProgressBolck)progressBlock sucess:(GGSucessBlock)sucessBlock failed:(GGFailedBlock)failedBlock{
    //初始化队列
    NSOperationQueue *queue = [[NSOperationQueue alloc ]init];
    //下载地址
    NSURL *url = [NSURL URLWithString:urlString];
    //保存路径
    NSString * filePath= localFileCachePath;
    
    NSFileManager * FM = [NSFileManager defaultManager];
    if([FM fileExistsAtPath:filePath]){
        if(sucessBlock){
            sucessBlock(filePath);
        }
        return;
    }
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc]initWithRequest:[NSURLRequest requestWithURL:url]];
    op.outputStream = [NSOutputStream outputStreamToFileAtPath:filePath append:NO];
    // 根据下载量设置进度条的百分比
    [op setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        //CGFloat precent = (CGFloat)totalBytesRead / totalBytesExpectedToRead;
        if(progressBlock){
            progressBlock(bytesRead,totalBytesRead,totalBytesExpectedToRead);
        }
    }];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"下载成功");
        if(sucessBlock){
            sucessBlock(filePath);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"下载失败");
        if(failedBlock){
            failedBlock(error.description);
        }
    }];
    //开始下载
    [queue addOperation:op];
}

+ (void)multipartFormRequestWithMethod:(NSString*)post path:(NSString*)path parameters:(NSDictionary*)parameters filesArray:(NSArray*) filesArray uploadProgressBlock:(UploadProgressBlock) progressBlock uploadSuccessBlock:(UploadSuccessBlock)successBlock   uploadFaildBlock:(UploadFaildBlock) faildBlock{
    
    YXHTTPOperationManager * manager = [YXHTTPOperationManager operationManager];
    NSError *serializationError = nil;
    NSString * urlString = [[NSURL URLWithString:path relativeToURL:manager.baseURL] absoluteString];
    NSMutableURLRequest *mulRequest = [manager.requestSerializer multipartFormRequestWithMethod:post URLString:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
 
        NSLog(@"============%@",parameters);
        for(NSString * key in parameters.allKeys){
            id value = [parameters objectForKey:key];
            if([value isKindOfClass:[NSString class]]){
                [formData appendPartWithFormData:[value dataUsingEncoding:NSUTF8StringEncoding] name:key];
                NSLog(@"if key=%@ value =%@",key,value);
            }else if([value isKindOfClass:[NSNumber class]]){
                NSString * s = [NSString stringWithFormat:@"%@",value];
                [formData appendPartWithFormData:[s dataUsingEncoding:NSUTF8StringEncoding] name:key];
                NSLog(@"else if key=%@ value =%@",key,s);
            }else if([value isKindOfClass:[NSDictionary class]]){
                NSDictionary * vDict = value;
                for(NSString * vkey in vDict){
                    NSString * vvalue = [NSString stringWithFormat:@"%@",vDict[vkey]];
                    NSString * vname = [NSString stringWithFormat:@"%@[%@]",key,vkey];
                    NSLog(@"else if key=%@ value =%@",vname,vvalue);
                    [formData appendPartWithFormData:[vvalue dataUsingEncoding:NSUTF8StringEncoding] name:vname];
                }
                
            }else{
                NSLog(@"else key=%@ value =%@",key,value);
            }
        }
        
        int i=0;
        for(InputFileModel * model in filesArray){
            i++;
            NSLog(@"第%d张图 name =%@ type=%@",i,model.fileName,model.fileType);
            [formData appendPartWithFileData:model.fileData name:model.inputName fileName:model.fileName mimeType:model.fileType];
        }
    } error:&serializationError];
    
    NSLog(@"upload.................=%@",mulRequest);
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:mulRequest];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"setCompletionBlockWithSuccess....=%@",responseObject);
        NSLog(@"setCompletionBlockWithSuccessSTR.....%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        if(successBlock){
            successBlock(operation,responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"setCompletionBlockWithFalure....=%@",error);
        if(faildBlock){
            faildBlock(operation,error);
        }
    }];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        NSLog(@".............totalBytesWritten=%lld",totalBytesWritten);
        NSLog(@".....totalBytesExpectedToWrite=%lld",totalBytesExpectedToWrite);
        if(progressBlock){
            progressBlock(bytesWritten,totalBytesWritten,totalBytesExpectedToWrite);
        }
    }];
    [manager.operationQueue addOperation:operation];
}
/*参数结构
{
    "clientOs":"1",     //1:android,2:iOS
    "version":"1.0.0",  //app版本号
    "sign":"",          //身份验证签名。
    "params":{          //具体参数
        "phoneNumber":"15589764321",
        "password":"lsadflkjasldf"
    }
}
*/
//sign生成规则：由前缀、clientOs、params的json字符串拼接后用md5加密。暂定前缀'ihOmeN@)!^06@TUi&^%@$%RtmNstcUS73'。
static const NSString * SignPrefix = @"ihOmeN@)!^06@TUi&^%@$%RtmNstcUS73";

+(NSDictionary*)globalSignParamsWithPrames:(NSDictionary *)params{

    NSMutableDictionary * signedParams = [[NSMutableDictionary alloc] init];
    NSString * clientOs = @"2";
    NSString *version = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
    
    NSString * paramsJson = [NSString jsonStringWithDictionary:params];
    NSString * originalString = [NSString stringWithFormat:@"%@%@%@",SignPrefix,clientOs,paramsJson];
    NSString * sign = [originalString md5];
    NSLog(@"globalSignParamsWithPrames__paramsJson=%@",paramsJson);
    [signedParams setValue:clientOs forKey:@"clientOs"];
    [signedParams setValue:version forKey:@"version"];
    [signedParams setValue:sign forKey:@"sign"];
    [signedParams setValue:params forKey:@"params"];
    
    return signedParams;
}

@end
@implementation InputFileModel

+(NSData*)imageCompressionDataWithImage:(UIImage*)image WithQuality:(CGFloat)quality MinDataSize:(CGFloat)dataSize{
    CGFloat compressionQuality = 1;
    UIImage * oImage = [image fixOrientation];
    NSData * oData = UIImageJPEGRepresentation(oImage, compressionQuality);
    if(oData.length > dataSize){
        compressionQuality = quality;
    }
    NSData * data = UIImageJPEGRepresentation(oImage, compressionQuality);
    return data;
}
+(NSData*)imageCompressionDataWithImage:(UIImage*)image{
    return [self imageCompressionDataWithImage:image WithQuality:0.3 MinDataSize:512*1024];
}
@end
