//
//  GWLayoutNetDataModel.h
//  TourNote
//
//  Created by 极客天地 on 17/1/19.
//  Copyright © 2017年 极客天地. All rights reserved.
//

#import "GWRootModel.h"

@interface GWLayoutNetDataModel : GWRootModel
@property(copy,nonatomic)NSString* objectId;
@property(copy,nonatomic)NSString * layoutJsonFileLocalPath;
@property(assign,nonatomic) BOOL isExistlayoutJsonLocalFile;

@property(copy,nonatomic)NSString* layoutPicImageUrl;
@property(copy,nonatomic)NSString* layouJsonUrl;
@property(assign,nonatomic) BOOL isSelected;
@end
