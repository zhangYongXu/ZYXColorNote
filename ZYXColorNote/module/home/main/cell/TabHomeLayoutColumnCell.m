//
//  TabHomeLayoutColumnCell.m
//  TourNote
//
//  Created by 极客天地 on 17/1/17.
//  Copyright © 2017年 极客天地. All rights reserved.
//

#import "TabHomeLayoutColumnCell.h"
#import "GWLayoutNetDataModel.h"
@interface TabHomeLayoutColumnCell()
@property (strong,nonatomic) GWLayoutNetDataModel * model;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIView *userView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end
@implementation TabHomeLayoutColumnCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
-(void)initUI{
    self.isShowSelectBtn = NO;
}
-(void)setIsShowSelectBtn:(BOOL)isShowSelectBtn{
    _isShowSelectBtn = isShowSelectBtn;
    self.selectBtn.hidden = !_isShowSelectBtn;
}
-(void)refreshUI{
    NSURL * url = [NSURL URLWithString:self.model.layoutPicImageUrl];
    [self.imageView sd_setImageWithURL:url completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        CGFloat height = (self.imageView.width/image.size.width)*image.size.height;
        self.imageView.height = height;
    }];
    
    self.userView.hidden =  (nil == self.model.publishUserPoint);
    if(nil != self.model.publishUserPoint){
        url = [NSURL URLWithString:self.model.publishUserPoint.img_url];
        [self.headerImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"头像"]];
        self.nameLabel.text = self.model.publishUserPoint.nick_name;
        self.dateLabel.text = self.model.createdAt;
    }
    
    self.selectBtn.selected = self.model.isSelected;
}
- (IBAction)selectBtnClicked:(id)sender {
}
-(void)setCellWithModel:(id)model{
    self.model = model;
    [self refreshUI];
}
@end
