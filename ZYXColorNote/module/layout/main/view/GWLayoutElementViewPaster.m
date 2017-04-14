//
//  GWLayoutElementViewImage.m
//  TourNote
//
//  Created by 极客天地 on 17/1/13.
//  Copyright © 2017年 极客天地. All rights reserved.
//

#import "GWLayoutElementViewPaster.h"


@interface GWLayoutElementViewPaster()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
@implementation GWLayoutElementViewPaster
-(GWLayoutElementViewTypes)elementViewType{
    return GWLayoutElementViewTypePaster;
}

-(void)setPasterModel:(PasterModel *)pasterModel{
    _pasterModel = pasterModel;
    if(!STR_IS_NIL(_pasterModel.localImagePath)){
        UIImage * image = [UIImage imageWithContentsOfFile:_pasterModel.localImagePath];
        self.imageView.image = image;
        CGFloat imageWidth = self.imageView.width;
        CGFloat imageHeight = (imageWidth/image.size.width)*image.size.height;
        
        CGRect bounds = self.bounds;
        bounds.size.height = imageHeight + GWLayoutElementViewHandleAddWidth;
        self.bounds = bounds;
    }
    
}
-(GWElementModel *)elementModel{
    GWElementModel * model = [super elementModel];

    model.elementPasterSetName = self.pasterModel.pasterSetName;
    model.elementPasterID  = self.pasterModel.pasterID;
    
    return model;
}
-(void)initUI{
    [super initUI];
    self.imageView.frame = self.contentView.bounds;
    [self.contentView addSubview:self.imageView];
    self.tipString = @"";
}

-(void)refreshWithElementModel:(GWElementModel *)elementModel LyoutModel:(GWLayoutModel *)layoutModel{
    [super refreshWithElementModel:elementModel LyoutModel:layoutModel];
    self.pasterModel = [[PasterModel alloc] init];
    self.pasterModel.pasterID = elementModel.elementPasterID;
    self.pasterModel.pasterSetName = elementModel.elementPasterSetName;
    UIImage * image = [PasterViewModel pasterImageWithPasterModel:self.pasterModel];
    
    self.imageView.image = image;
}
-(void)contentViewDoubleTap:(UITapGestureRecognizer *)doubleTapGesure{
    [super contentViewDoubleTap:doubleTapGesure];
    
}




@end
