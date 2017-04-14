//
//  PasterSectionView.m
//  TourNote
//
//  Created by 极客天地 on 2017/2/24.
//  Copyright © 2017年 极客天地. All rights reserved.
//

#import "PasterSectionView.h"
#import "PasterSetModel.h"
@interface PasterSectionView()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property(strong,nonatomic)PasterSetModel * model ;

@end
@implementation PasterSectionView

- (void)awakeFromNib {
    [super awakeFromNib];
}
-(void)refreshUI{
    self.nameLabel.text = self.model.pasterSetName;
}

-(void)setViewWithModel:(id)model{
    self.model = model;
    [self refreshUI];
}
+(CGFloat)viewHeight{
    return 40;
}
@end
