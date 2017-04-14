//
//  BackgroundViewModel.h
//  TourNote
//
//  Created by 极客天地 on 2017/2/28.
//  Copyright © 2017年 极客天地. All rights reserved.
//

#import "BackgroundModel.h"
@interface BackgroundViewModel : RootViewModel
@property(strong,nonatomic)NSMutableArray<BackgroundModel*>* backgroundModelArray;

+(BackgroundModel*)backgroundModelWithBackgroundName:(NSString*)backgroundName;
@end
