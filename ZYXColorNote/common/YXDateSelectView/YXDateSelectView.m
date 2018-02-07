//
//  YXDateSelectView.m
//  JiaMen
//
//  Created by 拓之林 on 16/6/23.
//  Copyright © 2016年 拓之林. All rights reserved.
//

#import "YXDateSelectView.h"

@interface YXDateSelectView()
@property (strong,nonatomic) UIView * mySuperView;
@property (assign,nonatomic) CGFloat dropMaxHeight;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *pickerContentView;

@property(copy,nonatomic)YXDateSelectConfirmBlock dateSelectConfirmBlock;

@property(strong,nonatomic) YXCustomDateView *customDateView;


@end
@implementation YXDateSelectView
-(YXCustomDateView *)customDateView{
    if(nil == _customDateView){
        _customDateView = [YXCustomDateView loadFromXibForFrameWork];
        _customDateView.dateViewMode = DateViewModeDate;
        
        NSInteger nowYear = [[[[NSDate date] init] stringWithFormat:@"yyyy"] integerValue];
        NSInteger startYear = nowYear - 80;
        NSInteger endYear = nowYear + 50;
        NSString * startDateStr = [NSString stringWithFormat:@"%ld-01-01 12:00:00",startYear];
        NSString * endDateStr = [NSString stringWithFormat:@"%ld-01-01 12:00:00",endYear];
        _customDateView.minDate = [NSDate dateWithString:startDateStr formate:@"yyyy-MM-dd HH:mm:ss"];
        _customDateView.maxDate = [NSDate dateWithString:endDateStr formate:@"yyyy-MM-dd HH:mm:ss"];
      
    }
    return _customDateView;
}
-(void)awakeFromNib{
    [super awakeFromNib];
}
-(void)initData{
    self.dropMaxHeight = 44 + 234*SCREEN_WIDTH_TO375_PROPERTION;
}

-(void)initUI{
    self.height = SCREEN_HEIGHT;
    self.width = SCREEN_WIDTH;
    self.contentView.height = self.dropMaxHeight;
    self.contentView.top = self.height;
    self.alpha = 0;
    self.hidden = YES;
    self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.7];
    self.contentView.clipsToBounds = NO;
    
    self.customDateView.customDatePickerView.frame = self.pickerContentView.bounds;
    [self.pickerContentView addSubview:self.customDateView.customDatePickerView];
    
    [self.customDateView refreshDataWithConfirmBlock:NULL];
    
    __weak typeof(self) weakSelf = self;
    [self addSingleTapGetureWithBlock:^(UITapGestureRecognizer *tapGeture) {
        [weakSelf hiddenDateSelectViewAnimation:YES];
    }];
}
-(void)initViewWithDateSelectConfirmBlock:(YXDateSelectConfirmBlock)dateSelectConfirmBlock{
    self.dateSelectConfirmBlock = dateSelectConfirmBlock;
}

-(void)showDateSelectViewAnimation:(BOOL)isAnimation{
    
    if(nil == self.mySuperView || (nil != self.superview && self.mySuperView != self.superview)){
        self.mySuperView = self.superview;
    }
    
    if(!self.hidden){
        return;
    }
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    for(UIView * view in self.mySuperView.subviews){
        if([view isKindOfClass:[GWRootCustomView<GWRootCustomViewProtocol> class]]){
            if([view respondsToSelector:@selector(hiddenViewWithAnimation:)]){
                GWRootCustomView<GWRootCustomViewProtocol> * dropView = (GWRootCustomView<GWRootCustomViewProtocol> *)view;
                [dropView hiddenViewWithAnimation:NO];
            }
        }
    }
    
    
    [self.mySuperView addSubview:self];
    
    self.hidden = NO;
    if(isAnimation){
        [UIView animateWithDuration:0.25 animations:^{
            self.contentView.bottom = self.height;
            self.alpha = 1;
        }completion:^(BOOL finished) {
            
        }];
    }else{
        self.contentView.bottom = self.height;
        self.alpha = 1;
    }
}
-(void)hiddenViewWithAnimation:(BOOL)animation{
    [self hiddenDateSelectViewAnimation:animation];
}
-(void)hiddenDateSelectViewAnimation:(BOOL)isAnimation{
    if(self.hidden){
        return;
    }
    
    if(isAnimation){
        [UIView animateWithDuration:0.25 animations:^{
            self.contentView.top = self.height;
            self.alpha = 0;
        }completion:^(BOOL finished) {
            self.hidden = YES;
            [self removeFromSuperview];
        }];
    }else{
        self.hidden = YES;
        self.contentView.top = self.height;
        self.alpha = 0;
        [self removeFromSuperview];
    }
}
- (IBAction)confirmBtnClicked:(id)sender {
    [self hiddenDateSelectViewAnimation:YES];
    if(self.dateSelectConfirmBlock){
        self.dateSelectConfirmBlock(self,self.customDateView.customDatePickerSelectedDate);
    }
}
- (IBAction)cancelBtnClicked:(id)sender {
    [self hiddenDateSelectViewAnimation:YES];
}
@end
