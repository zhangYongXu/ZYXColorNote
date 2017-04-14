//
//  StrokeBrushSizeView.m
//  TourNote
//
//  Created by 极客天地 on 2017/3/1.
//  Copyright © 2017年 极客天地. All rights reserved.
//

#import "StrokeBrushSizeView.h"
@interface StrokeBrushSizeView()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *sizeBtnArray;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *sizeFlagViewArray;
@property (weak, nonatomic) IBOutlet UIButton *upOrDownBtn;

@end
@implementation StrokeBrushSizeView
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    BOOL is = [super pointInside:point withEvent:event];
    //if内的条件应该为，当触摸点point超出蓝色部分，但在黄色部分时
    if(!is){
        if (point.x>self.upOrDownBtn.left && point.y>-20){
            is = YES;
        }
    }
    
    return is;
}
-(void)initData{
    self.strokeBrushSize = 8;
}
-(void)initUI{
    UIColor * lineColor = [UIColor colorWithHex:0xeeeeee];
    CGFloat lineWidth = 0.5;
    CGPoint sPoint = CGPointMake(0, self.contentView.top);
    CGPoint ePoint = CGPointMake(self.upOrDownBtn.left, self.contentView.top);
    [self drawSolidLineWithStartPoint:sPoint EndPoint:ePoint Color:lineColor Width:lineWidth];
    
    [self.upOrDownBtn drawBorderSolidLineWithPosition:BorderLinePositionTop Color:lineColor Width:lineWidth];
    [self.upOrDownBtn drawBorderSolidLineWithPosition:BorderLinePositionLeft Color:lineColor Width:lineWidth];
    
    [self drawBorderSolidLineWithPosition:BorderLinePositionBottom Color:lineColor Width:lineWidth];
}
- (IBAction)sizeBtnClicked:(UIButton*)sender {
    NSInteger viewTag = sender.tag*10;
    [self changeFlageViewColorWithViewTag:viewTag];
}
- (void)changeFlageViewColorWithViewTag:(NSInteger)viewTag{
    for(NSInteger i = 0;i<self.sizeFlagViewArray.count;i++){
        UIView * view = self.sizeFlagViewArray[i];
        if(viewTag == view.tag){
            view.backgroundColor = [UIColor colorWithHex:0x666666];
            NSInteger size = view.height;
            if(size != self.strokeBrushSize){
                self.strokeBrushSize = size;
                if(self.strokeBrushSizeDidSelectedBlock){
                    self.strokeBrushSizeDidSelectedBlock();
                }
            }
            
        }else{
            view.backgroundColor = [UIColor colorWithHex:0xeeeeee];
        }
    }
}
- (IBAction)styleClicked:(id)sender {
    if(self.strokeBrushSizeStyleClickedBlock){
        self.strokeBrushSizeStyleClickedBlock();
    }
}
- (IBAction)upDownBtnClicked:(UIButton*)sender {
    sender.selected = !sender.selected;
    if(self.strokeBrushSizeUpOrDownClickedBlock){
        self.strokeBrushSizeUpOrDownClickedBlock(self,sender);
    }
}
@end
