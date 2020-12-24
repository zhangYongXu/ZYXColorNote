//
//  GWLayoutNetDataModel.m
//  TourNote
//
//  Created by 极客天地 on 17/1/19.
//  Copyright © 2017年 极客天地. All rights reserved.
//

#import "GWLayoutNetDataModel.h"

@implementation GWLayoutNetDataModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isSelected = NO;
    }
    return self;
}

- (NSString *)layouJsonUrl{
    if(!STR_IS_NIL(_layouJsonUrl) && [_layouJsonUrl containsString:@"https://"]){
        _layouJsonUrl = [_layouJsonUrl stringByReplacingOccurrencesOfString:@"https://" withString:@"http://"];
    }
    return _layouJsonUrl;
}
- (NSString *)layoutPicImageUrl{
    if(!STR_IS_NIL(_layoutPicImageUrl) && [_layoutPicImageUrl containsString:@"https://"]){
        _layoutPicImageUrl = [_layoutPicImageUrl stringByReplacingOccurrencesOfString:@"https://" withString:@"http://"];
    }
    return _layoutPicImageUrl;
}
-(void)setPublishUserPoint:(UserModel *)publishUserPoint{
    if([publishUserPoint isKindOfClass:[NSDictionary class]]){
        _publishUserPoint = [[UserModel alloc] init];
        [_publishUserPoint setValuesForKeysWithDictionary:(NSDictionary*)publishUserPoint];
    }else{
        _publishUserPoint = publishUserPoint;
    }
}

-(NSString *)layoutJsonFileLocalPath{
    if(!STR_IS_NIL(self.layouJsonUrl)){
        NSString * fileName = [NSString stringWithFormat:@"%@.file",[self.layouJsonUrl md5]];
        NSString * filePath= [APPDelegate.documentDir stringByAppendingPathComponent:fileName];
        _layoutJsonFileLocalPath = filePath;
    }
    return _layoutJsonFileLocalPath;
}
-(BOOL)isExistlayoutJsonLocalFile{
    NSFileManager * FM = [NSFileManager defaultManager];
    _isExistlayoutJsonLocalFile = [FM fileExistsAtPath:self.layoutJsonFileLocalPath];
    return _isExistlayoutJsonLocalFile;
}
@end
