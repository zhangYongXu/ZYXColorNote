//
//  ZYXCutPathView.m
//  TourNote
//
//  Created by 极客天地 on 2017/2/22.
//  Copyright © 2017年 极客天地. All rights reserved.
//

#import "GWDrawPathView.h"

@interface GWDrawPathView()
@property (strong,nonatomic)UIImageView * backgroundImageView;

@property(assign,nonatomic)CGPoint strokeBrushPanStartPoint;
@property(assign,nonatomic)CGPoint strokeBrushPanLocationPoint;
@property(assign,nonatomic)CGPoint lastStrokeBrushImagePoint;
@property(assign,nonatomic)CGFloat distance;
@property(assign,nonatomic)NSInteger imageIndex;

@property(strong,nonatomic) NSMutableArray<id> * lineArray;
@property(strong,nonatomic) NSMutableArray<id> * historyLineArray;

@end
@implementation GWDrawPathView
-(UIImageView *)backgroundImageView{
    if(nil == _backgroundImageView){
        CGRect frame  = self.bounds;
        _backgroundImageView = [[UIImageView alloc] initWithFrame:frame];
        _backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _backgroundImageView;

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
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        [self initUI];
    }
    return self;
}

-(void)setBackgroundImage:(UIImage *)backgroundImage{
    self.backgroundImageView.image = backgroundImage;
    if(backgroundImage == nil){
        return;
    }
    CGFloat height = (self.superview.bounds.size.width/backgroundImage.size.width)*backgroundImage.size.height;
    self.backgroundImageView.height = height;
}
-(UIImage *)backgroundImage{
    return self.backgroundImageView.image;
}
-(NSMutableArray<id> *)lineArray{
    if(nil == _lineArray){
        _lineArray = [[NSMutableArray alloc] init];
    }
    return _lineArray;
}
-(NSMutableArray<id> *)historyLineArray{
    if(nil == _historyLineArray){
        _historyLineArray = [[NSMutableArray alloc] init];
    }
    return _historyLineArray;

}
-(void)displayLine:(id)line{
    if([line isKindOfClass:[GWPathLine class]]){
        [self setNeedsDisplay];
    }else if([line isKindOfClass:[GWImageLine class]]){
        GWImageLine * imageLine = line;
        for(UIImageView * imageView in imageLine.imageViewArray){
            if([self.lineArray containsObject:line]){
                [self addSubview:imageView];
            }else{
                [imageView removeFromSuperview];
            }
        }
    }
}
-(void)revoke{
    id line = self.lineArray.lastObject;
    if(nil == line){
        return;
    }
    [self.lineArray removeLastObject];
    [self.historyLineArray addObject:line];
    [self displayLine:line];
    
}
-(void)recovery{
    id line = self.historyLineArray.lastObject;
    if(nil == line){
        return;
    }
    [self.historyLineArray removeLastObject];
    [self.lineArray addObject:line];
    [self displayLine:line];
}
-(void)clearAllStroke{
    self.backgroundImage = nil;
    [self.historyLineArray addObjectsFromArray:self.lineArray];
    [self.lineArray removeAllObjects];
    for(id line in self.historyLineArray){
        [self displayLine:line];
    }
    
    [self.historyLineArray removeAllObjects];
    
}
-(void)drawRect:(CGRect)rect{
    for(id line in self.lineArray){
        if([line isKindOfClass:[GWPathLine class]]){
            GWPathLine * pathLine = line;
            [pathLine drawShape];
        }
    }
}

-(void)initData{
    
}

-(void)initUI{
    __weak typeof(self) weakSelf  = self;
    [self addTapGetureWithBlock:^(UITapGestureRecognizer *tapGeture) {
        [weakSelf singleTapGetureHandle:tapGeture];
    }];
    
    [self addSubview:self.backgroundImageView];
}

-(void)drawLineBegin{
    if(self.strokeBrushModel.strokeBrushType == StrokeBrushTypeColorBrush){
        UIBezierPath * path = [UIBezierPath bezierPath];
        path.lineWidth = self.strokeBrushModel.StrokeBrushSize;
        path.lineJoinStyle = kCGLineJoinRound;
        path.lineCapStyle = kCGLineCapRound;
        [path moveToPoint:self.strokeBrushPanStartPoint];
        GWPathLine * line = [[GWPathLine alloc] init];
        line.path = path;
        UIColor * color = self.strokeBrushModel.strokeBrushColor;
        line.color = color;
        [self.lineArray addObject:line];
    }else{
        self.lastStrokeBrushImagePoint = self.strokeBrushPanStartPoint;
        self.imageIndex = 0;
        
        GWImageLine * line = [[GWImageLine alloc] init];
        line.imageViewArray = [[NSMutableArray alloc] init];
        [self.lineArray addObject:line];
    }
}
-(void)drawingLine{
    if(self.strokeBrushModel.strokeBrushType == StrokeBrushTypeColorBrush){
        GWPathLine * line  = [self.lineArray lastObject];
        [line.path addLineToPoint:self.strokeBrushPanLocationPoint];
        [self setNeedsDisplay];
    }else{
        CGFloat distance = [self distanceWithPoint:self.lastStrokeBrushImagePoint otherPoint:self.strokeBrushPanLocationPoint];
        CGFloat height = self.strokeBrushModel.StrokeBrushSize*2;
        if(distance == 0 || distance >= (height + height*0.1)){
            
            
            NSInteger count = self.strokeBrushModel.strokeImagePathArray.count;
            NSInteger index = self.imageIndex%count;
            NSString * imagePath = self.strokeBrushModel.strokeImagePathArray[index];
            UIImage *Image = [UIImage imageWithContentsOfFile:imagePath];
            
            UIImageView * imageView = [[UIImageView alloc] init];
            imageView.image = Image;
            CGRect rect = CGRectMake(self.strokeBrushPanLocationPoint.x, self.strokeBrushPanLocationPoint.y, height, height);
            imageView.frame = rect;
            [self addSubview:imageView];
            
            GWImageLine * line  = [self.lineArray lastObject];
            [line.imageViewArray addObject:imageView];
            
            distance = -1;
            self.imageIndex++;
            self.lastStrokeBrushImagePoint = self.strokeBrushPanLocationPoint;
        }
    }
}

-(void)singleTapGetureHandle:(UITapGestureRecognizer *)tapGeture{
    CGPoint locationPoint = [tapGeture locationInView:self];
    self.strokeBrushPanStartPoint = locationPoint;
    self.strokeBrushPanLocationPoint = locationPoint;
    
    [self drawLineBegin];
    [self drawingLine];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch * touch  = [touches anyObject];
    CGPoint locationPoint = [touch locationInView:self];
    self.strokeBrushPanStartPoint = locationPoint;
    self.strokeBrushPanLocationPoint = locationPoint;
    [self drawLineBegin];
}
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch * touch  = [touches anyObject];
    CGPoint locationPoint = [touch locationInView:self];
    self.strokeBrushPanLocationPoint = locationPoint;
    [self drawingLine];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"");
}
-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"");
}


- (CGFloat)distanceWithPoint:(CGPoint)point otherPoint:(CGPoint)otherPoint
{
    return sqrt(pow(point.x - otherPoint.x, 2) + pow(point.y - otherPoint.y, 2));
    
    
}
@end
