//
//  TabHomeLayoutCell.m
//  TourNote
//
//  Created by 极客天地 on 17/1/17.
//  Copyright © 2017年 极客天地. All rights reserved.
//

#import "TabHomeLayoutCell.h"
#import "GWLayoutDraftModel.h"
#import "GWLabel.h"
@interface TabHomeLayoutCell()
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet GWLabel *dateLabel;
@property (strong,nonatomic) GWLayoutDraftModel * model;
@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
@property (weak, nonatomic) IBOutlet GWLabel *weekLabel;
@property (weak, nonatomic) IBOutlet GWLabel *timeLabel;
@end
@implementation TabHomeLayoutCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
-(void)refreshUI{
    self.contentLabel.text = [self.model.createDate stringWithFormat:@"dd"];
    self.dateLabel.text = [self.model.createDate stringWithFormat:@"yyyy-MM"];
    self.weekLabel.text = [self.model.createDate weekdayStr];
    self.timeLabel.text = [self.model.createDate stringWithFormat:@"HH:mm"];
    
    UIImage * image = [UIImage imageWithContentsOfFile:self.model.layoutDraftImagePath];
    self.showImageView.image = image;
}
-(void)setCellWithModel:(id)model{
    self.model = model;
    [self refreshUI];
}
+(CGFloat)cellHeight{
    return 120;
}
@end
