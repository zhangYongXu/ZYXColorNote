//
//  StrokeBrushSectionView.m
//  TourNote
//
//  Created by 极客天地 on 2017/3/1.
//  Copyright © 2017年 极客天地. All rights reserved.
//

#import "StrokeBrushSectionView.h"
@interface StrokeBrushSectionView()


@end
@implementation StrokeBrushSectionView

- (void)awakeFromNib {
    [super awakeFromNib];

}
-(void)initData{

}
-(void)initUI{
    [self drawBorderSolidLineWithPosition:BorderLinePositionBottom Color:[UIColor colorWithHex:0xf4f4f4] Width:0.5];
}
+(CGFloat)viewHeight{
    return 50;
}
@end
