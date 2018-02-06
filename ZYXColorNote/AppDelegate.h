//
//  AppDelegate.h
//  ZYXColorNote
//
//  Created by 极客天地 on 2017/4/13.
//  Copyright © 2017年 极客天地. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserViewModel.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong,nonatomic) UserViewModel * userViewModel;
@property (assign,nonatomic,readonly) BOOL isUserHasLogin;//用户是否已登录

@property (copy,nonatomic) NSString * documentDir;
@property (copy,nonatomic) NSString * draftDir;
@property (copy,nonatomic) NSString * resizeImageDir;

#pragma mark 判断相机权限
- (BOOL)judgeCameraRight;
#pragma mark 判断相册权限
- (BOOL)judgePhotosRight;
#pragma mark 判断定位权限
- (BOOL)judgeGeLoctionRight;
@end

