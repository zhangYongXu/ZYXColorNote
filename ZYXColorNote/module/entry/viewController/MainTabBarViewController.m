//
//  MainTabBarViewController.m
//  TEST
//
//  Created by  极客天地 on 16/2/24.
//  Copyright © 2016年  极客天地. All rights reserved.
//

#import "MainTabBarViewController.h"
#import "LayoutViewController.h"


@interface MainTabBarViewController ()<UITabBarControllerDelegate>
@property (strong,nonatomic) UIButton * button;
@property (strong,nonatomic)NSMutableDictionary * blockDict;
@end

@implementation MainTabBarViewController
-(NSMutableDictionary *)blockDict{
    if(nil == _blockDict){
        _blockDict = [[NSMutableDictionary alloc] init];
    }
    return _blockDict;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setHidden:YES];
    
    self.viewControllers = [self viewControllersArrayWithTabBarConfigFileName:@"MainTabConfig"];
    
    self.tabBarBackgroundColor = [UIColor colorWithHex:AppBaseBackgroundColor];
    self.tabBarTitleNormalColor = [UIColor colorWithHex:0xffffff];
    self.tabBarTitleSelectedColor = [UIColor colorWithHex:0x464b4b];
    
    self.delegate = self;
    [self addCenterButtonWithImage:[UIImage imageNamed:@"tabBar_center_add_button_icon"] selectedImage:[UIImage imageNamed:@"tabBar_center_add_button_icon"]];
  
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tabBar bringSubviewToFront:self.button];
    [self.navigationController.navigationBar setHidden:YES];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.tabBar bringSubviewToFront:self.button];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
//2就是tabbar上特殊按钮的索引下标
-(void)pressChange:(id)sender
{
//    if(self.button.selected){
//        return;
//    }
//    self.selectedIndex=1;
//    self.button.selected=YES;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"TabLayout" bundle:nil];
    LayoutViewController * lvc = [storyboard instantiateViewControllerWithIdentifier:@"LayoutViewController_SBID"];
    
    UIViewController * vc = self.selectedViewController;
    if([vc isKindOfClass:[UINavigationController class]]){
        UINavigationController * nvc = (UINavigationController*)vc;
        [nvc pushViewController:lvc animated:YES];
    }
}
//-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
//    if (self.selectedIndex==1) {
//        self.button.selected=YES;
//    }else{
//        self.button.selected=NO;
//    }
//}
-(void) addCenterButtonWithImage:(UIImage*)buttonImage selectedImage:(UIImage*)selectedImage
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(pressChange:) forControlEvents:UIControlEventTouchUpInside];
    button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    CGFloat width = MIN(buttonImage.size.width, 55);
    CGFloat height = MIN(buttonImage.size.height, 55);
    //  设定button大小为适应图片
    button.frame = CGRectMake(0.0, 0.0, width,height);
    [button setImage:buttonImage forState:UIControlStateNormal];
    [button setImage:selectedImage forState:UIControlStateSelected];
    
    //  这个比较恶心  去掉选中button时候的阴影
    button.adjustsImageWhenHighlighted=NO;
    
    button.centerX = self.tabBar.width/2.0;
    button.bottom = self.tabBar.height-10;
    [self.tabBar addSubview:button];
    
    self.button = button;
}

-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    NSString * key = NSStringFromClass([viewController class]);
    if([viewController isKindOfClass:[UINavigationController class]]){
        UIViewController * vc = [[(UINavigationController*)viewController viewControllers] lastObject];
        key = NSStringFromClass([vc class]);
    }
    if([self.blockDict.allKeys containsObject:key]){
        TabBarVCSholdSelectVCBlock block = self.blockDict[key];
        return block((MainTabBarViewController*)tabBarController,(GWRootViewController*)viewController);
    }
    return YES;
}
-(void)setTabBarVCSholdSelectVCBlock:(TabBarVCSholdSelectVCBlock)tabBarVCSholdSelectVCBlock CurrentVC:(GWRootViewController *)currentVC{
    if(nil == currentVC){
        return;
    }
    NSString * key = NSStringFromClass([currentVC class]);
    if([self.blockDict.allKeys containsObject:key]){
        return;
    }
    self.blockDict[key] = [tabBarVCSholdSelectVCBlock copy];
}
@end
