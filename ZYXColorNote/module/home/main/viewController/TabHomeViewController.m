//
//  TabHomeViewController.m
//  AllPeopleReading
//
//  Created by 极客天地 on 16/8/3.
//  Copyright © 2016年 极客天地. All rights reserved.
//

#import "TabHomeViewController.h"
#import "GWLayoutViewModel.h"


#import "TabHomeLayoutColumnCell.h"

#import "MJRefresh.h"

#import "ShowImageLayoutViewController.h"



@interface TabHomeViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong,nonatomic) GWLayoutViewModel * layoutViewModel;

@property (strong,nonatomic) NSMutableArray * dataArray;


@end

@implementation TabHomeViewController
-(GWLayoutViewModel *)layoutViewModel{
    if(nil == _layoutViewModel){
        _layoutViewModel = [[GWLayoutViewModel alloc] init];
    }
    return _layoutViewModel;
}
-(NSMutableArray *)dataArray{
    return self.layoutViewModel.netLaoutDataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];

}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.navigationController.navigationBar setHidden:NO];
    self.navigationController.navigationBar.top = 20;
}

-(void)viewWillDisappear:(BOOL)animated{
    
}
-(void)initData{
    [self requestData];
}
-(void)requestData{
    [self.layoutViewModel requestAllLayoutDataWithSuccessBlock:^(id object) {
        [self.collectionView reloadData];
        [self.collectionView.header endRefreshing];
    } FaildBlock:^(id object) {
        [self.collectionView.header endRefreshing];
    }];
}

-(void)initUI{
    
    [self.collectionView registerNib:[TabHomeLayoutColumnCell cellNib] forCellWithReuseIdentifier:[TabHomeLayoutColumnCell reuseIdentifier]];
    self.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestData];
    }];
}
#pragma mark collectionView数据源于代理方法

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TabHomeLayoutColumnCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:[TabHomeLayoutColumnCell reuseIdentifier] forIndexPath:indexPath];
    GWLayoutNetDataModel * model  = self.dataArray[indexPath.item];
    [cell setCellWithModel:model];
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cellW = 0;
    CGFloat cellH = 0;
    CGFloat cols = 2;
    cellW = (collectionView.width-15*(cols+1))/cols;
    cellH = 240*SCREEN_WIDTH_TO375_PROPERTION;
    
    return CGSizeMake(cellW, cellH);
    
}



-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(15, 15, 15, 15);
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 15;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    GWLayoutNetDataModel * model  = self.dataArray[indexPath.item];
    
    [self performSegueWithIdentifier:@"TabHomeToShowImageLayoutSegue" sender:model];

}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIViewController * vc = segue.destinationViewController;

    if([vc isKindOfClass:[ShowImageLayoutViewController class]]){
        ShowImageLayoutViewController * silvc = (ShowImageLayoutViewController*)vc;
        silvc.layoutNetDataModel = sender;
        silvc.layoutViewModel = self.layoutViewModel;
    }
}

@end
