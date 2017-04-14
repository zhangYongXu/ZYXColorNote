//
//  GWLayoutElementViewImage.m
//  TourNote
//
//  Created by 极客天地 on 17/1/13.
//  Copyright © 2017年 极客天地. All rights reserved.
//

#import "GWLayoutElementViewImage.h"

#import "ZYXImageEditViewController.h"
#import "GWRootNavigationViewController.h"

#import "ZYXImagePickerManager.h"

@interface GWLayoutElementViewImage()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
@implementation GWLayoutElementViewImage
-(GWLayoutElementViewTypes)elementViewType{
    return GWLayoutElementViewTypeImage;
}

-(UIImage *)image{
    return self.imageView.image;
}
-(void)setImage:(UIImage *)image{
    self.imageView.image = image;
    CGFloat imageWidth = self.imageView.width;
    CGFloat imageHeight = (imageWidth/image.size.width)*image.size.height;
    
    CGRect bounds = self.bounds;
    bounds.size.height = imageHeight + GWLayoutElementViewHandleAddWidth;
    self.bounds = bounds;
}
-(GWElementModel *)elementModel{
    GWElementModel * model = [super elementModel];

    model.elementPicImageBase64String = [UIImage base64StringWithImage:[self.image scaleToSize:self.contentView.bounds.size]];
    
    return model;
}
-(void)initUI{
    [super initUI];
    self.imageView.frame = self.contentView.bounds;
    [self.contentView addSubview:self.imageView];
    self.tipString = @"双击更换图片";
    self.image = [UIImage imageNamed:@"network_image_default"];
}

-(void)refreshWithElementModel:(GWElementModel *)elementModel LyoutModel:(GWLayoutModel *)layoutModel{
    [super refreshWithElementModel:elementModel LyoutModel:layoutModel];
    //NSURL * url = [NSURL URLWithString:self.elementModel.elementImageUrl];
    //[self.imageView setImageWithURL:url];
    UIImage * image = [UIImage imageFromBase64String:elementModel.elementPicImageBase64String];
    self.imageView.image = image;
    self.imageView.backgroundColor = [UIColor clearColor];
}
-(void)contentViewDoubleTap:(UITapGestureRecognizer *)doubleTapGesure{
    [super contentViewDoubleTap:doubleTapGesure];
    [self selectImage];
}

-(void)selectImage{
    
    UIAlertController *actionSheetController = [UIAlertController alertControllerWithTitle:nil message:@"选择图片" preferredStyle:UIAlertControllerStyleActionSheet];
    // 响应方法-取消
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    // 响应方法-相册
    UIAlertAction *takeAction = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showImagePickerVCWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    // 响应方法-拍照
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showImagePickerVCWithSourceType:UIImagePickerControllerSourceTypeCamera];
    }];
    // 添加响应方式
    [actionSheetController addAction:cancelAction];
    [actionSheetController addAction:takeAction];
    [actionSheetController addAction:photoAction];
    // 显示
    [APPDelegate.window.rootViewController presentViewController:actionSheetController animated:YES completion:nil];
}
- (void)showImagePickerVCWithSourceType:(UIImagePickerControllerSourceType)sourceType{
    [ZYXImagePickerManager showImagePickerWithSorceType:sourceType CompleteBlock:^(UIImage *image) {
        [self didSelectedImage:image];
    }];
}
- (void)didSelectedImage:(UIImage*)image{
    ZYXImageEditViewController * imageEditVc = [[ZYXImageEditViewController alloc] init];
    imageEditVc.image = [image fixOrientation];
    imageEditVc.hidesBottomBarWhenPushed = YES;
    [imageEditVc setImageEditCompleteBlock:^(UIImage *editedImage) {
        self.image = editedImage;
        
        [self elementModel];
        if(self.elementViewDidSelectedImageBlock){
            self.elementViewDidSelectedImageBlock(self,editedImage);
        }
    }];
    
    GWRootNavigationViewController * nvc = [[GWRootNavigationViewController navitionVCArray] lastObject];
    [nvc pushViewController:imageEditVc animated:YES];
}




@end
