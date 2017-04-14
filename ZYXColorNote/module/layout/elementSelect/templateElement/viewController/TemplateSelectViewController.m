//
//  BackgroundSelectViewController.m
//  TourNote
//
//  Created by 极客天地 on 2017/2/28.
//  Copyright © 2017年 极客天地. All rights reserved.
//

#import "TemplateSelectViewController.h"


#import "TemplateCell.h"

@interface TemplateSelectViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong,nonatomic) TemplateViewModel * templateViewModel;
@property (strong,nonatomic) NSMutableArray * dataArray;
@end

@implementation TemplateSelectViewController
- (IBAction)closeBtnClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(TemplateViewModel *)templateViewModel{
    if(nil == _templateViewModel){
        _templateViewModel = [[TemplateViewModel alloc] init];
    }
    return _templateViewModel;
}

-(NSMutableArray *)dataArray{
    return self.templateViewModel.templateModelArray;
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
    [self.collectionView registerNib:[TemplateCell cellNib] forCellWithReuseIdentifier:[TemplateCell reuseIdentifier]];
}

#pragma UIcollection

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TemplateCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:[TemplateCell reuseIdentifier] forIndexPath:indexPath];
    TemplateModel * templateModel  = self.dataArray[indexPath.item];
    [cell setCellWithModel:templateModel];
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
    TemplateModel * templateModel  = self.dataArray[indexPath.item];
    if(self.templateDidSelectedBlock){
        self.templateDidSelectedBlock(templateModel);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
@end
