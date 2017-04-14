//
//  ZYXFontViewModel.m
//  TourNote
//
//  Created by 极客天地 on 2017/2/6.
//  Copyright © 2017年 极客天地. All rights reserved.
//

#import "ZYXFontViewModel.h"
#import "YXMaskProgressView.h"

static ZYXFontViewModel * shareIntance = nil;
@interface ZYXFontViewModel()
@property (strong,nonatomic) YXMaskProgressView *progressViewMask;

@property (strong,nonatomic) NSMutableDictionary<NSString*,ZYXFontModel*> * fontModelDict;
@end
@implementation ZYXFontViewModel
+(ZYXFontViewModel *)shareInstance{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareIntance = [[ZYXFontViewModel alloc] init];
        [shareIntance requestAllCustomFontDataWithSuccessBlock:^(id object) {
            
        } FaildBlock:^(id object) {
            
        }];
    });
    return shareIntance;
}
-(NSMutableDictionary<NSString *,ZYXFontModel *> *)fontModelDict{
    if(nil == _fontModelDict){
        _fontModelDict = [[NSMutableDictionary alloc] init];
    }
    return _fontModelDict;
}
-(YXMaskProgressView *)progressViewMask{
    if(nil == _progressViewMask){
        _progressViewMask =  [YXMaskProgressView progressViewWithMask];
    }
    return _progressViewMask;
}
-(void)initData{
    //[self testData];
}
-(void)testData{
    NSArray<NSDictionary*>* dictArray = @[
                                          @{@"fontID":@"1",@"fontName":@"SentyCreamPuff-app003",@"fontLocalFilePath":[[NSBundle mainBundle] pathForResource:@"SentyCreamPuff-app003" ofType:@"ttf"]},
                                          @{@"fontID":@"2",@"fontName":@"SentyPea-APP-20151217",@"fontLocalFilePath":[[NSBundle mainBundle] pathForResource:@"SentyPea-APP-20151217" ofType:@"ttf"]},
                                          @{@"fontID":@"3",@"fontName":@"SentySnowMountain-app",@"fontLocalFilePath":[[NSBundle mainBundle] pathForResource:@"SentySnowMountain-app" ofType:@"ttf"]},
                                          @{@"fontID":@"4",@"fontName":@"SentyZhaoLite",@"fontLocalFilePath":[[NSBundle mainBundle] pathForResource:@"SentyZhaoLite" ofType:@"ttf"]}
                                          ];
    
    self.modelArray = [ZYXFontModel modelArrayFromDictArray:dictArray];
}

/**
 *  请求所有自定义字体数据
 *
 *  @param successBlokc 成功回调
 *  @param faildBlock   失败回调
 */
-(void)requestAllCustomFontDataWithSuccessBlock:(YXSuccessBlock)successBlokc FaildBlock:(YXFaildBlock)faildBlock{
    
    NSString * urlStr = @"GetAllCustomFontData";
    [YXNetWork postSystemHttp:urlStr showProgress:NO sucess:^(id responseObj) {
        NSArray * array = responseObj[@"allCustomFontsData"];
        self.modelArray = [ZYXFontModel modelArrayFromDictArray:array];
        for(ZYXFontModel * model in self.modelArray){
            self.fontModelDict[model.fontID] = model;
        }
        
        if(successBlokc){
            successBlokc(responseObj);
        }
        
    } failed:^(NSString *errorMsg) {
        if(faildBlock){
            faildBlock(errorMsg);
        }
    }];
}

/**
 *  请求自定义字体文件
 *
 *  @param fontModel    字体模型
 *  @param successBlokc 成功回调
 *  @param faildBlock   失败回调
 */
-(void)downloadFontFileDataWithFontModel:(ZYXFontModel*)fontModel SuccessBlock:(YXSuccessBlock)successBlokc FaildBlock:(YXFaildBlock)faildBlock{
    NSString * urlString = fontModel.fontFileUrl;
    [self.progressViewMask showProgressView];
    [YXNetWork downloadFileWithUrlString:urlString LocalFileCachePath:fontModel.fontLocalFilePath ProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        
        CGFloat  progress = (totalBytesRead/1.0)/(totalBytesExpectedToRead/1.0);
        CGFloat  tolalL = (totalBytesExpectedToRead/1024.0);
        CGFloat  writeL = (totalBytesRead/1024.0);
        NSString* text = [NSString stringWithFormat:@"字体文件下载中，总大小:%.2fkb,已下载:%.2fkb",tolalL,writeL];
        
        if (totalBytesExpectedToRead < 0 || totalBytesRead > totalBytesExpectedToRead){
            progress = (totalBytesRead % 1000000l) / 1000000.0f;
            text = [NSString stringWithFormat:@"字体文件下载中,已下载:%.2fkb",writeL];
        }

        [self.progressViewMask setProgressValue:progress];
        [self.progressViewMask setProgressLabelText:text];
    } sucess:^(NSString* filePath) {
        if(successBlokc){
            successBlokc(filePath);
        }
        [self.progressViewMask dismissProgressView];
    } failed:^(NSString *errorMsg) {
        if(faildBlock){
            faildBlock(errorMsg);
        }
        [self.progressViewMask dismissProgressView];
    }];
}
+(ZYXFontModel *)fontModelWithFontID:(NSString *)fontID{
    ZYXFontViewModel * fontViewModel = [ZYXFontViewModel shareInstance];
    ZYXFontModel * fontModel = fontViewModel.fontModelDict[fontID];
    return fontModel;
}
+(UIFont *)fontWithFontID:(NSString *)fontID fontSize:(NSInteger)fontSize{
    ZYXFontModel * fontModel = [self fontModelWithFontID:fontID];
    NSURL * url = [[NSURL alloc] initFileURLWithPath:fontModel.fontLocalFilePath];
    UIFont * font = [ZYXFontModel customFontWithFontUrl:url size:fontSize];
    return font;
}
@end
