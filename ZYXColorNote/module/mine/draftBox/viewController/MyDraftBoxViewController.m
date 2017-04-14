//
//  MyDraftBoxViewController.m
//  TourNote
//
//  Created by 极客天地 on 2017/3/15.
//  Copyright © 2017年 极客天地. All rights reserved.
//

#import "MyDraftBoxViewController.h"
#import "GWLayoutDraftModel.h"
#import "TabHomeLayoutCell.h"
#import "MJRefresh.h"
#import "LayoutViewController.h"
#import "GWLayoutModel.h"
@interface MyDraftBoxViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSMutableArray<GWLayoutDraftModel*> * draftDataArray;
@end

@implementation MyDraftBoxViewController
-(NSMutableArray<GWLayoutDraftModel *> *)draftDataArray{
    if(nil == _draftDataArray){
        _draftDataArray = [GWLayoutDraftModel getDraftModelArray];
    }
    return _draftDataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)initUI{
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView registerNib:[TabHomeLayoutCell cellNib] forCellReuseIdentifier:[TabHomeLayoutCell reuseIdentifier]];
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _draftDataArray = [GWLayoutDraftModel getDraftModelArray];
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
    }];

}
#pragma mark UITableView数据源与代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.draftDataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TabHomeLayoutCell * cell = [tableView dequeueReusableCellWithIdentifier:[TabHomeLayoutCell reuseIdentifier]];
    GWLayoutDraftModel * model  = self.draftDataArray[indexPath.row];
    [cell setCellWithModel:model];
    
    return cell;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [TabHomeLayoutCell cellHeight];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        GWLayoutDraftModel * model  = self.draftDataArray[indexPath.row];
        [self.draftDataArray removeObject:model];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        NSFileManager * FM = [NSFileManager defaultManager];
        if([FM removeItemAtPath:model.layoutDraft error:nil]){
            NSLog(@"删除成功");
        }else{
            NSLog(@"删除失败");
        }
    }
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GWLayoutDraftModel * model  = self.draftDataArray[indexPath.row];
    NSData * layoutJsonData = [NSData dataWithContentsOfFile:model.layoutDraftFilePath];
    if(!layoutJsonData){
        [SVProgressHUD showErrorWithStatus:@"改草稿箱数据已损坏"];
    }else{
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:layoutJsonData options:NSJSONReadingMutableContainers error:nil];
        GWLayoutModel * layoutModel = [[GWLayoutModel alloc] init];
        [layoutModel setValuesForKeysWithDictionary:dict];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"TabHome" bundle:nil];
        LayoutViewController * lvc = [storyboard instantiateViewControllerWithIdentifier:@"LayoutViewController_SBID"];
        lvc.existLayoutModel = layoutModel;
        [self.navigationController pushViewController:lvc animated:YES];
    }
    
}

@end
