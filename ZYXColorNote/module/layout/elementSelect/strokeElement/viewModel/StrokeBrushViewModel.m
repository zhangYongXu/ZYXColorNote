//
//  StrokeBrushViewModel.m
//  TourNote
//
//  Created by 极客天地 on 2017/3/1.
//  Copyright © 2017年 极客天地. All rights reserved.
//

#import "StrokeBrushViewModel.h"

@implementation StrokeBrushViewModel
-(void)initData{
    [self testData];
}
-(void)testData{
    self.imageBrushModelArray = [StrokeBrushViewModel imageStrokeBrushModelArray];
    self.colorBrushModelArray = [StrokeBrushViewModel colorStrokeBrushModelArray];
}
+(NSString*)imageBrushCreateFullPathWithDirName:(NSString*)dirName FileName:(NSString*)fileName{
    NSString * bundlePath = [NSBundle mainBundle].bundlePath;
    NSString * pathTemp = [NSString stringWithFormat:@"elementSelect/stroke/图案笔刷/%@/%@",dirName,fileName];
    return [bundlePath stringByAppendingPathComponent:pathTemp];
}
+(NSMutableArray<StrokeBrushModel*>*)imageStrokeBrushModelArray{
    NSArray * nameArray = @[@"爱心云",@"财神来了",@"彩色漩涡",@"冒泡泡",@"闪电",@"小兔兔"];
    NSMutableArray *  imageBrushModelArray = [[NSMutableArray alloc] init];
    for(NSInteger i = 0;i < nameArray.count;i++){
        NSString * name = nameArray[i];
        
        StrokeBrushModel * strokeBrushModel = [StrokeBrushViewModel imageStrokeBrushModelWithStrokeBrushName:name];
        if(!strokeBrushModel){
            continue;
        }
        [imageBrushModelArray addObject:strokeBrushModel];
    }
    return imageBrushModelArray;
}
+(StrokeBrushModel*)imageStrokeBrushModelWithStrokeBrushName:(NSString*)strokeBrushName{
    NSString * backgroundInfoJsonPath = [self imageBrushCreateFullPathWithDirName:strokeBrushName FileName:@"InfoJson.json"];
    NSData * jsonData = [NSData dataWithContentsOfFile:backgroundInfoJsonPath];
    if(nil == jsonData){
        return nil;
    }
    NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    
    dict[@"strokeBrushID"] = jsonDict[@"strokeBrushID"];
    dict[@"strokeBrushName"] = jsonDict[@"strokeBrushName"];
    dict[@"showImagePath"] = [StrokeBrushViewModel imageBrushCreateFullPathWithDirName:strokeBrushName FileName:jsonDict[@"showImageFileName"]];
    NSArray * strokeImageFileNameArray = jsonDict[@"strokeImageFileNameArray"];
    
    
    StrokeBrushModel * strokeBrushModel = [[StrokeBrushModel alloc] init];
    strokeBrushModel.strokeBrushType = StrokeBrushTypeImageBrush;
    strokeBrushModel.strokeBrushTypeStr = @"图案笔刷";
    [strokeBrushModel setValuesForKeysWithDictionary:dict];
    strokeBrushModel.strokeImagePathArray = [[NSMutableArray alloc] init];
    for(NSString * imageFileName in strokeImageFileNameArray){
        NSString * imagePath = [StrokeBrushViewModel imageBrushCreateFullPathWithDirName:strokeBrushName FileName:imageFileName];
        [strokeBrushModel.strokeImagePathArray addObject:imagePath];
    }
    return strokeBrushModel;
}

+(NSString*)colorBrushCreateFullPathWithFileName:(NSString*)fileName{
    NSString * bundlePath = [NSBundle mainBundle].bundlePath;
    NSString * pathTemp = [NSString stringWithFormat:@"elementSelect/stroke/颜色笔刷/%@",fileName];
    return [bundlePath stringByAppendingPathComponent:pathTemp];
}
+(NSMutableArray<StrokeBrushModel*>*)colorStrokeBrushModelArray{
    NSString * backgroundInfoJsonPath = [self colorBrushCreateFullPathWithFileName:@"InfoJson.json"];
    NSData * jsonData = [NSData dataWithContentsOfFile:backgroundInfoJsonPath];
    if(nil == jsonData){
        return nil;
    }
    NSArray * jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    NSMutableArray * colorStrokeBrushModelArray = [[NSMutableArray alloc] init];
    for(NSDictionary * jsonDict in jsonArray){
        NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
        
        dict[@"strokeBrushID"] = jsonDict[@"strokeBrushID"];
        dict[@"strokeBrushName"] = jsonDict[@"strokeBrushName"];
        dict[@"showImagePath"] = [StrokeBrushViewModel colorBrushCreateFullPathWithFileName:jsonDict[@"showImageFileName"]];
        NSString * colorHexStr = jsonDict[@"strokeBrushColorHex"];
        
        StrokeBrushModel * strokeBrushModel = [[StrokeBrushModel alloc] init];
        strokeBrushModel.strokeBrushType = StrokeBrushTypeColorBrush;
        strokeBrushModel.strokeBrushTypeStr = @"颜色笔刷";
        [strokeBrushModel setValuesForKeysWithDictionary:dict];
        strokeBrushModel.strokeBrushColor = [UIColor colorWithHexString:colorHexStr];
        [colorStrokeBrushModelArray addObject:strokeBrushModel];
    }
    return colorStrokeBrushModelArray;
}

@end
