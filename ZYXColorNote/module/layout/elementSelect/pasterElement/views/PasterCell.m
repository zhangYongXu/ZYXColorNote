//
//  PasterCell.m
//  TourNote
//
//  Created by 极客天地 on 2017/2/24.
//  Copyright © 2017年 极客天地. All rights reserved.
//

#import "PasterCell.h"
#import "PasterModel.h"
@interface PasterCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (strong,nonatomic) PasterModel * model ;

@end
@implementation PasterCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(void)refreshUI{
    UIImage * image = [UIImage imageWithContentsOfFile:self.model.localImagePath];
    self.imageView.image = image;
    self.nameLabel.text = self.model.pasterName;
}
-(void)setCellWithModel:(id)model{
    self.model = model;
    [self refreshUI];
}
@end
