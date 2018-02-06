//
//  ZYXFontSelectCell.m
//  TourNote
//
//  Created by 极客天地 on 2017/2/6.
//  Copyright © 2017年 极客天地. All rights reserved.
//

#import "ZYXFontSelectCell.h"
#import "ZYXFontModel.h"
@interface ZYXFontSelectCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) ZYXFontModel * model;
@end
@implementation ZYXFontSelectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)initUI{
    [self drawBorderSolidLineWithPosition:BorderLinePositionBottom Color:[UIColor colorWithHex:AppViewBottomLineColor] Width:AppViewBottomLineWidth];
}
-(void)refreshUI{
    NSURL * url = [NSURL URLWithString:self.model.showImageUrl];
    [self.imageView sd_setImageWithURL:url];
}
-(void)setCellWithModel:(id)model{
    self.model = model;
    [self refreshUI];
}
@end
