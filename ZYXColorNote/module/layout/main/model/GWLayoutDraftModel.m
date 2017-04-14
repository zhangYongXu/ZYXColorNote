//
//  GWLayoutDraftModel.m
//  TourNote
//
//  Created by 极客天地 on 2017/3/3.
//  Copyright © 2017年 极客天地. All rights reserved.
//

#import "GWLayoutDraftModel.h"
#import "YXFileOrDirItemModel.h"
@implementation GWLayoutDraftModel
+(NSMutableArray<GWLayoutDraftModel*>*)getDraftModelArray{
    NSMutableArray * array = [[NSMutableArray alloc] init];
    NSString * draftPath = APPDelegate.draftDir;

    NSArray<YXFileOrDirItemModel*> * fileArray = [YXFileOrDirItemModel scanDirectory:draftPath];
    for(YXFileOrDirItemModel * fileModel in fileArray){
        GWLayoutDraftModel * model = [[GWLayoutDraftModel alloc] init];
        model.layoutDraft = fileModel.fullPath;
        model.layoutDraftFileName = fileModel.name;
        NSString * jsonName = [NSString stringWithFormat:@"%@.json",fileModel.name];
        model.layoutDraftFilePath = [fileModel.fullPath stringByAppendingPathComponent:jsonName];
        model.layoutDraftImageName = fileModel.name;
        NSString * imageName = [NSString stringWithFormat:@"%@.png",fileModel.name];
        model.layoutDraftImagePath = [fileModel.fullPath stringByAppendingPathComponent:imageName];

        model.createDate = [NSDate dateWithString:fileModel.createTime formate:@"yyyy-MM-dd HH:mm:ss zzz"];
        [array addObject:model];
    }
    return array;
}
@end
