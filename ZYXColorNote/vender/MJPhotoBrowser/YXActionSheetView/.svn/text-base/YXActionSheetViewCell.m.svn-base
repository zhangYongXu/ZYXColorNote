//
//  SheetViewCell.m
//  BoBo
//
//  Created by BZBY on 15/7/24.
//  Copyright (c) 2015年 bzby. All rights reserved.
//

#import "YXActionSheetViewCell.h"
#import "YXActionSheetView.h"
@interface YXActionSheetViewCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong,nonatomic) YXActionSheetViewItem * model;
@end;
@implementation YXActionSheetViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initData];
    [self initUI];
}
- (void)initData{

}
- (void)initUI{
    self.layer.borderWidth = 0.3;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
}
- (void)refreshUI{
    self.titleLabel.text = self.model.title;
}
-(void)setCellWithModel:(id)model{
    self.model = model;
    [self refreshUI];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
