//
//  ShowImageLayoutViewController.m
//  TourNote
//
//  Created by 极客天地 on 2017/2/7.
//  Copyright © 2017年 极客天地. All rights reserved.
//

#import "ShowImageLayoutViewController.h"
#import "LayoutViewController.h"
@interface ShowImageLayoutViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIButton *downloadBottomBtn;

@property (strong,nonatomic) GWLayoutModel * layoutModel;

@end

@implementation ShowImageLayoutViewController
- (IBAction)downloadLayoutBtnClicked:(id)sender {
    if(self.layoutNetDataModel.isExistlayoutJsonLocalFile){
        self.layoutModel = [self.layoutViewModel getLayoutModelWithLayoutNetDataModel:self.layoutNetDataModel];
  
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"TabLayout" bundle:nil];
        LayoutViewController * lvc = [storyboard instantiateViewControllerWithIdentifier:@"LayoutViewController_SBID"];
        lvc.existLayoutModel = self.layoutModel;
        [self.navigationController pushViewController:lvc animated:YES];
    }else{
        [self.layoutViewModel downloadNetLayoutDataWithLayoutNetDataModel:self.layoutNetDataModel SuccessBlock:^(GWLayoutModel* layoutModel) {
            self.layoutModel = layoutModel;
            [self refreshUI];
        } FaildBlock:^(id object) {
            
        }];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

-(void)initData{
    
}
-(void)initUI{
    [self refreshUI];
    
    NSURL * url = [NSURL URLWithString:self.layoutNetDataModel.layoutPicImageUrl];
    [self.imageView sd_setImageWithURL:url completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        CGFloat height = (self.imageView.width/image.size.width)*image.size.height;
        self.imageView.height = height;
        self.scrollView.contentSize = CGSizeMake(self.imageView.width, self.imageView.height);
    }];
}
-(void)refreshUI{
    self.downloadBottomBtn.selected = self.layoutNetDataModel.isExistlayoutJsonLocalFile;
}
@end
