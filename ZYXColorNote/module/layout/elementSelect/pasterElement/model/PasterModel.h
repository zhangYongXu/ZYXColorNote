//
//  PasterModel.h
//  TourNote
//
//  Created by 极客天地 on 2017/2/24.
//  Copyright © 2017年 极客天地. All rights reserved.
//

#import "GWRootModel.h"

@interface PasterModel : GWRootModel
@property(strong,nonatomic) NSString * pasterID;
@property(strong,nonatomic) NSString * pasterName;
@property(strong,nonatomic) NSString * pasterImageUrl;
@property(strong,nonatomic) NSString * localImagePath;
@property(strong,nonatomic) NSString * pasterSetName;
@end
