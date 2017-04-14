//
//  StrokeSelectViewController.m
//  TourNote
//
//  Created by 极客天地 on 2017/3/1.
//  Copyright © 2017年 极客天地. All rights reserved.
//

#import "StrokeSelectViewController.h"

#import "StrokeBrushViewModel.h"
#import "StrokeBrushCell.h"
#import "StrokeBrushSectionView.h"

@interface StrokeSelectViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong,nonatomic) StrokeBrushViewModel * strokeBrushViewModel;
@property (strong,nonatomic) NSMutableArray * dataArray;

@end

@implementation StrokeSelectViewController
- (IBAction)closeBtnClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(StrokeBrushViewModel *)strokeBrushViewModel{
    if(nil == _strokeBrushViewModel){
        _strokeBrushViewModel = [[StrokeBrushViewModel alloc] init];
    }
    return _strokeBrushViewModel;
}

-(NSMutableArray *)dataArray{
    if(nil == _dataArray){
        _dataArray = [[NSMutableArray alloc] init];
        
        [_dataArray addObject:self.strokeBrushViewModel.colorBrushModelArray];
        [_dataArray addObject:self.strokeBrushViewModel.imageBrushModelArray];
    }
    return _dataArray;
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
    [self.collectionView registerNib:[StrokeBrushCell cellNib] forCellWithReuseIdentifier:[StrokeBrushCell reuseIdentifier]];
    [self.collectionView registerNib:[StrokeBrushSectionView viewNib] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[StrokeBrushSectionView reuseIdentifier]];
}

#pragma UIcollection
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.dataArray.count;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [(NSArray*)self.dataArray[section] count];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    StrokeBrushCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:[StrokeBrushCell reuseIdentifier] forIndexPath:indexPath];
    
    StrokeBrushModel * strokeBrushModel  = self.dataArray[indexPath.section][indexPath.item];
    [cell setCellWithModel:strokeBrushModel];
    return cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger cols = 2;
    CGFloat width = (collectionView.width-10*(cols+1))/cols;
    CGFloat height = width * 0.44;
    return CGSizeMake(width, height);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if([kind isEqualToString:UICollectionElementKindSectionHeader]){
        StrokeBrushSectionView * view = (StrokeBrushSectionView*)[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[StrokeBrushSectionView reuseIdentifier] forIndexPath:indexPath];
        NSString * name = nil;
        if(indexPath.section == 0){
            name = @"颜色笔刷";
        }else{
            name = @"图片笔刷";
        }
        view.nameLabel.text = name;
        return view;
    }else{
        return nil;
    }
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(collectionView.width, [StrokeBrushSectionView viewHeight]);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    StrokeBrushModel * strokeBrushModel  = self.dataArray[indexPath.section][indexPath.item];
    if(self.strokeBrushDidSelectedBlock){
        self.strokeBrushDidSelectedBlock(strokeBrushModel);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
@end
