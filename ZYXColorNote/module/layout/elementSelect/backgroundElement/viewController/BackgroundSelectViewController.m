//
//  BackgroundSelectViewController.m
//  TourNote
//
//  Created by 极客天地 on 2017/2/28.
//  Copyright © 2017年 极客天地. All rights reserved.
//

#import "BackgroundSelectViewController.h"


#import "BackgroundCell.h"

@interface BackgroundSelectViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong,nonatomic) BackgroundViewModel * backgroundViewModel;
@property (strong,nonatomic) NSMutableArray * dataArray;
@end

@implementation BackgroundSelectViewController
- (IBAction)closeBtnClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(BackgroundViewModel *)backgroundViewModel{
    if(nil == _backgroundViewModel){
        _backgroundViewModel = [[BackgroundViewModel alloc] init];
    }
    return _backgroundViewModel;
}

-(NSMutableArray *)dataArray{
    return self.backgroundViewModel.backgroundModelArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self.navigationController.navigationBar setHidden:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)initData{

}
-(void)initUI{
    [self.collectionView registerNib:[BackgroundCell cellNib] forCellWithReuseIdentifier:[BackgroundCell reuseIdentifier]];
}

#pragma UIcollection

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BackgroundCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:[BackgroundCell reuseIdentifier] forIndexPath:indexPath];
    BackgroundModel * backgroundModel  = self.dataArray[indexPath.item];
    [cell setCellWithModel:backgroundModel];
    return cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger cols = 3;
    CGFloat width = (collectionView.width-10*(cols+1))/cols;
    CGFloat height = width * 1.7;
    return CGSizeMake(width, height);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    BackgroundModel * backgroundModel  = self.dataArray[indexPath.item];
    if(self.backgroundDidSelectedBlock){
        self.backgroundDidSelectedBlock(backgroundModel);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
@end
