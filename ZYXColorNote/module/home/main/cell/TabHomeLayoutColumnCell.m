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

@end
@implementation TabHomeLayoutColumnCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
-(void)refreshUI{
    NSURL * url = [NSURL URLWithString:self.model.layoutPicImageUrl];
    [self.imageView setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        CGFloat height = (self.imageView.width/image.size.width)*image.size.height;
        self.imageView.height = height;
    }];
}
-(void)setCellWithModel:(id)model{
    self.model = model;
    [self refreshUI];
}
@end
