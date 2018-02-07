//
//  GWLayoutViewModel.m
//  TourNote
//
//  Created by 极客天地 on 17/1/16.
//  Copyright © 2017年 极客天地. All rights reserved.
//

#import "GWLayoutViewModel.h"
#import "YXMaskProgressView.h"
@interface GWLayoutViewModel()
@property (strong,nonatomic) YXMaskProgressView *progressViewMask;
@end
@implementation GWLayoutViewModel
-(YXMaskProgressView *)progressViewMask{
    if(nil == _progressViewMask){
        _progressViewMask =  [YXMaskProgressView progressViewWithMask];
    }
    return _progressViewMask;
}
-(GWLayoutModel *)layoutModel{
    if(nil == _layoutModel){
        _layoutModel = [[GWLayoutModel alloc] init];
    }
    return _layoutModel;
}
-(NSMutableDictionary<NSString *,GWLayoutModel *> *)layoutModelDict{
    if(nil == _layoutModelDict){
        _layoutModelDict = [[NSMutableDictionary alloc] init];
    }
    return _layoutModelDict;
}
-(GWLayoutModel*)getLayoutModelWithLayoutNetDataModel:(GWLayoutNetDataModel *)netLayoutDataModel{
    NSString * key = [netLayoutDataModel.layouJsonUrl md5];
    if([self.layoutModelDict.allKeys containsObject:key]){
        return self.layoutModelDict[key];
    }else{
        NSData * layoutJsonData = [NSData dataWithContentsOfFile:netLayoutDataModel.layoutJsonFileLocalPath];
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:layoutJsonData options:NSJSONReadingMutableContainers error:nil];
        GWLayoutModel * model = [[GWLayoutModel alloc] init];
        [model setValuesForKeysWithDictionary:dict];
        self.layoutModelDict[key] = model;
        return model;
    }
}
/**
 *  请求所有布局模板
 *
 *  @param successBlokc 成功回调
 *  @param faildBlock   失败回调
 */
-(void)requestAllLayoutDataWithSuccessBlock:(YXSuccessBlock)successBlokc FaildBlock:(YXFaildBlock)faildBlock{
    NSString * bql = @"select *,include publishUserPoint from LayoutModel";
    [BmobHttpApiGet getDataWithBql:bql showProgress:YES sucess:^(NSArray *array) {
        NSLog(@"requestAllLayoutDataWithSuccessBlock array:%@",array);
        self.netLaoutDataArray = [GWLayoutNetDataModel modelArrayFromDictArray:array];
        if(successBlokc){
            successBlokc(array);
        }
    } failed:^(NSString *errorMsg) {
        if(faildBlock){
            faildBlock(errorMsg);
        }
    }];
}

/**
 *  请求所有布局模板 查询我的布局
 *
 *  @param successBlokc 成功回调
 *  @param faildBlock   失败回调
 */
-(void)requestMineLayoutDataWithSuccessBlock:(YXSuccessBlock)successBlokc FaildBlock:(YXFaildBlock)faildBlock{
    NSString * objectId = APPDelegate.userViewModel.localCacheUserModel.objectId;
    NSString * bql = [NSString stringWithFormat:@"select include publishUserPoint, * from LayoutModel where publishUserPoint = pointer('LayoutUserModel', '%@')",objectId];
    [BmobHttpApiGet getDataWithBql:bql showProgress:YES sucess:^(NSArray *array) {
        NSLog(@"requestMineLayoutDataWithSuccessBlock array:%@",array);
        self.netLaoutDataArray = [GWLayoutNetDataModel modelArrayFromDictArray:array];
        if(successBlokc){
            successBlokc(array);
        }
    } failed:^(NSString *errorMsg) {
        if(faildBlock){
            faildBlock(errorMsg);
        }
    }];
}

/**
 *  请求网络布局模板文件
 *
 *  @param successBlokc 成功回调
 *  @param faildBlock   失败回调
 */
-(void)downloadNetLayoutDataWithLayoutNetDataModel:(GWLayoutNetDataModel*)layoutNetDataModel SuccessBlock:(YXSuccessBlock)successBlokc FaildBlock:(YXFaildBlock)faildBlock{
    NSString * urlString = layoutNetDataModel.layouJsonUrl;
    [self.progressViewMask showProgressView];
    [YXNetWork downloadFileWithUrlString:urlString LocalFileCachePath:layoutNetDataModel.layoutJsonFileLocalPath ProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        CGFloat  progress = (totalBytesRead/1.0)/(totalBytesExpectedToRead/1.0);
        CGFloat  tolalL = (totalBytesExpectedToRead/1024.0);
        CGFloat  writeL = (totalBytesRead/1024.0);
        NSString* text = [NSString stringWithFormat:@"下载中，总大小:%.2fkb,已下载:%.2fkb",tolalL,writeL];
        
        if (totalBytesExpectedToRead < 0 || totalBytesRead > totalBytesExpectedToRead){
            progress = (totalBytesRead % 1000000l) / 1000000.0f;
            text = [NSString stringWithFormat:@"下载中,已下载:%.2fkb",writeL];
        }
        
        [self.progressViewMask setProgressValue:progress];
        [self.progressViewMask setProgressLabelText:text];

    } sucess:^(NSString* filePath) {

        NSData * layoutJsonData = [NSData dataWithContentsOfFile:filePath];
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:layoutJsonData options:NSJSONReadingMutableContainers error:nil];
        GWLayoutModel * model = [[GWLayoutModel alloc] init];
        [model setValuesForKeysWithDictionary:dict];
        NSString * key = [urlString md5];
        self.layoutModelDict[key] = model;
        
        if(successBlokc){
            successBlokc(model);
        }
        [self.progressViewMask dismissProgressView];
    } failed:^(NSString *errorMsg) {
        if(faildBlock){
            faildBlock(errorMsg);
        }
        [self.progressViewMask dismissProgressView];
    }];
}
@end
