
//
//  BmobHttpApiFile.m
//  ZYXColorNote
//
//  Created by 极客天地 on 2018/2/7.
//  Copyright © 2018年 极客天地. All rights reserved.
//

#import "BmobHttpApiFile.h"

@implementation BmobHttpApiFile
/**
 *  上传图片
 *
 *  @param image            图片
 *  @param imageFileName    图片名称
 *  @param show             是否显示加载提示
 *  @param progressBlock    上传进度回调
 *  @param sucessBlock      成功回调
 *  @param failedBlock      失败回调
 */
+ (void)uploadImage:(UIImage*)image imageFileName:(NSString*)imageFileName showProgress:(BOOL)show ProgressBlock:(GGProgressBlock)progressBlock sucess:(BmobFileSucessBlock)sucessBlock failed:(GGFailedBlock)failedBlock{
    NSData * data = UIImagePNGRepresentation(image);
    if(STR_IS_NIL(imageFileName)){
        NSString * name = [NSString stringWithFormat:@"img_%@.png",@([[NSDate date] timeIntervalSince1970])];
        imageFileName = name;
    }
    
    
    [BmobNetWork uploadFileWithFileData:data FileName:imageFileName showProgress:show ProgressBlock:progressBlock sucess:sucessBlock failed:failedBlock];
}
@end
