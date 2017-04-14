//
//  PasterViewModel.m
//  TourNote
//
//  Created by 极客天地 on 2017/2/24.
//  Copyright © 2017年 极客天地. All rights reserved.
//

#import "PasterViewModel.h"

#import "YXFileOrDirItemModel.h"

@interface PasterViewModel()

@end
@implementation PasterViewModel
-(void)initData{
    [self testData];
}
-(void)testData{
    NSArray * nameArray = @[@"强烈推荐",@"天气",@"基本形状",@"可爱贴纸",@"表情包",@"线描箭头",@"JONJON囧囧爱情贴纸"];
    self.pasterSetArray = [[NSMutableArray alloc] init];
    NSString * bundlePath = [NSBundle mainBundle].bundlePath;
    for(NSString *name in nameArray){
        NSString * tempPath = [NSString stringWithFormat:@"elementSelect/paster/%@",name];
        NSString * pasterSetPath = [bundlePath stringByAppendingPathComponent:tempPath];
        PasterSetModel * pasterSet = [[PasterSetModel alloc] init];
        pasterSet.localPath = pasterSetPath;
        pasterSet.pasterSetName = name;
        pasterSet.pasterModelArray = [[NSMutableArray alloc] init];
        NSArray<YXFileOrDirItemModel*>* fileModelArray = [YXFileOrDirItemModel getAllFilesInPath:pasterSet.localPath];
        for(NSInteger i = 0;i < fileModelArray.count;i++){
            YXFileOrDirItemModel * fileModel = fileModelArray[i];
            PasterModel * model = [[PasterModel alloc] init];
            model.localImagePath = fileModel.fullPath;
            model.pasterID = fileModel.name;
            model.pasterName = [NSString stringWithFormat:@"%ld",i+1];
            model.pasterSetName = pasterSet.pasterSetName;
            [pasterSet.pasterModelArray addObject:model];
        }
        [self.pasterSetArray addObject:pasterSet];
    }
    
    
}
+(UIImage*)pasterImageWithPasterModel:(PasterModel*)pasterModel{
    NSString * bundlePath = [NSBundle mainBundle].bundlePath;
    NSString * tempPath = [NSString stringWithFormat:@"elementSelect/paster/%@/%@",pasterModel.pasterSetName,pasterModel.pasterID];
    NSString * pasterImagePath = [bundlePath stringByAppendingPathComponent:tempPath];
    pasterModel.localImagePath = pasterImagePath;
    UIImage * image = [UIImage imageWithContentsOfFile:pasterImagePath];
    return image;
}
@end
