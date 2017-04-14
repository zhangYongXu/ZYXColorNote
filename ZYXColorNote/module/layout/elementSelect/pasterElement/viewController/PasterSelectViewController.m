//
//  PasterSelectViewController.m
//  TourNote
//
//  Created by 极客天地 on 2017/2/24.
//  Copyright © 2017年 极客天地. All rights reserved.
//

#import "PasterSelectViewController.h"



#import "PasterCell.h"
#import "PasterSetNameCell.h"
#import "PasterSectionView.h"
@interface PasterSelectViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UITableView *tabelView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong,nonatomic) PasterViewModel * pasterViewModel;
@property (strong,nonatomic) NSMutableArray * dataArray;

@end

@implementation PasterSelectViewController
- (IBAction)closeBtnClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(PasterViewModel *)pasterViewModel{
    if(nil == _pasterViewModel){
        _pasterViewModel = [[PasterViewModel alloc] init];
    }
    return _pasterViewModel;
}
-(NSMutableArray *)dataArray{
    return self.pasterViewModel.pasterSetArray;
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
    self.tabelView.tableFooterView = [[UIView alloc] init];
    self.tabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    [self.tabelView registerNib:[PasterSetNameCell cellNib] forCellReuseIdentifier:[PasterSetNameCell reuseIdentifier]];
    [self.collectionView registerNib:[PasterCell cellNib] forCellWithReuseIdentifier:[PasterCell reuseIdentifier]];
    [self.collectionView registerNib:[PasterSectionView viewNib] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[PasterSectionView reuseIdentifier]];
    
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tabelView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
}

#pragma UItableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PasterSetNameCell * cell = [tableView dequeueReusableCellWithIdentifier:[PasterSetNameCell reuseIdentifier]];
    PasterSetModel * model = self.dataArray[indexPath.row];
    [cell setCellWithModel:model];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [PasterSetNameCell cellHeight];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSIndexPath * collectionIndexPath = [NSIndexPath indexPathForItem:0 inSection:indexPath.row];
    [self.collectionView scrollToItemAtIndexPath:collectionIndexPath atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
}
#pragma UIcollection
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.dataArray.count;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    PasterSetModel * setModel  = self.dataArray[section];
    return setModel.pasterModelArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PasterCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:[PasterCell reuseIdentifier] forIndexPath:indexPath];
    PasterSetModel * setModel  = self.dataArray[indexPath.section];
    PasterModel * model = setModel.pasterModelArray[indexPath.item];
    [cell setCellWithModel:model];
    return cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger cols = 3.0;
    CGFloat width = (collectionView.width-20*4)/cols;
    CGFloat height = width * 1.2;
    return CGSizeMake(width, height);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 20, 0, 20);
}
-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if([kind isEqualToString:UICollectionElementKindSectionHeader]){
        PasterSectionView * view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[PasterSectionView reuseIdentifier] forIndexPath:indexPath];
        PasterSetModel * model = self.dataArray[indexPath.section];
        [view setViewWithModel:model];
        return view;
    }else{
        return nil;
    }
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(self.collectionView.width, [PasterSectionView viewHeight]);
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView.width == self.collectionView.width){
        
        NSIndexPath * indexPathNow = [self.collectionView indexPathsForVisibleItems].firstObject;
        
        NSIndexPath * tIndexPath = [NSIndexPath indexPathForRow:indexPathNow.section inSection:0];
        NSIndexPath * selectedIndexPath = self.tabelView.indexPathForSelectedRow;
        if(tIndexPath.row != selectedIndexPath.row){
            [self.tabelView selectRowAtIndexPath:tIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        }
    }
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PasterSetModel * setModel  = self.dataArray[indexPath.section];
    PasterModel * model = setModel.pasterModelArray[indexPath.item];
    if(self.pasterDidSelectedBlock){
        self.pasterDidSelectedBlock(model);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
@end




