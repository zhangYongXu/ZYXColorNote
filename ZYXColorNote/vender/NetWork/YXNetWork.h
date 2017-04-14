//
//  YXNetWork.h
//  YXNetWorkEngineV1.0
//
//  Created by Static Ga on 13-11-14.
//  Copyright (c) 2013年 Static Ga. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXTypeDef.h"

#import "GWRootModel.h"



@interface YXNetWork : NSObject

/**
 *  Http Post
 *
 *  @param path        Http path,for example:Base URL is http://example.com/v1/, the path is login? or /login.
 *  @param par         parameters to post.
 *  @param sucessBlock sucess block to transfer object - JSON.
 *  @param failedBlock failed block to transfer error.
 */
+ (void)postHttp:(NSString *)path parameters:(NSDictionary *)par sucess:(GGSucessBlock)sucessBlock failed:(GGFailedBlock)failedBlock;

+ (void)postCustomeHttp:(NSString *)path parameters:(NSDictionary *)par showProgress:(BOOL)show sucess:(GGSucessBlock)sucessBlock failed:(GGFailedBlock)failedBlock;

+ (void)postHttp:(NSString *)path parameters:(NSDictionary *)par showProgress:(BOOL)show sucess:(GGSucessBlock)sucessBlock failed:(GGFailedBlock)failedBlock;

+ (void)requestHttpByURLRequest:(NSURLRequest *)request  sucess:(GGSucessBlock)sucessBlock failed:(GGFailedBlock)failedBlock;

+ (void)postHttpWithErrorCode:(NSString *)path parameters:(NSDictionary *)par sucess:(GGSucessBlock)sucessBlock
                       failed:(GGFailedBlockWithCode)failedBlock;

+ (NSURLRequest*)getUrlRequestWithMethod:(NSString*)method Path:(NSString*)path DicParam:(NSDictionary*)param;

/**
 *  Http Get .
 *
 *  @param path        Http path.
 *  @param par         parameters. (url form)
 *  @param sucessBlock sucess block to transfer object - JSON.
 *  @param failedBlock failed block to transfer error.
 */
+ (void)getHttp:(NSString *)path parameters:(NSDictionary *)par sucess:(GGSucessBlock)sucessBlock
         failed:(GGFailedBlock)failedBlock;
+ (void)getHttp:(NSString *)path parameters:(NSDictionary *)par showProgress:(BOOL)show sucess:(GGSucessBlock)sucessBlock
         failed:(GGFailedBlock)failedBlock;
+ (void)getHttpEx:(NSString *)path parameters:(NSDictionary *)par start:(GGWillStartBlock)startBlock sucess:(GGSucessBlock)sucessBlock failed:(GGFailedBlockWithCode)failedBlock;

+ (void)getHttpWithErrorCode:(NSString *)path parameters:(NSDictionary *)par sucess:(GGSucessBlock)sucessBlock failed:(GGFailedBlockWithCode)failedBlock;
#warning zhangyongxu
+ (void)postSystemHttp:(NSString *)path showProgress:(BOOL)show sucess:(GGSucessBlock)sucessBlock failed:(GGFailedBlock)failedBlock;
+ (void)postSystemHttp:(NSString *)path parameters:(NSDictionary*)parameters showProgress:(BOOL)show sucess:(GGSucessBlock)sucessBlock failed:(GGFailedBlock)failedBlock;
+ (void)uploadFileWithFileData:(NSData*)fileData FileName:(NSString*)fileName showProgress:(BOOL)show ProgressBlock:(GGProgressBlock)progressBlock sucess:(GGSucessBlock)sucessBlock failed:(GGFailedBlock)failedBlock;
+ (void)uploadImage:(UIImage*)image showProgress:(BOOL)show ProgressBlock:(GGProgressBlock)progressBlock sucess:(GGSucessBlock)sucessBlock failed:(GGFailedBlock)failedBlock;
+ (void)downloadFileWithUrlString:(NSString*)urlString ProgressBlock:(DownloadProgressBolck)progressBlock sucess:(GGSucessBlock)sucessBlock failed:(GGFailedBlock)failedBlock;
+ (void)downloadFileWithUrlString:(NSString*)urlString LocalFileCachePath:(NSString*)localFileCachePath ProgressBlock:(DownloadProgressBolck)progressBlock sucess:(GGSucessBlock)sucessBlock failed:(GGFailedBlock)failedBlock;
/**
 *  表单式文件上传
 *
 *  @param post          请求方式
 *  @param path          请求路径
 *  @param parameters    请求参数
 *  @param filesArray    上传文件（InputFileModel）数组
 *  @param progressBlock 上传进度回调
 *  @param successBlock  上传成功回调
 *  @param faildBlock    上传失败回调
 */
+ (void)multipartFormRequestWithMethod:(NSString*)post path:(NSString*)path parameters:(NSDictionary*)parameters filesArray:(NSArray*) filesArray uploadProgressBlock:(UploadProgressBlock) progressBlock uploadSuccessBlock:(UploadSuccessBlock)successBlock   uploadFaildBlock:(UploadFaildBlock) faildBlock;
/**
 *  创建带签名的参数
 *
 *  @param params 原参数
 *  @return 带签名的参数
 */
+ (NSDictionary*)globalSignParamsWithPrames:(NSDictionary*)params;
@end

@interface InputFileModel : GWRootModel
@property (copy,nonatomic)NSString * inputName;
@property (copy,nonatomic)NSString * fileName;
@property (copy,nonatomic)NSString * fileType;
@property (strong,nonatomic) NSData * fileData;

+(NSData*)imageCompressionDataWithImage:(UIImage*)image;

@end
