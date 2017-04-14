//
//  BackgroundSelectViewController.h
//  TourNote
//
//  Created by 极客天地 on 2017/2/28.
//  Copyright © 2017年 极客天地. All rights reserved.
//
#import "BackgroundViewModel.h"
#import "GWRootViewController.h"
typedef void (^BackgroundDidSelectedBlock)(BackgroundModel * backgroundModel);
@interface BackgroundSelectViewController : GWRootViewController
@property(copy,nonatomic) BackgroundDidSelectedBlock backgroundDidSelectedBlock;
-(void)setBackgroundDidSelectedBlock:(BackgroundDidSelectedBlock)backgroundDidSelectedBlock;
@end
