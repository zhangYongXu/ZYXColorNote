//
//  GWLayoutNetDataModel.m
//  TourNote
//
//  Created by 极客天地 on 17/1/19.
//  Copyright © 2017年 极客天地. All rights reserved.
//

#import "GWLayoutNetDataModel.h"

@implementation GWLayoutNetDataModel
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
