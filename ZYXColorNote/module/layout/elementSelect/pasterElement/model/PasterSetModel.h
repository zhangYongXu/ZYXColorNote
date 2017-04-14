//
//  PasterSetModel.h
//  TourNote
//
//  Created by 极客天地 on 2017/2/24.
//  Copyright © 2017年 极客天地. All rights reserved.
//

#import "GWRootViewModel.h"
#import "PasterModel.h"
@interface PasterSetModel : GWRootViewModel
@property(strong,nonatomic) NSString * pasterSetID;
@property(strong,nonatomic) NSString * pasterSetName;
@property(strong,nonatomic) NSString * pasterSetUrl;
@property(strong,nonatomic) NSString * localPath;

@property(strong,nonatomic)NSMutableArray<PasterModel*> * pasterModelArray;
@end
