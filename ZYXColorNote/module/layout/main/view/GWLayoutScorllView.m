//
//  GWLayoutScorllView.m
//  TourNote
//
//  Created by 极客天地 on 17/1/13.
//  Copyright © 2017年 极客天地. All rights reserved.
//

#import "GWLayoutScorllView.h"
#import "GWDrawPathView.h"
#import "GWPathLine.h"
@interface GWLayoutScorllView()

@property(strong,nonatomic)UIImageView * headerImageView;
@property(strong,nonatomic)UIImageView * footerImageView;



@end
@implementation GWLayoutScorllView
@synthesize backgroundView = _backgroundView;
@synthesize strokeView = _strokeView;
-(CGFloat)maxLayoutHeight{
    return SCREEN_HEIGHT*4;
}
-(UIImageView *)headerImageView{
    if(nil == _headerImageView){
        CGRect frame  = self.bounds;
        frame.size.height = 200;
        _headerImageView = [[UIImageView alloc] initWithFrame:frame];
        _headerImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        _headerImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _headerImageView;
}
-(UIImageView *)footerImageView{
    if(nil == _footerImageView){
        CGRect frame  = self.bounds;
        frame.size.height = 200;
        frame.origin.y = self.height - _footerImageView.height;
        _footerImageView = [[UIImageView alloc] initWithFrame:frame];
        _footerImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        _footerImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _footerImageView;
}
-(UIView *)backgroundView{
    if(nil == _backgroundView){
        _backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [_backgroundView addSubview:self.headerImageView];
        [_backgroundView addSubview:self.footerImageView];
    }
    return _backgroundView;
}
-(GWDrawPathView *)strokeView{
    if(nil == _strokeView){
        _strokeView = [[GWDrawPathView alloc] initWithFrame:self.bounds];
        _strokeView.height = self.maxLayoutHeight;
        _strokeView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _strokeView.backgroundColor = [UIColor clearColor];
        _strokeView.userInteractionEnabled = NO;
        
    }
    return _strokeView;
}
-(void)strokeRevoke{
    [self.strokeView revoke];
}
-(void)strokeRecovery{
    [self.strokeView recovery];
}
-(GWLayoutViewModel *)layoutViewModel{
    if(nil == _layoutViewModel){
        _layoutViewModel = [[GWLayoutViewModel alloc] init];
    }
    return _layoutViewModel;
}

-(void)layoutSubviews{
    [super layoutSubviews];
}
-(void)setBackgroundModel:(BackgroundModel *)backgroundModel{
    _backgroundModel = backgroundModel;
    self.backgroundView.height = self.contentSize.height;
    
    UIImage * headerImage = [UIImage imageWithContentsOfFile:self.backgroundModel.headerImagePath];
    if(headerImage){
        CGFloat height = self.width/headerImage.size.width * headerImage.size.height;
        self.headerImageView.height = height;
    }
    self.headerImageView.image = headerImage;
    
    UIImage * footerImage = [UIImage imageWithContentsOfFile:self.backgroundModel.footerImagePath];
    if(footerImage){
        CGFloat fheight = self.width/footerImage.size.width * footerImage.size.height;
        self.footerImageView.height = fheight;
        self.footerImageView.bottom = self.backgroundView.height;
    }
    self.footerImageView.image = footerImage;
    
    
    UIImage * colorImage = [UIImage imageWithContentsOfFile:self.backgroundModel.colorImagePath];
    self.backgroundView.backgroundColor = [UIColor colorWithPatternImage:colorImage];
    
    self.layoutViewModel.layoutModel.backgroundID = self.backgroundModel.backgroundID;
    self.layoutViewModel.layoutModel.backgroundName = self.backgroundModel.backgroundName;
}
-(void)setStrokeBrushModel:(StrokeBrushModel *)strokeBrushModel{
    _strokeBrushModel = strokeBrushModel;
    self.strokeView.strokeBrushModel = strokeBrushModel;
    if(nil != _strokeBrushModel){
        self.strokeView.userInteractionEnabled = YES;
        self.scrollEnabled = NO;
        [self handleElementViewUserInteractionEnabled:NO];
    }else{
        self.strokeView.userInteractionEnabled = NO;
        self.scrollEnabled = YES;
        [self handleElementViewUserInteractionEnabled:YES];
    }
}
//关闭/开启 所有布局元素UserInteractionEnabled
-(void)handleElementViewUserInteractionEnabled:(BOOL)enabled{
    for(UIView * view in self.subviews){
        if([view isKindOfClass:[GWLayoutElementView class]]){
            GWLayoutElementView * elementView = (GWLayoutElementView*)view;
            [elementView handleUserInteractionEnabled:enabled];
        }else{
            continue;
        }
    }
}
-(void)awakeFromNib{
    [super awakeFromNib];
    [self initData];
    [self initUI];
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initData];
        [self initUI];
    }
    return self;
}
-(void)initData{
    
}
-(void)initUI{
    
    [self addSubview:self.backgroundView];
    [self addSubview:self.strokeView];
    [self registerObserver];
}
-(void)dealloc{
    [self removeObserver];
}
-(void)removeObserver{
    @try {
        [self removeObserver:self forKeyPath:@"contentSize"];
    } @catch (NSException *exception) {
        
    }
    
}
-(void)registerObserver{
    // 注册监听
    [self addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    // 匹配keypath
    if ([keyPath isEqualToString:@"contentSize"]) {
        if(self.backgroundModel){
            self.backgroundView.height = self.contentSize.height;
        }
        //self.strokeView.height = self.contentSize.height;
    }
}

//元素 到底层
-(void)sendToBottomLayerWithElementView:(GWLayoutElementView*)elementView{
    [self insertSubview:elementView aboveSubview:self.strokeView];
}
//元素 到顶层
-(void)sendToTopLayerWithElementView:(GWLayoutElementView*)elementView{
    [self bringSubviewToFront:elementView];
}
//元素 到上一层
-(void)sendToUpLayerWithElementView:(GWLayoutElementView*)elementView{
    NSInteger index  = [self.subviews indexOfObject:elementView];
    NSInteger nextIndex = index + 1;
    if(nextIndex >= self.subviews.count){
        return;
    }
    [self exchangeSubviewAtIndex:index withSubviewAtIndex:nextIndex];
}
//元素 到下一层
-(void)sendToDownLayerWithElementView:(GWLayoutElementView*)elementView{
    NSInteger index  = [self.subviews indexOfObject:elementView];
    NSInteger lastIndex = index - 1;
    if(lastIndex <= 0){
        return;
    }
    [self exchangeSubviewAtIndex:index withSubviewAtIndex:lastIndex];
}

-(void)clearAllElementViews{
    [self.strokeView clearAllStroke];
    for(UIView * view in self.subviews){
        if([view isKindOfClass:[GWLayoutElementView class]]){
            [view removeFromSuperview];
        }
    }
}
@end
