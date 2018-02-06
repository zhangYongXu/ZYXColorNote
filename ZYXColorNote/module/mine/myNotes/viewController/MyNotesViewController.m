//
//  MyNotesViewController.m
//  ZYXColorNote
//
//  Created by 极客天地 on 2018/2/5.
//  Copyright © 2018年 极客天地. All rights reserved.
//

#import "MyNotesViewController.h"

#import "GWLayoutViewModel.h"


#import "TabHomeLayoutColumnCell.h"

#import "MJRefresh.h"

#import "ShowImageLayoutViewController.h"

@interface MyNotesViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong,nonatomic) GWLayoutViewModel * layoutViewModel;

@property (strong,nonatomic) NSMutableArray * dataArray;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@property (assign,nonatomic) BOOL isEditState;
@end

@implementation MyNotesViewController
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
    [self createRightItemWithTitle:@"编辑"];
    self.isEditState = NO;
    self.deleteBtn.hidden = YES;
}
-(void)rightItemClickedHandle:(UIBarButtonItem *)sender{
    self.isEditState = !self.isEditState;
    if(self.isEditState){
        sender.title = @"完成";
        self.deleteBtn.hidden = NO;
    }else{
        sender.title = @"编辑";
        self.deleteBtn.hidden = YES;
    }
    self.collectionView.height = SCREEN_HEIGHT - SystemNavBarHeight - (self.isEditState?self.deleteBtn.height:0);
    [self.collectionView reloadData];
}
-(void)initData{
    [self requestData];
}
-(void)requestData{
    [self.layoutViewModel requestMineLayoutDataWithSuccessBlock:^(id object) {
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
    cell.isShowSelectBtn = self.isEditState;
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
    
    if(self.isEditState){//编辑状态
        model.isSelected = !model.isSelected;
        [collectionView reloadItemsAtIndexPaths:@[indexPath]];
    }else{
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"TabHome" bundle:nil];
        NSString * identifier = NSStringFromClass([ShowImageLayoutViewController class]);
        ShowImageLayoutViewController * silvc = [storyboard instantiateViewControllerWithIdentifier:identifier];
        silvc.layoutNetDataModel = model;
        silvc.layoutViewModel = self.layoutViewModel;
        [self.navigationController pushViewController:silvc animated:YES];
    }
    
    
}

- (IBAction)deleteBtnClicked:(id)sender {
    NSMutableArray * selectArray = [[NSMutableArray alloc] init];
    NSMutableArray * itemArray = [[NSMutableArray alloc] init];
    for(GWLayoutNetDataModel * model in self.dataArray){
        if(model.isSelected){
            [selectArray addObject:model];
            BmobHttpApiDeleteItem * item = [[BmobHttpApiDeleteItem alloc] init];
            item.tableName = @"LayoutModel";
            item.objectId = model.objectId;
            [itemArray addObject:item];
        }
    }
    if(ARRAY_IS_EMPTY(selectArray)){
        [SVProgressHUD showErrorWithStatus:@"请选择至少一个来删除"];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [BmobHttpApiDelete deleteDataWithArray:itemArray showProgress:YES sucess:^(NSDictionary *dictionary) {
        NSLog(@"BmobHttpApiDelete LayoutModel:%@",dictionary);
        [weakSelf requestData];
    } failed:^(NSString *errorMsg) {
        
    }];
}


@end
