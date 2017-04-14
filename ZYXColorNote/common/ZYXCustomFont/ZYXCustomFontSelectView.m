//
//  ZYXRGBColorSelectView.m
//  TourNote
//
//  Created by 极客天地 on 17/1/20.
//  Copyright © 2017年 极客天地. All rights reserved.
//

#import "ZYXCustomFontSelectView.h"

#import "ZYXFontViewModel.h"
#import "ZYXFontSelectCell.h"

static ZYXCustomFontSelectView * shareIntance = nil;
@interface ZYXCustomFontSelectView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UIView *customBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong,nonatomic) ZYXFontViewModel * fontViewModel;

@property(copy,nonatomic) FontConfirmSelectedBlock confirmSelectedBlock;
@end
@implementation ZYXCustomFontSelectView
-(ZYXFontViewModel *)fontViewModel{
    return [ZYXFontViewModel shareInstance];
}
-(void)initData{
    [self.fontViewModel requestAllCustomFontDataWithSuccessBlock:^(id object) {
        [self.collectionView reloadData];
    } FaildBlock:^(id object) {
        
    }];
}


-(void)initUI{
    self.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
    self.frame = [[UIScreen mainScreen] bounds];
    
    [self.collectionView registerNib:[ZYXFontSelectCell cellNib] forCellWithReuseIdentifier:[ZYXFontSelectCell reuseIdentifier]];
    
    [self.customBackgroundView addTapGetureWithBlock:^(UITapGestureRecognizer *tapGeture) {
        [self closeView];
    }];
}
-(void)popView{
    GWRootNavigationViewController * lastNvc = [[GWRootNavigationViewController navitionVCArray] lastObject];
    UIView * superView = [lastNvc.viewControllers.lastObject view];
    self.centerY = superView.height/2.0;
    [superView addSubview:self];
}
-(void)closeView{
    [self removeFromSuperview];
}
+(ZYXCustomFontSelectView *)shareInstance{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareIntance = [ZYXCustomFontSelectView loadFromXib];
    });
    return shareIntance;
}
+(void)closeView{
    ZYXCustomFontSelectView * view = [ZYXCustomFontSelectView shareInstance];
    [view closeView];
}
+(void)popViewConfirmSelectedBlock:(FontConfirmSelectedBlock)confirmSelectedBlock{
    ZYXCustomFontSelectView * view = [ZYXCustomFontSelectView shareInstance];
    [view setConfirmSelectedBlock:confirmSelectedBlock];
    [view popView];
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.fontViewModel.modelArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZYXFontSelectCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:[ZYXFontSelectCell reuseIdentifier] forIndexPath:indexPath];
    ZYXFontModel * model = self.fontViewModel.modelArray[indexPath.item];
    [cell setCellWithModel:model];
    return cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = CGSizeMake((self.collectionView.width-30)/2.0, 40);
    return size;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    ZYXFontModel * model = self.fontViewModel.modelArray[indexPath.item];
    if(model.isExistfontLocalFile){
        if(self.confirmSelectedBlock){
            self.confirmSelectedBlock(self,model);
        }
    }else{
        [self.fontViewModel downloadFontFileDataWithFontModel:model SuccessBlock:^(id object) {
            [SVProgressHUD showSuccessWithStatus:@"字体下载成功"];
            if(self.confirmSelectedBlock){
                self.confirmSelectedBlock(self,model);
            }
        } FaildBlock:^(id object) {
            
        }];
    }
    
    [self closeView];
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}
@end
