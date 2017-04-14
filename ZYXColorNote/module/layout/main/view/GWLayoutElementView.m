//
//  GWLayoutElementView.m
//  TourNote
//
//  Created by 极客天地 on 17/1/13.
//  Copyright © 2017年 极客天地. All rights reserved.
//

#import "GWLayoutElementView.h"
@interface GWLayoutElementView()

@property(strong,nonatomic) UIView * contentView;
@property(assign,nonatomic) CGRect beforeOringalFrame;
@property(assign,nonatomic) CGRect beforeOringalBounds;
@property(assign,nonatomic) CGPoint beforeOringalCenter;
@property(assign,nonatomic) CGAffineTransform beforeOringalTransform;

@property(strong,nonatomic) UIImageView * scaleTipImageView;
@property(strong,nonatomic) UIImageView * rotateTipImageView;
@property(strong,nonatomic) UIButton * closeButton;
@property(strong,nonatomic) UILabel * tipLabel;

@property(assign,nonatomic)CGPoint panStartPoint;
@property(assign,nonatomic)CGPoint panLocationPoint;

@property(assign,nonatomic)CGPoint roatePanStartPoint;
@property(assign,nonatomic)CGPoint roatePanLocationPoint;

@end
@implementation GWLayoutElementView
@synthesize elementModel = _elementModel;
-(UIView *)contentView{
    if(nil == _contentView){
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(15, 15, self.width-15*2, self.height-15*2)];
        _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        UITapGestureRecognizer* singleTapGestureRecognizer = [self addSingleTapGestureToSelf];
        
        UITapGestureRecognizer *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(contentViewDoubleTap:)];
        
        [doubleTapGestureRecognizer setNumberOfTapsRequired:2];
        [_contentView addGestureRecognizer:doubleTapGestureRecognizer];
        
        [singleTapGestureRecognizer requireGestureRecognizerToFail:doubleTapGestureRecognizer];
        
        UIPanGestureRecognizer * contentPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(contentPanGestureHanele:)];
        [_contentView addGestureRecognizer:contentPanGesture];
    }
    return _contentView;
}
-(UILabel *)tipLabel{
    if(nil == _tipLabel){
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.height-15, self.width-20, 15)];
        _tipLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        _tipLabel.textColor = [UIColor colorWithHex:0x999999];
        _tipLabel.font = [UIFont systemFontOfSize:13];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.hidden = YES;
    }
    return _tipLabel;
}
-(NSString *)tipString{
    return self.tipLabel.text;
}
-(void)setTipString:(NSString *)tipString{
    self.tipLabel.text = tipString;
}
-(UIImageView *)scaleTipImageView{
    if(nil == _scaleTipImageView){
        _scaleTipImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
        _scaleTipImageView.image = [UIImage imageNamed:@"layout_handle_scale"];
        _scaleTipImageView.centerX = self.width - 15;
        _scaleTipImageView.centerY = self.height - 15;
        _scaleTipImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
        _scaleTipImageView.hidden = YES;
        
        _scaleTipImageView.userInteractionEnabled = YES;
        UIPanGestureRecognizer * panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureHanele:)];
        [_scaleTipImageView addGestureRecognizer:panGesture];
    }
    return _scaleTipImageView;
}
-(UIImageView *)rotateTipImageView{
    if(nil == _rotateTipImageView){
        _rotateTipImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
        _rotateTipImageView.image = [UIImage imageNamed:@"layout_handle_rotate"];
        _rotateTipImageView.centerX = self.width - 15;
        _rotateTipImageView.centerY = 15;
        _rotateTipImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
        _rotateTipImageView.hidden = YES;
        
        _rotateTipImageView.userInteractionEnabled = YES;
        UIPanGestureRecognizer * panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(roatePanGestureHanele:)];
        [_rotateTipImageView addGestureRecognizer:panGesture];
    }
    return _rotateTipImageView;
}
-(UIButton *)closeButton{
    if(nil == _closeButton){
        _closeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
        [_closeButton setImage:[UIImage imageNamed:@"layout_handle_close"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _closeButton.centerX = 15;
        _closeButton.centerY = 15;
        _closeButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        _closeButton.hidden = YES;
    }
    return _closeButton;
}
-(void)setIsFocusing:(BOOL)isFocusing{
    _isFocusing = isFocusing;
    [self changeFocsingShow];
    [self elementModel];
}
-(void)setEnableEditing:(BOOL)enableEditing{
    _enableEditing = enableEditing;
    self.userInteractionEnabled = self.enableEditing;
    self.contentView.userInteractionEnabled = self.enableEditing;
    if(self.enableEditing){
        [self registerObserver];
    }else{
        [self removeObserver];
    }
}
-(void)changeFocsingShow{
    
    self.scaleTipImageView.hidden = !self.isFocusing;
    self.closeButton.hidden = !self.isFocusing;
    self.rotateTipImageView.hidden = (!self.isFocusing || self.elementViewType != GWLayoutElementViewTypeLabel);
    self.tipLabel.hidden = !self.isFocusing;
    self.contentView.userInteractionEnabled = self.isFocusing;
    
    if(self.isFocusing){
        self.contentView.layer.borderWidth = 1.0;
        self.contentView.layer.borderColor = [UIColor redColor].CGColor;
    }else{
        self.contentView.layer.borderWidth = 0;
        self.contentView.layer.borderColor = [UIColor clearColor].CGColor;
    }
}
//关闭UIView的userInteractionEnabled
-(void)handleUserInteractionEnabled:(BOOL)enabled{
    if(enabled){
        self.userInteractionEnabled = self.enableEditing;
        self.contentView.userInteractionEnabled = self.enableEditing && self.isFocusing;
    }else{
        self.userInteractionEnabled = enabled;
        self.contentView.userInteractionEnabled = enabled;
    }
}
//
-(void)initData{
    self.enableEditing = NO;
}
-(void)initUI{
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.contentView];
    [self addSubview:self.tipLabel];

    [self addSubview:self.scaleTipImageView];
    [self addSubview:self.rotateTipImageView];
    [self addSubview:self.closeButton];

}
-(void)dealloc{
    [self removeObserver];
}
-(void)removeObserver{
    @try {
        [self removeObserver:self forKeyPath:@"frame"];
        [self removeObserver:self forKeyPath:@"bounds"];
        [self removeObserver:self forKeyPath:@"transform"];
        [self removeObserver:self forKeyPath:@"center"];
    } @catch (NSException *exception) {
        
    }
    
}
-(void)registerObserver{
    // 注册监听
    [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    [self addObserver:self forKeyPath:@"bounds" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    [self addObserver:self forKeyPath:@"transform" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    [self addObserver:self forKeyPath:@"center" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    // 匹配keypath
    if ([keyPath isEqualToString:@"frame"]) {
        //NSLog(@"self.frame = %@", NSStringFromCGRect(self.frame));
        [self elementModel];
    }else if([keyPath isEqualToString:@"bounds"]){
        //NSLog(@"self.bounds = %@", NSStringFromCGRect(self.bounds));
        [self elementModel];
    }else if([keyPath isEqualToString:@"transform"]){
        //NSLog(@"self.transform = %@", NSStringFromCGAffineTransform(self.transform));
        [self elementModel];
    }else if([keyPath isEqualToString:@"center"]){
        //NSLog(@"self.transform = %@", NSStringFromCGAffineTransform(self.transform));
        [self elementModel];
    }

}
-(GWElementModel *)elementModel{
    if(nil == _elementModel){
        _elementModel = [[GWElementModel alloc] init];
    }
    if(self.enableEditing){
        _elementModel.elementWidth = [NSString stringWithFormat:@"%.2f",self.contentView.bounds.size.width*SCREEN_SCALE];
        _elementModel.elementHeight = [NSString stringWithFormat:@"%.2f",self.contentView.bounds.size.height*SCREEN_SCALE];
        _elementModel.elementCenterX = [NSString stringWithFormat:@"%.2f",self.centerX*SCREEN_SCALE];
        _elementModel.elementCenterY = [NSString stringWithFormat:@"%.2f",self.centerY*SCREEN_SCALE];
        
        CGFloat rotate = acosf(self.transform.a);
        // 旋转180度后，需要处理弧度的变化
        if (self.transform.b < 0) {
            rotate = M_PI -rotate;
        }
        _elementModel.elementRoateAngle = [NSString stringWithFormat:@"%.2f",rotate];
        _elementModel.elementType = [NSString stringWithFormat:@"%ld",self.elementViewType];
        _elementModel.elementTypeStr = [self elementViewTypeStr];
    }
    return _elementModel;
}
-(NSString*)elementViewTypeStr{
    NSString * typeStr = @"";
    if(self.elementViewType == GWLayoutElementViewTypeLabel){
        typeStr = @"文本";
    }else if(self.elementViewType == GWLayoutElementViewTypeImage){
        typeStr = @"图片";
    }
    return typeStr;
}
-(void)refreshWithElementModel:(GWElementModel *)elementModel LyoutModel:(GWLayoutModel*)layoutModel{
    //_elementModel = elementModel;
    CGFloat percent = layoutModel.toCurrentScrrenPercent;
    CGFloat realElementWidth = ([elementModel.elementWidth floatValue] * percent)/SCREEN_SCALE;
    CGFloat realElementHeight = ([elementModel.elementHeight floatValue] * percent)/SCREEN_SCALE;
    CGFloat realElementCenterX = ([elementModel.elementCenterX floatValue] * percent)/SCREEN_SCALE;
    CGFloat realElementCenterY = ([elementModel.elementCenterY floatValue] * percent)/SCREEN_SCALE;

    CGRect bounds = self.bounds;
    bounds.size.width = realElementWidth + GWLayoutElementViewHandleAddWidth;
    bounds.size.height = realElementHeight + GWLayoutElementViewHandleAddWidth;
    CGPoint center = self.center;
    center.x = realElementCenterX;
    center.y = realElementCenterY;
    CGFloat roate = [elementModel.elementRoateAngle floatValue];
    self.center = center;
    self.bounds = bounds;
    
    self.transform = CGAffineTransformMakeRotation(roate);
    
}
-(UITapGestureRecognizer*)addSingleTapGestureToSelf{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selfSingleTap:)];
    [singleTapGestureRecognizer setNumberOfTapsRequired:1];
    [self addGestureRecognizer:singleTapGestureRecognizer];
    return singleTapGestureRecognizer;
}
-(void)selfSingleTap:(UITapGestureRecognizer*)singleTapGesure{
    if(!self.enableEditing){
        return;
    }
    self.isFocusing = YES;
    if(self.singleTapGestureBlock){
        self.singleTapGestureBlock(self,singleTapGesure);
    }
}
-(void)contentViewDoubleTap:(UITapGestureRecognizer*)doubleTapGesure{
    if(!self.isFocusing || !self.enableEditing){
        return;
    }
    if(self.doubleTapGestureBlock){
        self.doubleTapGestureBlock(self,doubleTapGesure);
    }
    
}

-(void)contentPanGestureHanele:(UIPanGestureRecognizer*)panGesture{
    if(!self.isFocusing || !self.enableEditing){
        return;
    }
    CGPoint startPoint = CGPointMake(0, 0);
    CGPoint locationPoint = [panGesture locationInView:self.superview];
    switch (panGesture.state) {
        case UIGestureRecognizerStatePossible:
            break;
        case UIGestureRecognizerStateBegan:{
            startPoint = locationPoint;
            self.panStartPoint = startPoint;
            self.beforeOringalCenter = self.center;
        }
            break;
        case UIGestureRecognizerStateChanged:{
            self.panLocationPoint = locationPoint;
            self.centerX = self.panLocationPoint.x + (self.beforeOringalCenter.x - self.panStartPoint.x);
            self.centerY = self.panLocationPoint.y + (self.beforeOringalCenter.y - self.panStartPoint.y);
        }
            break;
        case UIGestureRecognizerStateEnded:{
            
        }
            break;
        case UIGestureRecognizerStateCancelled:
            
            break;
        case UIGestureRecognizerStateFailed:
            break;
    }
}


-(void)panGestureHanele:(UIPanGestureRecognizer*)panGesture{
    if(!self.isFocusing || !self.enableEditing){
        return;
    }
    CGPoint startPoint = CGPointMake(0, 0);
    CGPoint locationPoint = [panGesture locationInView:self.superview];
    switch (panGesture.state) {
        case UIGestureRecognizerStatePossible:
            break;
        case UIGestureRecognizerStateBegan:{
            startPoint = locationPoint;
            self.panStartPoint = startPoint;
            self.beforeOringalBounds = self.bounds;
            self.beforeOringalFrame = self.frame;
            self.beforeOringalCenter = self.center;
            
            if(self.elementViewType != GWLayoutElementViewTypeLabel){
                self.roatePanStartPoint = startPoint;
                self.beforeOringalTransform = self.transform;
            }
        }
            break;
        case UIGestureRecognizerStateChanged:{
            self.panLocationPoint = locationPoint;
            [self scaleHandle];
            
            if(self.elementViewType != GWLayoutElementViewTypeLabel){
                self.roatePanLocationPoint = locationPoint;
                [self rotateHandle];
            }
            
            //NSLog(@"height:%@ bounds:%@ newBounds:%@",@(height),NSStringFromCGRect(self.beforeOringalBounds),NSStringFromCGRect(newBounds));
            
        }
            break;
        case UIGestureRecognizerStateEnded:{
            if(self.elementViewType != GWLayoutElementViewTypeLabel){
                self.roatePanLocationPoint = locationPoint;
                [self rotateHandle];
            }
        }
            break;
        case UIGestureRecognizerStateCancelled:
            
            break;
        case UIGestureRecognizerStateFailed:
            break;
    }
    
}
//缩放处理
-(void)scaleHandle{
    if(self.elementViewType == GWLayoutElementViewTypeImage || self.elementViewType == GWLayoutElementViewTypePaster){
        CGPoint center = self.center;
        
        if(self.panLocationPoint.x < center.x || self.panLocationPoint.y < center.y){
            return;
        }
        
        CGFloat startToCenterDistance = [self distanceWithPoint:center otherPoint:self.panStartPoint];
        CGFloat currentToCenterDistance = [self distanceWithPoint:center otherPoint:self.panLocationPoint];
        CGFloat percent = (currentToCenterDistance-startToCenterDistance)/startToCenterDistance;
        
        CGFloat percentOffX = self.beforeOringalBounds.size.width * percent;
        CGFloat percentOffY = self.beforeOringalBounds.size.height * percent;
        
        CGFloat width = self.beforeOringalBounds.size.width + percentOffX;
        CGFloat height = self.beforeOringalBounds.size.height + percentOffY;
        
        CGFloat minWH = 80;
        CGFloat realWidth = 0;
        CGFloat realHeight = 0;
        realWidth = width > minWH ? width : minWH;
        realHeight = height > minWH ? height : minWH;
        if(realWidth == minWH){
            realHeight = realWidth/width * height;
        }else if(realHeight == minWH){
            realWidth = realHeight/height * width;
        }
        
        
        CGRect newBounds = self.beforeOringalBounds;
        newBounds.size.width = realWidth;
        newBounds.size.height = realHeight;
        self.bounds = newBounds;
        self.center = self.beforeOringalCenter;
        
    }else{
        CGFloat offX = self.panLocationPoint.x - self.panStartPoint.x;
        CGFloat offY = self.panLocationPoint.y - self.panStartPoint.y;
        
        offX = offX*2;
        offY = offY*2;
        
        
        CGFloat width = self.beforeOringalBounds.size.width + offX;
        CGFloat height = self.beforeOringalBounds.size.height + offY;
        CGFloat minWH = 100;
        width = width > minWH ? width : minWH;
        height = height > minWH ? height : minWH;
        
        CGRect newBounds = self.beforeOringalBounds;
        newBounds.size.width = width;
        newBounds.size.height = height;
        self.bounds = newBounds;
        self.center = self.beforeOringalCenter;
        
    }
}
-(void)roatePanGestureHanele:(UIPanGestureRecognizer*)panGesture{
    if(!self.isFocusing || !self.enableEditing){
        return;
    }
    CGPoint startPoint = CGPointMake(0, 0);
    CGPoint locationPoint = [panGesture locationInView:self.superview];
    switch (panGesture.state) {
        case UIGestureRecognizerStatePossible:
            break;
        case UIGestureRecognizerStateBegan:{
            startPoint = locationPoint;
            self.roatePanStartPoint = startPoint;
            self.beforeOringalTransform = self.transform;
        }
            break;
        case UIGestureRecognizerStateChanged:{
            self.roatePanLocationPoint = locationPoint;
            [self rotateHandle];
        }
            break;
        case UIGestureRecognizerStateEnded:{
            self.roatePanLocationPoint = locationPoint;
            [self rotateHandle];
        }
            break;
        case UIGestureRecognizerStateCancelled:
            
            break;
        case UIGestureRecognizerStateFailed:
            break;
    }
    
}
//旋转处理
- (void)rotateHandle{
    CGPoint center = self.center;
    
    CGFloat angleInRadians = angleBetweenLines(center, self.roatePanLocationPoint, center, self.roatePanStartPoint);
    
    CGPoint startOff = CGPointMake(self.roatePanStartPoint.x - center.x, self.roatePanStartPoint.y - center.y);
    CGPoint locationOff = CGPointMake(self.roatePanLocationPoint.x - self.roatePanStartPoint.x, self.roatePanLocationPoint.y - self.roatePanStartPoint.y);
    CGFloat off = startOff.x * locationOff.y - startOff.y * locationOff.x;
    
    NSLog(@"off......:%.2f",off);
    if(off > 0){//顺时针方向
        angleInRadians  = fabs(angleInRadians);
    }else{ //逆时针方向
        angleInRadians  = -fabs(angleInRadians);
    }
    CGAffineTransform _trans = self.beforeOringalTransform;
    CGFloat rotate = acosf(_trans.a);
    
    // 旋转180度后，需要处理弧度的变化
//    if (_trans.b < 0) {
//        rotate = M_PI -rotate;
//    }
    if (_trans.b < 0) {
        rotate = -rotate;
    }
    
    CGFloat orignalRotateAngle = rotate;
    CGFloat currentRotateAngle = orignalRotateAngle + angleInRadians *M_PI / 180.0;
    NSLog(@"orignalRotateAngle:%.2f currentRotateAngle:%.2f",orignalRotateAngle,currentRotateAngle);
    self.transform = CGAffineTransformMakeRotation(currentRotateAngle);
}
- (CGFloat)distanceWithPoint:(CGPoint)point otherPoint:(CGPoint)otherPoint
{
    return sqrt(pow(point.x - otherPoint.x, 2) + pow(point.y - otherPoint.y, 2));
    
    
}
#define pi 3.14159265358979323846
#define radiansToDegrees(x) (180.0 * x / pi)
CGFloat angleBetweenLines(CGPoint line1Start, CGPoint line1End, CGPoint line2Start, CGPoint line2End) {
    
    CGFloat a = line1End.x - line1Start.x;
    CGFloat b = line1End.y - line1Start.y;
    CGFloat c = line2End.x - line2Start.x;
    CGFloat d = line2End.y - line2Start.y;
    
    CGFloat rads = acos(((a*c) + (b*d)) / ((sqrt(a*a + b*b)) * (sqrt(c*c + d*d))));
    
    return radiansToDegrees(rads);
    return rads;
}

-(void)closeBtnClicked:(UIButton*)button{
    if(!self.isFocusing || !self.enableEditing){
        return;
    }
    if(self.closeBtnClickedBlock){
        self.closeBtnClickedBlock(self,button);
    }
}


@end
