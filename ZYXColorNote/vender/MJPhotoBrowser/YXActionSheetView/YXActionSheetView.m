//
//  YXActionSheetView.m
//  BoBo
//
//  Created by BZBY on 15/7/24.
//  Copyright (c) 2015年 bzby. All rights reserved.
//

#import "YXActionSheetView.h"
#import "YXActionSheetViewCell.h"

@interface YXActionSheetView()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *backGroundView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong,nonatomic) NSMutableArray * dataArray;

@property (assign,nonatomic)SheetViewStatus viewStatus;

@property (assign,nonatomic)BOOL showOrHiddenAnimationRuning;

@property (copy,nonatomic) HandleBlock  dismissCompleteHandleBlock;
@end
@implementation YXActionSheetView

-(void)awakeFromNib{
    [super awakeFromNib];
    [self initData];
    [self initUI];
    [self addTapGeture];
}
-(void)initData{
    self.showOrHiddenAnimationRuning = NO;
    self.dataArray = [[NSMutableArray alloc] init];
    
    [self.dataArray addObject:[[NSMutableArray alloc] init]];
    [self.dataArray addObject:@[[YXActionSheetViewItem cancelItem]]];
}
-(void)initUI{
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 15);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.backGroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    self.alpha = 0;
    self.tableView.top = self.height;
    self.viewStatus = SheetViewItemTypeHidden;
    
}

-(SheetViewStatus)actionSheetViewStatus{
    return self.viewStatus;
}
-(void)addTapGeture{
    UITapGestureRecognizer * tapGeture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGetureHandle:)];
    [self.backGroundView addGestureRecognizer:tapGeture];
}
-(void)tapGetureHandle:(UITapGestureRecognizer*)tapGeture{
    [self hiddenActionSheetView:YES];
}

-(void)addSheetItemWithItemType:(SheetViewItemType)sheetViewItemType HandleBlock:(HandleBlock)handleBlock{
    YXActionSheetViewItem * item = [[YXActionSheetViewItem alloc] init];
    item.sheetViewItmeType = sheetViewItemType;
    switch (sheetViewItemType) {
        case SheetViewItemTypeCancel:
            item.title = @"取消";
            break;
        case SheetViewItemTypeConfrim:
            item.title = @"确认";
            break;
        case SheetViewItemTypeReport:
            item.title = @"举报";
            break;
        case SheetViewItemTypeSave:
            item.title = @"保存";
            break;
        default:
            break;
    }
    item.handleBlock = handleBlock;
    [[self.dataArray firstObject] addObject:item];
    [self.tableView reloadData];
    
    self.tableView.height = self.tableView.contentSize.height;
    self.tableView.top = self.height;
}
-(void)addSheetItemWithTitle:(NSString *)title HandleBlock:(HandleBlock)handleBlock{
    YXActionSheetViewItem * item = [[YXActionSheetViewItem alloc] init];
    item.sheetViewItmeType = SheetViewItemTypeNormal;
    item.title = title;
    item.handleBlock = handleBlock;
    [[self.dataArray firstObject] addObject:item];
    [self.tableView reloadData];
    
    self.tableView.height = self.tableView.contentSize.height;
    self.tableView.top = self.height;
}
-(void)removeAllSheetItem{
    [[self.dataArray firstObject] removeAllObjects];
    [self.tableView reloadData];
}
-(void)setActionSheetViewDismissCompleteHandleBlock:(HandleBlock)handleBlock{
    self.dismissCompleteHandleBlock = handleBlock;
}
#pragma mark 数据源与代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [(NSArray*)self.dataArray[section] count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXActionSheetViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[YXActionSheetViewCell reuseIdentifier]];
    if(nil == cell){
        cell = [YXActionSheetViewCell loadFromXib];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    YXActionSheetViewItem * model = self.dataArray[indexPath.section][indexPath.row];
    [cell setCellWithModel:model];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(self.dataArray.count-1 != section){
        return 0;
    }
    return 5;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(self.dataArray.count-1 != section){
        return nil;
    }
    UIView * view = [[UIView alloc] init];
    view.height = 5;
    view.width = self.tableView.width;
    view.backgroundColor = [UIColor lightGrayColor];
    return view;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self hiddenActionSheetView:YES];
    YXActionSheetViewItem * itme = self.dataArray[indexPath.section][indexPath.row];
    if(itme.handleBlock){
        itme.handleBlock();
    }
}


#pragma mark 显示隐藏
-(void)showActionSheetView:(BOOL)isAnimation{
    [APPDelegate.window addSubview:self];
    if(self.height != self.superview.height){
        self.height = self.superview.height;
        self.tableView.height = self.tableView.contentSize.height;
        self.tableView.top = self.height;
    }
   
    if(self.showOrHiddenAnimationRuning){
        return;
    }
    if(self.viewStatus == SheetViewItemTypeShowing){
        return;
    }
    if(isAnimation){
        self.showOrHiddenAnimationRuning = YES;
        [UIView animateWithDuration:0.25 animations:^{
            self.alpha = 1;
            self.tableView.bottom = self.height;
        }completion:^(BOOL finished) {
            self.showOrHiddenAnimationRuning = NO;
            self.viewStatus = SheetViewItemTypeShowing;
        }];
    }else{
        self.alpha = 1;
        self.tableView.bottom = self.height;
        self.viewStatus = SheetViewItemTypeShowing;
    }
}
-(void)hiddenActionSheetView:(BOOL)isAnimation{
    if(self.showOrHiddenAnimationRuning){
        return;
    }
    if(self.viewStatus == SheetViewItemTypeHidden){
        return;
    }
    if(self.dismissCompleteHandleBlock){
        self.dismissCompleteHandleBlock();
    }
    if(isAnimation){
        self.showOrHiddenAnimationRuning = YES;
        [UIView animateWithDuration:0.25 animations:^{
            self.alpha = 0;
            self.tableView.top = self.height;
        }completion:^(BOOL finished) {
            self.showOrHiddenAnimationRuning = NO;
            self.viewStatus = SheetViewItemTypeHidden;
            [self removeFromSuperview];
        }];
    }else{
        self.alpha = 0;
        self.tableView.top = self.height;
        self.viewStatus = SheetViewItemTypeHidden;
        [self removeFromSuperview];
    }
}
@end

@implementation YXActionSheetViewItem

+(YXActionSheetViewItem *)cancelItem{
    YXActionSheetViewItem * item = [[YXActionSheetViewItem alloc] init];
    item.sheetViewItmeType = SheetViewItemTypeCancel;
    item.title = @"取消";
    return item;
}
@end
