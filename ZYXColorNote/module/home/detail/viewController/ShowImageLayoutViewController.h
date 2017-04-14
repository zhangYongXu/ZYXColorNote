//
//  ShowImageLayoutViewController.h
//  TourNote
//
//  Created by 极客天地 on 2017/2/7.
//  Copyright © 2017年 极客天地. All rights reserved.
//

#import "GWRootViewController.h"

#import "GWLayoutViewModel.h"

@interface ShowImageLayoutViewController : GWRootViewController
@property (strong,nonatomic) GWLayoutViewModel * layoutViewModel;
@property(strong,nonatomic) GWLayoutNetDataModel * layoutNetDataModel;
@end
