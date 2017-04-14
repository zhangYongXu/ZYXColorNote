//
//  AppDelegate.m
//  ZYXColorNote
//
//  Created by 极客天地 on 2017/4/13.
//  Copyright © 2017年 极客天地. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
-(NSString *)documentDir{
    if(STR_IS_NIL(_documentDir)){
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDir = [paths objectAtIndex:0];
        _documentDir = documentDir;
    }
    return _documentDir;
}
-(NSString *)draftDir{
    if(STR_IS_NIL(_draftDir)){
        _draftDir = [self draftPath];
    }
    return _draftDir;
}
-(NSString*)draftPath{
    NSString * documentDir = APPDelegate.documentDir;
    NSString * draftPath = [documentDir stringByAppendingPathComponent:@"draftBox"];
    NSFileManager * FM = [NSFileManager defaultManager];
    NSError * error = nil;
    if([FM fileExistsAtPath:draftPath]){
        return draftPath;
    }else{
        if ([FM createDirectoryAtPath:draftPath withIntermediateDirectories:NO attributes:nil error:&error]) {
            return draftPath;
        }else{
            return nil;
        }
    }
}
-(NSString *)resizeImageDir{
    if(STR_IS_NIL(_resizeImageDir)){
        NSString * documentDir = APPDelegate.documentDir;
        NSString * draftPath = [documentDir stringByAppendingPathComponent:@"resizeImage"];
        NSFileManager * FM = [NSFileManager defaultManager];
        NSError * error = nil;
        if([FM fileExistsAtPath:draftPath]){
            return draftPath;
        }else{
            if ([FM createDirectoryAtPath:draftPath withIntermediateDirectories:NO attributes:nil error:&error]) {
                return draftPath;
            }else{
                return nil;
            }
        }
    }
    return _resizeImageDir;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [Bmob registerWithAppKey:@"d842971e25478c228bc6712028262562"];
    [ZYXFontViewModel shareInstance];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark 判断相机权限
- (BOOL)judgeCameraRight{
    return [ZYXSystemRightMonitor judgeCameraRightAndShowTipAlert];
}
#pragma mark 判断相册权限
- (BOOL)judgePhotosRight {
    return [ZYXSystemRightMonitor judgePhotosRightAndShowTipAlert];
}

#pragma mark 判断定位权限
- (BOOL)judgeGeLoctionRight{
    return [ZYXSystemRightMonitor judgeGeLoctionRightAndShowTipAlert];
}

@end
