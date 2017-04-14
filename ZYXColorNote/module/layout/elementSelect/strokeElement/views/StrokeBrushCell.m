//
//  StrokeBrushCell.m
//  TourNote
//
//  Created by 极客天地 on 2017/3/1.
//  Copyright © 2017年 极客天地. All rights reserved.
//

#import "StrokeBrushCell.h"
#import "StrokeBrushModel.h"
@interface StrokeBrushCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (strong,nonatomic) StrokeBrushModel * model;
@end
@implementation StrokeBrushCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
-(void)refreshUI{
    UIImage * image = [UIImage imageWithContentsOfFile:self.model.showImagePath];
    self.imageView.image = image;
    self.nameLabel.text = self.model.strokeBrushName;
}
-(void)setCellWithModel:(id)model{
    self.model = model;
    [self refreshUI];
}
@end
