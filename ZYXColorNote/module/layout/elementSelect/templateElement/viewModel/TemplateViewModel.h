//
//  TemplateViewModel.h
//  TourNote
//
//  Created by 极客天地 on 2017/3/15.
//  Copyright © 2017年 极客天地. All rights reserved.
//

#import "GWRootViewModel.h"
#import "TemplateModel.h"
@interface TemplateViewModel : GWRootViewModel
@property(strong,nonatomic)NSMutableArray<TemplateModel*>* templateModelArray;
@end
