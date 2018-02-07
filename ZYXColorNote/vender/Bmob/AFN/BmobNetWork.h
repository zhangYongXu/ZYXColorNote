//
//  BmobNetWork.h
//  RealMall
//
//  Created by 极客天地 on 2018/2/2.
//  Copyright © 2018年 极客天地. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BmobNetWorkConfig.h"
#import "BmobHttpSessionManager.h"
#import "BmobRequestOperationManager.h"
#import "NSString+Bmob.h"

typedef void (^BmobDictionarySucessBlock)(NSDictionary *dictionary);
typedef void (^BmobArraySucessBlock)(NSArray *array);
typedef void (^BmobStringSucessBlock)(NSString *string);
typedef void (^BmobFileSucessBlock)(BmobFile *bmobFile);
typedef void (^BmobStringFailedBlock)(NSString *errorMsg);

@interface BmobNetWork : NSObject
/**
 *  Post请求
 *
 *  @param path         请求路径
 *  @param par          请求参数
 *  @param show         是否显示加载提示
 *  @param sucessBlock  成功回调
 *  @param failedBlock  失败回调
 */
+ (void)postHttp:(NSString *)path parameters:(NSDictionary *)par showProgress:(BOOL)show sucess:(GGSucessBlock)sucessBlock failed:(GGFailedBlock)failedBlock;
/**
 *  get请求
 *
 *  @param path         请求路径
 *  @param par          请求参数
 *  @param show         是否显示加载提示
 *  @param sucessBlock  成功回调
 *  @param failedBlock  失败回调
 */
+ (void)getHttp:(NSString *)path parameters:(NSDictionary *)par showProgress:(BOOL)show sucess:(GGSucessBlock)sucessBlock failed:(GGFailedBlock)failedBlock;

/**
 *  创建request
 *
 *  @param method       请求方式
 *  @param path         请求路径
 *  @param param        请求参数
 */
+(NSMutableURLRequest *)getUrlRequestWithMethod:(NSString *)method Path:(NSString *)path DicParam:(NSDictionary *)param;
/**
 *  创建request系统方法
 *
 *  @param method       请求方式
 *  @param path         请求路径
 *  @param timeInterval 请求超时
 */
+(NSMutableURLRequest *)getUrlRequestWithMethod:(NSString *)method Path:(NSString *)path NSTimeInterval:(NSTimeInterval)timeInterval;


/**
 *  发起数据请求
 *
 *  @param request      请求体request
 *  @param show         是否显示加载提示
 *  @param sucessBlock  成功回调
 *  @param failedBlock  失败回调
 */
+ (void)requestHttpByURLRequest:(NSURLRequest *)request showProgress:(BOOL)show sucess:(GGSucessBlock)sucessBlock failed:(GGFailedBlock)failedBlock;
/**
 *  发起同步数据请求
 *
 *  @param request      请求体request
 */
+ (id)requestSystemHttpByURLRequest:(NSURLRequest *)request;

/**
 *  delete请求
 *
 *  @param path         请求路径
 *  @param par          请求参数
 *  @param show         是否显示加载提示
 *  @param sucessBlock  成功回调
 *  @param failedBlock  失败回调
 */
+ (void)deleteHttp:(NSString *)path parameters:(NSDictionary *)par showProgress:(BOOL)show sucess:(GGSucessBlock)sucessBlock failed:(GGFailedBlock)failedBlock;
/**
 *  delete请求
 *
 *  @param path         请求路径
 *  @param par          请求参数
 *  @param show         是否显示加载提示
 *  @param sucessBlock  成功回调
 *  @param failedBlock  失败回调
 */
+ (void)deleteSystemHttp:(NSString *)path parameters:(NSDictionary *)par showProgress:(BOOL)show sucess:(GGSucessBlock)sucessBlock failed:(GGFailedBlock)failedBlock;
/**
 *  delete请求
 *
 *  @param path         请求路径
 */
+ (NSDictionary*)deleteSystemHttp:(NSString *)path;

/**
 *  put请求
 *
 *  @param path         请求路径
 *  @param par          请求参数
 *  @param show         是否显示加载提示
 *  @param sucessBlock  成功回调
 *  @param failedBlock  失败回调
 */
+ (void)putSystemHttp:(NSString *)path parameters:(NSDictionary *)par showProgress:(BOOL)show sucess:(GGSucessBlock)sucessBlock failed:(GGFailedBlock)failedBlock;

/**
 *  上传文件
 *
 *  @param fileData         文件数据
 *  @param fileName         文件名称
 *  @param show             是否显示加载提示
 *  @param progressBlock    上传进度回调
 *  @param sucessBlock      成功回调
 *  @param failedBlock      失败回调
 */
+ (void)uploadFileWithFileData:(NSData*)fileData FileName:(NSString*)fileName showProgress:(BOOL)show ProgressBlock:(GGProgressBlock)progressBlock sucess:(BmobFileSucessBlock)sucessBlock failed:(GGFailedBlock)failedBlock;
@end
