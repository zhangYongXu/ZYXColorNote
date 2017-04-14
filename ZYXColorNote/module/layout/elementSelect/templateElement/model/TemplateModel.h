//
//  TemplateModel.h
//  TourNote
//
//  Created by 极客天地 on 2017/3/15.
//  Copyright © 2017年 极客天地. All rights reserved.
//

#import "GWRootModel.h"

@interface TemplateModel : GWRootModel
@property(strong,nonatomic) NSString * templateID;
@property(strong,nonatomic) NSString * templateName;
@property(strong,nonatomic) NSString * templateImagePath;
@property(strong,nonatomic) NSString * templateLayoutJsonPath;
@end
