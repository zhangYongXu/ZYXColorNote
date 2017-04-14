//
//  GWLayoutDraftModel.h
//  TourNote
//
//  Created by 极客天地 on 2017/3/3.
//  Copyright © 2017年 极客天地. All rights reserved.
//

#import "GWRootModel.h"

@interface GWLayoutDraftModel : GWRootModel
@property(strong,nonatomic) NSString* layoutDraft;

@property(strong,nonatomic) NSString* layoutDraftFileName;
@property(strong,nonatomic) NSString* layoutDraftFilePath;

@property(strong,nonatomic) NSString* layoutDraftImageName;
@property(strong,nonatomic) NSString* layoutDraftImagePath;

@property(strong,nonatomic) NSDate* createDate;

+(NSMutableArray<GWLayoutDraftModel*>*)getDraftModelArray;
@end
