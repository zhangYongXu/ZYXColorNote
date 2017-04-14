//
//  GWLayoutElementViewTextField.h
//  TourNote
//
//  Created by 极客天地 on 17/1/13.
//  Copyright © 2017年 极客天地. All rights reserved.
//

#import "GWLayoutElementView.h"
@class GWLayoutElementViewLabel;
typedef void (^ElementViewDidEditedTextBlock)(GWLayoutElementViewLabel * elementViewLabel);
@interface GWLayoutElementViewLabel : GWLayoutElementView
@property(copy,nonatomic)NSString * text;

@property(copy,nonatomic)ElementViewDidEditedTextBlock elementViewDidEditedTextBlock;
-(void)setElementViewDidEditedTextBlock:(ElementViewDidEditedTextBlock)elementViewDidEditedTextBlock;

-(void)showInputText;
@end
