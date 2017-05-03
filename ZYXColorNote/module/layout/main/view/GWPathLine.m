//
//  GWPathLine.m
//  Test
//
//  Created by BZBY on 15/4/1.
//  Copyright (c) 2015年 BZBY. All rights reserved.
//

#import "GWPathLine.h"

@implementation GWPathLine
-(void)drawShape{
    [self.color setStroke];
    [self.path stroke];
}
@end
