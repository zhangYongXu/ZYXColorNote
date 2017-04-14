//
//  PasterSetNameCell.m
//  TourNote
//
//  Created by 极客天地 on 2017/2/24.
//  Copyright © 2017年 极客天地. All rights reserved.
//

#import "PasterSetNameCell.h"
#import "PasterSetModel.h"
@interface PasterSetNameCell()
@property (weak, nonatomic) IBOutlet UIView *customSelectedBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property(strong,nonatomic)PasterSetModel * model ;

@end
@implementation PasterSetNameCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    

}
-(void)initUI{
    self.selectedBackgroundView = self.customSelectedBackgroundView;
}
-(void)refreshUI{
    self.nameLabel.text = self.model.pasterSetName;
}
-(void)setCellWithModel:(id)model{
    self.model = model;
    [self refreshUI];
}
+(CGFloat)cellHeight{
    return 40;
}

@end
