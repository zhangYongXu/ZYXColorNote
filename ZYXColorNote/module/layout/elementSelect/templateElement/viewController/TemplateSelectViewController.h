//
//  BackgroundSelectViewController.h
//  TourNote
//
//  Created by 极客天地 on 2017/2/28.
//  Copyright © 2017年 极客天地. All rights reserved.
//
#import "TemplateViewModel.h"
#import "GWRootViewController.h"
typedef void (^TemplateDidSelectedBlock)(TemplateModel * templateModel);
@interface TemplateSelectViewController : GWRootViewController
@property(copy,nonatomic) TemplateDidSelectedBlock templateDidSelectedBlock;
-(void)setTemplateDidSelectedBlock:(TemplateDidSelectedBlock)templateDidSelectedBlock;
@end
