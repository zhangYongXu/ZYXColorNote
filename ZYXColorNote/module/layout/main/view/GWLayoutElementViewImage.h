//
//  GWLayoutElementViewImage.h
//  TourNote
//
//  Created by 极客天地 on 17/1/13.
//  Copyright © 2017年 极客天地. All rights reserved.
//

#import "GWLayoutElementView.h"
@class GWLayoutElementViewImage;
typedef void (^ElementViewDidSelectedImageBlock)(GWLayoutElementViewImage * elementViewImage,UIImage * selectedImage);
@interface GWLayoutElementViewImage : GWLayoutElementView
@property(strong,nonatomic) UIImage * image;

@property(copy,nonatomic)ElementViewDidSelectedImageBlock elementViewDidSelectedImageBlock;
-(void)setElementViewDidSelectedImageBlock:(ElementViewDidSelectedImageBlock)elementViewDidSelectedImageBlock;

-(void)selectImage;
@end
