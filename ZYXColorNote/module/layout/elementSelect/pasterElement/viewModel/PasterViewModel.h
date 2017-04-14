//
//  PasterViewModel.h
//  TourNote
//
//  Created by 极客天地 on 2017/2/24.
//  Copyright © 2017年 极客天地. All rights reserved.
//

#import "GWRootViewModel.h"
#import "PasterSetModel.h"
@interface PasterViewModel : GWRootViewModel
@property(strong,nonatomic) NSMutableArray<PasterSetModel*> * pasterSetArray;

+(UIImage*)pasterImageWithPasterModel:(PasterModel*)pasterModel;
@end
