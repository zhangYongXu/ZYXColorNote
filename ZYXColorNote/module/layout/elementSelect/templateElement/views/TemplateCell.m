//
//  BackgroundCell.m
//  TourNote
//
//  Created by 极客天地 on 2017/2/28.
//  Copyright © 2017年 极客天地. All rights reserved.
//

#import "TemplateCell.h"
#import "TemplateModel.h"
@interface TemplateCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property(strong,nonatomic)TemplateModel * model;
@end
@implementation TemplateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)refreshUI{
    UIImage * image = [UIImage imageWithContentsOfFile:self.model.templateImagePath];
    self.imageView.image = image;
    self.nameLabel.text = self.model.templateName;
}
-(void)setCellWithModel:(id)model{
    self.model = model;
    [self refreshUI];
}
@end
