//
//  MainTabBarViewController.h
//  TEST
//
//  Created by  极客天地 on 16/2/24.
//  Copyright © 2016年  极客天地. All rights reserved.
//

@class MainTabBarViewController;
typedef BOOL (^TabBarVCSholdSelectVCBlock)(MainTabBarViewController* tabBarVc,GWRootViewController* willSelectVc);
@interface MainTabBarViewController :  GWRootTabBarViewController

-(void)setTabBarVCSholdSelectVCBlock:(TabBarVCSholdSelectVCBlock)tabBarVCSholdSelectVCBlock CurrentVC:(GWRootViewController*)currentVC;
@end
