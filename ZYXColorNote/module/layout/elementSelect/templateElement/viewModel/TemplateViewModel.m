//
//  TemplateViewModel.m
//  TourNote
//
//  Created by 极客天地 on 2017/3/15.
//  Copyright © 2017年 极客天地. All rights reserved.
//

#import "TemplateViewModel.h"

@implementation TemplateViewModel
-(void)initData{
    [self testData];
}
-(void)testData{
    NSArray * nameArray = @[@"侧颜",@"吃货世界",@"第一次下厨"];
    self.templateModelArray = [[NSMutableArray alloc] init];
    for(NSInteger i = 0;i < nameArray.count;i++){
        NSString * name = nameArray[i];
        
        TemplateModel * templateModel = [TemplateViewModel templateModelWithTemplateName:name];
        if(!templateModel){
            continue;
        }
        [self.templateModelArray addObject:templateModel];
    }
}

+(NSString*)createFullPathWithDirName:(NSString*)dirName FileName:(NSString*)fileName{
    NSString * bundlePath = [NSBundle mainBundle].bundlePath;
    NSString * pathTemp = [NSString stringWithFormat:@"elementSelect/template/%@/%@",dirName,fileName];
    return [bundlePath stringByAppendingPathComponent:pathTemp];
}
+(TemplateModel*)templateModelWithTemplateName:(NSString*)templateName{
    NSString * backgroundInfoJsonPath = [self createFullPathWithDirName:templateName FileName:@"InfoJson.json"];
    NSData * jsonData = [NSData dataWithContentsOfFile:backgroundInfoJsonPath];
    if(nil == jsonData){
        return nil;
    }
    NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    
    dict[@"templateID"] = jsonDict[@"templateID"];
    dict[@"templateName"] = jsonDict[@"templateName"];
    dict[@"templateImagePath"] = [self createFullPathWithDirName:templateName FileName:jsonDict[@"templateImageName"]];
    dict[@"templateLayoutJsonPath"] = [self createFullPathWithDirName:templateName FileName:jsonDict[@"templateLayoutJsonName"]];
    
    TemplateModel * templateModel = [[TemplateModel alloc] init];
    [templateModel setValuesForKeysWithDictionary:dict];
    
    return templateModel;
}
@end
