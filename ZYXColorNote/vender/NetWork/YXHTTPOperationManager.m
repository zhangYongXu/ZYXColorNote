//
//  YXHTTPOperationManager.m
//  FavoriteFreeDemo
//
//  Created by BZBY on 15/5/4.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "YXHTTPOperationManager.h"
@implementation YXHTTPOperationManager
+ (instancetype)operationManager {
    static YXHTTPOperationManager *myManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        myManager = [[YXHTTPOperationManager alloc] initWithBaseURL:[NSURL URLWithString:APPBaseURL]];
    });
    return myManager;
}
@end
