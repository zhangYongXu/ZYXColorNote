//
//  GWPathLine.h
//  Test
//
//  Created by BZBY on 15/4/1.
//  Copyright (c) 2015年 BZBY. All rights reserved.
//



@interface GWPathLine : GWRootModel
@property(nonatomic,strong)UIBezierPath * path;
@property(nonatomic,strong)UIColor * color;

-(void)drawShape;
@end
