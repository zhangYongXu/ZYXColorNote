//
//  BackgroundViewModel.m
//  TourNote
//
//  Created by 极客天地 on 2017/2/28.
//  Copyright © 2017年 极客天地. All rights reserved.
//

#import "BackgroundViewModel.h"

@implementation BackgroundViewModel
-(void)initData{
    [self testData];
}
-(void)testData{
    NSArray * nameArray = @[@"优质推荐",@"粉粉",@"美妙早餐",@"那些花儿",@"水彩小树",@"相机记录",@"校园"];
    self.backgroundModelArray = [[NSMutableArray alloc] init];
    for(NSInteger i = 0;i < nameArray.count;i++){
        NSString * name = nameArray[i];

        BackgroundModel * backgroundModel = [BackgroundViewModel backgroundModelWithBackgroundName:name];
        if(!backgroundModel){
            continue;
        }
        [self.backgroundModelArray addObject:backgroundModel];
    }
}
+(NSString*)createFullPathWithDirName:(NSString*)dirName FileName:(NSString*)fileName{
    NSString * bundlePath = [NSBundle mainBundle].bundlePath;
    NSString * pathTemp = [NSString stringWithFormat:@"elementSelect/background/%@/%@",dirName,fileName];
    return [bundlePath stringByAppendingPathComponent:pathTemp];
}
+(BackgroundModel*)backgroundModelWithBackgroundName:(NSString*)backgroundName{
    NSString * backgroundInfoJsonPath = [self createFullPathWithDirName:backgroundName FileName:@"InfoJson.json"];
    NSData * jsonData = [NSData dataWithContentsOfFile:backgroundInfoJsonPath];
    if(nil == jsonData){
        return nil;
    }
    NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    
    dict[@"backgroundID"] = jsonDict[@"backgroundID"];
    dict[@"backgroundName"] = jsonDict[@"backgroundName"];
    dict[@"headerImagePath"] = [BackgroundViewModel createFullPathWithDirName:backgroundName FileName:jsonDict[@"headerImageFileName"]];
    dict[@"footerImagePath"] = [BackgroundViewModel createFullPathWithDirName:backgroundName FileName:jsonDict[@"footerImageFileName"]];
    dict[@"colorImagePath"] = [BackgroundViewModel createFullPathWithDirName:backgroundName FileName:jsonDict[@"colorImageFileName"]];
    dict[@"showImagePath"] = [BackgroundViewModel createFullPathWithDirName:backgroundName FileName:jsonDict[@"showImageFileName"]];
    
    BackgroundModel * backgroundModel = [[BackgroundModel alloc] init];
    [backgroundModel setValuesForKeysWithDictionary:dict];
    
    return backgroundModel;
}
@end
