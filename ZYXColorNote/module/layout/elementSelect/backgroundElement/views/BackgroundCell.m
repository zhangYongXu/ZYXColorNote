//
//  BackgroundCell.m
//  TourNote
//
//  Created by 极客天地 on 2017/2/28.
//  Copyright © 2017年 极客天地. All rights reserved.
//

#import "BackgroundCell.h"
#import "BackgroundModel.h"
@interface BackgroundCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property(strong,nonatomic)BackgroundModel * model;
@end
@implementation BackgroundCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)refreshUI{
    UIImage * image = [UIImage imageWithContentsOfFile:self.model.showImagePath];
    self.imageView.image = image;
    self.nameLabel.text = self.model.backgroundName;
}
-(void)setCellWithModel:(id)model{
    self.model = model;
    [self refreshUI];
}
@end
